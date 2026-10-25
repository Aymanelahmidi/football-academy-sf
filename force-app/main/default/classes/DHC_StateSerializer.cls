/**
 * @description [SM] Produces a deterministic JSON state string and a SHA-256 fingerprint.
 *
 * DETERMINISM — two rules:
 *   1. Top-level keys are written in the fixed order provided by the caller (keyOrder list),
 *      never from Map iteration order.
 *   2. Nested string maps (the Access map for ObjectAccess) are wrapped in NestedMap and
 *      written with keys sorted alphabetically by writeNestedMap().
 *      This is critical: ObjectPermissions rows arrive in arbitrary order from the engine;
 *      the Access map must serialize identically regardless of insertion order.
 *
 * NOTE: Apex treats 'map' as a reserved word, making 'instanceof Map<String,Object>'
 * a compile error. All nested map values must be wrapped in NestedMap before being
 * passed to serialize().
 */
public with sharing class DHC_StateSerializer {

    // ─── NestedMap wrapper ───────────────────────────────────────────────────
    // Used for nested string maps that require deterministic (sorted-key) output.
    // NestedMap is a user-defined type, so 'instanceof NestedMap' is legal in Apex.

    public class NestedMap {
        public final Map<String, String> entries;
        public NestedMap(Map<String, String> entries) {
            this.entries = entries;
        }
    }

    // ─── Key order constants per scope type ──────────────────────────────────
    // Alphabetical within each list.
    // Appending new attributes to the END preserves hash compatibility
    // with existing baseline captures.

    // Flow scope (also the default for the single-argument overload)
    private static final List<String> ORDERED_KEYS = new List<String>{
        'ActiveVersionId',
        'IsActive',
        'IsOutOfDate',
        'LatestVersionId',
        'ProcessType',
        'TriggerType',
        'VersionNumber'
    };

    public static final List<String> PERMISSION_SET_KEYS = new List<String>{
        'AssignmentCount',
        'IsCustom',
        'IsOwnedByProfile',
        'Type'
    };

    // 'Access' key holds a NestedMap — written via writeNestedMap for determinism.
    public static final List<String> OBJECT_ACCESS_KEYS = new List<String>{
        'Access',
        'AnyCreate',
        'AnyDelete',
        'AnyEdit',
        'AnyModifyAll',
        'AnyRead',
        'AnyViewAll',
        'AnyViewAllFields',
        'PermSetCount'
    };

    public static final List<String> ENTITY_DEF_KEYS = new List<String>{
        'DeploymentStatus',
        'ExternalSharingModel',
        'InternalSharingModel',
        'IsCustomizable'
    };

    // 'Access' key holds a NestedMap — sorted by writeNestedMap for determinism.
    // PermSetCount counts ALL rows (including read=false, edit=false).
    public static final List<String> FIELD_ACCESS_KEYS = new List<String>{
        'Access',
        'AnyEdit',
        'AnyRead',
        'PermSetCount'
    };

    // ─── Result ──────────────────────────────────────────────────────────────

    public class Result {
        public final String stateJson;
        public final String hash;

        private Result(String stateJson, String hash) {
            this.stateJson = stateJson;
            this.hash      = hash;
        }
    }

    // ─── Public API ──────────────────────────────────────────────────────────

    /** Flow scope shorthand — uses ORDERED_KEYS. Kept for backward compatibility. */
    public static Result serialize(Map<String, Object> attributes) {
        return serialize(ORDERED_KEYS, attributes);
    }

    /**
     * Generic — caller provides the key order.
     * Supported value types: Boolean, Integer, Decimal, String, NestedMap, null.
     */
    public static Result serialize(List<String> keyOrder, Map<String, Object> attributes) {
        String stateJson = buildJson(keyOrder, attributes);
        String hash      = computeHash(stateJson);
        return new Result(stateJson, hash);
    }

    // ─── Private helpers ─────────────────────────────────────────────────────

    private static String buildJson(List<String> keyOrder, Map<String, Object> attributes) {
        JSONGenerator gen = JSON.createGenerator(false);
        gen.writeStartObject();
        for (String key : keyOrder) {
            writeField(gen, key, attributes.get(key));
        }
        gen.writeEndObject();
        return gen.getAsString();
    }

    private static void writeField(JSONGenerator gen, String key, Object value) {
        if (value == null) {
            gen.writeNullField(key);
        } else if (value instanceof Boolean) {
            gen.writeBooleanField(key, (Boolean) value);
        } else if (value instanceof Integer) {
            gen.writeNumberField(key, (Integer) value);
        } else if (value instanceof Decimal) {
            gen.writeNumberField(key, (Decimal) value);
        } else if (value instanceof NestedMap) {
            // User-defined type — instanceof is legal here (unlike Map<String,Object>)
            gen.writeFieldName(key);
            writeNestedMap(gen, (NestedMap) value);
        } else {
            gen.writeStringField(key, String.valueOf(value));
        }
    }

    /**
     * Writes a NestedMap as a JSON object with keys sorted alphabetically.
     * Sorting is the determinism guarantee: insertion order of the Access map
     * depends on ObjectPermissions query row order — sorting removes that dependency.
     */
    private static void writeNestedMap(JSONGenerator gen, NestedMap nm) {
        List<String> sortedKeys = new List<String>(nm.entries.keySet());
        sortedKeys.sort();
        gen.writeStartObject();
        for (String k : sortedKeys) {
            gen.writeStringField(k, nm.entries.get(k));
        }
        gen.writeEndObject();
    }

    private static String computeHash(String json) {
        Blob digest = Crypto.generateDigest('SHA-256', Blob.valueOf(json));
        return EncodingUtil.convertToHex(digest); // 64 hex chars
    }
}
