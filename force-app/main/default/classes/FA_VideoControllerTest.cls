@isTest
private with sharing class FA_VideoControllerTest {

    @TestSetup
    static void setup() {
        FA_Category__c cat = FA_TestDataFactory.createCategory('Senior', 'SEN', 18, 40);
        FA_Staff_Profile__c analyst = FA_TestDataFactory.createStaff('Video Analyst Samir', 'Analyst');
        FA_Match__c match = FA_TestDataFactory.createMatch(cat.Id, 'Mouloudia Oujda', Date.today().addDays(-3));
        FA_Video_Analysis__c video = FA_TestDataFactory.createVideoAnalysis(match.Id, analyst.Id);
    }

    @isTest
    static void controllerGetVideoAnalyses_noFilter_returnsAll() {
        Test.startTest();
        List<FA_Video_Analysis__c> result = FA_VideoController.getVideoAnalyses(null, null, null);
        Test.stopTest();
        System.assert(result.size() > 0, 'Controller should return video analyses');
    }

    @isTest
    static void controllerGetVideoAnalysisById_validId_returnsAnalysis() {
        FA_Video_Analysis__c video = [SELECT Id FROM FA_Video_Analysis__c LIMIT 1];
        Test.startTest();
        FA_Video_Analysis__c result = FA_VideoController.getVideoAnalysisById(video.Id);
        Test.stopTest();
        System.assertEquals(video.Id, result.Id, 'Controller should return correct analysis');
    }

    @isTest
    static void controllerCreateVideoAnalysis_validData_analysisCreated() {
        FA_Match__c match = [SELECT Id FROM FA_Match__c LIMIT 1];
        FA_Staff_Profile__c analyst = [SELECT Id FROM FA_Staff_Profile__c LIMIT 1];
        FA_Video_Analysis__c newVideo = new FA_Video_Analysis__c(
            Name = 'Analyse Highlights',
            Match__c = match.Id,
            Analyst__c = analyst.Id,
            Analysis_Date__c = Date.today(),
            Type__c = 'Highlights',
            Status__c = 'In Progress',
            Duration__c = 15
        );
        Test.startTest();
        FA_VideoController.createVideoAnalysis(newVideo);
        Test.stopTest();
        List<FA_Video_Analysis__c> videos = [SELECT Id FROM FA_Video_Analysis__c WHERE Type__c = 'Highlights'];
        System.assertEquals(1, videos.size(), 'Video analysis should be created via controller');
    }

    @isTest
    static void controllerAddAnnotation_validData_annotationCreated() {
        FA_Video_Analysis__c video = [SELECT Id FROM FA_Video_Analysis__c LIMIT 1];
        FA_Video_Annotation__c annotation = new FA_Video_Annotation__c(
            Video_Analysis__c = video.Id,
            Timestamp__c = 30,
            Type__c = 'Occasion',
            Label__c = 'Shot blocked'
        );
        Test.startTest();
        FA_VideoController.addAnnotation(annotation);
        Test.stopTest();
        List<FA_Video_Annotation__c> annotations = [SELECT Id FROM FA_Video_Annotation__c WHERE Video_Analysis__c = :video.Id];
        System.assertEquals(1, annotations.size(), 'Annotation should be created via controller');
    }

    @isTest
    static void controllerBulkAddAnnotations_multipleAnnotations_allCreated() {
        FA_Video_Analysis__c video = [SELECT Id FROM FA_Video_Analysis__c LIMIT 1];
        List<FA_Video_Annotation__c> annotations = new List<FA_Video_Annotation__c>{
            new FA_Video_Annotation__c(
                Video_Analysis__c = video.Id,
                Timestamp__c = 5,
                Type__c = 'Goal',
                Label__c = 'Opening goal'
            ),
            new FA_Video_Annotation__c(
                Video_Analysis__c = video.Id,
                Timestamp__c = 78,
                Type__c = 'Tactical',
                Label__c = 'Key pass'
            )
        };
        Test.startTest();
        FA_VideoController.bulkAddAnnotations(annotations);
        Test.stopTest();
        List<FA_Video_Annotation__c> result = [SELECT Id FROM FA_Video_Annotation__c WHERE Video_Analysis__c = :video.Id];
        System.assertEquals(2, result.size(), 'Both annotations should be created via controller');
    }
}
