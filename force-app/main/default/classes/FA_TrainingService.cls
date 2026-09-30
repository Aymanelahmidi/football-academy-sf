/**
 * @description [SM] Service class for FA_Training_Session__c and FA_Attendance__c.
 * Orchestrates FA_TrainingSelector (SOQL). Only layer authorized to perform DML.
 * @author Football Academy
 * @date 2026
 */
public with sharing class FA_TrainingService {

    public static List<FA_Training_Session__c> getSessions(Id categoryId, Date startDate, Date endDate) {
        return FA_TrainingSelector.getSessions(categoryId, startDate, endDate);
    }

    public static FA_Training_Session__c getSessionById(Id sessionId) {
        return FA_TrainingSelector.getSessionById(sessionId);
    }

    public static FA_Training_Session__c createSession(FA_Training_Session__c session) {
        insert session;
        return FA_TrainingSelector.getSessionById(session.Id);
    }

    public static FA_Training_Session__c updateSession(FA_Training_Session__c session) {
        update session;
        return FA_TrainingSelector.getSessionById(session.Id);
    }

    public static void deleteSession(Id sessionId) {
        delete new FA_Training_Session__c(Id = sessionId);
    }

    public static List<FA_Attendance__c> getAttendanceForSession(Id sessionId) {
        return FA_TrainingSelector.getAttendanceForSession(sessionId);
    }

    public static FA_Attendance__c upsertAttendance(FA_Attendance__c att) {
        List<FA_Attendance__c> existing = FA_TrainingSelector.getExistingAttendance(att.Player__c, att.Training_Session__c);
        if (!existing.isEmpty()) {
            att.Id = existing[0].Id;
            update att;
        } else {
            insert att;
        }
        return att;
    }

    public static void bulkUpsertAttendance(List<FA_Attendance__c> attendanceList) {
        Set<Id> playerIds = new Set<Id>();
        Set<Id> sessionIds = new Set<Id>();
        for (FA_Attendance__c a : attendanceList) {
            playerIds.add(a.Player__c);
            sessionIds.add(a.Training_Session__c);
        }

        Map<String, FA_Attendance__c> existingMap = new Map<String, FA_Attendance__c>();
        for (FA_Attendance__c existing : FA_TrainingSelector.getBulkExistingAttendance(playerIds, sessionIds)) {
            String key = String.valueOf(existing.Player__c) + '-' + String.valueOf(existing.Training_Session__c);
            existingMap.put(key, existing);
        }

        List<FA_Attendance__c> toInsert = new List<FA_Attendance__c>();
        List<FA_Attendance__c> toUpdate = new List<FA_Attendance__c>();

        for (FA_Attendance__c a : attendanceList) {
            String key = String.valueOf(a.Player__c) + '-' + String.valueOf(a.Training_Session__c);
            if (existingMap.containsKey(key)) {
                a.Id = existingMap.get(key).Id;
                toUpdate.add(a);
            } else {
                toInsert.add(a);
            }
        }

        if (!toInsert.isEmpty()) insert toInsert;
        if (!toUpdate.isEmpty()) update toUpdate;
    }

    public static Map<String, Object> getAttendanceStats() {
        Map<String, Object> stats = new Map<String, Object>();

        Integer totalRecords = FA_TrainingSelector.getAttendanceTotalCount();
        Integer presentCount = FA_TrainingSelector.getAttendancePresentCount();

        stats.put('totalRecords', totalRecords);
        stats.put('presentCount', presentCount);
        stats.put('attendanceRate', totalRecords > 0 ? (Decimal.valueOf(presentCount) / totalRecords * 100).setScale(1) : 0);

        List<AggregateResult> byStatus = FA_TrainingSelector.getAttendanceByStatus();
        Map<String, Integer> statusMap = new Map<String, Integer>();
        for (AggregateResult ar : byStatus) {
            statusMap.put((String) ar.get('st'), (Integer) ar.get('cnt'));
        }
        stats.put('byStatus', statusMap);

        return stats;
    }
}
