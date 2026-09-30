/**
 * @description Thin trigger for FA_Match__c. Delegates 100% to FA_MatchTriggerHandler.
 * @author Football Academy
 * @date 2026
 */
trigger FA_MatchTrigger on FA_Match__c (before insert, before update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            FA_MatchTriggerHandler.handleBeforeInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            FA_MatchTriggerHandler.handleBeforeUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}
