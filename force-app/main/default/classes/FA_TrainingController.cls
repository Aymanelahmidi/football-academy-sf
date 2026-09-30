/**
 * @description Lightning controller for Training and Attendance pages.
 * @author Football Academy Migration
 * @date 2026
 */
public with sharing class FA_TrainingController {

    @AuraEnabled(cacheable=true)
    public static List<FA_Training_Session__c> getSessions(Id categoryId, Date startDate, Date endDate) {
        return FA_TrainingService.getSessions(categoryId, startDate, endDate);
    }

    @AuraEnabled(cacheable=true)
    public static FA_Training_Session__c getSessionById(Id sessionId) {
        return FA_TrainingService.getSessionById(sessionId);
    }

    @AuraEnabled
    public static FA_Training_Session__c createSession(FA_Training_Session__c session) {
        return FA_TrainingService.createSession(session);
    }

    @AuraEnabled
    public static FA_Training_Session__c updateSession(FA_Training_Session__c session) {
        return FA_TrainingService.updateSession(session);
    }

    @AuraEnabled
    public static void deleteSession(Id sessionId) {
        FA_TrainingService.deleteSession(sessionId);
    }

    @AuraEnabled(cacheable=true)
    public static List<FA_Attendance__c> getAttendanceForSession(Id sessionId) {
        return FA_TrainingService.getAttendanceForSession(sessionId);
    }

    @AuraEnabled
    public static FA_Attendance__c upsertAttendance(FA_Attendance__c att) {
        return FA_TrainingService.upsertAttendance(att);
    }

    @AuraEnabled
    public static void bulkUpsertAttendance(List<FA_Attendance__c> attendanceList) {
        FA_TrainingService.bulkUpsertAttendance(attendanceList);
    }

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getAttendanceStats() {
        return FA_TrainingService.getAttendanceStats();
    }
}
