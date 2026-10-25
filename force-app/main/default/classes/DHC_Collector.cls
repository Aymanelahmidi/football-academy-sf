/**
 * @description [SM] Queueable that captures org component state into DHC_Component__c.
 *
 * One Queueable execution processes the first scope type in remainingScopes,
 * then chains a new instance for the rest. The controller builds the initial
 * ordered list via DHC_CaptureScopeSelector.
 *
 * Query isolation pattern (all scopes):
 *   Each scope has a @TestVisible injected<Scope>Rows field. Tests set this field
 *   before enqueueing to bypass the real SOQL. Production uses the real query.
 *
 * ObjectAccess determinism:
 *   buildObjectAccessComponents() is @TestVisible so tests can call it directly
 *   with rows in different orders and compare hashes — no async needed.
 *   The Access map keys are sorted via DHC_StateSerializer.NestedMap + writeNestedMap().
 *
 * No Database.AllowsCallouts — all scopes here use standard SOQL only.
 */
public with sharing class DHC_Collector implements Queueable {

    private final DHC_CaptureMode captureMode;
    private final Id              deploymentId;   // nullable — set by AppController
    private final List<String>    remainingScopes;

    // ─── Test injection points ────────────────────────────────────────────────

    @TestVisible private List<Map<String, Object>> injectedFlowRows;
    @TestVisible private List<Map<String, Object>> injectedPermSetRows;
    @TestVisible private List<Map<String, Object>> injectedObjectAccessRows;
    @TestVisible private List<Map<String, Object>> injectedEntityDefRows;

    // ─── Constructors ────────────────────────────────────────────────────────

    /**
     * Primary constructor — deploymentId is propagated through the chain so
     * the garde-fou can set the deployment to 'Échoué' on unrecoverable error.
     */
    public DHC_Collector(DHC_CaptureMode captureMode, Id deploymentId, List<String> remainingScopes) {
        this.captureMode     = captureMode;
        this.deploymentId    = deploymentId;
        this.remainingScopes = remainingScopes != null ? remainingScopes : new List<String>();
    }

    /** Convenience overload — no deployment association (CollectorController path). */
    public DHC_Collector(DHC_CaptureMode captureMode, List<String> remainingScopes) {
        this(captureMode, null, remainingScopes);
    }

    // ─── Queueable ───────────────────────────────────────────────────────────

    public void execute(QueueableContext ctx) {
        // Terminal case: all Queueable scopes are done — launch FieldAccess batch.
        // The batch is the next link in the sequential chain; it closes the deployment
        // or chains DHC_RuleEngineBatch when it finishes.
        // Guard: test context cannot run a second async job after the Queueable.
        if (remainingScopes.isEmpty()) {
            if (!Test.isRunningTest()) {
                Database.executeBatch(
                    new DHC_FieldAccessBatch(captureMode, deploymentId), 2000
                );
            }
            return;
        }

        String       currentType = remainingScopes[0];
        List<String> nextScopes  = new List<String>();
        for (Integer i = 1; i < remainingScopes.size(); i++) {
            nextScopes.add(remainingScopes[i]);
        }

        try {
            if      (currentType == 'Flow')          { processFlows(getFlowRows()); }
            else if (currentType == 'PermissionSet')  { processPermissionSets(getPermSetRows()); }
            else if (currentType == 'ObjectAccess')   { processObjectAccess(getObjectAccessRows()); }
            else if (currentType == 'EntityDef')      { processEntityDefs(getEntityDefRows()); }
            // Unknown scope types are silently skipped — they do not abort the chain.

            if (!nextScopes.isEmpty()) {
                // More Queueable scopes remain — chain to the next one.
                // Guard: test context cannot chain Queueables (stack depth limit).
                // Each scope is covered individually by its dedicated test class.
                if (!Test.isRunningTest()) {
                    System.enqueueJob(
                        new DHC_Collector(captureMode, deploymentId, nextScopes)
                    );
                }
            } else {
                // Last Queueable scope done — launch FieldAccess batch as terminal step.
                // Guard: test context cannot launch a batch after a Queueable.
                if (!Test.isRunningTest()) {
                    Database.executeBatch(
                        new DHC_FieldAccessBatch(captureMode, deploymentId), 2000
                    );
                }
            }
        } catch (Exception ex) {
            System.debug(LoggingLevel.ERROR,
                'DHC_Collector: exception inattendue sur le scope "' + currentType + '" — ' +
                ex.getMessage() + '\n' + ex.getStackTraceString());
            markDeploymentFailed(ex.getMessage());
        }
    }

    // ─── Garde-fou ───────────────────────────────────────────────────────────

    private void markDeploymentFailed(String errorMessage) {
        if (deploymentId == null) return;
        try {
            update new DHC_Deployment__c(
                Id            = deploymentId,
                DHC_Status__c = 'Échoué'
            );
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR,
                'DHC_Collector: impossible de marquer le déploiement en Échoué — ' +
                e.getMessage());
        }
    }

    // ─── Flow scope ──────────────────────────────────────────────────────────

    private List<Map<String, Object>> getFlowRows() {
        if (injectedFlowRows != null) return injectedFlowRows;
        return queryFlowDefinitions();
    }

    private List<Map<String, Object>> queryFlowDefinitions() {
        List<Map<String, Object>> rows = new List<Map<String, Object>>();
        for (FlowDefinitionView fdv : [
            SELECT ApiName, Label, IsActive, IsOutOfDate,
                   ActiveVersionId, LatestVersionId, VersionNumber,
                   ProcessType, TriggerType, ManageableState
            FROM   FlowDefinitionView
            WHERE  ManageableState = 'unmanaged'
            WITH   USER_MODE
        ]) {
            rows.add(new Map<String, Object>{
                'ApiName'         => fdv.ApiName,
                'Label'           => fdv.Label,
                'IsActive'        => fdv.IsActive,
                'IsOutOfDate'     => fdv.IsOutOfDate,
                'ActiveVersionId' => fdv.ActiveVersionId,
                'LatestVersionId' => fdv.LatestVersionId,
                'VersionNumber'   => fdv.VersionNumber,
                'ProcessType'     => fdv.ProcessType,
                'TriggerType'     => fdv.TriggerType
            });
        }
        return rows;
    }

    private void processFlows(List<Map<String, Object>> flowRows) {
        List<DHC_Component__c> components = new List<DHC_Component__c>();
        for (Map<String, Object> row : flowRows) {
            Map<String, Object> stateAttrs = new Map<String, Object>{
                'ActiveVersionId' => row.get('ActiveVersionId'),
                'IsActive'        => row.get('IsActive'),
                'IsOutOfDate'     => row.get('IsOutOfDate'),
                'LatestVersionId' => row.get('LatestVersionId'),
                'ProcessType'     => row.get('ProcessType'),
                'TriggerType'     => row.get('TriggerType'),
                'VersionNumber'   => row.get('VersionNumber')
            };
            DHC_StateSerializer.Result sr = DHC_StateSerializer.serialize(stateAttrs);
            components.add(buildComponent(
                'Flow.' + (String) row.get('ApiName'), 'Flow',
                (String) row.get('Label'), sr
            ));
        }
        upsertComponents(components);
    }

    // ─── PermissionSet scope — sequence 20 ───────────────────────────────────

    private List<Map<String, Object>> getPermSetRows() {
        if (injectedPermSetRows != null) return injectedPermSetRows;
        return queryPermissionSetRows();
    }

    private List<Map<String, Object>> queryPermissionSetRows() {
        // Query 1 — custom, non-profile permission sets
        List<PermissionSet> permSets = [
            SELECT Id, Name, Label, IsCustom, IsOwnedByProfile, NamespacePrefix, Type
            FROM   PermissionSet
            WHERE  IsOwnedByProfile = false
            AND    IsCustom = true
            WITH   USER_MODE
        ];

        Set<Id> psIds = new Set<Id>();
        for (PermissionSet ps : permSets) { psIds.add(ps.Id); }

        // Query 2 — aggregated assignment counts.
        // Database.queryWithBinds returns List<SObject>; iterate with SObject, not AggregateResult.
        Map<Id, Integer> countById = new Map<Id, Integer>();
        if (!psIds.isEmpty()) {
            Map<String, Object> binds = new Map<String, Object>{ 'psIds' => psIds };
            for (SObject ar : Database.queryWithBinds(
                'SELECT PermissionSetId psId, COUNT(Id) total ' +
                'FROM   PermissionSetAssignment ' +
                'WHERE  IsActive = true AND PermissionSetId IN :psIds ' +
                'GROUP BY PermissionSetId',
                binds,
                AccessLevel.USER_MODE
            )) {
                countById.put((Id) ar.get('psId'), Integer.valueOf(ar.get('total')));
            }
        }

        List<Map<String, Object>> rows = new List<Map<String, Object>>();
        for (PermissionSet ps : permSets) {
            rows.add(new Map<String, Object>{
                'Name'             => ps.Name,
                'Label'            => ps.Label,
                'IsCustom'         => ps.IsCustom,
                'IsOwnedByProfile' => ps.IsOwnedByProfile,
                'Type'             => ps.Type,
                'AssignmentCount'  => countById.containsKey(ps.Id)
                    ? countById.get(ps.Id) : 0
            });
        }
        return rows;
    }

    private void processPermissionSets(List<Map<String, Object>> rows) {
        List<DHC_Component__c> components = new List<DHC_Component__c>();
        for (Map<String, Object> row : rows) {
            Map<String, Object> stateAttrs = new Map<String, Object>{
                'AssignmentCount'  => row.get('AssignmentCount'),
                'IsCustom'         => row.get('IsCustom'),
                'IsOwnedByProfile' => row.get('IsOwnedByProfile'),
                'Type'             => row.get('Type')
            };
            DHC_StateSerializer.Result sr = DHC_StateSerializer.serialize(
                DHC_StateSerializer.PERMISSION_SET_KEYS, stateAttrs
            );
            components.add(buildComponent(
                'PermissionSet.' + (String) row.get('Name'), 'PermissionSet',
                (String) row.get('Label'), sr
            ));
        }
        upsertComponents(components);
    }

    // ─── ObjectAccess scope — sequence 30 ────────────────────────────────────

    private List<Map<String, Object>> getObjectAccessRows() {
        if (injectedObjectAccessRows != null) return injectedObjectAccessRows;
        return queryObjectAccessRows();
    }

    private List<Map<String, Object>> queryObjectAccessRows() {
        List<Map<String, Object>> rows = new List<Map<String, Object>>();
        for (ObjectPermissions op : [
            SELECT ParentId, Parent.Name, SobjectType,
                   PermissionsRead, PermissionsCreate, PermissionsEdit, PermissionsDelete,
                   PermissionsViewAllRecords, PermissionsModifyAllRecords, PermissionsViewAllFields
            FROM   ObjectPermissions
            WHERE  Parent.IsOwnedByProfile = false
            WITH   USER_MODE
        ]) {
            rows.add(new Map<String, Object>{
                'SobjectType'                => op.SobjectType,
                'ParentName'                 => op.Parent.Name,
                'PermissionsRead'            => op.PermissionsRead,
                'PermissionsCreate'          => op.PermissionsCreate,
                'PermissionsEdit'            => op.PermissionsEdit,
                'PermissionsDelete'          => op.PermissionsDelete,
                'PermissionsViewAllRecords'  => op.PermissionsViewAllRecords,
                'PermissionsModifyAllRecords'=> op.PermissionsModifyAllRecords,
                'PermissionsViewAllFields'   => op.PermissionsViewAllFields
            });
        }
        return rows;
    }

    /**
     * Builds DHC_Component__c list from raw ObjectPermissions rows without DML.
     * @TestVisible: determinism tests call this directly with rows in different orders
     * and compare the resulting hashes — no async, no startTest needed.
     */
    @TestVisible
    private List<DHC_Component__c> buildObjectAccessComponents(
        List<Map<String, Object>> rawRows
    ) {
        // Group: one aggregated state per SobjectType
        Map<String, Map<String, Object>>  aggByObject    = new Map<String, Map<String, Object>>();
        Map<String, Map<String, String>>  accessByObject = new Map<String, Map<String, String>>();

        for (Map<String, Object> row : rawRows) {
            String sObjectType = (String) row.get('SobjectType');
            String parentName  = (String) row.get('ParentName');

            if (!aggByObject.containsKey(sObjectType)) {
                aggByObject.put(sObjectType, new Map<String, Object>{
                    'AnyRead'         => false,
                    'AnyCreate'       => false,
                    'AnyEdit'         => false,
                    'AnyDelete'       => false,
                    'AnyViewAll'      => false,
                    'AnyModifyAll'    => false,
                    'AnyViewAllFields'=> false,
                    'PermSetCount'    => 0
                });
                accessByObject.put(sObjectType, new Map<String, String>());
            }

            Map<String, Object> agg = aggByObject.get(sObjectType);
            Map<String, String> acc = accessByObject.get(sObjectType);

            // OR-aggregate booleans across all permission sets
            if ((Boolean) row.get('PermissionsRead'))             agg.put('AnyRead', true);
            if ((Boolean) row.get('PermissionsCreate'))           agg.put('AnyCreate', true);
            if ((Boolean) row.get('PermissionsEdit'))             agg.put('AnyEdit', true);
            if ((Boolean) row.get('PermissionsDelete'))           agg.put('AnyDelete', true);
            if ((Boolean) row.get('PermissionsViewAllRecords'))   agg.put('AnyViewAll', true);
            if ((Boolean) row.get('PermissionsModifyAllRecords')) agg.put('AnyModifyAll', true);
            if ((Boolean) row.get('PermissionsViewAllFields'))    agg.put('AnyViewAllFields', true);

            agg.put('PermSetCount', (Integer) agg.get('PermSetCount') + 1);

            // acc keys are sorted by writeNestedMap at serialization time —
            // insertion order here does NOT affect the hash.
            acc.put(parentName, buildAccessLetters(row));
        }

        // Build components
        List<DHC_Component__c> components = new List<DHC_Component__c>();
        for (String sObjectType : aggByObject.keySet()) {
            Map<String, Object> stateAttrs = aggByObject.get(sObjectType);
            // Wrap the string map in NestedMap so the serializer can sort its keys.
            stateAttrs.put('Access',
                new DHC_StateSerializer.NestedMap(accessByObject.get(sObjectType))
            );
            DHC_StateSerializer.Result sr = DHC_StateSerializer.serialize(
                DHC_StateSerializer.OBJECT_ACCESS_KEYS, stateAttrs
            );
            components.add(buildComponent(
                'ObjectAccess.' + sObjectType, 'ObjectAccess', sObjectType, sr
            ));
        }
        return components;
    }

    /**
     * Encodes one ObjectPermissions row as compact letters.
     * Fixed order: r c e d v m f — never changes, changing order = different hash.
     */
    private static String buildAccessLetters(Map<String, Object> row) {
        String letters = '';
        if ((Boolean) row.get('PermissionsRead'))             letters += 'r';
        if ((Boolean) row.get('PermissionsCreate'))           letters += 'c';
        if ((Boolean) row.get('PermissionsEdit'))             letters += 'e';
        if ((Boolean) row.get('PermissionsDelete'))           letters += 'd';
        if ((Boolean) row.get('PermissionsViewAllRecords'))   letters += 'v';
        if ((Boolean) row.get('PermissionsModifyAllRecords')) letters += 'm';
        if ((Boolean) row.get('PermissionsViewAllFields'))    letters += 'f';
        return letters;
    }

    private void processObjectAccess(List<Map<String, Object>> rawRows) {
        upsertComponents(buildObjectAccessComponents(rawRows));
    }

    // ─── EntityDef scope — sequence 40 ───────────────────────────────────────

    private List<Map<String, Object>> getEntityDefRows() {
        if (injectedEntityDefRows != null) return injectedEntityDefRows;
        return queryEntityDefRows();
    }

    private List<Map<String, Object>> queryEntityDefRows() {
        List<Map<String, Object>> rows = new List<Map<String, Object>>();
        Map<String, Object> binds = new Map<String, Object>{ 'pattern' => '%__c' };
        for (SObject ed : Database.queryWithBinds(
            'SELECT QualifiedApiName, Label, DeploymentStatus, InternalSharingModel, ' +
            'ExternalSharingModel, IsCustomizable ' +
            'FROM   EntityDefinition ' +
            'WHERE  QualifiedApiName LIKE :pattern',
            binds,
            AccessLevel.USER_MODE
        )) {
            rows.add(new Map<String, Object>{
                'QualifiedApiName'     => ed.get('QualifiedApiName'),
                'Label'                => ed.get('Label'),
                'DeploymentStatus'     => ed.get('DeploymentStatus'),
                'InternalSharingModel' => ed.get('InternalSharingModel'),
                'ExternalSharingModel' => ed.get('ExternalSharingModel'),
                'IsCustomizable'       => ed.get('IsCustomizable')
            });
        }
        return rows;
    }

    private void processEntityDefs(List<Map<String, Object>> rows) {
        List<DHC_Component__c> components = new List<DHC_Component__c>();
        for (Map<String, Object> row : rows) {
            Map<String, Object> stateAttrs = new Map<String, Object>{
                'DeploymentStatus'     => row.get('DeploymentStatus'),
                'ExternalSharingModel' => row.get('ExternalSharingModel'),
                'InternalSharingModel' => row.get('InternalSharingModel'),
                'IsCustomizable'       => row.get('IsCustomizable')
            };
            DHC_StateSerializer.Result sr = DHC_StateSerializer.serialize(
                DHC_StateSerializer.ENTITY_DEF_KEYS, stateAttrs
            );
            components.add(buildComponent(
                'EntityDef.' + (String) row.get('QualifiedApiName'), 'EntityDef',
                (String) row.get('Label'), sr
            ));
        }
        upsertComponents(components);
    }

    // ─── Shared helpers ──────────────────────────────────────────────────────

    private DHC_Component__c buildComponent(
        String apiName, String componentType, String label,
        DHC_StateSerializer.Result sr
    ) {
        DHC_Component__c comp      = new DHC_Component__c();
        comp.DHC_API_Name__c       = apiName;
        comp.DHC_Component_Type__c = componentType;
        comp.DHC_Label__c          = label;
        if (captureMode == DHC_CaptureMode.BASELINE) {
            comp.DHC_Baseline_State__c = sr.stateJson;
            comp.DHC_Baseline_Hash__c  = sr.hash;
        } else {
            comp.DHC_Current_State__c = sr.stateJson;
            comp.DHC_Current_Hash__c  = sr.hash;
            comp.DHC_Last_Checked__c  = Datetime.now();
        }
        return comp;
    }

    private void upsertComponents(List<DHC_Component__c> components) {
        if (!components.isEmpty()) {
            Database.upsert(components, DHC_Component__c.DHC_API_Name__c, AccessLevel.USER_MODE);
        }
    }
}
