@isTest
private class FA_PlayerSelectorTest {
    @TestSetup
    static void setup() {
        FA_TestDataFactory.createFullTestData();
    }

    @isTest
    static void testGetPlayers_noFilters() {
        List<FA_Player__c> players = FA_PlayerSelector.getPlayers(null, null, null);
        System.assert(!players.isEmpty(), 'Should return players');
    }

    @isTest
    static void testGetPlayers_withCategoryFilter() {
        FA_Category__c cat = [SELECT Id FROM FA_Category__c LIMIT 1];
        List<FA_Player__c> players = FA_PlayerSelector.getPlayers(cat.Id, null, null);
        for (FA_Player__c p : players) {
            System.assertEquals(cat.Id, p.Category__c);
        }
    }

    @isTest
    static void testGetPlayers_withStatusFilter() {
        List<FA_Player__c> players = FA_PlayerSelector.getPlayers(null, 'Active', null);
        for (FA_Player__c p : players) {
            System.assertEquals('Active', p.Status__c);
        }
    }

    @isTest
    static void testGetPlayers_withSearchTerm() {
        List<FA_Player__c> players = FA_PlayerSelector.getPlayers(null, null, 'You');
        System.assert(!players.isEmpty(), 'Should find player by search term');
    }

    @isTest
    static void testGetPlayerById() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        FA_Player__c result = FA_PlayerSelector.getPlayerById(player.Id);
        System.assertNotEquals(null, result);
        System.assertEquals(player.Id, result.Id);
    }

    @isTest
    static void testGetTotalActivePlayers() {
        Integer total = FA_PlayerSelector.getTotalActivePlayers();
        System.assert(total >= 1, 'Should count active players');
    }

    @isTest
    static void testGetPlayersByCategory() {
        List<AggregateResult> results = FA_PlayerSelector.getPlayersByCategory();
        System.assertNotEquals(null, results);
    }

    @isTest
    static void testGetPlayersByPosition() {
        List<AggregateResult> results = FA_PlayerSelector.getPlayersByPosition();
        System.assertNotEquals(null, results);
    }

    @isTest
    static void testGetPlayersByStatus() {
        List<AggregateResult> results = FA_PlayerSelector.getPlayersByStatus();
        System.assertNotEquals(null, results);
    }

    @isTest
    static void testGetPlayersWithInjuryStatus() {
        FA_Category__c cat = [SELECT Id FROM FA_Category__c LIMIT 1];
        List<FA_Player__c> players = FA_PlayerSelector.getPlayersWithInjuryStatus(cat.Id);
        System.assertNotEquals(null, players);
    }

    @isTest
    static void testGetCategories() {
        List<FA_Category__c> cats = FA_PlayerSelector.getCategories();
        System.assert(!cats.isEmpty());
    }

    @isTest
    static void testGetPlayerContracts() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        List<FA_Contract__c> contracts = FA_PlayerSelector.getPlayerContracts(player.Id);
        System.assertNotEquals(null, contracts);
    }

    @isTest
    static void testGetPlayerGuardians() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        List<FA_Legal_Guardian__c> guardians = FA_PlayerSelector.getPlayerGuardians(player.Id);
        System.assertNotEquals(null, guardians);
    }
}