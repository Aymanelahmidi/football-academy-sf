/**
 * @description [DM] Domain class for FA_Evaluation__c business rules.
 * Pure logic on in-memory collections. No SOQL, no DML.
 * @author Football Academy
 * @date 2026
 */
public with sharing class FA_EvaluationDomain {

    /**
     * @description Auto-calculate the overall score as an average of all provided component scores.
     * Only sets Overall_Score__c if it was not already provided.
     * @param eval Evaluation record to update in-memory.
     */
    public static void calculateOverallScore(FA_Evaluation__c eval) {
        if (eval.Overall_Score__c != null) {
            return; // Already set by caller
        }

        List<Decimal> scores = new List<Decimal>();
        if (eval.Technical_Score__c != null)  scores.add(eval.Technical_Score__c);
        if (eval.Tactical_Score__c != null)   scores.add(eval.Tactical_Score__c);
        if (eval.Physical_Score__c != null)   scores.add(eval.Physical_Score__c);
        if (eval.Mental_Score__c != null)     scores.add(eval.Mental_Score__c);
        if (eval.Speed_Score__c != null)      scores.add(eval.Speed_Score__c);
        if (eval.Endurance_Score__c != null)  scores.add(eval.Endurance_Score__c);

        if (!scores.isEmpty()) {
            Decimal total = 0;
            for (Decimal s : scores) total += s;
            eval.Overall_Score__c = (total / scores.size()).setScale(0);
        }
    }

    /**
     * @description Auto-generate evaluation name from date.
     * @param eval Evaluation record to update in-memory.
     */
    public static void buildName(FA_Evaluation__c eval) {
        eval.Name = 'Eval-' + String.valueOf(eval.Evaluation_Date__c);
    }

    /**
     * @description Validate required fields before insert/update.
     * Adds errors directly to records (trigger context).
     * @param evals List of evaluation records to validate.
     */
    public static void validateList(List<FA_Evaluation__c> evals) {
        for (FA_Evaluation__c e : evals) {
            if (e.Player__c == null) {
                e.addError('Le joueur est obligatoire.');
            }
            if (e.Evaluation_Date__c == null) {
                e.addError('Date evaluation obligatoire.');
            }
        }
    }
}
