/**
 * @description [TH] Trigger handler for FA_Match__c.
 * Routes trigger events to Domain logic. No SOQL, no DML.
 * @author Football Academy
 * @date 2026
 */
public with sharing class FA_MatchTriggerHandler {

    /**
     * @description Handle before insert: auto-generate name and validate.
     * @param newMatches List of new match records.
     */
    public static void handleBeforeInsert(List<FA_Match__c> newMatches) {
        for (FA_Match__c m : newMatches) {
            if (String.isBlank(m.Name) && m.Opponent__c != null && m.Match_Date__c != null) {
                FA_MatchDomain.buildName(m);
            }
        }
        FA_MatchDomain.validateList(newMatches);
    }

    /**
     * @description Handle before update: rebuild name if key fields changed, validate.
     * @param newMatches List of updated match records (new values).
     * @param oldMap Map of old match record values.
     */
    public static void handleBeforeUpdate(List<FA_Match__c> newMatches, Map<Id, FA_Match__c> oldMap) {
        for (FA_Match__c m : newMatches) {
            FA_Match__c old = oldMap.get(m.Id);
            Boolean keyFieldChanged = m.Opponent__c != old.Opponent__c
                || m.Match_Date__c != old.Match_Date__c
                || m.Is_Home__c != old.Is_Home__c;
            if (keyFieldChanged) {
                FA_MatchDomain.buildName(m);
            }
        }
        FA_MatchDomain.validateList(newMatches);
    }
}
