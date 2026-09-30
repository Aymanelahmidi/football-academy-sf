@isTest
private class FA_VideoSelectorTest {
    @TestSetup
    static void setup() {
        FA_TestDataFactory.createFullTestData();
    }

    @isTest
    static void testGetVideoAnalyses_noFilters() {
        FA_Match__c match = [SELECT Id FROM FA_Match__c LIMIT 1];
        FA_Video_Analysis__c video = new FA_Video_Analysis__c(
            Name = 'Test', Match__c = match.Id,
            Analysis_Date__c = Date.today(), Type__c = 'Full Match', Status__c = 'In Progress'
        );
        insert video;
        List<FA_Video_Analysis__c> results = FA_VideoSelector.getVideoAnalyses(null, null, null);
        System.assert(!results.isEmpty());
    }

    @isTest
    static void testGetVideoAnalyses_withFilters() {
        FA_Match__c match = [SELECT Id FROM FA_Match__c LIMIT 1];
        List<FA_Video_Analysis__c> results = FA_VideoSelector.getVideoAnalyses(match.Id, 'Full Match', 'In Progress');
        System.assertNotEquals(null, results);
    }

    @isTest
    static void testGetVideoAnalysisById() {
        FA_Match__c match = [SELECT Id FROM FA_Match__c LIMIT 1];
        FA_Video_Analysis__c video = new FA_Video_Analysis__c(
            Name = 'Test', Match__c = match.Id,
            Analysis_Date__c = Date.today(), Type__c = 'Full Match', Status__c = 'In Progress'
        );
        insert video;
        FA_Video_Analysis__c result = FA_VideoSelector.getVideoAnalysisById(video.Id);
        System.assertNotEquals(null, result);
    }
}