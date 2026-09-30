@isTest
private class FA_PerformanceSelectorTest {
    @TestSetup
    static void setup() {
        FA_TestDataFactory.createFullTestData();
    }

    @isTest
    static void testGetGpsData_noFilters() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        List<FA_GPS_Data__c> data = FA_PerformanceSelector.getGpsData(player.Id, null, null, null);
        System.assert(!data.isEmpty());
    }

    @isTest
    static void testGetGpsData_withFilters() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        FA_Training_Session__c session = [SELECT Id FROM FA_Training_Session__c LIMIT 1];
        List<FA_GPS_Data__c> data = FA_PerformanceSelector.getGpsData(
            player.Id, session.Id, Date.today().addDays(-7), Date.today().addDays(1)
        );
        System.assertNotEquals(null, data);
    }

    @isTest
    static void testGetPlayerGpsAverages() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        List<AggregateResult> results = FA_PerformanceSelector.getPlayerGpsAverages(player.Id, Date.today().addDays(-30));
        System.assertNotEquals(null, results);
    }

    @isTest
    static void testGetPhysicalPrograms() {
        FA_Category__c cat = [SELECT Id FROM FA_Category__c LIMIT 1];
        List<FA_Physical_Program__c> progs = FA_PerformanceSelector.getPhysicalPrograms(cat.Id, null);
        System.assertNotEquals(null, progs);
    }

    @isTest
    static void testGetFitnessTests() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        List<FA_Fitness_Test__c> tests = FA_PerformanceSelector.getFitnessTests(player.Id, null);
        System.assertNotEquals(null, tests);
    }

    @isTest
    static void testGetMorphologicalMeasures() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        List<FA_Morphological_Measure__c> measures = FA_PerformanceSelector.getMorphologicalMeasures(player.Id);
        System.assertNotEquals(null, measures);
    }
}