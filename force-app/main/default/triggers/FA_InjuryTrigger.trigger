/**
 * @description Thin trigger for FA_Injury__c. Delegates 100% to FA_InjuryTriggerHandler.
 * @author Football Academy
 * @date 2026
 */
trigger FA_InjuryTrigger on FA_Injury__c (after insert, after update) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            FA_InjuryTriggerHandler.handleAfterInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            FA_InjuryTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}
