/**
 * @description Unit tests for DHC_FieldAccessBatch.
 *
 * FieldPermissions rows are NOT insertable in Apex tests, so every test bypasses the
 * real SOQL by using the @TestVisible 3-argument constructor and @TestVisible
 * accumulateRow() / collectComponents() methods.
 *
 * THE MOST CRITICAL TEST is chunkSplit_sameFieldSpansTwoChunks_mergesIntoOneComponent():
 *   it proves that a field whose rows are split across two batch chunks is merged into a
 *   single DHC_Component__c with correct AnyRead, AnyEdit, and PermSetCount.
 */
@IsTest
private class DHC_FieldAccessBatchTest {

    // ─── 1. BASELINE — two fields, two permission sets ────────────────────────

    @IsTest
    static void baseline_twoFieldsTwoPermSets_correctComponents() {
        DHC_FieldAccessBatch batch = new DHC_FieldAccessBatch(
            DHC_CaptureMode.BASELINE, null, new List<String>{ 'Account' }
        );

        batch.accumulateRow('Account.Industry', true,  false, 'PS_Reader');
        batch.accumulateRow('Account.Name',     true,  true,  'PS_Editor');

        List<DHC_Component__c> comps = batch.collectComponents();
        System.assertEquals(2, comps.size(), 'Expected 2 components — one per field');

        Map<String, DHC_Component__c> byName = indexByApiName(comps);

        DHC_Component__c industry = byName.get('Account.Industry');
        System.assertNotEquals(null, industry, 'Account.Industry must be captured');
        System.assertEquals('FieldAccess',     industry.DHC_Component_Type__c);
        System.assertNotEquals(null,           industry.DHC_Baseline_State__c);
        System.assertNotEquals(null,           industry.DHC_Baseline_Hash__c);
        System.assertEquals(null,              industry.DHC_Current_State__c,
            'BASELINE mode must not write current state');

        DHC_Component__c name = byName.get('Account.Name');
        System.assertNotEquals(null, name, 'Account.Name must be captured');
        System.assertEquals(64, name.DHC_Baseline_Hash__c.length(), 'SHA-256 = 64 hex chars');
    }

    // ─── 2. CURRENT mode — writes current fields ──────────────────────────────

    @IsTest
    static void current_oneField_writesCurrentStateAndLastChecked() {
        DHC_FieldAccessBatch batch = new DHC_FieldAccessBatch(
            DHC_CaptureMode.CURRENT, null, new List<String>{ 'Account' }
        );

        batch.accumulateRow('Account.Industry', true, true, 'PS_FullAccess');

        List<DHC_Component__c> comps = batch.collectComponents();
        System.assertEquals(1, comps.size());

        DHC_Component__c comp = comps[0];
        System.assertEquals(null, comp.DHC_Baseline_State__c,
            'CURRENT mode must not write baseline state');
        System.assertNotEquals(null, comp.DHC_Current_State__c);
        System.assertNotEquals(null, comp.DHC_Current_Hash__c);
        System.assertNotEquals(null, comp.DHC_Last_Checked__c,
            'CURRENT mode must stamp DHC_Last_Checked__c');
    }

    // ─── 3. THE chunk-split test ──────────────────────────────────────────────

    @IsTest
    static void chunkSplit_sameFieldSpansTwoChunks_mergesIntoOneComponent() {
        DHC_FieldAccessBatch batch = new DHC_FieldAccessBatch(
            DHC_CaptureMode.BASELINE, null, new List<String>{ 'Account' }
        );

        // ── Simulated chunk 1 ends with Account.Industry partially accumulated ──
        // Only PS_Reader's row arrives in chunk 1; no field change → no flush yet.
        batch.accumulateRow('Account.Industry', true, false, 'PS_Reader');

        // ── Simulated chunk 2 begins — still Account.Industry, then Account.Name ──
        // PS_Editor's row continues the same field; Account.Name triggers the flush.
        batch.accumulateRow('Account.Industry', false, true,  'PS_Editor');
        batch.accumulateRow('Account.Name',     true,  false, 'PS_Reader');

        List<DHC_Component__c> comps = batch.collectComponents();
        System.assertEquals(2, comps.size(), 'Must produce exactly 2 components');

        Map<String, DHC_Component__c> byName = indexByApiName(comps);
        DHC_Component__c industry = byName.get('Account.Industry');
        System.assertNotEquals(null, industry, 'Account.Industry must exist');

        // Parse and assert merged state
        Map<String, Object> state = (Map<String, Object>)
            JSON.deserializeUntyped(industry.DHC_Baseline_State__c);

        System.assertEquals(true, state.get('AnyRead'),
            'AnyRead must be true — PS_Reader had read in chunk 1');
        System.assertEquals(true, state.get('AnyEdit'),
            'AnyEdit must be true — PS_Editor had edit in chunk 2');
        System.assertEquals(2,
            Integer.valueOf(String.valueOf(state.get('PermSetCount'))),
            'PermSetCount must be 2 — one row per chunk');

        Map<String, Object> accessMap = (Map<String, Object>) state.get('Access');
        System.assertEquals(2, accessMap.size(), 'Access map must have 2 entries');
        System.assertEquals('r', (String) accessMap.get('PS_Reader'));
        System.assertEquals('e', (String) accessMap.get('PS_Editor'));
    }

