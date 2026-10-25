/**
 * @description Tests for DHC_StateSerializer.
 * Covers the three determinism properties:
 *   1. Same input → same hash (stability)
 *   2. One changed attribute → different hash (sensitivity)
 *   3. Map insertion order → irrelevant (key-order independence)
 */
@isTest
private class DHC_StateSerializerTest {

    // ─── Fixtures ────────────────────────────────────────────────────────────

    private static Map<String, Object> buildAttrs(
        Boolean isActive,
        Boolean isOutOfDate,
        Integer versionNumber
    ) {
        return new Map<String, Object>{
            'ActiveVersionId' => '3010000001ABC',
            'IsActive'        => isActive,
            'IsOutOfDate'     => isOutOfDate,
            'LatestVersionId' => '3010000001ABC',
            'ProcessType'     => 'Flow',
            'TriggerType'     => null,
            'VersionNumber'   => versionNumber
        };
    }

    // ─── Stability ───────────────────────────────────────────────────────────

    @isTest
    static void serialize_sameInput_producesSameHash() {
        Map<String, Object> attrs = buildAttrs(true, false, 1);

        DHC_StateSerializer.Result r1 = DHC_StateSerializer.serialize(attrs);
        DHC_StateSerializer.Result r2 = DHC_StateSerializer.serialize(attrs);

        System.assertEquals(
            r1.hash, r2.hash,
            'Two calls on identical attributes must produce the same hash'
        );
        System.assertEquals(
            r1.stateJson, r2.stateJson,
            'Two calls on identical attributes must produce the same JSON'
        );
    }

    @isTest
    static void serialize_hash_isSHA256HexLength() {
        DHC_StateSerializer.Result r = DHC_StateSerializer.serialize(buildAttrs(true, false, 1));
        System.assertEquals(64, r.hash.length(), 'SHA-256 hex digest must be 64 characters');
    }

    // ─── Sensitivity ─────────────────────────────────────────────────────────

    @isTest
    static void serialize_isActiveFlipped_producesDifferentHash() {
        DHC_StateSerializer.Result rActive   = DHC_StateSerializer.serialize(buildAttrs(true, false, 1));
        DHC_StateSerializer.Result rInactive = DHC_StateSerializer.serialize(buildAttrs(false, false, 1));

        System.assertNotEquals(
            rActive.hash, rInactive.hash,
            'Flipping IsActive must produce a different hash'
        );
    }

    @isTest
    static void serialize_versionNumberChanged_producesDifferentHash() {
        DHC_StateSerializer.Result r1 = DHC_StateSerializer.serialize(buildAttrs(true, false, 1));
        DHC_StateSerializer.Result r2 = DHC_StateSerializer.serialize(buildAttrs(true, false, 2));

        System.assertNotEquals(
            r1.hash, r2.hash,
            'Changing VersionNumber must produce a different hash'
        );
    }

    // ─── Key-order independence ───────────────────────────────────────────────

    @isTest
    static void serialize_differentMapInsertionOrder_producesIdenticalResult() {
        // Same key-value pairs, opposite insertion order
        Map<String, Object> orderedAsc = new Map<String, Object>{
            'ActiveVersionId' => 'XYZ',
            'IsActive'        => true,
            'IsOutOfDate'     => false,
            'LatestVersionId' => 'XYZ',
            'ProcessType'     => 'AutoLaunchedFlow',
            'TriggerType'     => 'RecordAfterSave',
            'VersionNumber'   => 5
        };
        Map<String, Object> orderedDesc = new Map<String, Object>{
            'VersionNumber'   => 5,
            'TriggerType'     => 'RecordAfterSave',
            'ProcessType'     => 'AutoLaunchedFlow',
            'LatestVersionId' => 'XYZ',
            'IsOutOfDate'     => false,
            'IsActive'        => true,
            'ActiveVersionId' => 'XYZ'
        };

        DHC_StateSerializer.Result rAsc  = DHC_StateSerializer.serialize(orderedAsc);
        DHC_StateSerializer.Result rDesc = DHC_StateSerializer.serialize(orderedDesc);

        System.assertEquals(
            rAsc.stateJson, rDesc.stateJson,
            'Map insertion order must not affect the serialized JSON'
        );
        System.assertEquals(
            rAsc.hash, rDesc.hash,
            'Map insertion order must not affect the hash'
        );
    }

    // ─── Null-value stability ────────────────────────────────────────────────

    @isTest
    static void serialize_nullField_appearsInJsonAndIsStable() {
        Map<String, Object> attrs = buildAttrs(true, false, 1); // TriggerType = null

        DHC_StateSerializer.Result r1 = DHC_StateSerializer.serialize(attrs);
        DHC_StateSerializer.Result r2 = DHC_StateSerializer.serialize(attrs);

        System.assert(
            r1.stateJson.contains('TriggerType'),
            'A null field must still appear as a key in the JSON'
        );
        System.assertEquals(r1.stateJson, r2.stateJson, 'Null fields must serialize consistently');
    }
}
