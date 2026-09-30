@isTest
private with sharing class FA_MatchTest {

    @TestSetup
    static void setup() {
        FA_Category__c cat = FA_TestDataFactory.createCategory('Senior', 'SEN', 18, 40);
        FA_Player__c player = FA_TestDataFactory.createPlayer('Omar', 'Kettani', cat.Id, 'Goalkeeper');
        FA_Match__c match = FA_TestDataFactory.createMatch(cat.Id, 'Raja Club', Date.today());
    }

    @isTest
    static void getMatches_withCategoryFilter_returnsMatches() {
        FA_Category__c cat = [SELECT Id FROM FA_Category__c LIMIT 1];
        Test.startTest();
        List<FA_Match__c> result = FA_MatchService.getMatches(cat.Id, null, null, null);
        Test.stopTest();
        System.assert(result.size() > 0, 'Should return matches for category');
    }

    @isTest
    static void getMatchById_validId_returnsMatch() {
        FA_Match__c match = [SELECT Id FROM FA_Match__c LIMIT 1];
        Test.startTest();
        FA_Match__c result = FA_MatchService.getMatchById(match.Id);
        Test.stopTest();
        System.assertNotEquals(null, result, 'Should return match');
        System.assertEquals(match.Id, result.Id, 'Should return correct match');
    }

    @isTest
    static void getMatchStats_returnsStats() {
        Test.startTest();
        Map<String, Object> stats = FA_MatchService.getMatchStats();
        Test.stopTest();
        System.assertNotEquals(null, stats, 'Stats should not be null');
    }

    @isTest
    static void createMatch_validData_matchCreated() {
        FA_Category__c cat = [SELECT Id FROM FA_Category__c LIMIT 1];
        FA_Match__c newMatch = new FA_Match__c(
            Name = 'vs Wydad AC',
            Category__c = cat.Id,
            Opponent__c = 'Wydad AC',
            Match_Date__c = Date.today().addDays(7),
            Kickoff_Time__c = '15:00',
            Location__c = 'Stade Annexe',
            Is_Home__c = true,
            Status__c = 'Scheduled'
        );
        Test.startTest();
        FA_MatchService.createMatch(newMatch);
        Test.stopTest();
        List<FA_Match__c> matches = [SELECT Id FROM FA_Match__c WHERE Opponent__c = 'Wydad AC'];
        System.assertEquals(1, matches.size(), 'Match should be created');
    }

    @isTest
    static void addMatchEvent_validData_eventCreated() {
        FA_Match__c match = [SELECT Id FROM FA_Match__c LIMIT 1];
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        FA_Match_Event__c event = new FA_Match_Event__c(
            Match__c = match.Id,
            Player__c = player.Id,
            Event_Type__c = 'Goal',
            Minute__c = 45
        );
        Test.startTest();
        FA_MatchService.addMatchEvent(event);
        Test.stopTest();
        List<FA_Match_Event__c> events = [SELECT Id FROM FA_Match_Event__c WHERE Match__c = :match.Id];
        System.assertEquals(1, events.size(), 'Match event should be created');
    }

    @isTest
    static void controllerGetCompetitions_returnsCompetitions() {
        FA_Competition__c comp = FA_TestDataFactory.createCompetition('Botola Pro', 'League');
        Test.startTest();
        List<FA_Competition__c> result = FA_MatchController.getCompetitions();
        Test.stopTest();
        System.assert(result.size() > 0, 'Should return competitions');
    }

    @isTest
    static void getMatches_withStatusFilter_returnsFilteredMatches() {
        Test.startTest();
        List<FA_Match__c> result = FA_MatchService.getMatches(null, 'Scheduled', null, null);
        Test.stopTest();
        System.assertNotEquals(null, result, 'Result should not be null');
    }
}
