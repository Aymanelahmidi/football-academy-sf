/**
 * @description [EM] Selector for FA_Medical_Record__c, FA_Injury__c, FA_Medical_Access_Log__c.
 * All SOQL uses Database.queryWithBinds + AccessLevel.USER_MODE to enforce FLS.
 * No DML, no business logic.
 * @author Football Academy
 * @date 2026
 */
public with sharing class FA_MedicalSelector {

    public static List<FA_Medical_Record__c> getMedicalRecord(Id playerId) {
        String query =
            'SELECT Id, Player__c, Player__r.First_Name__c, Player__r.Last_Name__c, ' +
            'Blood_Type__c, Allergies__c, Chronic_Conditions__c, ' +
            'Last_Checkup_Date__c, Fitness_Status__c, Notes__c, LastModifiedDate ' +
            'FROM FA_Medical_Record__c WHERE Player__c = :playerId LIMIT 1';
        Map<String, Object> binds = new Map<String, Object>{ 'playerId' => playerId };
        return Database.queryWithBinds(query, binds, AccessLevel.USER_MODE);
    }

    public static List<FA_Injury__c> getInjuries(Id playerId, String status) {
        String query =
            'SELECT Id, Player__c, Player__r.First_Name__c, Player__r.Last_Name__c, ' +
            'Player__r.Category__r.Short_Name__c, Type__c, Body_Part__c, Severity__c, ' +
            'Injury_Date__c, Expected_Return_Date__c, Actual_Return_Date__c, ' +
            'Status__c, Doctor__c, Doctor__r.Display_Name__c, Notes__c, CreatedDate ' +
            'FROM FA_Injury__c WHERE Id != null';

        Map<String, Object> binds = new Map<String, Object>();

        if (playerId != null) {
            query += ' AND Player__c = :playerId';
            binds.put('playerId', playerId);
        }
        if (String.isNotBlank(status)) {
            query += ' AND Status__c = :status';
            binds.put('status', status);
        }

        query += ' ORDER BY Injury_Date__c DESC';
        return Database.queryWithBinds(query, binds, AccessLevel.USER_MODE);
    }

    public static List<AggregateResult> getMedicalStatsByFitness() {
        String query =
            'SELECT Fitness_Status__c st, COUNT(Id) cnt ' +
            'FROM FA_Medical_Record__c GROUP BY Fitness_Status__c';
        return (List<AggregateResult>) Database.queryWithBinds(query, new Map<String, Object>(), AccessLevel.USER_MODE);
    }

    public static Integer getActiveInjuriesCount() {
        String query = 'SELECT COUNT() FROM FA_Injury__c WHERE Status__c != :status';
        Map<String, Object> binds = new Map<String, Object>{ 'status' => 'Recovered' };
        return Database.countQueryWithBinds(query, binds, AccessLevel.USER_MODE);
    }

    public static List<AggregateResult> getMedicalStatsBySeverity() {
        String query =
            'SELECT Severity__c sev, COUNT(Id) cnt ' +
            'FROM FA_Injury__c WHERE Status__c != :status GROUP BY Severity__c';
        Map<String, Object> binds = new Map<String, Object>{ 'status' => 'Recovered' };
        return (List<AggregateResult>) Database.queryWithBinds(query, binds, AccessLevel.USER_MODE);
    }

    public static Integer getOtherActiveInjuriesCount(Id playerId, Id excludeInjuryId) {
        String query =
            'SELECT COUNT() FROM FA_Injury__c ' +
            'WHERE Player__c = :playerId AND Status__c != :status AND Id != :excludeId';
        Map<String, Object> binds = new Map<String, Object>{
            'playerId' => playerId,
            'status' => 'Recovered',
            'excludeId' => excludeInjuryId
        };
        return Database.countQueryWithBinds(query, binds, AccessLevel.USER_MODE);
    }

    public static List<FA_Medical_Access_Log__c> getAccessLogs(Id playerId) {
        String query =
            'SELECT Id, User__c, User__r.Name, Player__c, Player__r.Name, ' +
            'Action__c, Details__c, IP_Address__c, CreatedDate ' +
            'FROM FA_Medical_Access_Log__c WHERE Player__c = :playerId ' +
            'ORDER BY CreatedDate DESC LIMIT 100';
        Map<String, Object> binds = new Map<String, Object>{ 'playerId' => playerId };
        return Database.queryWithBinds(query, binds, AccessLevel.USER_MODE);
    }
}
