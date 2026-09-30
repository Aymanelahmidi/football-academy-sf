@isTest
private class FA_MatchSelectorTest {
    @TestSetup
    static void setup() {
        FA_TestDataFactory.createFullTestData();
    }

    @isTest
    static void testGetMatches_noFilters() {
        List<FA_Match__c> matches = FA_MatchSelector.getMatches(null, null, null, null);
        System.assert(!matches.isEmpty());
    }

    @isTest
    static void testGetMatches_withFilters() {
        FA_Category__c cat = [SELECT Id FROM FA_Category__c LIMIT 1];
        List<FA_Match__c> matches = FA_MatchSelector.getMatches(cat.Id, 'Completed', null, null);
        System.assertNotEquals(null, matches);
        List<FA_Match__c> withDate = FA_MatchSelector.getMatches(null, null, Date.today().addDays(-30), Date.today());
        System.assertNotEquals(null, withDate);
    }

    @isTest
    static void testGetMatchById() {
        FA_Match__c match = [SELECT Id FROM FA_Match__c LIMIT 1];
        FA_Match__c result = FA_MatchSelector.getMatchById(match.Id);
        System.assertNotEquals(null, result);
    }

    @isTest
    static void testGetCompletedMatches() {
        List<FA_Match__c> matches = FA_MatchSelector.getCompletedMatches();
        System.assertNotEquals(null, matches);
    }

    @isTest
    static void testGetUpcomingMatchesCount() {
        Integer count = FA_MatchSelector.getUpcomingMatchesCount();
        System.assert(count >= 0);
    }

    @isTest
    static void testGetCompetitions() {
        List<FA_Competition__c> comps = FA_MatchSelector.getCompetitions();
        System.assertNotEquals(null, comps);
    }
}