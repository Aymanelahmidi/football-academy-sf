/**
 * @description Tests for DHC_Collector — EntityDef scope.
 * Injection via injectedEntityDefRows — no EntityDefinition SOQL in test context.
 */
@isTest
private class DHC_CollectorEntityDefTest {

    private static List<Map<String, Object>> mockRows() {
        return new List<Map<String, Object>>{
            new Map<String, Object>{
                'QualifiedApiName'     => 'FA_Player__c',
                'Label'                => 'Player',
                'DeploymentStatus'     => 'Deployed',
                'InternalSharingModel' => 'ReadWrite',
                'ExternalSharingModel' => 'Private',
                'IsCustomizable'       => true
            },
            new Map<String, Object>{
                'QualifiedApiName'     => 'FA_Match__c',
                'Label'                => 'Match',
                'DeploymentStatus'     => 'Deployed',
                'InternalSharingModel' => 'Private',
                'ExternalSharingModel' => 'Private',
                'IsCustomizable'       => true
            }
        };
    }

    private static DHC_Collector makeCollector(DHC_CaptureMode mode) {
        DHC_Collector c = new DHC_Collector(mode, new List<String>{ 'EntityDef' });
        c.injectedEntityDefRows = mockRows();
        return c;
    }

    // ─── BASELINE ────────────────────────────────────────────────────────────

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
            WHERE  DHC_Component_Type__c = 'EntityDef'
            ORDER BY DHC_API_Name__c ASC
        ];

        System.assertEquals(2, comps.size(), 'Two EntityDef components expected');
        System.assertEquals('EntityDef.FA_Match__c',  comps[0].DHC_API_Name__c);
        System.assertEquals('EntityDef.FA_Player__c', comps[1].DHC_API_Name__c);

        for (DHC_Component__c comp : comps) {
            System.assertNotEquals(null, comp.DHC_Baseline_State__c, 'Baseline state must be set');
            System.assertNotEquals(null, comp.DHC_Baseline_Hash__c,  'Baseline hash must be set');
            System.assertEquals(null, comp.DHC_Current_State__c, 'Current state must remain null');
            System.assertEquals(null, comp.DHC_Current_Hash__c,  'Current hash must remain null');
        }
    }

    // ─── CURRENT ─────────────────────────────────────────────────────────────

    @isTest
    static void captureCurrent_setsCurrentFieldsAndLastChecked() {
        Test.startTest();
        System.enqueueJob(makeCollector(DHC_CaptureMode.CURRENT));
        Test.stopTest();

        List<DHC_Component__c> comps = [
            SELECT DHC_Current_State__c, DHC_Current_Hash__c,
                   DHC_Last_Checked__c,  DHC_Baseline_State__c
            FROM   DHC_Component__c
            WHERE  DHC_Component_Type__c = 'EntityDef'
        ];

        System.assertEquals(2, comps.size());
        for (DHC_Component__c comp : comps) {
            System.assertNotEquals(null, comp.DHC_Current_State__c, 'Current state must be set');
            System.assertNotEquals(null, comp.DHC_Current_Hash__c,  'Current hash must be set');
            System.assertNotEquals(null, comp.DHC_Last_Checked__c,  'Last checked must be set');
            System.assertEquals(null, comp.DHC_Baseline_State__c,   'Baseline must stay null');
        }
    }

    // ─── No duplicate on re-run ───────────────────────────────────────────────

    @isTest
    static void captureBaseline_rerun_noNewRow() {
        insert new DHC_Component__c(
            DHC_API_Name__c        = 'EntityDef.FA_Player__c',
            DHC_Component_Type__c  = 'EntityDef',
            DHC_Label__c           = 'stale',
            DHC_Baseline_Hash__c   = 'stalehash'
        );

        Test.startTest();
        System.enqueueJob(makeCollector(DHC_CaptureMode.BASELINE));
        Test.stopTest();

        Integer total = [
            SELECT COUNT() FROM DHC_Component__c WHERE DHC_Component_Type__c = 'EntityDef'
        ];
        System.assertEquals(2, total, 'Re-run must not create a duplicate');

        DHC_Component__c updated = [
            SELECT DHC_Label__c FROM DHC_Component__c
            WHERE  DHC_API_Name__c = 'EntityDef.FA_Player__c'
        ];
        System.assertEquals('Player', updated.DHC_Label__c, 'Label must be refreshed by upsert');
    }
}
