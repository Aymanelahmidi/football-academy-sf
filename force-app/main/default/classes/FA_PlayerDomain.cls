/**
 * @description [DM] Domain class for FA_Player__c business rules.
 * Pure logic on in-memory collections. No SOQL, no DML.
 * @author Football Academy
 * @date 2026
 */
public with sharing class FA_PlayerDomain {

    /**
     * @description Auto-build the Name field from first + last name.
     * @param player Player record to update in-memory.
     */
    public static void buildName(FA_Player__c player) {
        if (String.isNotBlank(player.First_Name__c) && String.isNotBlank(player.Last_Name__c)) {
            player.Name = player.First_Name__c + ' ' + player.Last_Name__c;
        }
    }

    /**
     * @description Validate required fields before insert/update.
     * Throws AuraHandledException on validation failure.
     * @param player Player record to validate.
     */
    public static void validateForSave(FA_Player__c player) {
        if (String.isBlank(player.First_Name__c)) {
            AuraHandledException ex = new AuraHandledException('Le prénom est obligatoire.');
            ex.setMessage('Le prénom est obligatoire.');
            throw ex;
        }
        if (String.isBlank(player.Last_Name__c)) {
            AuraHandledException ex = new AuraHandledException('Le nom de famille est obligatoire.');
            ex.setMessage('Le nom de famille est obligatoire.');
            throw ex;
        }
    }

    /**
     * @description Set default values on new player records.
     * @param players List of new player records.
     */
    public static void setDefaults(List<FA_Player__c> players) {
        for (FA_Player__c p : players) {
            if (p.Status__c == null) {
                p.Status__c = 'Active';
            }
            if (p.Is_Active__c != true) {
                p.Is_Active__c = true;
            }
            buildName(p);
        }
    }

    /**
     * @description Validate a list of player records.
     * Adds errors directly to records (trigger context).
     * @param players List of player records to validate.
     */
    public static void validateList(List<FA_Player__c> players) {
        for (FA_Player__c p : players) {
            if (String.isBlank(p.First_Name__c)) {
                p.addError('Le prénom est obligatoire.');
            }
            if (String.isBlank(p.Last_Name__c)) {
                p.addError('Le nom de famille est obligatoire.');
            }
        }
    }
}
