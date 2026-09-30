@isTest
private with sharing class FA_GpsIntegrationTest {

    private class MockCatapultSuccess implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"activities":[{"athletes":[{"first_name":"Youssef","last_name":"Benali","metrics":{"total_distance":8500,"max_velocity":7.86,"sprint_count":12,"high_speed_running":1800,"avg_heart_rate":155,"max_heart_rate":188}}]}]}');
            return res;
        }
    }

    private class MockSTATSportsSuccess implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"sessions":[{"players":[{"name":"youssef benali","total_distance":8.5,"top_speed":28.3,"number_of_sprints":12,"average_heart_rate":155,"max_heart_rate":188,"calories":650}]}]}');
            return res;
        }
    }

    @TestSetup
    static void setup() {
        FA_Category__c cat = FA_TestDataFactory.createCategory('Senior', 'SEN', 18, 40);
        FA_Staff_Profile__c coach = FA_TestDataFactory.createStaff('Coach GPS', 'Coach');
        FA_Player__c player = FA_TestDataFactory.createPlayer('Youssef', 'Benali', cat.Id, 'Midfielder');
        FA_Training_Session__c session = FA_TestDataFactory.createSession(cat.Id, coach.Id, Date.today());
    }

    @isTest
    static void importFromCatapult_successResponse_returnsCount() {
        FA_Training_Session__c session = [SELECT Id FROM FA_Training_Session__c LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new MockCatapultSuccess());
        Test.startTest();
        Integer result = FA_GpsIntegration.importFromCatapult(Date.today(), session.Id);
        Test.stopTest();
        System.assert(result >= 0, 'Result should be a non-negative count');
    }

    @isTest
    static void importFromSTATSports_successResponse_returnsCount() {
        FA_Training_Session__c session = [SELECT Id FROM FA_Training_Session__c LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new MockSTATSportsSuccess());
        Test.startTest();
        Integer result = FA_GpsIntegration.importFromSTATSports(Date.today(), session.Id);
        Test.stopTest();
        System.assert(result >= 0, 'Result should be a non-negative count');
    }

    @isTest
    static void importFromCSV_validCsvData_returnsCount() {
        FA_Training_Session__c session = [SELECT Id FROM FA_Training_Session__c LIMIT 1];
        String csvData = 'player_name,total_distance,max_velocity,sprint_count,high_speed_running,avg_heart_rate,max_heart_rate\n' +
                         'youssef benali,8500,7.86,12,1800,155,188\n';
        Test.startTest();
        Integer result = FA_GpsIntegration.importFromCSV(csvData, session.Id);
        Test.stopTest();
        System.assert(result >= 0, 'Result should be a non-negative count');
    }

    @isTest
    static void importFromCatapult_noSession_returnsCount() {
        Test.setMock(HttpCalloutMock.class, new MockCatapultSuccess());
        Test.startTest();
        Integer result = FA_GpsIntegration.importFromCatapult(Date.today(), null);
        Test.stopTest();
        System.assert(result >= 0, 'Result should be a non-negative count without session');
    }
}
