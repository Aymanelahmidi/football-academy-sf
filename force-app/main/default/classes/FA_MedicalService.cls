/**
 * @description [SM] Service class for medical records, injuries, and RGPD audit logging.
 * Orchestrates FA_MedicalSelector (SOQL) and FA_MedicalDomain (logic).
 * Only layer authorized to perform DML.
 * @author Football Academy
 * @date 2026
 */
public with sharing class FA_MedicalService {

    public static FA_Medical_Record__c getMedicalRecord(Id playerId) {
        List<FA_Medical_Record__c> records = FA_MedicalSelector.getMedicalRecord(playerId);
        return records.isEmpty() ? null : records[0];
    }

    public static List<FA_Injury__c> getInjuries(Id playerId, String status) {
        return FA_MedicalSelector.getInjuries(playerId, status);
    }

    public static Map<String, Object> getMedicalStats() {
        Map<String, Object> stats = new Map<String, Object>();

        List<AggregateResult> byFitness = FA_MedicalSelector.getMedicalStatsByFitness();
        Map<String, Integer> fitnessMap = new Map<String, Integer>();
        for (AggregateResult ar : byFitness) {
            fitnessMap.put((String) ar.get('st'), (Integer) ar.get('cnt'));
        }
        stats.put('byFitnessStatus', fitnessMap);

        stats.put('activeInjuries', FA_MedicalSelector.getActiveInjuriesCount());

        List<AggregateResult> bySeverity = FA_MedicalSelector.getMedicalStatsBySeverity();
        Map<String, Integer> severityMap = new Map<String, Integer>();
        for (AggregateResult ar : bySeverity) {
            severityMap.put((String) ar.get('sev'), (Integer) ar.get('cnt'));
        }
        stats.put('injuriesBySeverity', severityMap);

        return stats;
    }

    public static FA_Injury__c createInjury(FA_Injury__c injury) {
        insert injury;
        FA_Player__c player = new FA_Player__c(Id = injury.Player__c, Status__c = 'Injured');
        update player;
        return injury;
    }

    public static FA_Injury__c updateInjury(FA_Injury__c injury) {
        update injury;
        if (injury.Status__c == 'Recovered') {
            Integer otherActive = FA_MedicalSelector.getOtherActiveInjuriesCount(injury.Player__c, injury.Id);
            if (FA_MedicalDomain.needsPlayerStatusReset(otherActive)) {
                FA_Player__c player = new FA_Player__c(Id = injury.Player__c, Status__c = 'Active');
                update player;
            }
        }
        return injury;
    }

    public static void logMedicalAccess(Id userId, Id playerId, String action, String details) {
        FA_Medical_Access_Log__c log = new FA_Medical_Access_Log__c(
            User__c    = userId,
            Player__c  = playerId,
            Action__c  = action,
            Details__c = details,
            Name       = action + ' - ' + String.valueOf(Datetime.now())
        );
        insert log;
    }

    public static List<FA_Medical_Access_Log__c> getAccessLogs(Id playerId) {
        return FA_MedicalSelector.getAccessLogs(playerId);
    }

    /**
     * @description Called by FA_InjuryTriggerHandler after insert.
     * Sets all specified players to 'Injured' status in bulk.
     * @param playerIds Set of player Ids to mark as injured.
     */
    public static void setPlayersInjured(Set<Id> playerIds) {
        List<FA_Player__c> toUpdate = new List<FA_Player__c>();
        for (Id pid : playerIds) {
            toUpdate.add(new FA_Player__c(Id = pid, Status__c = 'Injured'));
        }
        update toUpdate;
    }

    /**
     * @description Called by FA_InjuryTriggerHandler after update (recovery).
     * Resets player to Active if no other active injuries remain.
     * @param playerId The player Id to check.
     * @param recoveredInjuryId The injury Id that was just recovered (excluded from count).
     */
    public static void checkAndResetPlayerStatus(Id playerId, Id recoveredInjuryId) {
        Integer otherActive = FA_MedicalSelector.getOtherActiveInjuriesCount(playerId, recoveredInjuryId);
        if (FA_MedicalDomain.needsPlayerStatusReset(otherActive)) {
            update new FA_Player__c(Id = playerId, Status__c = 'Active');
        }
    }
}
