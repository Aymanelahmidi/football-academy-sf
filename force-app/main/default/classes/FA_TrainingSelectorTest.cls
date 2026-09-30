@isTest
private class FA_TrainingSelectorTest {
    @TestSetup
    static void setup() {
        FA_TestDataFactory.createFullTestData();
    }

    @isTest
    static void testGetSessions_noFilters() {
        List<FA_Training_Session__c> sessions = FA_TrainingSelector.getSessions(null, null, null);
        System.assert(!sessions.isEmpty());
    }

    @isTest
    static void testGetSessions_withCategoryFilter() {
        FA_Category__c cat = [SELECT Id FROM FA_Category__c LIMIT 1];
        List<FA_Training_Session__c> sessions = FA_TrainingSelector.getSessions(cat.Id, null, null);
        for (FA_Training_Session__c s : sessions) {
            System.assertEquals(cat.Id, s.Category__c);
        }
    }

    @isTest
    static void testGetSessions_withDateFilters() {
        List<FA_Training_Session__c> sessions = FA_TrainingSelector.getSessions(
            null, Date.today().addDays(-7), Date.today().addDays(7)
        );
        System.assertNotEquals(null, sessions);
    }

    @isTest
    static void testGetSessionById() {
        FA_Training_Session__c session = [SELECT Id FROM FA_Training_Session__c LIMIT 1];
        FA_Training_Session__c result = FA_TrainingSelector.getSessionById(session.Id);
        System.assertNotEquals(null, result);
    }

    @isTest
    static void testGetAttendanceForSession() {
        FA_Training_Session__c session = [SELECT Id FROM FA_Training_Session__c LIMIT 1];
        List<FA_Attendance__c> att = FA_TrainingSelector.getAttendanceForSession(session.Id);
        System.assertNotEquals(null, att);
    }

    @isTest
    static void testGetExistingAttendance_notFound() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        FA_Training_Session__c session = [SELECT Id FROM FA_Training_Session__c LIMIT 1];
        List<FA_Attendance__c> att = FA_TrainingSelector.getExistingAttendance(player.Id, session.Id);
        System.assertEquals(0, att.size());
    }

    @isTest
    static void testGetExistingAttendance_found() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        FA_Training_Session__c session = [SELECT Id FROM FA_Training_Session__c LIMIT 1];
        FA_Attendance__c att = new FA_Attendance__c(
            Player__c = player.Id,
            Training_Session__c = session.Id,
            Attendance_Date__c = Date.today(),
            Status__c = 'Present'
        );
        insert att;
        List<FA_Attendance__c> result = FA_TrainingSelector.getExistingAttendance(player.Id, session.Id);
        System.assertEquals(1, result.size());
    }

    @isTest
    static void testGetAttendanceCounts() {
        Integer total = FA_TrainingSelector.getAttendanceTotalCount();
        Integer present = FA_TrainingSelector.getAttendancePresentCount();
        System.assert(total >= 0);
        System.assert(present >= 0);
    }

    @isTest
    static void testGetAttendanceByStatus() {
        List<AggregateResult> results = FA_TrainingSelector.getAttendanceByStatus();
        System.assertNotEquals(null, results);
    }
}