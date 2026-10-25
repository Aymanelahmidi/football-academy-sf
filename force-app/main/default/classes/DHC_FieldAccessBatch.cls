/**
 * @description [SM] Batch that captures FieldPermissions (FLS) state into DHC_Component__c.
 *
 * CHUNK-BOUNDARY PROBLEM:
 *   FieldPermissions rows arrive sorted by Field ASC, Parent.Name ASC.
 *   A batch chunk of 2 000 rows can split in the middle of the N rows belonging to
 *   one field — e.g. Account.Industry rows span the end of chunk 1 and the start of
 *   chunk 2. Flushing at the end of execute() would produce two partial components
 *   for the same field instead of one merged component.
 *
 * SOLUTION — Stateful cross-chunk accumulator:
 *   - pendingFieldName … pendingAccessMap are instance variables that survive across
 *     execute() calls thanks to Database.Stateful serialization.
 *   - Flush happens inside the loop when the field NAME CHANGES, never at end of execute().
 *   - finish() flushes the last pending field then upserts all staged components in bulk.
 *
 * DETERMINISM:
 *   The Access map is wrapped in DHC_StateSerializer.NestedMap so writeNestedMap() sorts
 *   its keys alphabetically before serialization — insertion order is irrelevant.
 *
 * ACCESS:
 *   - Only permission sets (Parent.IsOwnedByProfile = false).
 *   - A FieldPermissions row with PermissionsRead = false AND PermissionsEdit = false is
 *     counted in PermSetCount but NOT added to the Access map (convention: absence = no access).
 *   - DHC_API_Name__c = FieldPermissions.Field — already 'SobjectType.FieldName'; no prefix added.
 */
