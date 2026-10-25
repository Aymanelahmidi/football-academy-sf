/**
 * @description Tests for DHC_Collector — PermissionSet scope.
 * Injection via injectedPermSetRows — no SeeAllData, no real PermissionSet query.
 */
@isTest
private class DHC_CollectorPermSetTest {

    private static List<Map<String, Object>> mockRows() {
        return new List<Map<String, Object>>{
            new Map<String, Object>{
                'Name'             => 'DHC_Admin',
                'Label'            => 'DHC Admin',
                'IsCustom'         => true,
                'IsOwnedByProfile' => false,
                'Type'             => 'Regular',
                'AssignmentCount'  => 3
            },
            new Map<String, Object>{
                'Name'             => 'DHC_User',
                'Label'            => 'DHC User',
                'IsCustom'         => true,
                'IsOwnedByProfile' => false,
                'Type'             => 'Regular',
                'AssignmentCount'  => 0
            }
        };
    }

    private static DHC_Collector makeCollector(DHC_CaptureMode mode) {
        DHC_Collector c = new DHC_Collector(mode, new List<String>{ 'PermissionSet' });
        c.injectedPermSetRows = mockRows();
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
            WHERE  DHC_Component_Type__c = 'PermissionSet'
            ORDER BY DHC_API_Name__c ASC
        ];

        System.assertEquals(2, comps.size(), 'Two PermissionSet components expected');
        System.assertEquals('PermissionSet.DHC_Admin', comps[0].DHC_API_Name__c);
        System.assertEquals('PermissionSet.DHC_User',  comps[1].DHC_API_Name__c);

        for (DHC_Component__c comp : comps) {
            System.assertNotEquals(null, comp.DHC_Baseline_State__c, 'Baseline state must be set');
            System.assertNotEquals(null, comp.DHC_Baseline_Hash__c,  'Baseline hash must be set');
            System.assertEquals(null, comp.DHC_Current_State__c, 'Current state must remain null');
            System.assertEquals(null, comp.DHC_Current_Hash__c,  'Current hash must remain null');
            System.assertEquals(null, comp.DHC_Last_Checked__c,  'Last checked must remain null');
        }
    }

    // ─── AssignmentCount = 0 ────────────────────────────────────────────────

    @isTest
    static void captureBaseline_zeroAssignments_stateReflectsZero() {
        Test.startTest();
        System.enqueueJob(makeCollector(DHC_CaptureMode.BASELINE));
        Test.stopTest();

        DHC_Component__c dhcUser = [
            SELECT DHC_Baseline_State__c
            FROM   DHC_Component__c
            WHERE  DHC_API_Name__c = 'PermissionSet.DHC_User'
        ];

        System.assert(
            dhcUser.DHC_Baseline_State__c.contains('"AssignmentCount":0'),
            'AssignmentCount 0 must appear in the state JSON'
        );
    }

    // ─── No duplicate on re-run ───────────────────────────────────────────────

    @isTest
    static void captureBaseline_rerun_noNewRow() {
        insert new DHC_Component__c(
            DHC_API_Name__c        = 'PermissionSet.DHC_Admin',
            DHC_Component_Type__c  = 'PermissionSet',
            DHC_Label__c           = 'stale',
            DHC_Baseline_Hash__c   = 'stalehash'
        );

        Test.startTest();
        System.enqueueJob(makeCollector(DHC_CaptureMode.BASELINE));
        Test.stopTest();

        Integer total = [
            SELECT COUNT() FROM DHC_Component__c WHERE DHC_Component_Type__c = 'PermissionSet'
        ];
        System.assertEquals(2, total, 'Re-run must not create a duplicate');

        DHC_Component__c updated = [
            SELECT DHC_Label__c FROM DHC_Component__c
            WHERE  DHC_API_Name__c = 'PermissionSet.DHC_Admin'
        ];
        System.assertEquals('DHC Admin', updated.DHC_Label__c, 'Label must be refreshed');
    }
}
