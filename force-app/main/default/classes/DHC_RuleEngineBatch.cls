/**
 * @description [SM] Batch that evaluates all active DHC_Rule__mdt records against
 * captured DHC_Component__c states and produces DHC_Finding__c records.
 *
 * RECOMMENDED BATCH SIZE: 200
 *   Each component's state JSON is parsed and each rule's evaluate() is called.
 *   JSON parsing is heap-intensive; 200 keeps the batch well within heap limits
 *   even for large FieldAccess payloads.
 *   Caller: Database.executeBatch(new DHC_RuleEngineBatch(deploymentId), 200)
 *
 * IDEMPOTENCE:
 *   start() deletes all 'Ouvert' DHC_Finding__c for this deployment before
 *   the first execute() runs. Findings in 'Corrigé' or 'Accepté' are NEVER
 *   deleted — they carry a human decision (DHC_Justification__c) and must survive
 *   re-runs.
 *   If more than 10 000 Ouvert findings exist (SOQL LIMIT), the excess are not
 *   deleted on this run. Log is emitted; re-runs will clear the remainder.
 *
 * RULE LOADING:
 *   All active DHC_Rule__mdt records are loaded once in the constructor,
 *   indexed by DHC_Component_Type__c. Never queried inside execute().
 *
 * NON ÉVALUABLE FINDINGS:
 *   A 'Non évaluable' verdict triggers a DHC_Finding__c with DHC_Status__c = 'Ouvert'
 *   and DHC_Severity__c = 'Non évaluable'. It is NOT counted in Critical_Count or
 *   Warning_Count. It is logged in notEvaluableCount for observability.
 *
 * MESSAGE TOKENS:
 *   {component} → DHC_Label__c (or DHC_API_Name__c if label blank)
 *   {value}     → current evaluated value
 *   {expected}  → DHC_Expected_Value__c
 *   Tokens with no value are removed (never written as 'null').
 */
