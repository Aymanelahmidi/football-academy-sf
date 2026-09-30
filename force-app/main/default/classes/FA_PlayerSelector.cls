/**
 * @description [EM] Selector for FA_Player__c and related objects.
 * All SOQL uses Database.queryWithBinds + AccessLevel.USER_MODE to enforce FLS.
 * No DML, no business logic.
 * @author Football Academy
 * @date 2026
 */
public with sharing class FA_PlayerSelector {

    public static List<FA_Player__c> getPlayers(Id categoryId, String status, String searchTerm) {
        String query =
            'SELECT Id, Name, First_Name__c, Last_Name__c, Date_of_Birth__c, ' +
            'Nationality__c, Category__c, Category__r.Name, Category__r.Short_Name__c, ' +
            'Position__c, Preferred_Foot__c, Height__c, Weight__c, Photo_URL__c, ' +
            'Phone__c, Email__c, Jersey_Number__c, Status__c, Join_Date__c, Is_Active__c, ' +
            'CreatedDate ' +
            'FROM FA_Player__c WHERE Is_Active__c = true';

        Map<String, Object> binds = new Map<String, Object>();

        if (categoryId != null) {
            query += ' AND Category__c = :categoryId';
            binds.put('categoryId', categoryId);
        }
        if (String.isNotBlank(status)) {
            query += ' AND Status__c = :status';
            binds.put('status', status);
        }
        if (String.isNotBlank(searchTerm)) {
            String searchPattern = '%' + searchTerm + '%';
            query += ' AND (First_Name__c LIKE :searchPattern OR Last_Name__c LIKE :searchPattern)';
            binds.put('searchPattern', searchPattern);
        }

        query += ' ORDER BY Last_Name__c ASC, First_Name__c ASC';
        return Database.queryWithBinds(query, binds, AccessLevel.USER_MODE);
    }

    public static FA_Player__c getPlayerById(Id playerId) {
        String query =
            'SELECT Id, Name, First_Name__c, Last_Name__c, Date_of_Birth__c, ' +
            'Nationality__c, Category__c, Category__r.Name, Category__r.Short_Name__c, ' +
            'Position__c, Preferred_Foot__c, Height__c, Weight__c, Photo_URL__c, ' +
            'Phone__c, Email__c, Address__c, Parent_Name__c, Parent_Phone__c, ' +
            'Jersey_Number__c, Status__c, Join_Date__c, Is_Active__c, ' +
            'CreatedDate, LastModifiedDate ' +
            'FROM FA_Player__c WHERE Id = :playerId LIMIT 1';
        Map<String, Object> binds = new Map<String, Object>{ 'playerId' => playerId };
        List<FA_Player__c> results = Database.queryWithBinds(query, binds, AccessLevel.USER_MODE);
        return results.isEmpty() ? null : results[0];
    }

    public static Integer getTotalActivePlayers() {
        String query = 'SELECT COUNT() FROM FA_Player__c WHERE Is_Active__c = true';
        return Database.countQueryWithBinds(query, new Map<String, Object>(), AccessLevel.USER_MODE);
    }

    public static List<AggregateResult> getPlayersByCategory() {
        String query =
            'SELECT Category__r.Short_Name__c catName, COUNT(Id) cnt ' +
            'FROM FA_Player__c WHERE Is_Active__c = true ' +
            'GROUP BY Category__r.Short_Name__c ORDER BY Category__r.Short_Name__c';
        return (List<AggregateResult>) Database.queryWithBinds(query, new Map<String, Object>(), AccessLevel.USER_MODE);
    }

    public static List<AggregateResult> getPlayersByPosition() {
        String query =
            'SELECT Position__c pos, COUNT(Id) cnt ' +
            'FROM FA_Player__c WHERE Is_Active__c = true GROUP BY Position__c';
        return (List<AggregateResult>) Database.queryWithBinds(query, new Map<String, Object>(), AccessLevel.USER_MODE);
    }

    public static List<AggregateResult> getPlayersByStatus() {
        String query =
            'SELECT Status__c st, COUNT(Id) cnt ' +
            'FROM FA_Player__c WHERE Is_Active__c = true GROUP BY Status__c';
        return (List<AggregateResult>) Database.queryWithBinds(query, new Map<String, Object>(), AccessLevel.USER_MODE);
    }

    public static List<FA_Player__c> getPlayersWithInjuryStatus(Id categoryId) {
        String query =
            'SELECT Id, First_Name__c, Last_Name__c, Position__c, Jersey_Number__c, Status__c, ' +
            '(SELECT Id, Type__c, Status__c, Expected_Return_Date__c ' +
            ' FROM Injuries__r WHERE Status__c != \'Recovered\' ' +
            ' ORDER BY CreatedDate DESC LIMIT 1) ' +
            'FROM FA_Player__c WHERE Category__c = :categoryId AND Is_Active__c = true ' +
            'ORDER BY Jersey_Number__c ASC';
        Map<String, Object> binds = new Map<String, Object>{ 'categoryId' => categoryId };
        return Database.queryWithBinds(query, binds, AccessLevel.USER_MODE);
    }

    public static List<FA_Category__c> getCategories() {
        String query =
            'SELECT Id, Name, Short_Name__c, Age_Min__c, Age_Max__c, Color__c, Max_Players__c, Is_Active__c ' +
            'FROM FA_Category__c WHERE Is_Active__c = true ORDER BY Age_Min__c ASC';
        return Database.queryWithBinds(query, new Map<String, Object>(), AccessLevel.USER_MODE);
    }

    public static List<FA_Contract__c> getPlayerContracts(Id playerId) {
        String query =
            'SELECT Id, Name, Type__c, Start_Date__c, End_Date__c, Monthly_Fee__c, Status__c, Notes__c ' +
            'FROM FA_Contract__c WHERE Player__c = :playerId ORDER BY Start_Date__c DESC';
        Map<String, Object> binds = new Map<String, Object>{ 'playerId' => playerId };
        return Database.queryWithBinds(query, binds, AccessLevel.USER_MODE);
    }

    public static List<FA_Legal_Guardian__c> getPlayerGuardians(Id playerId) {
        String query =
            'SELECT Id, Name, First_Name__c, Last_Name__c, Relationship__c, ' +
            'Phone__c, Email__c, Address__c, Is_Emergency_Contact__c, Is_Primary_Contact__c ' +
            'FROM FA_Legal_Guardian__c WHERE Player__c = :playerId ORDER BY Is_Primary_Contact__c DESC';
        Map<String, Object> binds = new Map<String, Object>{ 'playerId' => playerId };
        return Database.queryWithBinds(query, binds, AccessLevel.USER_MODE);
    }
}
