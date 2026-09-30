/**
 * @description Thin trigger for FA_Morphological_Measure__c. Delegates 100% to FA_PerformanceTriggerHandler.
 * @author Football Academy
 * @date 2026
 */
trigger FA_PerformanceTrigger on FA_Morphological_Measure__c (before insert, before update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            FA_PerformanceTriggerHandler.handleBeforeInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            FA_PerformanceTriggerHandler.handleBeforeUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}
