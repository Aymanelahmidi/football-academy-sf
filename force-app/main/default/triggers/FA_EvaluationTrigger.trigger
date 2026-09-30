/**
 * @description Thin trigger for FA_Evaluation__c. Delegates 100% to FA_EvaluationTriggerHandler.
 * @author Football Academy
 * @date 2026
 */
trigger FA_EvaluationTrigger on FA_Evaluation__c (before insert, before update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            FA_EvaluationTriggerHandler.handleBeforeInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            FA_EvaluationTriggerHandler.handleBeforeUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}
