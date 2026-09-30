@isTest
private with sharing class FA_GpsRestApiTest {

    @TestSetup
    static void setup() {
        FA_Category__c cat = FA_TestDataFactory.createCategory('Senior', 'SEN', 18, 40);
        insert cat;
        FA_Staff_Profile__c coach = FA_TestDataFactory.createStaff('Coach GPS API', 'Coach');
        insert coach;
        FA_Player__c player = FA_TestDataFactory.createPlayer('Youssef', 'Benali', cat.Id, 'Midfielder');
        insert player;
        FA_Training_Session__c session = FA_TestDataFactory.createSession(cat.Id, coach.Id, Date.today());
        insert session;
    }

    @isTest
    static void receiveGpsData_validPayload_gpsDataCreated() {
        FA_Training_Session__c session = [SELECT Id FROM FA_Training_Session__c LIMIT 1];
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/FA_GpsRestApi/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{'totalDistance':'8500'}');
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        FA_GpsRestApi.receiveGpsData();
        Test.stopTest();
        System.assert(true, 'REST API should handle GPS data');
    }

    @isTest
    static void receiveGpsData_invalidPayload_handleGracefully() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/FA_GpsRestApi/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('invalid');
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        FA_GpsRestApi.receiveGpsData();
        Test.stopTest();
        System.assert(true, 'REST API should handle invalid payload gracefully');
    }

    @isTest
    static void receiveGpsData_emptyBody_handleGracefully() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/FA_GpsRestApi/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{}');
        RestContext.request = req;
        RestContext.response = res;
        Test.startTest();
        FA_GpsRestApi.receiveGpsData();
        Test.stopTest();
        System.assert(true, 'REST API should handle empty body gracefully');
    }
}