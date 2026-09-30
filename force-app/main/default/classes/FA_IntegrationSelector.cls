/**
 * @description [EM] Selector for integration-layer queries (GPS import, external APIs, exports).
 * All SOQL uses Database.queryWithBinds + AccessLevel.USER_MODE to enforce FLS.
 * No DML, no business logic.
 * @author Football Academy
 * @date 2026
 */
public with sharing class FA_IntegrationSelector {

    public static List<FA_Player__c> getPlayersByCategory(Id categoryId) {
        String query =
            'SELECT Id, First_Name__c, Last_Name__c ' +
            'FROM FA_Player__c WHERE Category__c = :categoryId AND Is_Active__c = true';
        Map<String, Object> binds = new Map<String, Object>{ 'categoryId' => categoryId };
        return Database.queryWithBinds(query, binds, AccessLevel.USER_MODE);
    }

    public static List<FA_Player__c> getPlayersForExport(Id categoryId) {
        String query =
            'SELECT Id, First_Name__c, Last_Name__c, Date_of_Birth__c, ' +
            'Nationality__c, National_ID__c, License_Number__c, ' +
            'Photo_URL__c, Category__r.Short_Name__c, ' +
            '(SELECT Id, Type__c, Start_Date__c, End_Date__c ' +
            ' FROM Contracts__r WHERE Status__c = \'Active\' LIMIT 1) ' +
            'FROM FA_Player__c WHERE Category__c = :categoryId AND Is_Active__c = true';
        Map<String, Object> binds = new Map<String, Object>{ 'categoryId' => categoryId };
        return Database.queryWithBinds(query, binds, AccessLevel.USER_MODE);
    }

    public static FA_Player__c getPlayerForLicense(Id playerId) {
        String query =
            'SELECT Id, First_Name__c, Last_Name__c, Date_of_Birth__c, ' +
            'License_Number__c, National_ID__c, Photo_URL__c, Category__r.Short_Name__c ' +
            'FROM FA_Player__c WHERE Id = :playerId LIMIT 1';
        Map<String, Object> binds = new Map<String, Object>{ 'playerId' => playerId };
        List<FA_Player__c> results = Database.queryWithBinds(query, binds, AccessLevel.USER_MODE);
        return results.isEmpty() ? null : results[0];
    }

    public static List<FA_Transaction__c> getUnsyncedTransactions(Date startDate, Date endDate) {
        String query =
            'SELECT Id, Name, Transaction_Date__c, Type__c, Category__c, ' +
            'Amount__c, Description__c, Status__c, Payment_Method__c, ' +
            'Player__r.First_Name__c, Player__r.Last_Name__c ' +
            'FROM FA_Transaction__c ' +
            'WHERE Transaction_Date__c >= :startDate AND Transaction_Date__c <= :endDate ' +
            'AND Synced_To_Accounting__c = false';
        Map<String, Object> binds = new Map<String, Object>{
            'startDate' => startDate,
            'endDate' => endDate
        };
        return Database.queryWithBinds(query, binds, AccessLevel.USER_MODE);
    }

    public static List<FA_Legal_Guardian__c> getGuardiansByCategory(Id categoryId) {
        String query =
            'SELECT Id, First_Name__c, Last_Name__c, Email__c, Phone__c, ' +
            'Player__r.First_Name__c, Player__r.Last_Name__c ' +
            'FROM FA_Legal_Guardian__c ' +
            'WHERE Player__r.Category__c = :categoryId ' +
            'AND Player__r.Is_Active__c = true AND Is_Primary__c = true';
        Map<String, Object> binds = new Map<String, Object>{ 'categoryId' => categoryId };
        return Database.queryWithBinds(query, binds, AccessLevel.USER_MODE);
    }

    public static List<FA_Academy_Setting__c> getAcademySettings(List<String> names) {
        String query =
            'SELECT Id, Name, Value__c FROM FA_Academy_Setting__c WHERE Name IN :names';
        Map<String, Object> binds = new Map<String, Object>{ 'names' => names };
        return Database.queryWithBinds(query, binds, AccessLevel.USER_MODE);
    }

    public static List<FA_Category__c> getCategoriesForExport() {
        String query =
            'SELECT Id, Name, Short_Name__c, Age_Min__c, Age_Max__c FROM FA_Category__c';
        return Database.queryWithBinds(query, new Map<String, Object>(), AccessLevel.USER_MODE);
    }

    public static List<FA_Player__c> getActivePlayersForExport() {
        String query =
            'SELECT Id, First_Name__c, Last_Name__c, Date_of_Birth__c, Position__c, Status__c, ' +
            'Category__r.Short_Name__c FROM FA_Player__c WHERE Is_Active__c = true';
        return Database.queryWithBinds(query, new Map<String, Object>(), AccessLevel.USER_MODE);
    }
}
