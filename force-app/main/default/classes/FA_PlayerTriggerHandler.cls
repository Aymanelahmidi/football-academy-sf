/**
 * @description [TH] Trigger handler for FA_Player__c.
 * Routes trigger events to Domain logic. No SOQL, no DML.
 * @author Football Academy
 * @date 2026
 */
public with sharing class FA_PlayerTriggerHandler {

    /**
     * @description Handle before insert: set defaults and validate.
     * @param newPlayers List of new player records.
     */
    public static void handleBeforeInsert(List<FA_Player__c> newPlayers) {
        FA_PlayerDomain.setDefaults(newPlayers);
        FA_PlayerDomain.validateList(newPlayers);
    }

    /**
     * @description Handle before update: rebuild name if names changed, validate.
     * @param newPlayers List of updated player records (new values).
     * @param oldMap Map of old player record values.
     */
    public static void handleBeforeUpdate(List<FA_Player__c> newPlayers, Map<Id, FA_Player__c> oldMap) {
        for (FA_Player__c p : newPlayers) {
            FA_Player__c old = oldMap.get(p.Id);
            Boolean nameChanged = p.First_Name__c != old.First_Name__c || p.Last_Name__c != old.Last_Name__c;
            if (nameChanged) {
                FA_PlayerDomain.buildName(p);
            }
        }
        FA_PlayerDomain.validateList(newPlayers);
    }
}
