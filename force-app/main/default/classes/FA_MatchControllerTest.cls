@isTest
private with sharing class FA_MatchControllerTest {

    @TestSetup
    static void setup() {
        FA_Category__c cat = FA_TestDataFactory.createCategory('Senior', 'SEN', 18, 40);
        FA_Player__c player = FA_TestDataFactory.createPlayer('Hakim', 'Ziyech', cat.Id, 'Forward');
        FA_Match__c match = FA_TestDataFactory.createMatch(cat.Id, 'Difaa El Jadidi', Date.today().addDays(-2));
        FA_Competition__c comp = FA_TestDataFactory.createCompetition('Botola Pro D1', 'League');
    }

    @isTest
    static void controllerGetMatches_noFilter_returnsMatches() {
        Test.startTest();
        List<FA_Match__c> result = FA_MatchController.getMatches(null, null, null, null);
        Test.stopTest();
        System.assert(result.size() > 0, 'Controller should return matches');
    }

    @isTest
    static void controllerGetMatchById_validId_returnsMatch() {
        FA_Match__c match = [SELECT Id FROM FA_Match__c LIMIT 1];
        Test.startTest();
        FA_Match__c result = FA_MatchController.getMatchById(match.Id);
        Test.stopTest();
        System.assertEquals(match.Id, result.Id, 'Controller should return correct match');
    }

    @isTest
    static void controllerGetMatchStats_returnsStats() {
        Test.startTest();
        Map<String, Object> stats = FA_MatchController.getMatchStats();
        Test.stopTest();
        System.assertNotEquals(null, stats, 'Controller should return stats');
    }

    @isTest
    static void controllerCreateMatch_validData_matchCreated() {
        FA_Category__c cat = [SELECT Id FROM FA_Category__c LIMIT 1];
        FA_Match__c newMatch = new FA_Match__c(
            Category__c = cat.Id,
            Opponent__c = 'AS FAR',
            Match_Date__c = Date.today().addDays(5),
            Status__c = 'Scheduled',
            Location__c = 'Home'
        );
        Test.startTest();
        FA_MatchController.createMatch(newMatch);
        Test.stopTest();
        List<FA_Match__c> matches = [SELECT Id FROM FA_Match__c WHERE Opponent__c = 'AS FAR'];
        System.assertEquals(1, matches.size(), 'Match should be created via controller');
    }

    @isTest
    static void controllerAddMatchEvent_validData_eventCreated() {
        FA_Match__c match = [SELECT Id FROM FA_Match__c LIMIT 1];
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        FA_Match_Event__c event = new FA_Match_Event__c(
            Match__c = match.Id,
            Player__c = player.Id,
            Event_Type__c = 'Yellow Card',
            Minute__c = 55
        );
        Test.startTest();
        FA_MatchController.addMatchEvent(event);
        Test.stopTest();
        List<FA_Match_Event__c> events = [SELECT Id FROM FA_Match_Event__c WHERE Match__c = :match.Id];
        System.assertEquals(1, events.size(), 'Match event should be created via controller');
    }

    @isTest
    static void controllerGetCompetitions_returnsCompetitions() {
        Test.startTest();
        List<FA_Competition__c> result = FA_MatchController.getCompetitions();
        Test.stopTest();
        System.assert(result.size() > 0, 'Controller should return competitions');
    }
}