    // ─── 4. No-access row excluded from Access map ───────────────────────────

    @IsTest
    static void noAccessRow_readFalseEditFalse_notInAccessMapButCountedInPermSetCount() {
        DHC_FieldAccessBatch batch = new DHC_FieldAccessBatch(
            DHC_CaptureMode.BASELINE, null, new List<String>{ 'Account' }
        );

        batch.accumulateRow('Account.Industry', true,  false, 'PS_Reader');
        // PS_NoAccess has both permissions false — must NOT appear in Access map
        batch.accumulateRow('Account.Industry', false, false, 'PS_NoAccess');

        List<DHC_Component__c> comps = batch.collectComponents();
        System.assertEquals(1, comps.size());

        Map<String, Object> state = (Map<String, Object>)
            JSON.deserializeUntyped(comps[0].DHC_Baseline_State__c);

        Map<String, Object> accessMap = (Map<String, Object>) state.get('Access');
        System.assertEquals(1, accessMap.size(),
            'PS_NoAccess (no read, no edit) must not appear in Access map');
        System.assertEquals('r', (String) accessMap.get('PS_Reader'));
        System.assertEquals(2,
            Integer.valueOf(String.valueOf(state.get('PermSetCount'))),
            'PermSetCount counts ALL rows including no-access ones');
    }

    // ─── 5. Determinism — row insertion order does not affect hash ────────────

    @IsTest
    static void determinism_differentRowOrder_producesIdenticalHash() {
        // Order A
        DHC_FieldAccessBatch batchA = new DHC_FieldAccessBatch(
            DHC_CaptureMode.BASELINE, null, new List<String>{ 'Account' }
        );
        batchA.accumulateRow('Account.Industry', true, false, 'PS_Alpha');
        batchA.accumulateRow('Account.Industry', false, true, 'PS_Beta');
        List<DHC_Component__c> compsA = batchA.collectComponents();

        // Order B — reversed
        DHC_FieldAccessBatch batchB = new DHC_FieldAccessBatch(
            DHC_CaptureMode.BASELINE, null, new List<String>{ 'Account' }
        );
        batchB.accumulateRow('Account.Industry', false, true, 'PS_Beta');
        batchB.accumulateRow('Account.Industry', true, false, 'PS_Alpha');
        List<DHC_Component__c> compsB = batchB.collectComponents();

        System.assertEquals(
            compsA[0].DHC_Baseline_Hash__c,
            compsB[0].DHC_Baseline_Hash__c,
            'Hash must be identical regardless of permission set row order'
        );
    }

    // ─── 6. Empty scoped objects — no components produced ────────────────────

    @IsTest
    static void emptyScopedObjects_collectComponents_returnsEmptyList() {
        DHC_FieldAccessBatch batch = new DHC_FieldAccessBatch(
            DHC_CaptureMode.BASELINE, null, new List<String>()
        );
        List<DHC_Component__c> comps = batch.collectComponents();
        System.assertEquals(0, comps.size(),
            'No components expected when scopedObjects is empty');
    }

    // ─── 7. OR-aggregation — AnyRead true when any permission set has read ────

