/**
 * @description Tests for DHC_Collector.
 *
 * FlowDefinitionView cannot be inserted in test context.
 * The Collector exposes @TestVisible injectedFlowRows: tests set this field
 * on the instance before enqueuing — the real SOQL is never executed.
 *
 * Coverage scenarios:
 *   - BASELINE: baseline fields set, current fields remain null
 *   - CURRENT:  current fields and DHC_Last_Checked__c set, baseline untouched
 *   - Has_Changed__c stays false after a single BASELINE capture
 *   - Re-running the same capture does not create duplicate records (upsert idempotency)
 */
@isTest
private class DHC_CollectorTest {

    // ─── Mock data ───────────────────────────────────────────────────────────

    private static List<Map<String, Object>> mockFlowRows() {
        return new List<Map<String, Object>>{
            new Map<String, Object>{
                'ApiName'         => 'Account_Flow',
                'Label'           => 'Account Flow',
                'IsActive'        => true,
                'IsOutOfDate'     => false,
                'ActiveVersionId' => '3010000001AAA',
                'LatestVersionId' => '3010000001AAA',
                'VersionNumber'   => 3,
                'ProcessType'     => 'Flow',
                'TriggerType'     => null
            },
            new Map<String, Object>{
                'ApiName'         => 'Player_Onboarding',
                'Label'           => 'Player Onboarding',
                'IsActive'        => false,
                'IsOutOfDate'     => true,
                'ActiveVersionId' => null,
                'LatestVersionId' => '3010000002BBB',
                'VersionNumber'   => 1,
                'ProcessType'     => 'Flow',
                'TriggerType'     => null
            }
        };
    }

    private static DHC_Collector makeCollector(DHC_CaptureMode mode) {
        DHC_Collector c = new DHC_Collector(mode, new List<String>{ 'Flow' });
        c.injectedFlowRows = mockFlowRows();
        return c;
    }

    // ─── BASELINE mode ───────────────────────────────────────────────────────

    @isTest
    static void captureBaseline_setsBaselineFields_currentRemainsNull() {
        Test.startTest();
        System.enqueueJob(makeCollector(DHC_CaptureMode.BASELINE));
        Test.stopTest();

        List<DHC_Component__c> comps = [
            SELECT DHC_API_Name__c,
                   DHC_Baseline_State__c, DHC_Baseline_Hash__c,
                   DHC_Current_State__c,  DHC_Current_Hash__c,
                   DHC_Last_Checked__c
            FROM   DHC_Component__c
            WHERE  DHC_Component_Type__c = 'Flow'
            ORDER BY DHC_API_Name__c ASC
        ];

        System.assertEquals(2, comps.size(), 'Two Flow components must be created');

        for (DHC_Component__c comp : comps) {
            System.assertNotEquals(null, comp.DHC_Baseline_State__c, 'Baseline state must be set — ' + comp.DHC_API_Name__c);
            System.assertNotEquals(null, comp.DHC_Baseline_Hash__c,  'Baseline hash must be set — '  + comp.DHC_API_Name__c);
            System.assertEquals(null, comp.DHC_Current_State__c, 'Current state must remain null after BASELINE — ' + comp.DHC_API_Name__c);
            System.assertEquals(null, comp.DHC_Current_Hash__c,  'Current hash must remain null after BASELINE — '  + comp.DHC_API_Name__c);
            System.assertEquals(null, comp.DHC_Last_Checked__c,  'Last checked must remain null after BASELINE — '  + comp.DHC_API_Name__c);
        }

        // Verify API name prefix
        System.assertEquals('Flow.Account_Flow',    comps[0].DHC_API_Name__c);
        System.assertEquals('Flow.Player_Onboarding', comps[1].DHC_API_Name__c);
    }

    // ─── CURRENT mode ────────────────────────────────────────────────────────

