@isTest
private with sharing class FA_TrainingControllerTest {

    @TestSetup
    static void setup() {
        FA_Category__c cat = FA_TestDataFactory.createCategory('U15', 'U15', 13, 15);
        FA_Staff_Profile__c coach = FA_TestDataFactory.createStaff('Coach Benzema', 'Coach');
        FA_Player__c player = FA_TestDataFactory.createPlayer('Nabil', 'Fekir', cat.Id, 'Midfielder');
        FA_Training_Session__c session = FA_TestDataFactory.createSession(cat.Id, coach.Id, Date.today());
    }

    @isTest
    static void controllerGetSessions_withCategory_returnsSessions() {
        FA_Category__c cat = [SELECT Id FROM FA_Category__c LIMIT 1];
        Test.startTest();
        List<FA_Training_Session__c> result = FA_TrainingController.getSessions(cat.Id, null, null);
        Test.stopTest();
        System.assert(result.size() > 0, 'Controller should return sessions');
    }

    @isTest
    static void controllerGetSessionById_validId_returnsSession() {
        FA_Training_Session__c session = [SELECT Id FROM FA_Training_Session__c LIMIT 1];
        Test.startTest();
        FA_Training_Session__c result = FA_TrainingController.getSessionById(session.Id);
        Test.stopTest();
        System.assertEquals(session.Id, result.Id, 'Controller should return correct session');
    }

    @isTest
    static void controllerCreateSession_validData_sessionCreated() {
        FA_Category__c cat = [SELECT Id FROM FA_Category__c LIMIT 1];
        FA_Staff_Profile__c coach = [SELECT Id FROM FA_Staff_Profile__c LIMIT 1];
        FA_Training_Session__c newSession = new FA_Training_Session__c(
            Category__c = cat.Id,
            Coach__c = coach.Id,
            Session_Date__c = Date.today().addDays(2),
            Type__c = 'Technical',
            Status__c = 'Scheduled',
            Start_Time__c = '09:00',
            End_Time__c = '11:00'
        );
        Test.startTest();
        FA_TrainingController.createSession(newSession);
        Test.stopTest();
        List<FA_Training_Session__c> sessions = [SELECT Id FROM FA_Training_Session__c WHERE Session_Date__c = :Date.today().addDays(2)];
        System.assert(sessions.size() > 0, 'Controller should create session');
    }

    @isTest
    static void controllerUpsertAttendance_validData_attendanceCreated() {
        FA_Training_Session__c session = [SELECT Id FROM FA_Training_Session__c LIMIT 1];
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        FA_Attendance__c att = new FA_Attendance__c(
            Player__c = player.Id,
            Training_Session__c = session.Id,
            Status__c = 'Present',
            Attendance_Date__c = Date.today()
        );
        Test.startTest();
        FA_TrainingController.upsertAttendance(att);
        Test.stopTest();
        List<FA_Attendance__c> result = [SELECT Id FROM FA_Attendance__c WHERE Training_Session__c = :session.Id];
        System.assertEquals(1, result.size(), 'Attendance should be created via controller');
    }

    @isTest
    static void controllerGetAttendanceForSession_validSession_returnsAttendance() {
        FA_Training_Session__c session = [SELECT Id FROM FA_Training_Session__c LIMIT 1];
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        FA_Attendance__c att = new FA_Attendance__c(
            Player__c = player.Id,
            Training_Session__c = session.Id,
            Status__c = 'Present',
            Attendance_Date__c = Date.today()
        );
        insert att;
        Test.startTest();
        List<FA_Attendance__c> result = FA_TrainingController.getAttendanceForSession(session.Id);
        Test.stopTest();
        System.assertEquals(1, result.size(), 'Controller should return attendance');
    }

    @isTest
    static void controllerDeleteSession_validId_sessionDeleted() {
        FA_Training_Session__c session = [SELECT Id FROM FA_Training_Session__c LIMIT 1];
        Id sessionId = session.Id;
        Test.startTest();
        FA_TrainingController.deleteSession(sessionId);
        Test.stopTest();
        List<FA_Training_Session__c> sessions = [SELECT Id FROM FA_Training_Session__c WHERE Id = :sessionId];
        System.assertEquals(0, sessions.size(), 'Session should be deleted via controller');
    }
}
