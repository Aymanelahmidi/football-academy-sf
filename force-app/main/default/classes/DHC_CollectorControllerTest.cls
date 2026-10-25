/**
 * @description Unit + security tests for DHC_CollectorController.
 *
 * Coverage targets:
 *   - captureBaseline      : nominal (returns job Id)
 *   - captureCurrent       : nominal (returns job Id)
 *   - runFieldAccessCapture: nominal BASELINE, invalid mode
 *   - security             : DHC_User (read-only) cannot call captureBaseline
 *
 * Setup note: User + PermissionSetAssignment are setup objects and must be
 * inserted inside System.runAs(new User(Id = UserInfo.getUserId())) to avoid
 * MIXED_DML_OPERATION when combined with standard-object DML in the same
 * transaction.
 */
@isTest
private class DHC_CollectorControllerTest {

    // ─── Test data setup ──────────────────────────────────────────────────────

    @TestSetup
    static void makeData() {
        Profile stdProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];

        User readonlyUser = new User(
            Alias             = 'dhcctrl',
            Email             = 'dhc.ctrl.test@example.invalid',
            EmailEncodingKey  = 'UTF-8',
            LastName          = 'DhcCtrlUser',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey      = 'en_US',
            ProfileId         = stdProfile.Id,
            TimeZoneSidKey    = 'America/Los_Angeles',
            UserName          = 'dhc.ctrl.test@example.invalid'
        );

