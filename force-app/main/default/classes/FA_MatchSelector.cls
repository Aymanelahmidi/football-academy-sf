/**
 * @description [EM] Selector for FA_Match__c, FA_Match_Event__c, FA_Competition__c.
 * All SOQL uses Database.queryWithBinds + AccessLevel.USER_MODE to enforce FLS.
 * No DML, no business logic.
 * @author Football Academy
 * @date 2026
 */
public with sharing class FA_MatchSelector {

    public static List<FA_Match__c> getMatches(Id categoryId, String status, Date startDate, Date endDate) {
        String query =
            'SELECT Id, Name, Category__c, Category__r.Name, Category__r.Short_Name__c, ' +
            'Competition__c, Competition__r.Name, Opponent__c, Match_Date__c, Kickoff_Time__c, ' +
            'Location__c, Is_Home__c, Goals_For__c, Goals_Against__c, Formation__c, ' +
            'Status__c, Notes__c, CreatedDate ' +
            'FROM FA_Match__c WHERE Id != null';

        Map<String, Object> binds = new Map<String, Object>();

        if (categoryId != null) {
            query += ' AND Category__c = :categoryId';
            binds.put('categoryId', categoryId);
        }
        if (String.isNotBlank(status)) {
            query += ' AND Status__c = :status';
            binds.put('status', status);
        }
        if (startDate != null) {
            query += ' AND Match_Date__c >= :startDate';
            binds.put('startDate', startDate);
        }
        if (endDate != null) {
            query += ' AND Match_Date__c <= :endDate';
            binds.put('endDate', endDate);
        }

        query += ' ORDER BY Match_Date__c DESC';
        return Database.queryWithBinds(query, binds, AccessLevel.USER_MODE);
    }

    public static FA_Match__c getMatchById(Id matchId) {
        String query =
            'SELECT Id, Name, Category__c, Category__r.Name, Category__r.Short_Name__c, ' +
            'Competition__c, Competition__r.Name, Opponent__c, Match_Date__c, Kickoff_Time__c, ' +
            'Location__c, Is_Home__c, Goals_For__c, Goals_Against__c, Formation__c, ' +
            'Status__c, Notes__c, CreatedDate, ' +
            '(SELECT Id, Player__c, Player__r.First_Name__c, Player__r.Last_Name__c, ' +
            ' Player__r.Jersey_Number__c, Event_Type__c, Minute__c, Notes__c ' +
            ' FROM Match_Events__r ORDER BY Minute__c ASC) ' +
            'FROM FA_Match__c WHERE Id = :matchId LIMIT 1';
        Map<String, Object> binds = new Map<String, Object>{ 'matchId' => matchId };
        List<FA_Match__c> results = Database.queryWithBinds(query, binds, AccessLevel.USER_MODE);
        return results.isEmpty() ? null : results[0];
    }

    public static List<FA_Match__c> getCompletedMatches() {
        String query =
            'SELECT Goals_For__c, Goals_Against__c FROM FA_Match__c WHERE Status__c = :status';
        Map<String, Object> binds = new Map<String, Object>{ 'status' => 'Completed' };
        return Database.queryWithBinds(query, binds, AccessLevel.USER_MODE);
    }

    public static Integer getUpcomingMatchesCount() {
        String query =
            'SELECT COUNT() FROM FA_Match__c WHERE Status__c = :status AND Match_Date__c >= TODAY';
        Map<String, Object> binds = new Map<String, Object>{ 'status' => 'Scheduled' };
        return Database.countQueryWithBinds(query, binds, AccessLevel.USER_MODE);
    }

    public static List<FA_Competition__c> getCompetitions() {
        String query =
            'SELECT Id, Name, Type__c, Season__c, Category__c, Category__r.Name, ' +
            'Start_Date__c, End_Date__c, Is_Active__c ' +
            'FROM FA_Competition__c WHERE Is_Active__c = true ORDER BY Name ASC';
        return Database.queryWithBinds(query, new Map<String, Object>(), AccessLevel.USER_MODE);
    }
}