public with sharing class DHC_RuleEngineBatch
    implements Database.Batchable<SObject>, Database.Stateful {

    private final Id deploymentId;

    // Rules loaded once in constructor — never queried in execute()
    private Map<String, List<DHC_Rule__mdt>> rulesByType;

    // ─── Stateful counters ────────────────────────────────────────────────────

    private Integer criticalCount     = 0;
    private Integer warningCount      = 0;
    private Integer infoCount         = 0;
    private Integer notEvaluableCount = 0;
    private Integer componentsScanned = 0;
    private Boolean hasErrors         = false;

    // ─── Constructors ─────────────────────────────────────────────────────────

    public DHC_RuleEngineBatch(Id deploymentId) {
        this.deploymentId = deploymentId;
        this.rulesByType  = loadActiveRules();
    }

    /**
     * @TestVisible overload — injects a pre-built rulesByType map.
     * Used in tests so rules are never dependent on Custom Metadata deployed to the org.
     */
    @TestVisible
    private DHC_RuleEngineBatch(
        Id                               deploymentId,
        Map<String, List<DHC_Rule__mdt>> injectedRules
    ) {
        this.deploymentId = deploymentId;
        this.rulesByType  = injectedRules != null ? injectedRules : new Map<String, List<DHC_Rule__mdt>>();
    }

    // ─── Batchable ────────────────────────────────────────────────────────────

    public Database.QueryLocator start(Database.BatchableContext bc) {
        // Idempotence — delete Ouvert findings so a re-run is clean.
        // 'Corrigé' and 'Accepté' findings are preserved (human decisions).
        // LIMIT 10 000 = DML row limit per transaction.
        if (deploymentId != null) {
            Map<String, Object> binds = new Map<String, Object>{
                'deploymentId' => deploymentId
            };
            List<SObject> toDelete = Database.queryWithBinds(
                'SELECT Id FROM DHC_Finding__c ' +
                'WHERE DHC_Deployment__c = :deploymentId AND DHC_Status__c = \'Ouvert\' ' +
                'LIMIT 10000',
                binds,
                AccessLevel.USER_MODE
            );
            if (!toDelete.isEmpty()) {
                if (toDelete.size() == 10000) {
                    System.debug(LoggingLevel.WARN,
                        'DHC_RuleEngineBatch: 10 000 findings Ouvert supprimés — ' +
                        'il peut en rester davantage. Relancer le batch pour nettoyer le reste.');
                }
                Database.delete(toDelete, false);
            }
        }

        return Database.getQueryLocator([
            SELECT Id, DHC_API_Name__c, DHC_Component_Type__c, DHC_Label__c,
                   DHC_Baseline_State__c, DHC_Current_State__c,
                   DHC_Baseline_Hash__c,  DHC_Current_Hash__c,
                   DHC_Is_Absent__c
            FROM   DHC_Component__c
            WITH   USER_MODE
        ]);
    }

    public void execute(Database.BatchableContext bc, List<SObject> scope) {
        List<DHC_Finding__c> findings = new List<DHC_Finding__c>();

        for (SObject record : scope) {
            DHC_Component__c comp = (DHC_Component__c) record;
            componentsScanned++;

            String componentType = comp.DHC_Component_Type__c;
            List<DHC_Rule__mdt> rules = rulesByType.get(componentType);

            if (rules == null || rules.isEmpty()) {
                System.debug(LoggingLevel.DEBUG,
                    'DHC_RuleEngineBatch: aucune règle active pour le type "' +
                    componentType + '" (' + comp.DHC_API_Name__c + ')');
                continue;
            }

            Map<String, Object> baselineState = DHC_RuleEvaluator.parseState(comp.DHC_Baseline_State__c);
            Map<String, Object> currentState  = DHC_RuleEvaluator.parseState(comp.DHC_Current_State__c);
            Boolean             isAbsent      = comp.DHC_Is_Absent__c == true;

            String componentLabel = String.isNotBlank(comp.DHC_Label__c)
                ? comp.DHC_Label__c
                : comp.DHC_API_Name__c;

            for (DHC_Rule__mdt rule : rules) {
                DHC_RuleEvaluator.Verdict verdict = DHC_RuleEvaluator.evaluate(
                    rule, baselineState, currentState, isAbsent
                );

                if (!verdict.triggered) continue;

                // Accumulate counters — 'Non évaluable' never counts in Critical/Warning
                if      (verdict.severity == 'Critique')      criticalCount++;
                else if (verdict.severity == 'Avertissement')  warningCount++;
                else if (verdict.severity == 'Info')           infoCount++;
                else if (verdict.severity == 'Non évaluable')  notEvaluableCount++;

                // Substitute {component}, {value}, {expected} tokens
                String finalMessage = DHC_RuleEvaluator.renderMessage(
                    verdict.message,
                    componentLabel,
                    verdict.evaluatedValue,
                    rule.DHC_Expected_Value__c
                );

                DHC_Finding__c finding   = new DHC_Finding__c();
                finding.DHC_Component__c  = comp.Id;
                finding.DHC_Deployment__c = deploymentId;
                finding.DHC_Rule_Code__c  = rule.DeveloperName;
                finding.DHC_Severity__c   = verdict.severity;
                finding.DHC_Message__c    = finalMessage;
                finding.DHC_Status__c     = 'Ouvert';
                findings.add(finding);
            }
        }

        if (!findings.isEmpty()) {
            insertFindings(findings);
        }
    }

    public void finish(Database.BatchableContext bc) {
        try {
            System.debug(LoggingLevel.INFO,
                'DHC_RuleEngineBatch terminé — ' +
                'composants scannés : '   + componentsScanned +
                ' | critiques : '         + criticalCount +
                ' | avertissements : '    + warningCount +
                ' | info : '              + infoCount +
                ' | non évaluables : '    + notEvaluableCount +
                ' | erreurs DML : '       + hasErrors
            );

            if (deploymentId != null) {
                DHC_Deployment__c dep = new DHC_Deployment__c(
                    Id                    = deploymentId,
                    DHC_Critical_Count__c = criticalCount,
                    DHC_Warning_Count__c  = warningCount,
                    DHC_Status__c         = hasErrors ? 'Échoué' : 'Terminé'
                );
                try {
                    update dep;
                } catch (Exception e) {
                    System.debug(LoggingLevel.ERROR,
                        'DHC_RuleEngineBatch: échec mise à jour déploiement — ' + e.getMessage());
                }
            }
        } catch (Exception ex) {
            // Garde-fou : toute exception non prévue dans finish() ne doit jamais laisser
            // le déploiement en 'En cours'. On le passe directement en 'Échoué'.
            System.debug(LoggingLevel.ERROR,
                'DHC_RuleEngineBatch: exception inattendue dans finish() — ' +
                ex.getMessage() + '\n' + ex.getStackTraceString());
            if (deploymentId != null) {
                try {
                    update new DHC_Deployment__c(
                        Id            = deploymentId,
                        DHC_Status__c = 'Échoué'
                    );
                } catch (Exception e2) {
                    System.debug(LoggingLevel.ERROR,
                        'DHC_RuleEngineBatch: impossible de marquer le déploiement en Échoué — ' +
                        e2.getMessage());
                }
            }
        }
    }

    // ─── Private helpers ──────────────────────────────────────────────────────

    private void insertFindings(List<DHC_Finding__c> findings) {
        List<Database.SaveResult> results = Database.insert(findings, false);
        for (Integer i = 0; i < results.size(); i++) {
            if (!results[i].isSuccess()) {
                hasErrors = true;
                System.debug(LoggingLevel.ERROR,
                    'DHC_RuleEngineBatch: échec insert finding — composant ' +
                    findings[i].DHC_Component__c + ' / règle ' +
                    findings[i].DHC_Rule_Code__c + ' — ' +
                    results[i].getErrors()[0].getMessage()
                );
            }
        }
    }

    private Map<String, List<DHC_Rule__mdt>> loadActiveRules() {
        Map<String, List<DHC_Rule__mdt>> result = new Map<String, List<DHC_Rule__mdt>>();
        for (DHC_Rule__mdt rule : [
            SELECT DeveloperName, DHC_Component_Type__c, DHC_Attribute__c,
                   DHC_Operator__c, DHC_Expected_Value__c, DHC_Severity__c, DHC_Message__c
            FROM   DHC_Rule__mdt
            WHERE  DHC_Is_Active__c = true
        ]) {
            if (!result.containsKey(rule.DHC_Component_Type__c)) {
                result.put(rule.DHC_Component_Type__c, new List<DHC_Rule__mdt>());
            }
            result.get(rule.DHC_Component_Type__c).add(rule);
        }
        return result;
    }
}
