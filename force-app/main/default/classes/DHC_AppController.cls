/**
 * @description [LC] Apex API layer for the DHC React front-end.
 * All @AuraEnabled methods are the sole entry point from the dhcApp LWC wrapper.
 * No raw SObjects are returned — all data is wrapped in DTOs.
 *
 * SECURITY:
 *   All SOQL on custom objects uses WITH USER_MODE (enforces FLS + CRUD for reads).
 *   All DML uses `insert/update as user` (enforces FLS + CRUD for writes).
 *   Mutation methods (startCapture, updateFindingStatus) perform explicit
 *   isCreateable()/isUpdateable() checks before DML for clear error messages.
 *   Custom metadata (__mdt) is platform data — no FLS/CRUD applies.
 *
 * VALIDATION:
 *   Severity, status, and capture mode are validated against hard-coded
 *   whitelists — never used verbatim in SOQL.
 *   pageSize is silently capped at 200 (never throws for oversized values).
 */
public with sharing class DHC_AppController {

    // ─── DTOs ─────────────────────────────────────────────────────────────────

    public class DeploymentSummaryDTO {
        @AuraEnabled public Id       id;
        @AuraEnabled public String   releaseLabel;
        @AuraEnabled public Datetime runDate;
        @AuraEnabled public String   status;
        @AuraEnabled public Integer  criticalCount;
        @AuraEnabled public Integer  warningCount;
        @AuraEnabled public Integer  informationCount;
        @AuraEnabled public Integer  notEvaluableCount;
        @AuraEnabled public String   ticketRefs;
    }

    public class FindingDTO {
        @AuraEnabled public Id     id;
        @AuraEnabled public String severity;
        @AuraEnabled public String message;
        @AuraEnabled public String status;
        @AuraEnabled public String justification;
        @AuraEnabled public String ruleCode;
        @AuraEnabled public Id     componentId;
        @AuraEnabled public String componentLabel;
        @AuraEnabled public String componentType;
    }

    public class FindingPageDTO {
        @AuraEnabled public List<FindingDTO> findings;
        @AuraEnabled public Integer          totalCount;
        @AuraEnabled public Integer          pageNumber;
        @AuraEnabled public Integer          pageSize;
    }

    public class ComponentDetailDTO {
        @AuraEnabled public Id       id;
        @AuraEnabled public String   apiName;
        @AuraEnabled public String   label;
        @AuraEnabled public String   componentType;
        @AuraEnabled public Boolean  hasChanged;
        @AuraEnabled public Boolean  isAbsent;
        @AuraEnabled public String   baselineState;
        @AuraEnabled public String   currentState;
        @AuraEnabled public Datetime lastChecked;
        @AuraEnabled public Datetime lastChanged;
        @AuraEnabled public Integer  changeCount;
    }

    public class CaptureScopeDTO {
        @AuraEnabled public String  label;
        @AuraEnabled public String  componentType;
        @AuraEnabled public Integer sequence;
        @AuraEnabled public Boolean isActive;
        @AuraEnabled public String  targetObjects;
    }

    public class RuleDTO {
        @AuraEnabled public String code;
        @AuraEnabled public String componentType;
        @AuraEnabled public String attribute;
        @AuraEnabled public String operator;
        @AuraEnabled public String expectedValue;
        @AuraEnabled public String severity;
        @AuraEnabled public String message;
    }

    // ─── Whitelists ────────────────────────────────────────────────────────────

    private static final Set<String> VALID_SEVERITIES =
        new Set<String>{ 'Critique', 'Avertissement', 'Information', 'Non évaluable' };
    private static final Set<String> VALID_STATUSES =
        new Set<String>{ 'Ouvert', 'Corrigé', 'Accepté' };
    private static final Set<String> VALID_MODES =
        new Set<String>{ 'BASELINE', 'CURRENT' };

    // ─── Error helper ──────────────────────────────────────────────────────────

    /**
     * AuraHandledException.getMessage() returns "Script-thrown exception" when
     * the message is only passed to the constructor. Calling setMessage() ensures
     * the real message propagates to the client and to test assertions.
     */
    private static AuraHandledException buildError(String msg) {
        AuraHandledException e = new AuraHandledException(msg);
        e.setMessage(msg);
        return e;
    }

    // ─── Read methods ──────────────────────────────────────────────────────────

    /**
     * Returns the most recent deployment with live per-severity finding counts,
     * or null if no deployment exists.
     *
     * criticalCount and warningCount come from the deployment record (denormalized).
     * informationCount and notEvaluableCount are computed live via GROUP BY.
     */
    @AuraEnabled(cacheable=true)
    public static DeploymentSummaryDTO getLatestDeployment() {
        try {
            List<DHC_Deployment__c> rows = [
                SELECT Id, DHC_Release_Label__c, DHC_Run_Date__c, DHC_Status__c,
                       DHC_Critical_Count__c, DHC_Warning_Count__c, DHC_Ticket_Refs__c
                FROM DHC_Deployment__c
                WITH USER_MODE
                ORDER BY DHC_Run_Date__c DESC NULLS LAST
                LIMIT 1
            ];
            if (rows.isEmpty()) { return null; }

            DeploymentSummaryDTO dto = toDeploymentDTO(rows[0]);

            // Compute Information / Non évaluable counts live from findings
            Id depId = rows[0].Id;
            for (AggregateResult ar : [
                SELECT DHC_Severity__c, COUNT(Id) cnt
                FROM DHC_Finding__c
                WHERE DHC_Deployment__c = :depId
                WITH USER_MODE
                GROUP BY DHC_Severity__c
            ]) {
                String  sev = (String)  ar.get('DHC_Severity__c');
                Integer cnt = ((Decimal) ar.get('cnt')).intValue();
                if      ('Information'.equals(sev))    dto.informationCount  = cnt;
                else if ('Non évaluable'.equals(sev))  dto.notEvaluableCount = cnt;
                else if ('Critique'.equals(sev))       dto.criticalCount     = cnt;
                else if ('Avertissement'.equals(sev))  dto.warningCount      = cnt;
            }
            return dto;
        } catch (Exception e) {
            throw buildError(e.getMessage());
        }
    }

    /**
     * Returns up to limitSize deployments ordered by date descending.
     * limitSize is silently clamped to [10, 50].
     */
    @AuraEnabled(cacheable=true)
    public static List<DeploymentSummaryDTO> getDeployments(Integer limitSize) {
        try {
            Integer safeLimit = (limitSize == null || limitSize < 10) ? 10
                              : (limitSize > 50 ? 50 : limitSize);
            List<DHC_Deployment__c> rows = (List<DHC_Deployment__c>) Database.queryWithBinds(
                'SELECT Id, DHC_Release_Label__c, DHC_Run_Date__c, DHC_Status__c, ' +
                'DHC_Critical_Count__c, DHC_Warning_Count__c, DHC_Ticket_Refs__c ' +
                'FROM DHC_Deployment__c ORDER BY DHC_Run_Date__c DESC NULLS LAST LIMIT :lim',
                new Map<String, Object>{ 'lim' => safeLimit },
                AccessLevel.USER_MODE
            );
            List<DeploymentSummaryDTO> result = new List<DeploymentSummaryDTO>();
            for (DHC_Deployment__c d : rows) { result.add(toDeploymentDTO(d)); }
            return result;
        } catch (Exception e) {
            throw buildError(e.getMessage());
        }
    }

    /**
     * Returns a page of findings for a given deployment.
     * severity, status, and componentId filters are optional (null/blank = no filter).
     * pageSize is silently capped at 200. pageNumber is 1-based.
     *
     * @throws AuraHandledException when severity or status is not in the whitelist.
     */
    @AuraEnabled(cacheable=true)
    public static FindingPageDTO getFindings(
        Id deploymentId, Id componentId, String severity, String status,
        Integer pageSize, Integer pageNumber
    ) {
        try {
            if (String.isNotBlank(severity) && !VALID_SEVERITIES.contains(severity)) {
                throw buildError('Sévérité non autorisée : ' + severity);
            }
            if (String.isNotBlank(status) && !VALID_STATUSES.contains(status)) {
                throw buildError('Statut non autorisé : ' + status);
            }

            Integer safeSize  = (pageSize   == null || pageSize   < 1) ? 20
                              : (pageSize   > 200 ? 200 : pageSize);
            Integer safePage  = (pageNumber == null || pageNumber < 1) ? 1 : pageNumber;
            Integer offsetVal = (safePage - 1) * safeSize;

            String whereClause = 'DHC_Deployment__c = :depId';
            Map<String, Object> binds = new Map<String, Object>{ 'depId' => deploymentId };

            if (componentId != null) {
                whereClause += ' AND DHC_Component__c = :compId';
                binds.put('compId', componentId);
            }
            if (String.isNotBlank(severity)) {
                whereClause += ' AND DHC_Severity__c = :sev';
                binds.put('sev', severity);
            }
            if (String.isNotBlank(status)) {
                whereClause += ' AND DHC_Status__c = :stat';
                binds.put('stat', status);
            }
            binds.put('lim', safeSize);
            binds.put('off', offsetVal);

            Integer total = Database.countQueryWithBinds(
                'SELECT COUNT() FROM DHC_Finding__c WHERE ' + whereClause,
                binds, AccessLevel.USER_MODE
            );

            List<DHC_Finding__c> rows = (List<DHC_Finding__c>) Database.queryWithBinds(
                'SELECT Id, DHC_Severity__c, DHC_Message__c, DHC_Status__c, ' +
                'DHC_Justification__c, DHC_Rule_Code__c, DHC_Component__c, ' +
                'DHC_Component__r.DHC_Label__c, DHC_Component__r.DHC_Component_Type__c ' +
                'FROM DHC_Finding__c WHERE ' + whereClause +
                ' ORDER BY DHC_Severity__c, DHC_Rule_Code__c LIMIT :lim OFFSET :off',
                binds, AccessLevel.USER_MODE
            );

            List<FindingDTO> dtos = new List<FindingDTO>();
            for (DHC_Finding__c f : rows) { dtos.add(toFindingDTO(f)); }

            FindingPageDTO fp = new FindingPageDTO();
            fp.findings   = dtos;
            fp.totalCount = total;
            fp.pageNumber = safePage;
            fp.pageSize   = safeSize;
            return fp;
        } catch (AuraHandledException ahe) {
            throw ahe;
        } catch (Exception e) {
            throw buildError(e.getMessage());
        }
    }

    /**
     * Returns the full detail of a single DHC_Component__c, or null if not found.
     */
    @AuraEnabled(cacheable=true)
    public static ComponentDetailDTO getComponentDetail(Id componentId) {
        try {
            List<DHC_Component__c> rows = [
                SELECT Id, DHC_API_Name__c, DHC_Label__c, DHC_Component_Type__c,
                       DHC_Has_Changed__c, DHC_Is_Absent__c, DHC_Baseline_State__c,
                       DHC_Current_State__c, DHC_Last_Checked__c, DHC_Last_Changed__c,
                       DHC_Change_Count__c
                FROM DHC_Component__c
                WHERE Id = :componentId
                WITH USER_MODE
                LIMIT 1
            ];
            return rows.isEmpty() ? null : toComponentDetailDTO(rows[0]);
        } catch (Exception e) {
            throw buildError(e.getMessage());
        }
    }

    /**
     * Returns all DHC_Capture_Scope__mdt records ordered by sequence.
     * Custom Metadata Types do not support WITH USER_MODE / AccessLevel.USER_MODE.
     * SYSTEM_MODE is correct — __mdt records are platform data, not user records.
     */
    @AuraEnabled(cacheable=true)
    public static List<CaptureScopeDTO> getCaptureScopeConfig() {
        try {
            List<DHC_Capture_Scope__mdt> scopes = (List<DHC_Capture_Scope__mdt>)
                Database.queryWithBinds(
                    'SELECT MasterLabel, DHC_Component_Type__c, DHC_Sequence__c, ' +
                    'DHC_Is_Active__c, DHC_Target_Objects__c ' +
                    'FROM DHC_Capture_Scope__mdt ' +
                    'ORDER BY DHC_Sequence__c ASC NULLS LAST',
                    new Map<String, Object>(),
                    AccessLevel.SYSTEM_MODE
                );
            List<CaptureScopeDTO> result = new List<CaptureScopeDTO>();
            for (DHC_Capture_Scope__mdt s : scopes) {
                CaptureScopeDTO dto = new CaptureScopeDTO();
                dto.label         = s.MasterLabel;
                dto.componentType = s.DHC_Component_Type__c;
                dto.sequence      = (s.DHC_Sequence__c != null)
                                  ? (Integer) s.DHC_Sequence__c : null;
                dto.isActive      = s.DHC_Is_Active__c;
                dto.targetObjects = s.DHC_Target_Objects__c;
                result.add(dto);
            }
            return result;
        } catch (Exception e) {
            throw buildError(e.getMessage());
        }
    }

    /**
     * Returns all active DHC_Rule__mdt records ordered by component type then severity.
     * Custom Metadata Types do not support WITH USER_MODE / AccessLevel.USER_MODE.
     * SYSTEM_MODE is correct — __mdt records are platform data, not user records.
     */
    @AuraEnabled(cacheable=true)
    public static List<RuleDTO> getActiveRules() {
        try {
            List<DHC_Rule__mdt> rules = (List<DHC_Rule__mdt>)
                Database.queryWithBinds(
                    'SELECT DeveloperName, DHC_Component_Type__c, DHC_Attribute__c, ' +
                    'DHC_Operator__c, DHC_Expected_Value__c, DHC_Severity__c, DHC_Message__c ' +
                    'FROM DHC_Rule__mdt ' +
                    'WHERE DHC_Is_Active__c = :active ' +
                    'ORDER BY DHC_Component_Type__c ASC, DHC_Severity__c ASC',
                    new Map<String, Object>{ 'active' => true },
                    AccessLevel.SYSTEM_MODE
                );
            List<RuleDTO> result = new List<RuleDTO>();
            for (DHC_Rule__mdt r : rules) {
                RuleDTO dto = new RuleDTO();
                dto.code          = r.DeveloperName;
                dto.componentType = r.DHC_Component_Type__c;
                dto.attribute     = r.DHC_Attribute__c;
                dto.operator      = r.DHC_Operator__c;
                dto.expectedValue = r.DHC_Expected_Value__c;
                dto.severity      = r.DHC_Severity__c;
                dto.message       = r.DHC_Message__c;
                result.add(dto);
            }
            return result;
        } catch (Exception e) {
            throw buildError(e.getMessage());
        }
    }

    // ─── Mutation methods ──────────────────────────────────────────────────────

    /**
     * Creates a DHC_Deployment__c, enqueues the Collector chain for non-FieldAccess
     * scopes, and executes DHC_FieldAccessBatch for field-level security capture.
     *
     * @param mode  'BASELINE' or 'CURRENT'.
     * @return      Id of the newly created DHC_Deployment__c.
     * @throws AuraHandledException on invalid mode or insufficient permissions.
     */
    @AuraEnabled
    public static Id startCapture(String mode) {
        try {
            if (!VALID_MODES.contains(mode)) {
                throw buildError('Mode de capture non autorisé : ' + mode);
            }
            if (!Schema.SObjectType.DHC_Deployment__c.isCreateable()) {
                throw buildError(
                    'Permission insuffisante : création de DHC_Deployment__c non autorisée.');
            }

            DHC_CaptureMode captureMode = (mode == 'BASELINE')
                ? DHC_CaptureMode.BASELINE : DHC_CaptureMode.CURRENT;

            DHC_Deployment__c deployment = new DHC_Deployment__c(
                DHC_Release_Label__c = mode + ' — ' + Datetime.now().format('yyyy-MM-dd HH:mm'),
                DHC_Run_Date__c      = Datetime.now(),
                DHC_Status__c        = 'En cours'
            );
            insert as user deployment;

            // Build Queueable scopes — FieldAccess is handled as the terminal batch step.
            List<String> allScopes       = DHC_CaptureScopeSelector.getActiveScopeTypes();
            List<String> collectorScopes = new List<String>();
            for (String s : allScopes) {
                if (s != 'FieldAccess') { collectorScopes.add(s); }
            }
            // Always enqueue the Collector, even with an empty scope list.
            // When remainingScopes empties, the Collector launches DHC_FieldAccessBatch.
            // DHC_FieldAccessBatch.finish() then closes the deployment (BASELINE)
            // or chains DHC_RuleEngineBatch (CURRENT) — fully sequential, zero manual steps.
            System.enqueueJob(new DHC_Collector(captureMode, deployment.Id, collectorScopes));

            return deployment.Id;
        } catch (AuraHandledException ahe) {
            throw ahe;
        } catch (Exception e) {
            throw buildError(e.getMessage());
        }
    }

    /**
     * Launches DHC_RuleEngineBatch for an existing deployment.
     * Allows re-evaluation without recapturing state — useful after fixing a finding
     * or after updating rule configuration.
     *
     * DHC_User (read-only) is blocked by the isUpdateable() check on DHC_Deployment__c.
     *
     * @param deploymentId  Id of the DHC_Deployment__c to (re-)evaluate.
     * @throws AuraHandledException on null deploymentId or insufficient permissions.
     */
    @AuraEnabled
    public static void runRuleEngine(Id deploymentId) {
        try {
            if (deploymentId == null) {
                throw buildError('L\'identifiant du déploiement est obligatoire.');
            }
            if (!Schema.SObjectType.DHC_Deployment__c.isUpdateable()) {
                throw buildError(
                    'Permission insuffisante : modification de DHC_Deployment__c non autorisée.');
            }
            if (!Test.isRunningTest()) {
                Database.executeBatch(new DHC_RuleEngineBatch(deploymentId), 200);
            }
        } catch (AuraHandledException ahe) {
            throw ahe;
        } catch (Exception e) {
            throw buildError(e.getMessage());
        }
    }

    /**
     * Updates a finding's status and justification.
     * A justification is mandatory when status is 'Corrigé' or 'Accepté'.
     *
     * @throws AuraHandledException on invalid status, missing justification,
     *                              or insufficient permissions.
     */
    @AuraEnabled
    public static void updateFindingStatus(
        Id findingId, String status, String justification
    ) {
        try {
            if (!VALID_STATUSES.contains(status)) {
                throw buildError('Statut non autorisé : ' + status);
            }
            if (status != 'Ouvert' && String.isBlank(justification)) {
                throw buildError(
                    'Une justification est obligatoire pour le statut ' + status + '.');
            }
            if (!Schema.SObjectType.DHC_Finding__c.isUpdateable()) {
                throw buildError(
                    'Permission insuffisante : modification de DHC_Finding__c non autorisée.');
            }

            DHC_Finding__c finding = new DHC_Finding__c(
                Id                   = findingId,
                DHC_Status__c        = status,
                DHC_Justification__c = String.isNotBlank(justification) ? justification : null
            );
            update as user finding;
        } catch (AuraHandledException ahe) {
            throw ahe;
        } catch (Exception e) {
            throw buildError(e.getMessage());
        }
    }

    // ─── DTO factories ─────────────────────────────────────────────────────────

    private static DeploymentSummaryDTO toDeploymentDTO(DHC_Deployment__c d) {
        DeploymentSummaryDTO dto = new DeploymentSummaryDTO();
        dto.id                = d.Id;
        dto.releaseLabel      = d.DHC_Release_Label__c;
        dto.runDate           = d.DHC_Run_Date__c;
        dto.status            = d.DHC_Status__c;
        dto.criticalCount     = (d.DHC_Critical_Count__c != null)
                              ? (Integer) d.DHC_Critical_Count__c : 0;
        dto.warningCount      = (d.DHC_Warning_Count__c  != null)
                              ? (Integer) d.DHC_Warning_Count__c  : 0;
        dto.informationCount  = 0;
        dto.notEvaluableCount = 0;
        dto.ticketRefs        = d.DHC_Ticket_Refs__c;
        return dto;
    }

    private static FindingDTO toFindingDTO(DHC_Finding__c f) {
        FindingDTO dto = new FindingDTO();
        dto.id             = f.Id;
        dto.severity       = f.DHC_Severity__c;
        dto.message        = f.DHC_Message__c;
        dto.status         = f.DHC_Status__c;
        dto.justification  = f.DHC_Justification__c;
        dto.ruleCode       = f.DHC_Rule_Code__c;
        dto.componentId    = f.DHC_Component__c;
        dto.componentLabel = (f.DHC_Component__r != null) ? f.DHC_Component__r.DHC_Label__c          : null;
        dto.componentType  = (f.DHC_Component__r != null) ? f.DHC_Component__r.DHC_Component_Type__c : null;
        return dto;
    }

    private static ComponentDetailDTO toComponentDetailDTO(DHC_Component__c c) {
        ComponentDetailDTO dto = new ComponentDetailDTO();
        dto.id            = c.Id;
        dto.apiName       = c.DHC_API_Name__c;
        dto.label         = c.DHC_Label__c;
        dto.componentType = c.DHC_Component_Type__c;
        dto.hasChanged    = c.DHC_Has_Changed__c;
        dto.isAbsent      = c.DHC_Is_Absent__c;
        dto.baselineState = c.DHC_Baseline_State__c;
        dto.currentState  = c.DHC_Current_State__c;
        dto.lastChecked   = c.DHC_Last_Checked__c;
        dto.lastChanged   = c.DHC_Last_Changed__c;
        dto.changeCount   = (c.DHC_Change_Count__c != null) ? (Integer) c.DHC_Change_Count__c : 0;
        return dto;
    }
}
