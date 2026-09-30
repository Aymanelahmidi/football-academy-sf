/**
 * @description [EM] Selector for FA_Video_Analysis__c and FA_Video_Annotation__c.
 * All SOQL uses Database.queryWithBinds + AccessLevel.USER_MODE to enforce FLS.
 * No DML, no business logic.
 * @author Football Academy
 * @date 2026
 */
public with sharing class FA_VideoSelector {

    public static List<FA_Video_Analysis__c> getVideoAnalyses(Id matchId, String analysisType, String status) {
        String query =
            'SELECT Id, Name, Match__c, Match__r.Name, Match__r.Opponent__c, ' +
            'Training_Session__c, Training_Session__r.Name, ' +
            'Analyst__c, Analyst__r.Display_Name__c, Video_URL__c, Thumbnail_URL__c, ' +
            'Duration__c, Analysis_Date__c, Type__c, Status__c, Description__c, Tags__c, ' +
            'Notes__c, CreatedDate, ' +
            '(SELECT Id, Player__c, Player__r.First_Name__c, Player__r.Last_Name__c, ' +
            ' Timestamp__c, End_Timestamp__c, Type__c, Label__c, Description__c ' +
            ' FROM Annotations__r ORDER BY Timestamp__c ASC) ' +
            'FROM FA_Video_Analysis__c WHERE Id != null';

        Map<String, Object> binds = new Map<String, Object>();

        if (matchId != null) {
            query += ' AND Match__c = :matchId';
            binds.put('matchId', matchId);
        }
        if (String.isNotBlank(analysisType)) {
            query += ' AND Type__c = :analysisType';
            binds.put('analysisType', analysisType);
        }
        if (String.isNotBlank(status)) {
            query += ' AND Status__c = :status';
            binds.put('status', status);
        }

        query += ' ORDER BY Analysis_Date__c DESC';
        return Database.queryWithBinds(query, binds, AccessLevel.USER_MODE);
    }

    public static FA_Video_Analysis__c getVideoAnalysisById(Id videoId) {
        String query =
            'SELECT Id, Name, Match__c, Match__r.Name, Match__r.Opponent__c, Match__r.Match_Date__c, ' +
            'Training_Session__c, Training_Session__r.Name, ' +
            'Analyst__c, Analyst__r.Display_Name__c, Video_URL__c, Thumbnail_URL__c, ' +
            'Duration__c, Analysis_Date__c, Type__c, Status__c, Description__c, Tags__c, ' +
            'Notes__c, CreatedDate, ' +
            '(SELECT Id, Player__c, Player__r.First_Name__c, Player__r.Last_Name__c, ' +
            ' Timestamp__c, End_Timestamp__c, Type__c, Label__c, Description__c, Drawing_Data__c ' +
            ' FROM Annotations__r ORDER BY Timestamp__c ASC) ' +
            'FROM FA_Video_Analysis__c WHERE Id = :videoId LIMIT 1';
        Map<String, Object> binds = new Map<String, Object>{ 'videoId' => videoId };
        List<FA_Video_Analysis__c> results = Database.queryWithBinds(query, binds, AccessLevel.USER_MODE);
        return results.isEmpty() ? null : results[0];
    }
}
