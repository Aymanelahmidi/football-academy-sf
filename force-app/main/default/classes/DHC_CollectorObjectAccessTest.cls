/**
 * @description Tests for DHC_Collector — ObjectAccess scope.
 *
 * The most important test is objectAccess_differentRowOrder_sameHash:
 * ObjectPermissions rows for the same object can come back in any order
 * from the query engine (first DHC_Admin, then DHC_User — or vice versa).
 * The hash must be identical regardless.
 *
 * This is tested by calling buildObjectAccessComponents() directly via
 * @TestVisible — no async, no startTest/stopTest needed for the determinism case.
 */
@isTest
private class DHC_CollectorObjectAccessTest {

    // ─── Fixtures ────────────────────────────────────────────────────────────

    private static Map<String, Object> adminRow() {
        return new Map<String, Object>{
            'SobjectType'                => 'FA_Player__c',
            'ParentName'                 => 'DHC_Admin',
            'PermissionsRead'            => true,
            'PermissionsCreate'          => true,
            'PermissionsEdit'            => true,
            'PermissionsDelete'          => false,
            'PermissionsViewAllRecords'  => false,
            'PermissionsModifyAllRecords'=> false,
            'PermissionsViewAllFields'   => false
        };
    }

    private static Map<String, Object> userRow() {
        return new Map<String, Object>{
            'SobjectType'                => 'FA_Player__c',
            'ParentName'                 => 'DHC_User',
            'PermissionsRead'            => true,
            'PermissionsCreate'          => false,
            'PermissionsEdit'            => false,
            'PermissionsDelete'          => false,
            'PermissionsViewAllRecords'  => false,
            'PermissionsModifyAllRecords'=> false,
            'PermissionsViewAllFields'   => false
        };
    }

    private static Map<String, Object> matchRow() {
        return new Map<String, Object>{
            'SobjectType'                => 'FA_Match__c',
            'ParentName'                 => 'DHC_Admin',
            'PermissionsRead'            => true,
            'PermissionsCreate'          => true,
            'PermissionsEdit'            => true,
            'PermissionsDelete'          => true,
            'PermissionsViewAllRecords'  => false,
            'PermissionsModifyAllRecords'=> false,
            'PermissionsViewAllFields'   => false
        };
    }

    // ─── DETERMINISM — the most important test ────────────────────────────────

    @isTest
    static void objectAccess_differentRowOrder_sameHash() {
        // Two row lists with the same data but permission-set order swapped
        List<Map<String, Object>> orderA = new List<Map<String, Object>>{
            adminRow(), userRow()
        };
        List<Map<String, Object>> orderB = new List<Map<String, Object>>{
            userRow(), adminRow()  // reversed
        };

        // Use @TestVisible method directly — no async required
        DHC_Collector collector = new DHC_Collector(
            DHC_CaptureMode.BASELINE, new List<String>()
        );

        List<DHC_Component__c> resultA = collector.buildObjectAccessComponents(orderA);
        List<DHC_Component__c> resultB = collector.buildObjectAccessComponents(orderB);

        System.assertEquals(1, resultA.size(), 'One component per object');
        System.assertEquals(1, resultB.size(), 'One component per object');

        System.assertEquals(
            resultA[0].DHC_Baseline_Hash__c,
            resultB[0].DHC_Baseline_Hash__c,
            'Different query row order must produce the same hash'
        );
        System.assertEquals(
            resultA[0].DHC_Baseline_State__c,
            resultB[0].DHC_Baseline_State__c,
            'Different query row order must produce identical state JSON'
        );
    }

    // ─── One record per object, not per row ───────────────────────────────────

    @isTest
    static void captureBaseline_oneComponentPerObject_notPerRow() {
        DHC_Collector c = new DHC_Collector(
            DHC_CaptureMode.BASELINE, new List<String>{ 'ObjectAccess' }
        );
        // Two rows for FA_Player__c, one row for FA_Match__c
        c.injectedObjectAccessRows = new List<Map<String, Object>>{
            adminRow(), userRow(), matchRow()
        };

        Test.startTest();
        System.enqueueJob(c);
        Test.stopTest();

        Integer total = [
            SELECT COUNT() FROM DHC_Component__c WHERE DHC_Component_Type__c = 'ObjectAccess'
        ];
        System.assertEquals(2, total, 'One component per SobjectType, not per row');
    }

    // ─── AnyX aggregation ────────────────────────────────────────────────────

    @isTest
    static void captureBaseline_anyFlagsAreOrAcrossPermSets() {
        // DHC_Admin has Delete=false, DHC_User has Delete=false
        // => AnyDelete must be false
        // DHC_Admin has Create=true => AnyCreate must be true
        DHC_Collector collector = new DHC_Collector(
            DHC_CaptureMode.BASELINE, new List<String>()
        );
        List<DHC_Component__c> comps = collector.buildObjectAccessComponents(
            new List<Map<String, Object>>{ adminRow(), userRow() }
        );
        String json = comps[0].DHC_Baseline_State__c;

        System.assert(json.contains('"AnyCreate":true'),  'AnyCreate must be true (admin has create)');
        System.assert(json.contains('"AnyDelete":false'), 'AnyDelete must be false (no one has delete)');
        System.assert(json.contains('"PermSetCount":2'),  'PermSetCount must be 2');
    }

    // ─── No duplicate on re-run ───────────────────────────────────────────────

    @isTest
    static void captureBaseline_rerun_noNewRow() {
        insert new DHC_Component__c(
            DHC_API_Name__c        = 'ObjectAccess.FA_Player__c',
            DHC_Component_Type__c  = 'ObjectAccess',
            DHC_Label__c           = 'stale',
            DHC_Baseline_Hash__c   = 'stalehash'
        );

        DHC_Collector c = new DHC_Collector(
            DHC_CaptureMode.BASELINE, new List<String>{ 'ObjectAccess' }
        );
        c.injectedObjectAccessRows = new List<Map<String, Object>>{ adminRow(), userRow() };

        Test.startTest();
        System.enqueueJob(c);
        Test.stopTest();

        Integer total = [
            SELECT COUNT() FROM DHC_Component__c WHERE DHC_Component_Type__c = 'ObjectAccess'
        ];
        System.assertEquals(1, total, 'Re-run must not create a duplicate');
    }
}
