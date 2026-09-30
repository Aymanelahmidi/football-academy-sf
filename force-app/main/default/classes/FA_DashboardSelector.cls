/**
 * @description [EM] Selector for Dashboard-specific queries.
 * All SOQL uses Database.queryWithBinds + AccessLevel.USER_MODE to enforce FLS.
 * No DML, no business logic.
 * @author Football Academy
 * @date 2026
 */
public with sharing class FA_DashboardSelector {

    public static List<FA_Match__c> getRecentMatches() {
        String query =
            'SELECT Id, Name, Opponent__c, Match_Date__c, Goals_For__c, Goals_Against__c, ' +
            'Status__c, Category__r.Short_Name__c ' +
            'FROM FA_Match__c ORDER BY Match_Date__c DESC LIMIT 5';
        return Database.queryWithBinds(query, new Map<String, Object>(), AccessLevel.USER_MODE);
    }

    public static List<FA_Injury__c> getRecentInjuries() {
        String query =
            'SELECT Id, Player__r.First_Name__c, Player__r.Last_Name__c, ' +
            'Type__c, Severity__c, Status__c, Injury_Date__c ' +
            'FROM FA_Injury__c ORDER BY CreatedDate DESC LIMIT 5';
        return Database.queryWithBinds(query, new Map<String, Object>(), AccessLevel.USER_MODE);
    }

    public static List<FA_Match__c> getUpcomingMatches() {
        String query =
            'SELECT Id, Opponent__c, Match_Date__c, Kickoff_Time__c, Location__c, ' +
            'Is_Home__c, Category__r.Short_Name__c ' +
            'FROM FA_Match__c WHERE Status__c = :status AND Match_Date__c >= TODAY ' +
            'ORDER BY Match_Date__c ASC LIMIT 5';
        Map<String, Object> binds = new Map<String, Object>{ 'status' => 'Scheduled' };
        return Database.queryWithBinds(query, binds, AccessLevel.USER_MODE);
    }

    public static List<FA_Training_Session__c> getUpcomingTrainingSessions() {
        String query =
            'SELECT Id, Name, Session_Date__c, Start_Time__c, Location__c, ' +
            'Type__c, Category__r.Short_Name__c ' +
            'FROM FA_Training_Session__c WHERE Status__c = :status AND Session_Date__c >= TODAY ' +
            'ORDER BY Session_Date__c ASC LIMIT 5';
        Map<String, Object> binds = new Map<String, Object>{ 'status' => 'Scheduled' };
        return Database.queryWithBinds(query, binds, AccessLevel.USER_MODE);
    }
}
