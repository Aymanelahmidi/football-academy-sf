/**
 * @description [EM] Selector for FA_Training_Session__c and FA_Attendance__c.
 * All SOQL uses Database.queryWithBinds + AccessLevel.USER_MODE to enforce FLS.
 * No DML, no business logic.
 * @author Football Academy
 * @date 2026
 */
public with sharing class FA_TrainingSelector {

    public static List<FA_Training_Session__c> getSessions(Id categoryId, Date startDate, Date endDate) {
        String query =
            'SELECT Id, Name, Category__c, Category__r.Name, Category__r.Short_Name__c, ' +
            'Coach__c, Coach__r.Display_Name__c, Session_Date__c, Start_Time__c, End_Time__c, ' +
            'Location__c, Type__c, Objectives__c, Notes__c, Status__c, CreatedDate ' +
            'FROM FA_Training_Session__c WHERE Id != null';

        Map<String, Object> binds = new Map<String, Object>();

        if (categoryId != null) {
            query += ' AND Category__c = :categoryId';
            binds.put('categoryId', categoryId);
        }
        if (startDate != null) {
            query += ' AND Session_Date__c >= :startDate';
            binds.put('startDate', startDate);
        }
        if (endDate != null) {
            query += ' AND Session_Date__c <= :endDate';
            binds.put('endDate', endDate);
        }

        query += ' ORDER BY Session_Date__c DESC, Start_Time__c DESC';
        return Database.queryWithBinds(query, binds, AccessLevel.USER_MODE);
    }

    public static FA_Training_Session__c getSessionById(Id sessionId) {
        String query =
            'SELECT Id, Name, Category__c, Category__r.Name, Category__r.Short_Name__c, ' +
            'Coach__c, Coach__r.Display_Name__c, Session_Date__c, Start_Time__c, End_Time__c, ' +
            'Location__c, Type__c, Objectives__c, Notes__c, Status__c, CreatedDate, ' +
            '(SELECT Id, Name, Description__c, Duration__c, Order_Index__c ' +
            ' FROM Exercises__r ORDER BY Order_Index__c ASC) ' +
            'FROM FA_Training_Session__c WHERE Id = :sessionId LIMIT 1';
        Map<String, Object> binds = new Map<String, Object>{ 'sessionId' => sessionId };
        List<FA_Training_Session__c> results = Database.queryWithBinds(query, binds, AccessLevel.USER_MODE);
        return results.isEmpty() ? null : results[0];
    }

    public static List<FA_Attendance__c> getAttendanceForSession(Id sessionId) {
        String query =
            'SELECT Id, Player__c, Player__r.First_Name__c, Player__r.Last_Name__c, ' +
            'Player__r.Jersey_Number__c, Player__r.Position__c, ' +
            'Training_Session__c, Attendance_Date__c, Status__c, Notes__c ' +
            'FROM FA_Attendance__c WHERE Training_Session__c = :sessionId ' +
            'ORDER BY Player__r.Last_Name__c ASC';
        Map<String, Object> binds = new Map<String, Object>{ 'sessionId' => sessionId };
        return Database.queryWithBinds(query, binds, AccessLevel.USER_MODE);
    }

    public static List<FA_Attendance__c> getExistingAttendance(Id playerId, Id sessionId) {
        String query =
            'SELECT Id FROM FA_Attendance__c ' +
            'WHERE Player__c = :playerId AND Training_Session__c = :sessionId LIMIT 1';
        Map<String, Object> binds = new Map<String, Object>{
            'playerId' => playerId,
            'sessionId' => sessionId
        };
        return Database.queryWithBinds(query, binds, AccessLevel.USER_MODE);
    }

    public static List<FA_Attendance__c> getBulkExistingAttendance(Set<Id> playerIds, Set<Id> sessionIds) {
        String query =
            'SELECT Id, Player__c, Training_Session__c FROM FA_Attendance__c ' +
            'WHERE Player__c IN :playerIds AND Training_Session__c IN :sessionIds';
        Map<String, Object> binds = new Map<String, Object>{
            'playerIds' => playerIds,
            'sessionIds' => sessionIds
        };
        return Database.queryWithBinds(query, binds, AccessLevel.USER_MODE);
    }

    public static Integer getAttendanceTotalCount() {
        String query = 'SELECT COUNT() FROM FA_Attendance__c';
        return Database.countQueryWithBinds(query, new Map<String, Object>(), AccessLevel.USER_MODE);
    }

    public static Integer getAttendancePresentCount() {
        String query = 'SELECT COUNT() FROM FA_Attendance__c WHERE Status__c = :status';
        Map<String, Object> binds = new Map<String, Object>{ 'status' => 'Present' };
        return Database.countQueryWithBinds(query, binds, AccessLevel.USER_MODE);
    }

    public static List<AggregateResult> getAttendanceByStatus() {
        String query =
            'SELECT Status__c st, COUNT(Id) cnt FROM FA_Attendance__c GROUP BY Status__c';
        return (List<AggregateResult>) Database.queryWithBinds(query, new Map<String, Object>(), AccessLevel.USER_MODE);
    }
}
