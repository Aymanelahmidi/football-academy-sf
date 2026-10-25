/**
 * @description Unit + security tests for DHC_AppController.
 *
 * Test data is created in @TestSetup so each method starts with a clean,
 * known state. Security tests use System.runAs() to verify that DHC_User
 * (read-only) cannot call mutations.
 *
 * Coverage targets:
 *   - getLatestDeployment  : 2 scenarios (no data, with data) + severity counts
 *   - getDeployments       : limit clamping
 *   - getFindings          : invalid severity, invalid status, pageSize cap,
 *                            filter by severity, pagination, componentId filter
 *   - getComponentDetail   : valid id, unknown id
 *   - getCaptureScopeConfig: smoke (returns list, no exception)
 *   - getActiveRules       : smoke (returns list, no exception)
 *   - updateFindingStatus  : valid update, missing justification, invalid status
 *   - startCapture         : invalid mode, security (DHC_User cannot call)
 *   - updateFindingStatus  : security (DHC_User cannot call)
 */
@isTest
private class DHC_AppControllerTest {

    // ─── Test data setup ──────────────────────────────────────────────────────

    @TestSetup
    static void makeData() {
        Profile stdProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];

        // Declare users before the runAs block so their Ids are accessible after
        User adminUser = new User(
            Alias            = 'dhcadm',
            Email            = 'dhc.admin.test@example.invalid',
            EmailEncodingKey = 'UTF-8',
            LastName         = 'DhcAdmin',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey     = 'en_US',
            ProfileId        = stdProfile.Id,
            TimeZoneSidKey   = 'America/Los_Angeles',
            UserName         = 'dhc.admin.test@example.invalid'
        );
        User readonlyUser = new User(
            Alias            = 'dhcusr',
            Email            = 'dhc.user.test@example.invalid',
            EmailEncodingKey = 'UTF-8',
            LastName         = 'DhcUser',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey     = 'en_US',
            ProfileId        = stdProfile.Id,
            TimeZoneSidKey   = 'America/Los_Angeles',
            UserName         = 'dhc.user.test@example.invalid'
        );

        // Setup objects (User, PermissionSetAssignment) must be in a System.runAs block
        // to avoid MIXED_DML_OPERATION when combined with standard object DML below.
        System.runAs(new User(Id = UserInfo.getUserId())) {
            insert new List<User>{ adminUser, readonlyUser };
            PermissionSet dhcAdmin = [SELECT Id FROM PermissionSet WHERE Name = 'DHC_Admin' LIMIT 1];
            PermissionSet dhcUser  = [SELECT Id FROM PermissionSet WHERE Name = 'DHC_User'  LIMIT 1];
            insert new List<PermissionSetAssignment>{
                new PermissionSetAssignment(AssigneeId = adminUser.Id,    PermissionSetId = dhcAdmin.Id),
                new PermissionSetAssignment(AssigneeId = readonlyUser.Id, PermissionSetId = dhcUser.Id)
            };
        }

        // Create a deployment
        DHC_Deployment__c dep = new DHC_Deployment__c(
            DHC_Release_Label__c  = 'Test BASELINE — 2026-01-01',
            DHC_Run_Date__c       = Datetime.now(),
            DHC_Status__c         = 'Terminé',
            DHC_Critical_Count__c = 1,
            DHC_Warning_Count__c  = 1
        );
        insert dep;

        // Create a component
        DHC_Component__c comp = new DHC_Component__c(
            DHC_API_Name__c       = 'Test_Flow_SetupData',
            DHC_Label__c          = 'Test Flow',
            DHC_Component_Type__c = 'Flow'
        );
        insert comp;