public with sharing class DHC_FieldAccessBatch
    implements Database.Batchable<SObject>, Database.Stateful {

    private final DHC_CaptureMode captureMode;
    private final Id              deploymentId;
    private final List<String>    scopedObjects;

    // ─── Stateful cross-chunk accumulator ────────────────────────────────────

    private String              pendingFieldName    = null;
    private Boolean             pendingAnyRead      = false;
    private Boolean             pendingAnyEdit      = false;
    private Integer             pendingPermSetCount = 0;
    private Map<String, String> pendingAccessMap    = new Map<String, String>();

    // Accumulates flushed DHC_Component__c records for bulk upsert in finish().
    // Stateful — persists across execute() calls.
    private List<DHC_Component__c> stagedComponents = new List<DHC_Component__c>();

    // ─── Constructors ─────────────────────────────────────────────────────────

    public DHC_FieldAccessBatch(DHC_CaptureMode captureMode, Id deploymentId) {
        this.captureMode   = captureMode;
        this.deploymentId  = deploymentId;
        this.scopedObjects = DHC_CaptureScopeSelector.getFieldAccessTargetObjects();
    }

    /**
     * @TestVisible overload — injects scopedObjects directly, bypassing Custom Metadata SOQL.
     * Used by tests to avoid dependency on deployed DHC_Capture_Scope__mdt records.
     */
    @TestVisible
    private DHC_FieldAccessBatch(
        DHC_CaptureMode captureMode,
        Id              deploymentId,
        List<String>    scopedObjects
    ) {
        this.captureMode   = captureMode;
        this.deploymentId  = deploymentId;
        this.scopedObjects = scopedObjects != null ? scopedObjects : new List<String>();
    }

    // ─── Batchable ────────────────────────────────────────────────────────────

    public Database.QueryLocator start(Database.BatchableContext bc) {
        if (scopedObjects.isEmpty()) {
            System.debug(LoggingLevel.WARN,
                'DHC_FieldAccessBatch: aucun objet configuré dans DHC_Capture_Scope__mdt ' +
                'pour le type FieldAccess — capture ignorée.');
            return Database.getQueryLocatorWithBinds(
                'SELECT Field FROM FieldPermissions LIMIT 0',
                new Map<String, Object>(),
                AccessLevel.USER_MODE
            );
        }
        Map<String, Object> binds = new Map<String, Object>{ 'scopedObjects' => scopedObjects };
        return Database.getQueryLocatorWithBinds(
            'SELECT Field, SobjectType, PermissionsRead, PermissionsEdit, ' +
            '       Parent.Name, Parent.Label ' +
            'FROM   FieldPermissions ' +
            'WHERE  Parent.IsOwnedByProfile = false ' +
            'AND    SobjectType IN :scopedObjects ' +
            'ORDER BY Field ASC, Parent.Name ASC',
            binds,
            AccessLevel.USER_MODE
        );
    }

    public void execute(Database.BatchableContext bc, List<SObject> scope) {
        for (SObject row : scope) {
            String  fieldName = (String)  row.get('Field');
            Boolean canRead   = (Boolean) row.get('PermissionsRead');
            Boolean canEdit   = (Boolean) row.get('PermissionsEdit');
            String  psName    = (String)  row.getSObject('Parent').get('Name');
            accumulateRow(fieldName, canRead, canEdit, psName);
        }
        // Do NOT flush here — the same field may continue in the next chunk.
    }

    public void finish(Database.BatchableContext bc) {
        try {
            // Flush the last pending field (no subsequent row will trigger it).
            flushPending();
            if (!stagedComponents.isEmpty()) {
                upsertComponents(stagedComponents);
            }
            if (stagedComponents.isEmpty() && !scopedObjects.isEmpty()) {
                System.debug(LoggingLevel.WARN,
                    'DHC_FieldAccessBatch: aucun composant FieldAccess produit pour les objets : ' +
                    String.join(scopedObjects, ', ') +
                    '. Vérifier que ces objets existent dans cette org et que des permission sets ' +
                    '(IsOwnedByProfile = false) leur accordent des FieldPermissions.');
            }

            // ─── Sequential chain ────────────────────────────────────────────────
            // CURRENT → chain DHC_RuleEngineBatch (evaluates rules, closes deployment).
            // BASELINE → close deployment directly (nothing to compare yet).
            // Both branches are guarded against deploymentId being null (direct-invoke path).
            if (captureMode == DHC_CaptureMode.CURRENT) {
                if (deploymentId != null) {
                    // Guard: test context must not chain batches — covered by DHC_RuleEngineBatchTest.
                    if (!Test.isRunningTest()) {
                        Database.executeBatch(new DHC_RuleEngineBatch(deploymentId), 200);
                    }
                }
            } else {
                // BASELINE — no rule evaluation (no current state to compare); close now.
                if (deploymentId != null) {
                    try {
                        update new DHC_Deployment__c(
                            Id            = deploymentId,
                            DHC_Status__c = 'Terminé'
                        );
                    } catch (Exception eClose) {
                        System.debug(LoggingLevel.ERROR,
                            'DHC_FieldAccessBatch: impossible de clore le déploiement BASELINE — ' +
                            eClose.getMessage());
                    }
                }
            }
        } catch (Exception ex) {
            System.debug(LoggingLevel.ERROR,
                'DHC_FieldAccessBatch: exception inattendue dans finish() — ' +
                ex.getMessage() + '\n' + ex.getStackTraceString());
            if (deploymentId != null) {
                try {
                    update new DHC_Deployment__c(
                        Id            = deploymentId,
                        DHC_Status__c = 'Échoué'
                    );
                } catch (Exception e2) {
                    System.debug(LoggingLevel.ERROR,
                        'DHC_FieldAccessBatch: impossible de marquer le déploiement en Échoué — ' +
                        e2.getMessage());
                }
            }
        }
    }

    // ─── Row accumulation ─────────────────────────────────────────────────────

    /**
     * Processes one FieldPermissions row into the stateful accumulator.
     * Flushes the previous field when the field name changes.
     *
     * @TestVisible — tests call this directly to simulate chunk boundaries without
     * insertable FieldPermissions records.  The chunk-split scenario is the critical
     * test case: same field fed across two separate accumulateRow call sequences.
     */
    @TestVisible
    private void accumulateRow(
        String  fieldName,
        Boolean canRead,
        Boolean canEdit,
        String  psName
    ) {
        if (pendingFieldName != null && fieldName != pendingFieldName) {
            flushPending();
        }
        pendingFieldName = fieldName;

        if (canRead) pendingAnyRead = true;
        if (canEdit) pendingAnyEdit = true;
        pendingPermSetCount++;

        // Only include in Access map if at least one permission is granted.
        // A row with both false means no access — counted in PermSetCount only.
        if (canRead || canEdit) {
            String letters = '';
            if (canRead) letters += 'r';
            if (canEdit) letters += 'e';
            pendingAccessMap.put(psName, letters);
        }
    }

    /**
     * Flushes any pending field and returns all staged components (no DML).
     *
     * @TestVisible — used by tests to retrieve results synchronously.
     */
    @TestVisible
    private List<DHC_Component__c> collectComponents() {
        flushPending();
        return stagedComponents;
    }

    // ─── Private helpers ──────────────────────────────────────────────────────

    private void flushPending() {
        if (pendingFieldName == null) return;

        Map<String, Object> stateAttrs = new Map<String, Object>{
            'Access'       => new DHC_StateSerializer.NestedMap(pendingAccessMap),
            'AnyEdit'      => pendingAnyEdit,
            'AnyRead'      => pendingAnyRead,
            'PermSetCount' => pendingPermSetCount
        };
        DHC_StateSerializer.Result sr = DHC_StateSerializer.serialize(
            DHC_StateSerializer.FIELD_ACCESS_KEYS, stateAttrs
        );

        DHC_Component__c comp      = new DHC_Component__c();
        comp.DHC_API_Name__c       = pendingFieldName; // Already 'SobjectType.FieldName'
        comp.DHC_Component_Type__c = 'FieldAccess';
        comp.DHC_Label__c          = pendingFieldName;

        if (captureMode == DHC_CaptureMode.BASELINE) {
            comp.DHC_Baseline_State__c = sr.stateJson;
            comp.DHC_Baseline_Hash__c  = sr.hash;
        } else {
            comp.DHC_Current_State__c = sr.stateJson;
            comp.DHC_Current_Hash__c  = sr.hash;
            comp.DHC_Last_Checked__c  = Datetime.now();
        }
        stagedComponents.add(comp);

        // Reset accumulator for the next field
        pendingFieldName    = null;
        pendingAnyRead      = false;
        pendingAnyEdit      = false;
        pendingPermSetCount = 0;
        pendingAccessMap    = new Map<String, String>();
    }

    private void upsertComponents(List<DHC_Component__c> components) {
        List<Database.UpsertResult> results = Database.upsert(
            components,
            DHC_Component__c.DHC_API_Name__c,
            false // allOrNone=false — log partial failures, do not abort the batch
        );
        for (Integer i = 0; i < results.size(); i++) {
            if (!results[i].isSuccess()) {
                System.debug(LoggingLevel.ERROR,
                    'DHC_FieldAccessBatch: échec upsert sur ' +
                    components[i].DHC_API_Name__c + ' — ' +
                    results[i].getErrors()[0].getMessage()
                );
            }
        }
    }
}
