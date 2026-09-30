/**
 * @description [TH] Trigger handler for FA_Evaluation__c.
 * Routes trigger events to Domain logic. No SOQL, no DML.
 * @author Football Academy
 * @date 2026
 */
public with sharing class FA_EvaluationTriggerHandler {

    /**
     * @description Handle before insert: calculate overall score and build name.
     * @param newEvals List of new evaluation records.
     */
    public static void handleBeforeInsert(List<FA_Evaluation__c> newEvals) {
        for (FA_Evaluation__c eval : newEvals) {
            FA_EvaluationDomain.calculateOverallScore(eval);
            if (String.isBlank(eval.Name)) {
                FA_EvaluationDomain.buildName(eval);
            }
        }
        FA_EvaluationDomain.validateList(newEvals);
    }

    /**
     * @description Handle before update: recalculate if scores changed.
     * @param newEvals List of updated evaluation records (new values).
     * @param oldMap Map of old evaluation record values.
     */
    public static void handleBeforeUpdate(List<FA_Evaluation__c> newEvals, Map<Id, FA_Evaluation__c> oldMap) {
        for (FA_Evaluation__c eval : newEvals) {
            FA_Evaluation__c old = oldMap.get(eval.Id);
            Boolean scoresChanged = eval.Technical_Score__c != old.Technical_Score__c
                || eval.Tactical_Score__c != old.Tactical_Score__c
                || eval.Physical_Score__c != old.Physical_Score__c
                || eval.Mental_Score__c != old.Mental_Score__c
                || eval.Speed_Score__c != old.Speed_Score__c
                || eval.Endurance_Score__c != old.Endurance_Score__c;
            if (scoresChanged) {
                eval.Overall_Score__c = null; // reset to allow recalculation
                FA_EvaluationDomain.calculateOverallScore(eval);
            }
        }
        FA_EvaluationDomain.validateList(newEvals);
    }
}