    @IsTest
    static void orAggregation_multiplePermSets_anyReadTrueWhenOneHasRead() {
        DHC_FieldAccessBatch batch = new DHC_FieldAccessBatch(
            DHC_CaptureMode.BASELINE, null, new List<String>{ 'Contact' }
        );

        // Three permission sets; only PS_C has edit
        batch.accumulateRow('Contact.Phone', false, false, 'PS_A');
        batch.accumulateRow('Contact.Phone', false, false, 'PS_B');
        batch.accumulateRow('Contact.Phone', false, true,  'PS_C');

        List<DHC_Component__c> comps = batch.collectComponents();
        System.assertEquals(1, comps.size());

        Map<String, Object> state = (Map<String, Object>)
            JSON.deserializeUntyped(comps[0].DHC_Baseline_State__c);

        System.assertEquals(false, state.get('AnyRead'),  'No PS has read — AnyRead must be false');
        System.assertEquals(true,  state.get('AnyEdit'),  'PS_C has edit — AnyEdit must be true');
        System.assertEquals(3,
            Integer.valueOf(String.valueOf(state.get('PermSetCount'))),
            'All 3 rows must be counted');
    }

    // ─── 8. Non-existent object in scope — batch completes, no exception ─────

    @IsTest
    static void unknownScopeObject_noExceptionThrown_existingObjectStillCaptured() {
        // Verifies that an object listed in DHC_Capture_Scope__mdt that does not
        // exist in the org (or has no FieldPermissions) is silently skipped.
        // The batch must continue processing rows for other valid objects and never
        // throw an exception that would kill the whole batch job.
        DHC_FieldAccessBatch batch = new DHC_FieldAccessBatch(
            DHC_CaptureMode.BASELINE, null,
            new List<String>{ 'NonExistentObject__c', 'Account' }
        );

        // Simulate: no rows for NonExistentObject__c (the SobjectType filter returns
        // nothing for an unknown type), but one row for Account.Industry.
        batch.accumulateRow('Account.Industry', true, false, 'PS_Reader');

        List<DHC_Component__c> comps = batch.collectComponents();

        Assert.areEqual(1, comps.size(),
            'Only Account.Industry must be captured — NonExistentObject__c produces no rows');
        Assert.areEqual('Account.Industry', comps[0].DHC_API_Name__c);
        Assert.areEqual('FieldAccess', comps[0].DHC_Component_Type__c);
        Assert.isNotNull(comps[0].DHC_Baseline_State__c,
            'Baseline state must be set for the valid field');
    }

    // ─── 9. BASELINE finish closes deployment ──────────────────────────────────

    @IsTest
    static void finish_baselineMode_closesDeploymentTermine() {
        // Use an empty scope so the batch produces 0 FieldPermission rows
        // (avoids any real data dependency) and goes straight to finish().
        DHC_Deployment__c dep = new DHC_Deployment__c(DHC_Status__c = 'En cours');
        insert dep;

        DHC_FieldAccessBatch batch = new DHC_FieldAccessBatch(
            DHC_CaptureMode.BASELINE, dep.Id, new List<String>()
        );

        Test.startTest();
        Database.executeBatch(batch, 200);
        Test.stopTest();

        DHC_Deployment__c dep2 = [SELECT DHC_Status__c FROM DHC_Deployment__c WHERE Id = :dep.Id];
        Assert.areEqual('Terminé', dep2.DHC_Status__c,
            'BASELINE finish() must close the deployment to Terminé directly');
    }

    // ─── 10. CURRENT finish does NOT close deployment (RuleEngineBatch is chained in prod) ───

    @IsTest
    static void finish_currentMode_deploymentRemainsEnCours() {
        // In test context, !Test.isRunningTest() is false, so the RuleEngineBatch is NOT
        // launched. The deployment must remain 'En cours' — the caller's test of
        // DHC_RuleEngineBatch covers the final close independently.
        DHC_Deployment__c dep = new DHC_Deployment__c(DHC_Status__c = 'En cours');
        insert dep;

        DHC_FieldAccessBatch batch = new DHC_FieldAccessBatch(
            DHC_CaptureMode.CURRENT, dep.Id, new List<String>()
        );

        Test.startTest();
        Database.executeBatch(batch, 200);
        Test.stopTest();

        DHC_Deployment__c dep2 = [SELECT DHC_Status__c FROM DHC_Deployment__c WHERE Id = :dep.Id];
        Assert.areEqual('En cours', dep2.DHC_Status__c,
            'CURRENT finish() must NOT close the deployment — that is done by DHC_RuleEngineBatch ' +
            '(guarded in test context by !Test.isRunningTest())');
    }

    // ─── Helper ───────────────────────────────────────────────────────────────

    private static Map<String, DHC_Component__c> indexByApiName(List<DHC_Component__c> comps) {
        Map<String, DHC_Component__c> result = new Map<String, DHC_Component__c>();
        for (DHC_Component__c c : comps) {
            result.put(c.DHC_API_Name__c, c);
        }
        return result;
    }
}