    @isTest
    static void captureCurrent_setsCurrentFieldsAndLastChecked_baselineUntouched() {
        Test.startTest();
        System.enqueueJob(makeCollector(DHC_CaptureMode.CURRENT));
        Test.stopTest();

        List<DHC_Component__c> comps = [
            SELECT DHC_Baseline_State__c, DHC_Baseline_Hash__c,
                   DHC_Current_State__c,  DHC_Current_Hash__c,
                   DHC_Last_Checked__c
            FROM   DHC_Component__c
            WHERE  DHC_Component_Type__c = 'Flow'
        ];

        System.assertEquals(2, comps.size());

        for (DHC_Component__c comp : comps) {
            System.assertNotEquals(null, comp.DHC_Current_State__c, 'Current state must be set in CURRENT mode');
            System.assertNotEquals(null, comp.DHC_Current_Hash__c,  'Current hash must be set in CURRENT mode');
            System.assertNotEquals(null, comp.DHC_Last_Checked__c,  'Last checked must be set in CURRENT mode');
            System.assertEquals(null, comp.DHC_Baseline_State__c, 'Baseline state must remain null when only CURRENT was captured');
            System.assertEquals(null, comp.DHC_Baseline_Hash__c,  'Baseline hash must remain null when only CURRENT was captured');
        }
    }

    // ─── Has_Changed__c after single BASELINE capture ────────────────────────

    @isTest
    static void captureBaseline_hasChangedIsFalse_currentHashMissing() {
        Test.startTest();
        System.enqueueJob(makeCollector(DHC_CaptureMode.BASELINE));
        Test.stopTest();

        List<DHC_Component__c> comps = [
            SELECT DHC_Has_Changed__c
            FROM   DHC_Component__c
            WHERE  DHC_Component_Type__c = 'Flow'
        ];

        for (DHC_Component__c comp : comps) {
            System.assertEquals(
                false, comp.DHC_Has_Changed__c,
                'Has_Changed must be false when current hash is blank'
            );
        }
    }

    // ─── Garde-fou : exception en cours d'exécution → déploiement 'Échoué' ─────

    @isTest
    static void execute_unexpectedException_marksDeploymentFailed() {
        DHC_Deployment__c dep = new DHC_Deployment__c(DHC_Status__c = 'En cours');
        insert dep;

        DHC_Collector c = new DHC_Collector(
            DHC_CaptureMode.BASELINE, dep.Id, new List<String>{ 'Flow' }
        );
        // Inject a null map — null.get('ApiName') inside processFlows() throws
        // NullPointerException, which the try/catch in execute() must catch.
        c.injectedFlowRows = new List<Map<String, Object>>{ null };

        Test.startTest();
        System.enqueueJob(c);
        Test.stopTest();

        DHC_Deployment__c dep2 = [
            SELECT DHC_Status__c FROM DHC_Deployment__c WHERE Id = :dep.Id
        ];
        Assert.areEqual('Échoué', dep2.DHC_Status__c,
            'An exception in execute() must set the deployment to Échoué, not leave it En cours');
    }

    // ─── Idempotency (no duplicates on re-run) ────────────────────────────────

    @isTest
    static void captureBaseline_rerun_updatesExistingRecord_noNewRow() {
        // Simulate a previous capture by pre-inserting one component
        insert new DHC_Component__c(
            DHC_API_Name__c        = 'Flow.Account_Flow',
            DHC_Component_Type__c  = 'Flow',
            DHC_Label__c           = 'Account Flow (stale)',
            DHC_Baseline_State__c  = '{"stale":"true"}',
            DHC_Baseline_Hash__c   = 'stalehash0000000000000000000000000000000000000000000000000000000'
        );

        Test.startTest();
        System.enqueueJob(makeCollector(DHC_CaptureMode.BASELINE));
        Test.stopTest();

        // Total must stay at 2 (1 upserted + 1 newly inserted), not 3
        Integer total = [SELECT COUNT() FROM DHC_Component__c WHERE DHC_Component_Type__c = 'Flow'];
        System.assertEquals(2, total, 'Re-running capture must not create a duplicate record');

        // The pre-existing record must be updated with the fresh label
        DHC_Component__c updated = [
            SELECT DHC_Label__c, DHC_Baseline_Hash__c
            FROM   DHC_Component__c
            WHERE  DHC_API_Name__c = 'Flow.Account_Flow'
        ];
        System.assertEquals('Account Flow', updated.DHC_Label__c, 'Label must be refreshed by the upsert');
        System.assertNotEquals(
            'stalehash0000000000000000000000000000000000000000000000000000000',
            updated.DHC_Baseline_Hash__c,
            'Hash must be replaced with the freshly computed value'
        );
    }
}