        System.runAs(new User(Id = UserInfo.getUserId())) {
            insert readonlyUser;
            PermissionSet dhcUserPs = [SELECT Id FROM PermissionSet WHERE Name = 'DHC_User' LIMIT 1];
            insert new PermissionSetAssignment(
                AssigneeId      = readonlyUser.Id,
                PermissionSetId = dhcUserPs.Id
            );
        }
    }

    // ─── captureBaseline ──────────────────────────────────────────────────────

    @isTest
    static void captureBaseline_nominal_returnsJobId() {
        // Note: in test context, DHC_Collector chains only one scope
        // (Test.isRunningTest() guard skips the subsequent enqueueJob calls).
        // Per-scope DML correctness is covered by the dedicated test classes:
        //   DHC_CollectorTest, DHC_CollectorPermSetTest,
        //   DHC_CollectorObjectAccessTest, DHC_CollectorEntityDefTest.
        Test.startTest();
        Id jobId = DHC_CollectorController.captureBaseline();
        Test.stopTest();

        Assert.isNotNull(jobId, 'captureBaseline should return a valid queueable job Id');
    }

    // ─── captureCurrent ───────────────────────────────────────────────────────

    @isTest
    static void captureCurrent_nominal_returnsJobId() {
        // Same single-scope restriction as captureBaseline — see comment above.
        Test.startTest();
        Id jobId = DHC_CollectorController.captureCurrent();
        Test.stopTest();

        Assert.isNotNull(jobId, 'captureCurrent should return a valid queueable job Id');
    }

    // ─── Per-scope direct coverage (Test.isRunningTest() guard means the
    //     controller tests above only run the first scope of the chain) ────────

    @isTest
    static void captureBaseline_flowScope_processedWithoutException() {
        DHC_Collector c = new DHC_Collector(
            DHC_CaptureMode.BASELINE, null, new List<String>{ 'Flow' }
        );
        c.injectedFlowRows = new List<Map<String, Object>>{
            new Map<String, Object>{
                'ApiName' => 'Test_Flow', 'Label' => 'Test Flow',
                'IsActive' => true, 'IsOutOfDate' => false,
                'ActiveVersionId' => null, 'LatestVersionId' => null,
                'VersionNumber' => 1, 'ProcessType' => 'Flow', 'TriggerType' => null
            }
        };
        Test.startTest();
        System.enqueueJob(c);
        Test.stopTest();

        Assert.areEqual(1,
            [SELECT COUNT() FROM DHC_Component__c WHERE DHC_Component_Type__c = 'Flow'],
            'Flow scope must produce one component'
        );
    }

    @isTest
    static void captureBaseline_permSetScope_processedWithoutException() {
        DHC_Collector c = new DHC_Collector(
            DHC_CaptureMode.BASELINE, null, new List<String>{ 'PermissionSet' }
        );
        c.injectedPermSetRows = new List<Map<String, Object>>{
            new Map<String, Object>{
                'Name' => 'DHC_Admin', 'Label' => 'DHC Admin',
                'IsCustom' => true, 'IsOwnedByProfile' => false,
                'Type' => 'Regular', 'AssignmentCount' => 1
            }
        };
        Test.startTest();
        System.enqueueJob(c);
        Test.stopTest();

        Assert.areEqual(1,
            [SELECT COUNT() FROM DHC_Component__c WHERE DHC_Component_Type__c = 'PermissionSet'],
            'PermissionSet scope must produce one component'
        );
    }

    @isTest
    static void captureBaseline_objectAccessScope_processedWithoutException() {
        DHC_Collector c = new DHC_Collector(
            DHC_CaptureMode.BASELINE, null, new List<String>{ 'ObjectAccess' }
        );
        c.injectedObjectAccessRows = new List<Map<String, Object>>{
            new Map<String, Object>{
                'SobjectType' => 'Account', 'ParentName' => 'DHC_Admin',
                'PermissionsRead' => true, 'PermissionsCreate' => false,
                'PermissionsEdit' => false, 'PermissionsDelete' => false,
                'PermissionsViewAllRecords' => false, 'PermissionsModifyAllRecords' => false,
                'PermissionsViewAllFields' => false
            }
        };
        Test.startTest();
        System.enqueueJob(c);
        Test.stopTest();

        Assert.areEqual(1,
            [SELECT COUNT() FROM DHC_Component__c WHERE DHC_Component_Type__c = 'ObjectAccess'],
            'ObjectAccess scope must produce one component'
        );
    }

    @isTest
    static void captureBaseline_entityDefScope_processedWithoutException() {
        DHC_Collector c = new DHC_Collector(
            DHC_CaptureMode.BASELINE, null, new List<String>{ 'EntityDef' }
        );
        c.injectedEntityDefRows = new List<Map<String, Object>>{
            new Map<String, Object>{
                'QualifiedApiName' => 'Account', 'Label' => 'Account',
                'DeploymentStatus' => 'Deployed', 'InternalSharingModel' => 'ReadWrite',
                'ExternalSharingModel' => 'Private', 'IsCustomizable' => true
            }
        };
        Test.startTest();
        System.enqueueJob(c);
        Test.stopTest();

        Assert.areEqual(1,
            [SELECT COUNT() FROM DHC_Component__c WHERE DHC_Component_Type__c = 'EntityDef'],
            'EntityDef scope must produce one component'
        );
    }

    // ─── runFieldAccessCapture ────────────────────────────────────────────────

    @isTest
    static void runFieldAccessCapture_baseline_returnsJobId() {
        Test.startTest();
        Id jobId = DHC_CollectorController.runFieldAccessCapture('BASELINE', null);
        Test.stopTest();

        Assert.isNotNull(jobId, 'runFieldAccessCapture should return a valid batch job Id');
    }

    @isTest
    static void runFieldAccessCapture_invalidMode_throwsException() {
        try {
            DHC_CollectorController.runFieldAccessCapture('INVALID_MODE', null);
            Assert.fail('Expected AuraHandledException for invalid mode');
        } catch (AuraHandledException e) {
            Assert.isTrue(
                e.getMessage().contains('Mode de capture non autorisé'),
                'Message should mention invalid mode: ' + e.getMessage()
            );
        }
    }

    // ─── Security ─────────────────────────────────────────────────────────────

    @isTest
    static void captureBaseline_dhcUserReadOnly_throwsException() {
        User readonlyUser = [
            SELECT Id FROM User WHERE UserName = 'dhc.ctrl.test@example.invalid'
        ];

        try {
            System.runAs(readonlyUser) {
                DHC_CollectorController.captureBaseline();
            }
            Assert.fail('DHC_User should not be able to call captureBaseline');
        } catch (AuraHandledException e) {
            Assert.isTrue(
                e.getMessage().contains('Permission insuffisante'),
                'Should report permission error: ' + e.getMessage()
            );
        }
    }
}
