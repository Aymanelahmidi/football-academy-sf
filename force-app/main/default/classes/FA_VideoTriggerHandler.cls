/**
 * @description [TH] Trigger handler for FA_Video_Analysis__c.
 * Routes trigger events to Domain logic. No SOQL, no DML.
 * @author Football Academy
 * @date 2026
 */
public with sharing class FA_VideoTriggerHandler {

    /**
     * @description Handle before insert: set defaults and validate.
     * @param newVideos List of new video analysis records.
     */
    public static void handleBeforeInsert(List<FA_Video_Analysis__c> newVideos) {
        FA_VideoDomain.setDefaults(newVideos);
        FA_VideoDomain.validateList(newVideos);
    }

    /**
     * @description Handle before update: rebuild name if key fields changed, validate.
     * @param newVideos List of updated video records (new values).
     * @param oldMap Map of old video record values.
     */
    public static void handleBeforeUpdate(List<FA_Video_Analysis__c> newVideos, Map<Id, FA_Video_Analysis__c> oldMap) {
        for (FA_Video_Analysis__c v : newVideos) {
            FA_Video_Analysis__c old = oldMap.get(v.Id);
            Boolean keyFieldChanged = v.Type__c != old.Type__c
                || v.Analysis_Date__c != old.Analysis_Date__c;
            if (keyFieldChanged) {
                FA_VideoDomain.buildName(v);
            }
        }
        FA_VideoDomain.validateList(newVideos);
    }
}
