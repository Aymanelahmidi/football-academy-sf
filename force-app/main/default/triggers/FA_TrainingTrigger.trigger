/**
 * @description Thin trigger for FA_Training_Session__c. Delegates 100% to FA_TrainingTriggerHandler.
 * @author Football Academy
 * @date 2026
 */
trigger FA_TrainingTrigger on FA_Training_Session__c (before insert, before update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            FA_TrainingTriggerHandler.handleBeforeInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            FA_TrainingTriggerHandler.handleBeforeUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}
