/**
 * @description [TH] Trigger handler for FA_Training_Session__c.
 * Routes trigger events to Domain logic. No SOQL, no DML.
 * @author Football Academy
 * @date 2026
 */
public with sharing class FA_TrainingTriggerHandler {

    /**
     * @description Handle before insert: set defaults and validate.
     * @param newSessions List of new training session records.
     */
    public static void handleBeforeInsert(List<FA_Training_Session__c> newSessions) {
        FA_TrainingDomain.setDefaults(newSessions);
        FA_TrainingDomain.validateList(newSessions);
    }

    /**
     * @description Handle before update: rebuild name if key fields changed, validate.
     * @param newSessions List of updated session records (new values).
     * @param oldMap Map of old session record values.
     */
    public static void handleBeforeUpdate(List<FA_Training_Session__c> newSessions, Map<Id, FA_Training_Session__c> oldMap) {
        for (FA_Training_Session__c s : newSessions) {
            FA_Training_Session__c old = oldMap.get(s.Id);
            Boolean keyFieldChanged = s.Session_Date__c != old.Session_Date__c
                || s.Type__c != old.Type__c;
            if (keyFieldChanged) {
                FA_TrainingDomain.buildName(s);
            }
        }
        FA_TrainingDomain.validateList(newSessions);
    }
}