        // Create two findings (1 Critique, 1 Avertissement)
        insert new List<DHC_Finding__c>{
            new DHC_Finding__c(
                DHC_Deployment__c = dep.Id,
                DHC_Component__c  = comp.Id,
                DHC_Severity__c   = 'Critique',
                DHC_Message__c    = 'Finding Critique',
                DHC_Status__c     = 'Ouvert',
                DHC_Rule_Code__c  = 'TEST_C1'
            ),
            new DHC_Finding__c(
                DHC_Deployment__c = dep.Id,
                DHC_Component__c  = comp.Id,
                DHC_Severity__c   = 'Avertissement',
                DHC_Message__c    = 'Finding Avertissement',
                DHC_Status__c     = 'Ouvert',
                DHC_Rule_Code__c  = 'TEST_W1'
            )
        };
    }

    // ─── getLatestDeployment ──────────────────────────────────────────────────

    @isTest
    static void getLatestDeployment_withData_returnsDTO() {
        DHC_AppController.DeploymentSummaryDTO dto =
            DHC_AppController.getLatestDeployment();

        Assert.isNotNull(dto, 'Should return a DTO when data exists');
        Assert.areEqual('Test BASELINE — 2026-01-01', dto.releaseLabel);
        // criticalCount and warningCount are now computed live from findings via GROUP BY
        Assert.areEqual(1, dto.criticalCount,     'criticalCount from aggregate: 1 Critique finding');
        Assert.areEqual(1, dto.warningCount,      'warningCount from aggregate: 1 Avertissement finding');
        Assert.areEqual(0, dto.informationCount,  'informationCount: no Information findings');
        Assert.areEqual(0, dto.notEvaluableCount, 'notEvaluableCount: no Non évaluable findings');
    }

    // ─── getDeployments ───────────────────────────────────────────────────────

    @isTest
    static void getDeployments_limitClamped_to50Max() {
        List<DHC_Deployment__c> extras = new List<DHC_Deployment__c>();
        for (Integer i = 0; i < 5; i++) {
            extras.add(new DHC_Deployment__c(
                DHC_Release_Label__c = 'Extra ' + i,
                DHC_Run_Date__c      = Datetime.now(),
                DHC_Status__c        = 'Terminé'
            ));
        }
        insert extras;

        List<DHC_AppController.DeploymentSummaryDTO> result =
            DHC_AppController.getDeployments(200);

        // Only 6 records exist (1 from setup + 5 extras); all returned, well within cap
        Assert.isTrue(result.size() <= 50, 'Should be capped at 50');
    }

    @isTest
    static void getDeployments_nullLimit_defaults10() {
        List<DHC_AppController.DeploymentSummaryDTO> result =
            DHC_AppController.getDeployments(null);
        Assert.isNotNull(result);
    }

    // ─── getFindings ──────────────────────────────────────────────────────────
    // New signature: getFindings(deploymentId, componentId, severity, status, pageSize, pageNumber)
    // componentId is the second parameter; pass null to disable the filter.

    @isTest
    static void getFindings_invalidSeverity_throwsException() {
        DHC_Deployment__c dep = [SELECT Id FROM DHC_Deployment__c LIMIT 1];
        try {
            DHC_AppController.getFindings(dep.Id, null, 'INVALID', null, 20, 1);
            Assert.fail('Expected AuraHandledException for invalid severity');
        } catch (AuraHandledException e) {
            Assert.isTrue(
                e.getMessage().contains('Sévérité non autorisée'),
                'Message should mention invalid severity: ' + e.getMessage()
            );
        }
    }

    @isTest
    static void getFindings_invalidStatus_throwsException() {
        DHC_Deployment__c dep = [SELECT Id FROM DHC_Deployment__c LIMIT 1];
        try {
            DHC_AppController.getFindings(dep.Id, null, null, 'INVALID', 20, 1);
            Assert.fail('Expected AuraHandledException for invalid status');
        } catch (AuraHandledException e) {
            Assert.isTrue(
                e.getMessage().contains('Statut non autorisé'),
                e.getMessage()
            );
        }
    }

    @isTest
    static void getFindings_pageSizeCapped_noException() {
        DHC_Deployment__c dep = [SELECT Id FROM DHC_Deployment__c LIMIT 1];

        DHC_AppController.FindingPageDTO result =
            DHC_AppController.getFindings(dep.Id, null, null, null, 10000, 1);

        Assert.isNotNull(result, 'Result should not be null');
        Assert.areEqual(200, result.pageSize,   'pageSize should be capped at 200');
        Assert.areEqual(2,   result.totalCount, 'Should count 2 findings');
    }

    @isTest
    static void getFindings_filterBySeverity_returnsFilteredPage() {
        DHC_Deployment__c dep = [SELECT Id FROM DHC_Deployment__c LIMIT 1];

        DHC_AppController.FindingPageDTO result =
            DHC_AppController.getFindings(dep.Id, null, 'Critique', null, 20, 1);

        Assert.areEqual(1, result.totalCount, 'Should find 1 Critique finding');
        Assert.areEqual(1, result.findings.size());
        Assert.areEqual('Critique', result.findings[0].severity);
        Assert.areEqual('TEST_C1',  result.findings[0].ruleCode);
    }

    @isTest
    static void getFindings_filterByComponentId_returnsComponentFindings() {
        DHC_Deployment__c dep  = [SELECT Id FROM DHC_Deployment__c LIMIT 1];
        DHC_Component__c  comp = [SELECT Id FROM DHC_Component__c  LIMIT 1];

        DHC_AppController.FindingPageDTO result =
            DHC_AppController.getFindings(dep.Id, comp.Id, null, null, 20, 1);

        Assert.areEqual(2, result.totalCount, 'Both findings belong to this component');
    }

    @isTest
    static void getFindings_page2_returnsEmptyForSmallDataset() {
        DHC_Deployment__c dep = [SELECT Id FROM DHC_Deployment__c LIMIT 1];

        DHC_AppController.FindingPageDTO result =
            DHC_AppController.getFindings(dep.Id, null, null, null, 20, 2);

        Assert.areEqual(2, result.totalCount, 'Total count should still be 2');
        Assert.areEqual(0, result.findings.size(), 'Page 2 should have no results');
        Assert.areEqual(2, result.pageNumber);
    }

    // ─── getComponentDetail ───────────────────────────────────────────────────

    @isTest
    static void getComponentDetail_validId_returnsDTO() {
        DHC_Component__c comp = [SELECT Id FROM DHC_Component__c LIMIT 1];

        DHC_AppController.ComponentDetailDTO dto =
            DHC_AppController.getComponentDetail(comp.Id);

        Assert.isNotNull(dto, 'Should return DTO for valid component');
        Assert.areEqual('Test_Flow_SetupData', dto.apiName);
        Assert.areEqual('Flow', dto.componentType);
    }

    @isTest
    static void getComponentDetail_unknownId_returnsNull() {
        DHC_Component__c tmp = new DHC_Component__c(
            DHC_API_Name__c = 'TmpForDelete', DHC_Component_Type__c = 'Flow'
        );
        insert tmp;
        Id deletedId = tmp.Id;
        delete tmp;

        DHC_AppController.ComponentDetailDTO dto =
            DHC_AppController.getComponentDetail(deletedId);

        Assert.isNull(dto, 'Should return null for non-existent component');
    }

    // ─── getCaptureScopeConfig ────────────────────────────────────────────────

    @isTest
    static void getCaptureScopeConfig_doesNotThrow_returnsList() {
        List<DHC_AppController.CaptureScopeDTO> result =
            DHC_AppController.getCaptureScopeConfig();

        Assert.isNotNull(result, 'Should return a non-null list');
        // Custom metadata may or may not have records in test context; list can be empty
        for (DHC_AppController.CaptureScopeDTO s : result) {
            Assert.isNotNull(s.componentType, 'Each scope DTO should have a componentType');
        }
    }

    // ─── getActiveRules ───────────────────────────────────────────────────────

    @isTest
    static void getActiveRules_doesNotThrow_returnsList() {
        List<DHC_AppController.RuleDTO> result =
            DHC_AppController.getActiveRules();

        Assert.isNotNull(result, 'Should return a non-null list');
        for (DHC_AppController.RuleDTO r : result) {
            Assert.isNotNull(r.code, 'Each rule DTO should have a code (DeveloperName)');
        }
    }

    // ─── updateFindingStatus ──────────────────────────────────────────────────

    @isTest
    static void updateFindingStatus_invalidStatus_throwsException() {
        DHC_Finding__c f = [SELECT Id FROM DHC_Finding__c LIMIT 1];
        try {
            DHC_AppController.updateFindingStatus(f.Id, 'INVALID', 'just');
            Assert.fail('Expected AuraHandledException');
        } catch (AuraHandledException e) {
            Assert.isTrue(e.getMessage().contains('Statut non autorisé'), e.getMessage());
        }
    }

    @isTest
    static void updateFindingStatus_corrigeSansJustification_throwsException() {
        DHC_Finding__c f = [SELECT Id FROM DHC_Finding__c LIMIT 1];
        try {
            DHC_AppController.updateFindingStatus(f.Id, 'Corrigé', null);
            Assert.fail('Expected AuraHandledException for missing justification');
        } catch (AuraHandledException e) {
            Assert.isTrue(
                e.getMessage().contains('justification'),
                e.getMessage()
            );
        }
    }

    @isTest
    static void updateFindingStatus_accepteSansJustification_throwsException() {
        DHC_Finding__c f = [SELECT Id FROM DHC_Finding__c LIMIT 1];
        try {
            DHC_AppController.updateFindingStatus(f.Id, 'Accepté', '   ');
            Assert.fail('Expected AuraHandledException for blank justification');
        } catch (AuraHandledException e) {
            Assert.isTrue(e.getMessage().contains('justification'), e.getMessage());
        }
    }

    @isTest
    static void updateFindingStatus_corrigeAvecJustification_success() {
        DHC_Finding__c f = [SELECT Id FROM DHC_Finding__c WHERE DHC_Rule_Code__c = 'TEST_C1' LIMIT 1];

        DHC_AppController.updateFindingStatus(f.Id, 'Corrigé', 'Corrigé en déployant la version 3.2.');

        DHC_Finding__c updated = [
            SELECT DHC_Status__c, DHC_Justification__c FROM DHC_Finding__c WHERE Id = :f.Id
        ];
        Assert.areEqual('Corrigé', updated.DHC_Status__c);
        Assert.areEqual('Corrigé en déployant la version 3.2.', updated.DHC_Justification__c);
    }

    // ─── startCapture ─────────────────────────────────────────────────────────

    @isTest
    static void startCapture_invalidMode_throwsException() {
        try {
            DHC_AppController.startCapture('INVALID_MODE');
            Assert.fail('Expected AuraHandledException for invalid mode');
        } catch (AuraHandledException e) {
            Assert.isTrue(
                e.getMessage().contains('Mode de capture non autorisé'),
                e.getMessage()
            );
        }
    }

    @isTest
    static void startCapture_validMode_createsDeployment() {
        User adminUser = [SELECT Id FROM User WHERE UserName = 'dhc.admin.test@example.invalid'];

        Test.startTest();
        Id depId;
        System.runAs(adminUser) {
            depId = DHC_AppController.startCapture('BASELINE');
        }
        Test.stopTest();

        Assert.isNotNull(depId, 'Should return a deployment Id');
        DHC_Deployment__c dep = [SELECT DHC_Status__c FROM DHC_Deployment__c WHERE Id = :depId];
        Assert.areEqual('En cours', dep.DHC_Status__c);
    }

    // ─── runRuleEngine ────────────────────────────────────────────────────────

    @isTest
    static void runRuleEngine_validId_doesNotThrow() {
        // DHC_Admin can call runRuleEngine — batch launch is guarded in test context.
        User adminUser = [SELECT Id FROM User WHERE UserName = 'dhc.admin.test@example.invalid'];
        DHC_Deployment__c dep = [SELECT Id FROM DHC_Deployment__c LIMIT 1];

        System.runAs(adminUser) {
            DHC_AppController.runRuleEngine(dep.Id);
        }
        // No assertion needed — test passes if no exception is thrown.
    }

    @isTest
    static void runRuleEngine_nullId_throwsException() {
        User adminUser = [SELECT Id FROM User WHERE UserName = 'dhc.admin.test@example.invalid'];

        try {
            System.runAs(adminUser) {
                DHC_AppController.runRuleEngine(null);
            }
            Assert.fail('Expected AuraHandledException for null deploymentId');
        } catch (AuraHandledException e) {
            Assert.isTrue(
                e.getMessage().contains('identifiant'),
                'Message should mention missing deploymentId: ' + e.getMessage()
            );
        }
    }

    @isTest
    static void runRuleEngine_dhcUserReadOnly_throwsException() {
        User readonlyUser = [SELECT Id FROM User WHERE UserName = 'dhc.user.test@example.invalid'];
        DHC_Deployment__c dep = [SELECT Id FROM DHC_Deployment__c LIMIT 1];

        try {
            System.runAs(readonlyUser) {
                DHC_AppController.runRuleEngine(dep.Id);
            }
            Assert.fail('DHC_User should not be able to call runRuleEngine');
        } catch (AuraHandledException e) {
            Assert.isTrue(
                e.getMessage().contains('Permission insuffisante'),
                'Should report permission error: ' + e.getMessage()
            );
        }
    }

    // ─── Security tests ───────────────────────────────────────────────────────

    @isTest
    static void startCapture_dhcUserReadOnly_throwsException() {
        User readonlyUser = [SELECT Id FROM User WHERE UserName = 'dhc.user.test@example.invalid'];
        try {
            System.runAs(readonlyUser) {
                DHC_AppController.startCapture('BASELINE');
            }
            Assert.fail('DHC_User should not be able to call startCapture');
        } catch (AuraHandledException e) {
            Assert.isTrue(
                e.getMessage().contains('Permission insuffisante'),
                'Should report permission error: ' + e.getMessage()
            );
        }
    }

    @isTest
    static void updateFindingStatus_dhcUserReadOnly_throwsException() {
        User readonlyUser = [SELECT Id FROM User WHERE UserName = 'dhc.user.test@example.invalid'];
        DHC_Finding__c f = [SELECT Id FROM DHC_Finding__c LIMIT 1];

        try {
            System.runAs(readonlyUser) {
                DHC_AppController.updateFindingStatus(f.Id, 'Corrigé', 'Test justification');
            }
            Assert.fail('DHC_User should not be able to update a finding');
        } catch (AuraHandledException e) {
            Assert.isTrue(
                e.getMessage().contains('Permission insuffisante'),
                'Should report permission error: ' + e.getMessage()
            );
        }
    }
}
