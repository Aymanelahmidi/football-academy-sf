/**
 * @description Thin trigger for FA_Player__c. Delegates 100% to FA_PlayerTriggerHandler.
 * @author Football Academy
 * @date 2026
 */
trigger FA_PlayerTrigger on FA_Player__c (before insert, before update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            FA_PlayerTriggerHandler.handleBeforeInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            FA_PlayerTriggerHandler.handleBeforeUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}
