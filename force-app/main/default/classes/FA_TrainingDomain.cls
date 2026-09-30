/**
 * @description [DM] Domain class for FA_Training_Session__c business rules.
 * Pure logic on in-memory collections. No SOQL, no DML.
 * @author Football Academy
 * @date 2026
 */
public with sharing class FA_TrainingDomain {

    /**
     * @description Set default status on new sessions if not provided.
     * @param sessions List of new training session records.
     */
    public static void setDefaults(List<FA_Training_Session__c> sessions) {
        for (FA_Training_Session__c s : sessions) {
            if (String.isBlank(s.Status__c)) {
                s.Status__c = 'Planifiée';
            }
            if (String.isBlank(s.Name) && s.Session_Date__c != null && s.Category__c != null) {
                buildName(s);
            }
        }
    }

    /**
     * @description Auto-generate a session Name from date and type.
     * @param session Training session record to update in-memory.
     */
    public static void buildName(FA_Training_Session__c session) {
        String type = String.isNotBlank(session.Type__c) ? session.Type__c + ' - ' : '';
        session.Name = type + String.valueOf(session.Session_Date__c);
    }

    /**
     * @description Validate required fields before insert/update.
     * Adds errors directly to records (trigger context).
     * @param sessions List of training session records to validate.
     */
    public static void validateList(List<FA_Training_Session__c> sessions) {
        for (FA_Training_Session__c s : sessions) {
            if (s.Session_Date__c == null) {
                s.addError('La date de la séance est obligatoire.');
            }
            if (s.Category__c == null) {
                s.addError('La catégorie est obligatoire.');
            }
            if (String.isBlank(s.Start_Time__c)) {
                s.addError('Heure debut obligatoire.');
            }
            if (String.isBlank(s.End_Time__c)) {
                s.addError('Heure fin obligatoire.');
            }
        }
    }
}
