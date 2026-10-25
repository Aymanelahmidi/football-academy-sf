/**
 * @description Integration tests for DHC_RuleEngineBatch.
 *
 * Rules are injected via the @TestVisible 2-argument constructor so tests never
 * depend on DHC_Rule__mdt records deployed to the org.
 *
 * Test scenarios:
 *   1. Component with detectable change → Critique finding created, counters updated.
 *   2. Re-run idempotence → no duplicate Ouvert findings; Accepté finding survives.
 *   3. Component without baseline, CHANGED_TO rule → Non évaluable finding, Critical_Count = 0.
 *   4. No active rules for any component type → batch completes, Status = 'Terminé'.
 *
 * No @SeeAllData.
 */
@IsTest
private class DHC_RuleEngineBatchTest {

    // ─── Test data helpers ────────────────────────────────────────────────────

    private static DHC_Deployment__c makeDeployment() {
        DHC_Deployment__c dep = new DHC_Deployment__c(
            DHC_Status__c        = 'En cours',
            DHC_Critical_Count__c = 0,
            DHC_Warning_Count__c  = 0
        );
        insert dep;
        return dep;
    }

    private static DHC_Component__c makeComponent(
        String apiName, String componentType,
        String baselineJson, String currentJson
    ) {
        DHC_Component__c comp = new DHC_Component__c(
            DHC_API_Name__c       = apiName,
            DHC_Component_Type__c = componentType,
            DHC_Label__c          = apiName,
            DHC_Baseline_State__c = baselineJson,
            DHC_Current_State__c  = currentJson,
            DHC_Is_Absent__c      = false
        );
        insert comp;
        return comp;
    }

    /** Builds a rule that triggers when IsActive CHANGED_TO true. */
    private static DHC_Rule__mdt changedToRule() {
        return new DHC_Rule__mdt(
            DeveloperName         = 'Flow_F1',
            DHC_Component_Type__c = 'Flow',
            DHC_Attribute__c      = 'IsActive',
            DHC_Operator__c       = 'CHANGED_TO',
            DHC_Expected_Value__c = 'true',
            DHC_Severity__c       = 'Critique',
            DHC_Message__c        = '{component} est passé à actif'
        );
    }

    private static Map<String, List<DHC_Rule__mdt>> rulesMap(DHC_Rule__mdt rule) {
        return new Map<String, List<DHC_Rule__mdt>>{
            rule.DHC_Component_Type__c => new List<DHC_Rule__mdt>{ rule }
        };
    }

    // ─── 1. Triggered finding + counters ─────────────────────────────────────

    @IsTest
    static void triggeredRule_critiqueFindingCreated_countersUpdated() {
        DHC_Deployment__c dep  = makeDeployment();
        DHC_Component__c  comp = makeComponent(
            'Flow.My_Flow', 'Flow',
            '{"IsActive":false}',  // baseline: inactive
            '{"IsActive":true}'    // current: now active — CHANGED_TO true triggers
        );

        Test.startTest();
        Database.executeBatch(
            new DHC_RuleEngineBatch(dep.Id, rulesMap(changedToRule())),
            200
        );
        Test.stopTest();

        // One finding must have been created
        List<DHC_Finding__c> findings = [
            SELECT Id, DHC_Severity__c, DHC_Status__c, DHC_Message__c, DHC_Rule_Code__c
            FROM   DHC_Finding__c
            WHERE  DHC_Deployment__c = :dep.Id
        ];
        System.assertEquals(1, findings.size(), 'Exactly one finding expected');
        System.assertEquals('Critique', findings[0].DHC_Severity__c);
        System.assertEquals('Ouvert',   findings[0].DHC_Status__c);
        System.assertEquals('Flow_F1',  findings[0].DHC_Rule_Code__c);
        System.assert(findings[0].DHC_Message__c.contains('My_Flow'),
            'Message must contain the component label');

        // Deployment counters must be updated
        DHC_Deployment__c dep2 = [
            SELECT DHC_Critical_Count__c, DHC_Warning_Count__c, DHC_Status__c
            FROM   DHC_Deployment__c WHERE Id = :dep.Id
        ];
        System.assertEquals(1,        dep2.DHC_Critical_Count__c);
        System.assertEquals(0,        dep2.DHC_Warning_Count__c);
        System.assertEquals('Terminé', dep2.DHC_Status__c);
    }

    // ─── 2. Idempotence — no duplicates, Accepté finding survives ────────────

