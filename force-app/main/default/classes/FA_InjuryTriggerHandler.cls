/**
 * @description [TH] Trigger handler for FA_Injury__c.
 * Routes trigger events to Domain + Service logic. No direct SOQL or DML.
 * @author Football Academy
 * @date 2026
 */
public with sharing class FA_InjuryTriggerHandler {

    /**
     * @description Handle after insert: update player status to 'Injured' for all new injuries.
     * @param newInjuries List of newly inserted injury records.
     */
    public static void handleAfterInsert(List<FA_Injury__c> newInjuries) {
        Set<Id> playerIds = new Set<Id>();
        for (FA_Injury__c inj : newInjuries) {
            if (inj.Player__c != null) {
                playerIds.add(inj.Player__c);
            }
        }
        if (!playerIds.isEmpty()) {
            FA_MedicalService.setPlayersInjured(playerIds);
        }
    }

    /**
     * @description Handle after update: if an injury is marked Recovered, check if
     * player has other active injuries; if not, reset player status to Active.
     * @param newInjuries List of updated injury records (new values).
     * @param oldMap Map of old injury record values.
     */
    public static void handleAfterUpdate(List<FA_Injury__c> newInjuries, Map<Id, FA_Injury__c> oldMap) {
        for (FA_Injury__c inj : newInjuries) {
            FA_Injury__c old = oldMap.get(inj.Id);
            Boolean justRecovered = inj.Status__c == 'Recovered' && old.Status__c != 'Recovered';
            if (justRecovered) {
                FA_MedicalService.checkAndResetPlayerStatus(inj.Player__c, inj.Id);
            }
        }
    }
}
