@isTest
private with sharing class FA_TrainingTest {

    @TestSetup
    static void setup() {
        FA_Category__c cat = FA_TestDataFactory.createCategory('U15', 'U15', 13, 15);
        FA_Staff_Profile__c coach = FA_TestDataFactory.createStaff('Coach Martin', 'Coach');
        FA_Player__c player = FA_TestDataFactory.createPlayer('Karim', 'Zidane', cat.Id, 'Forward');
        FA_Training_Session__c session = FA_TestDataFactory.createSession(cat.Id, coach.Id, Date.today());
    }

    @isTest
    static void getSessions_withCategoryFilter_returnsSessions() {
        FA_Category__c cat = [SELECT Id FROM FA_Category__c LIMIT 1];
        Test.startTest();
        List<FA_Training_Session__c> result = FA_TrainingService.getSessions(cat.Id, null, null);
        Test.stopTest();
        System.assert(result.size() > 0, 'Should return sessions for category');
    }

    @isTest
    static void getSessionById_validId_returnsSession() {
        FA_Training_Session__c session = [SELECT Id FROM FA_Training_Session__c LIMIT 1];
        Test.startTest();
        FA_Training_Session__c result = FA_TrainingService.getSessionById(session.Id);
        Test.stopTest();
        System.assertNotEquals(null, result, 'Should return session');
        System.assertEquals(session.Id, result.Id, 'Should return correct session');
    }

    @isTest
    static void createSession_validData_sessionCreated() {
        FA_Category__c cat = [SELECT Id FROM FA_Category__c LIMIT 1];
        FA_Staff_Profile__c coach = [SELECT Id FROM FA_Staff_Profile__c LIMIT 1];
        FA_Training_Session__c newSession = new FA_Training_Session__c(
            Name = 'Entraînement Test',
            Category__c = cat.Id,
            Coach__c = coach.Id,
            Session_Date__c = Date.today().addDays(1),
            Start_Time__c = '09:00',
            End_Time__c = '10:30',
            Location__c = 'Terrain B',
            Type__c = 'Technical',
            Status__c = 'Scheduled'
        );
        Test.startTest();
        FA_TrainingService.createSession(newSession);
        Test.stopTest();
        List<FA_Training_Session__c> sessions = [SELECT Id FROM FA_Training_Session__c WHERE Session_Date__c = :Date.today().addDays(1)];
        System.assert(sessions.size() > 0, 'Session should be created');
    }

    @isTest
    static void updateSession_validData_sessionUpdated() {
        FA_Training_Session__c session = [SELECT Id, Status__c FROM FA_Training_Session__c LIMIT 1];
        session.Status__c = 'Completed';
        Test.startTest();
        FA_TrainingService.updateSession(session);
        Test.stopTest();
        FA_Training_Session__c updated = [SELECT Status__c FROM FA_Training_Session__c WHERE Id = :session.Id];
        System.assertEquals('Completed', updated.Status__c, 'Status should be updated');
    }

    @isTest
    static void deleteSession_validId_sessionDeleted() {
        FA_Training_Session__c session = [SELECT Id FROM FA_Training_Session__c LIMIT 1];
        Id sessionId = session.Id;
        Test.startTest();
        FA_TrainingService.deleteSession(sessionId);
        Test.stopTest();
        List<FA_Training_Session__c> sessions = [SELECT Id FROM FA_Training_Session__c WHERE Id = :sessionId];
        System.assertEquals(0, sessions.size(), 'Session should be deleted');
    }

    @isTest
    static void upsertAttendance_validData_attendanceCreated() {
        FA_Training_Session__c session = [SELECT Id FROM FA_Training_Session__c LIMIT 1];
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        FA_Attendance__c att = new FA_Attendance__c(
            Player__c = player.Id,
            Training_Session__c = session.Id,
            Status__c = 'Present',
            Attendance_Date__c = Date.today()
        );
        Test.startTest();
        FA_TrainingService.upsertAttendance(att);
        Test.stopTest();
        List<FA_Attendance__c> result = [SELECT Id FROM FA_Attendance__c WHERE Training_Session__c = :session.Id];
        System.assertEquals(1, result.size(), 'Attendance should be created');
    }

    @isTest
    static void bulkUpsertAttendance_multipleRecords_allCreated() {
        FA_Training_Session__c session = [SELECT Id FROM FA_Training_Session__c LIMIT 1];
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        List<FA_Attendance__c> attendances = new List<FA_Attendance__c>{
            new FA_Attendance__c(Player__c = player.Id, Training_Session__c = session.Id, Status__c = 'Present', Attendance_Date__c = Date.today())
        };
        Test.startTest();
        FA_TrainingService.bulkUpsertAttendance(attendances);
        Test.stopTest();
        List<FA_Attendance__c> result = [SELECT Id FROM FA_Attendance__c WHERE Training_Session__c = :session.Id];
        System.assertEquals(1, result.size(), 'Bulk attendance should be created');
    }

    @isTest
    static void getAttendanceStats_returnsStats() {
        Test.startTest();
        Map<String, Object> stats = FA_TrainingService.getAttendanceStats();
        Test.stopTest();
        System.assertNotEquals(null, stats, 'Stats should not be null');
    }
}
