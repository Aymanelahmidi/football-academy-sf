@isTest
private with sharing class FA_VideoTest {

    @TestSetup
    static void setup() {
        FA_Category__c cat = FA_TestDataFactory.createCategory('Senior', 'SEN', 18, 40);
        FA_Staff_Profile__c analyst = FA_TestDataFactory.createStaff('Analyst Brahim', 'Analyst');
        FA_Match__c match = FA_TestDataFactory.createMatch(cat.Id, 'Fath Union', Date.today().addDays(-1));
        FA_Video_Analysis__c video = FA_TestDataFactory.createVideoAnalysis(match.Id, analyst.Id);
    }

    @isTest
    static void getVideoAnalyses_noFilter_returnsAll() {
        Test.startTest();
        List<FA_Video_Analysis__c> result = FA_VideoService.getVideoAnalyses(null, null, null);
        Test.stopTest();
        System.assert(result.size() > 0, 'Should return video analyses');
    }

    @isTest
    static void getVideoAnalysisById_validId_returnsAnalysis() {
        FA_Video_Analysis__c video = [SELECT Id FROM FA_Video_Analysis__c LIMIT 1];
        Test.startTest();
        FA_Video_Analysis__c result = FA_VideoService.getVideoAnalysisById(video.Id);
        Test.stopTest();
        System.assertNotEquals(null, result, 'Should return video analysis');
        System.assertEquals(video.Id, result.Id, 'Should return correct analysis');
    }

    @isTest
    static void createVideoAnalysis_validData_analysisCreated() {
        FA_Match__c match = [SELECT Id FROM FA_Match__c LIMIT 1];
        FA_Staff_Profile__c analyst = [SELECT Id FROM FA_Staff_Profile__c LIMIT 1];
        FA_Video_Analysis__c newVideo = new FA_Video_Analysis__c(
            Name = 'Analyse Tactique Test',
            Match__c = match.Id,
            Analyst__c = analyst.Id,
            Analysis_Date__c = Date.today(),
            Type__c = 'Tactical',
            Status__c = 'In Progress',
            Duration__c = 45
        );
        Test.startTest();
        FA_VideoService.createVideoAnalysis(newVideo);
        Test.stopTest();
        List<FA_Video_Analysis__c> videos = [SELECT Id FROM FA_Video_Analysis__c WHERE Type__c = 'Tactical'];
        System.assertEquals(1, videos.size(), 'Video analysis should be created');
    }

    @isTest
    static void addAnnotation_validData_annotationCreated() {
        FA_Video_Analysis__c video = [SELECT Id FROM FA_Video_Analysis__c LIMIT 1];
        FA_Video_Annotation__c annotation = new FA_Video_Annotation__c(
            Video_Analysis__c = video.Id,
            Timestamp__c = 45,
            End_Timestamp__c = 46,
            Type__c = 'Goal',
            Label__c = 'Goal from header',
            Description__c = 'Scored from corner kick'
        );
        Test.startTest();
        FA_VideoService.addAnnotation(annotation);
        Test.stopTest();
        List<FA_Video_Annotation__c> annotations = [SELECT Id FROM FA_Video_Annotation__c WHERE Video_Analysis__c = :video.Id];
        System.assertEquals(1, annotations.size(), 'Annotation should be created');
    }

    @isTest
    static void bulkAddAnnotations_multipleAnnotations_allCreated() {
        FA_Video_Analysis__c video = [SELECT Id FROM FA_Video_Analysis__c LIMIT 1];
        List<FA_Video_Annotation__c> annotations = new List<FA_Video_Annotation__c>{
            new FA_Video_Annotation__c(
                Video_Analysis__c = video.Id,
                Timestamp__c = 10,
                Type__c = 'Occasion',
                Label__c = 'Shot on target'
            ),
            new FA_Video_Annotation__c(
                Video_Analysis__c = video.Id,
                Timestamp__c = 20,
                Type__c = 'Tactical',
                Label__c = 'Key pass'
            )
        };
        Test.startTest();
        FA_VideoService.bulkAddAnnotations(annotations);
        Test.stopTest();
        List<FA_Video_Annotation__c> result = [SELECT Id FROM FA_Video_Annotation__c WHERE Video_Analysis__c = :video.Id];
        System.assertEquals(2, result.size(), 'Both annotations should be created');
    }

    @isTest
    static void getVideoAnalyses_withTypeFilter_returnsFiltered() {
        Test.startTest();
        List<FA_Video_Analysis__c> result = FA_VideoService.getVideoAnalyses(null, 'Full Match', null);
        Test.stopTest();
        System.assertNotEquals(null, result, 'Result should not be null');
    }
}
