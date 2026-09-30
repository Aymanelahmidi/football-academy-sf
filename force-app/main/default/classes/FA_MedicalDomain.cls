/**
 * @description [DM] Domain class for medical/injury business rules.
 * Pure logic on in-memory data. No SOQL, no DML.
 * @author Football Academy
 * @date 2026
 */
public with sharing class FA_MedicalDomain {

    /**
     * @description Determines if a player's status should be reset to 'Active'
     * after an injury is marked as recovered.
     * @param otherActiveInjuriesCount Number of other non-recovered injuries for the player.
     * @return True if no other active injuries remain → player should be set Active.
     */
    public static Boolean needsPlayerStatusReset(Integer otherActiveInjuriesCount) {
        return otherActiveInjuriesCount == 0;
    }

    /**
     * @description Validates injury record fields before insert/update.
     * Adds errors directly to records (trigger context).
     * @param injuries List of injury records to validate.
     */
    public static void validateList(List<FA_Injury__c> injuries) {
        for (FA_Injury__c inj : injuries) {
            if (inj.Player__c == null) {
                inj.addError('Le joueur est obligatoire.');
            }
            if (inj.Injury_Date__c == null) {
                inj.addError('La date de blessure est obligatoire.');
            }
        }
    }
}
