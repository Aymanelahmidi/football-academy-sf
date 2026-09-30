/**
 * @description Thin trigger for FA_Video_Analysis__c. Delegates 100% to FA_VideoTriggerHandler.
 * @author Football Academy
 * @date 2026
 */
trigger FA_VideoTrigger on FA_Video_Analysis__c (before insert, before update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            FA_VideoTriggerHandler.handleBeforeInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            FA_VideoTriggerHandler.handleBeforeUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}