    @IsTest
    static void rerun_ouvertDeleted_acceptePreserved_noNewDuplicates() {
        DHC_Deployment__c dep  = makeDeployment();
        DHC_Component__c  comp = makeComponent(
            'Flow.My_Flow', 'Flow',
            '{"IsActive":false}',
            '{"IsActive":true}'
        );

        // Pre-existing Ouvert finding — must be cleaned by re-run
        DHC_Finding__c ouvert = new DHC_Finding__c(
            DHC_Component__c  = comp.Id,
            DHC_Deployment__c = dep.Id,
            DHC_Rule_Code__c  = 'Flow_F1',
            DHC_Severity__c   = 'Critique',
            DHC_Message__c    = 'stale finding',
            DHC_Status__c     = 'Ouvert'
        );
        insert ouvert;

        // Pre-existing Accepté finding — must NEVER be deleted (human decision)
        DHC_Finding__c accepted = new DHC_Finding__c(
            DHC_Component__c  = comp.Id,
            DHC_Deployment__c = dep.Id,
            DHC_Rule_Code__c  = 'Flow_F1',
            DHC_Severity__c   = 'Critique',
            DHC_Message__c    = 'accepted by security team',
            DHC_Status__c     = 'Accepté'
        );
        insert accepted;

        Test.startTest();
        Database.executeBatch(
            new DHC_RuleEngineBatch(dep.Id, rulesMap(changedToRule())),
            200
        );
        Test.stopTest();

        List<DHC_Finding__c> allFindings = [
            SELECT Id, DHC_Status__c FROM DHC_Finding__c WHERE DHC_Deployment__c = :dep.Id
        ];
        // Exactly 2: 1 fresh Ouvert (from this run) + 1 Accepté (preserved)
        System.assertEquals(2, allFindings.size(), 'Expected exactly 2 findings after re-run');

        Integer acceptedCount = 0;
        Integer ouvertCount   = 0;
        for (DHC_Finding__c f : allFindings) {
            if (f.DHC_Status__c == 'Accepté') acceptedCount++;
            if (f.DHC_Status__c == 'Ouvert')  ouvertCount++;
        }
        System.assertEquals(1, acceptedCount,
            'The Accepté finding (human decision) must survive re-run');
        System.assertEquals(1, ouvertCount,
            'Exactly one fresh Ouvert finding expected — no duplicates');

        // The original Ouvert finding must have been deleted
        List<DHC_Finding__c> originalOuvert = [
            SELECT Id FROM DHC_Finding__c WHERE Id = :ouvert.Id
        ];
        System.assertEquals(0, originalOuvert.size(),
            'The original stale Ouvert finding must have been deleted');
    }

    // ─── 3. No baseline → Non évaluable, Critical_Count unchanged ─────────────

    @IsTest
    static void noBaseline_changedToRule_nonEvaluableFinding_criticalCountZero() {
        DHC_Deployment__c dep  = makeDeployment();
        DHC_Component__c  comp = makeComponent(
            'Flow.My_Flow', 'Flow',
            null,                  // no baseline captured
            '{"IsActive":true}'
        );

        Test.startTest();
        Database.executeBatch(
            new DHC_RuleEngineBatch(dep.Id, rulesMap(changedToRule())),
            200
        );
        Test.stopTest();

        List<DHC_Finding__c> findings = [
            SELECT DHC_Severity__c, DHC_Status__c
            FROM   DHC_Finding__c
            WHERE  DHC_Deployment__c = :dep.Id
        ];
        System.assertEquals(1, findings.size(), 'One Non évaluable finding expected');
        System.assertEquals('Non évaluable', findings[0].DHC_Severity__c);
        System.assertEquals('Ouvert',        findings[0].DHC_Status__c);

        DHC_Deployment__c dep2 = [
            SELECT DHC_Critical_Count__c, DHC_Status__c
            FROM   DHC_Deployment__c WHERE Id = :dep.Id
        ];
        System.assertEquals(0,         dep2.DHC_Critical_Count__c,
            'Non évaluable must NOT increment Critical_Count');
        System.assertEquals('Terminé', dep2.DHC_Status__c);
    }

    // ─── 4. No rules for any type → clean finish, Status 'Terminé' ────────────

    @IsTest
    static void noRulesForAnyType_batchFinishesCleanly_statusTermine() {
        DHC_Deployment__c dep  = makeDeployment();
        DHC_Component__c  comp = makeComponent(
            'Flow.My_Flow', 'Flow',
            '{"IsActive":false}',
            '{"IsActive":true}'
        );

        // Empty rule map — no rules for any type
        Map<String, List<DHC_Rule__mdt>> emptyRules = new Map<String, List<DHC_Rule__mdt>>();

        Test.startTest();
        Database.executeBatch(new DHC_RuleEngineBatch(dep.Id, emptyRules), 200);
        Test.stopTest();

        List<DHC_Finding__c> findings = [
            SELECT Id FROM DHC_Finding__c WHERE DHC_Deployment__c = :dep.Id
        ];
        System.assertEquals(0, findings.size(), 'No findings expected when no rules exist');

        DHC_Deployment__c dep2 = [
            SELECT DHC_Critical_Count__c, DHC_Status__c
            FROM   DHC_Deployment__c WHERE Id = :dep.Id
        ];
        System.assertEquals(0,         dep2.DHC_Critical_Count__c);
        System.assertEquals('Terminé', dep2.DHC_Status__c,
            'Batch must finish with Status Terminé even when no rules apply');
    }
}
