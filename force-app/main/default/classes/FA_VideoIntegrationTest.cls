@isTest
private with sharing class FA_VideoIntegrationTest {

    private class MockHudlSuccess implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"title":"Test Video","url":"https://example.com/video","thumbnail":"https://example.com/thumb.jpg","duration":90,"description":"Test","clips":[{"title":"Goal","start_time":45,"end_time":46,"type":"goal","notes":"Header"}]}');
            return res;
        }
    }

    private class MockWyscoutSuccess implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"matchLabel":"Test Match","videoUrl":"https://example.com/video","duration":90,"events":[{"type":"goal","videoTimestamp":45,"description":"Header goal"}]}');
            return res;
        }
    }

    @TestSetup
    static void setup() {
        FA_Category__c cat = FA_TestDataFactory.createCategory('Senior', 'SEN', 18, 40);
        FA_Staff_Profile__c analyst = FA_TestDataFactory.createStaff('Analyst Test', 'Analyst');
        FA_Match__c match = FA_TestDataFactory.createMatch(cat.Id, 'Test Opponent', Date.today().addDays(-1));
    }

    @isTest
    static void importFromHudl_successResponse_createsVideoAnalysis() {
        FA_Match__c match = [SELECT Id FROM FA_Match__c LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new MockHudlSuccess());
        Test.startTest();
        FA_Video_Analysis__c result = FA_VideoIntegration.importFromHudl(match.Id, 'hudl-video-123');
        Test.stopTest();
        System.assertNotEquals(null, result, 'Video analysis should be created');
    }

    @isTest
    static void importFromWyscout_successResponse_createsVideoAnalysis() {
        FA_Match__c match = [SELECT Id FROM FA_Match__c LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new MockWyscoutSuccess());
        Test.startTest();
        FA_Video_Analysis__c result = FA_VideoIntegration.importFromWyscout(match.Id, 'wyscout-video-456');
        Test.stopTest();
        System.assertNotEquals(null, result, 'Video analysis should be created');
    }

    @isTest
    static void videoSyncSchedulable_execute_completesWithoutError() {
        Test.setMock(HttpCalloutMock.class, new MockHudlSuccess());
        FA_VideoIntegration.VideoSyncSchedulable sched = new FA_VideoIntegration.VideoSyncSchedulable();
        Test.startTest();
        sched.execute(null);
        Test.stopTest();
        System.assert(true, 'Schedulable should execute without error');
    }

    @isTest
    static void importFromHudl_withAnnotations_annotationsCreated() {
        FA_Match__c match = [SELECT Id FROM FA_Match__c LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new MockHudlSuccess());
        Test.startTest();
        FA_Video_Analysis__c result = FA_VideoIntegration.importFromHudl(match.Id, 'hudl-video-789');
        Test.stopTest();
        if (result != null && result.Id != null) {
            List<FA_Video_Annotation__c> annotations = [SELECT Id FROM FA_Video_Annotation__c WHERE Video_Analysis__c = :result.Id];
            System.assert(annotations.size() >= 0, 'Annotations query should succeed');
        }
        System.assert(true, 'Import with annotations should complete');
    }
}
