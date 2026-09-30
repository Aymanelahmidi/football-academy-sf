@isTest
private with sharing class FA_PlayerTest {

    @TestSetup
    static void setup() {
        FA_Category__c cat = FA_TestDataFactory.createCategory('U17', 'U17', 15, 17);
        FA_Staff_Profile__c coach = FA_TestDataFactory.createStaff('Coach Dupont', 'Coach');
        FA_Player__c player = FA_TestDataFactory.createPlayer('Youssef', 'Benali', cat.Id, 'Midfielder');
    }

    @isTest
    static void getPlayers_withCategoryFilter_returnsFilteredPlayers() {
        FA_Category__c cat = [SELECT Id FROM FA_Category__c LIMIT 1];
        Test.startTest();
        List<FA_Player__c> result = FA_PlayerService.getPlayers(cat.Id, null, null);
        Test.stopTest();
        System.assert(result.size() > 0, 'Should return players for category');
    }

    @isTest
    static void getPlayerById_validId_returnsPlayer() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        Test.startTest();
        FA_Player__c result = FA_PlayerService.getPlayerById(player.Id);
        Test.stopTest();
        System.assertNotEquals(null, result, 'Should return player');
        System.assertEquals(player.Id, result.Id, 'Should return correct player');
    }

    @isTest
    static void getPlayerStats_returnsStats() {
        Test.startTest();
        Map<String, Object> stats = FA_PlayerService.getPlayerStats();
        Test.stopTest();
        System.assertNotEquals(null, stats, 'Stats should not be null');
    }

    @isTest
    static void createPlayer_validData_playerCreated() {
        FA_Category__c cat = [SELECT Id FROM FA_Category__c LIMIT 1];
        FA_Player__c newPlayer = new FA_Player__c(
            First_Name__c = 'Ali',
            Last_Name__c = 'Khattabi',
            Date_of_Birth__c = Date.today().addYears(-14),
            Category__c = cat.Id,
            Position__c = 'Forward',
            Status__c = 'Active',
            Is_Active__c = true
        );
        Test.startTest();
        FA_PlayerService.createPlayer(newPlayer);
        Test.stopTest();
        List<FA_Player__c> players = [SELECT Id FROM FA_Player__c WHERE First_Name__c = 'Ali'];
        System.assertEquals(1, players.size(), 'Player should be created');
    }

    @isTest
    static void updatePlayer_validData_playerUpdated() {
        FA_Player__c player = [SELECT Id, First_Name__c, Last_Name__c, Status__c FROM FA_Player__c LIMIT 1];
        player.Status__c = 'Injured';
        Test.startTest();
        FA_PlayerService.updatePlayer(player);
        Test.stopTest();
        FA_Player__c updated = [SELECT Status__c FROM FA_Player__c WHERE Id = :player.Id];
        System.assertEquals('Injured', updated.Status__c, 'Status should be updated');
    }

    @isTest
    static void deactivatePlayer_validId_playerDeactivated() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        Test.startTest();
        FA_PlayerService.deactivatePlayer(player.Id);
        Test.stopTest();
        FA_Player__c updated = [SELECT Is_Active__c FROM FA_Player__c WHERE Id = :player.Id];
        System.assertEquals(false, updated.Is_Active__c, 'Player should be deactivated');
    }

    @isTest
    static void getPlayersWithInjuryStatus_validCategory_returnsPlayers() {
        FA_Category__c cat = [SELECT Id FROM FA_Category__c LIMIT 1];
        Test.startTest();
        List<Map<String, Object>> result = FA_PlayerService.getPlayersWithInjuryStatus(cat.Id);
        Test.stopTest();
        System.assertNotEquals(null, result, 'Result should not be null');
    }

    @isTest
    static void controllerGetCategories_returnsCategories() {
        Test.startTest();
        List<FA_Category__c> result = FA_PlayerController.getCategories();
        Test.stopTest();
        System.assert(result.size() > 0, 'Should return categories');
    }

    @isTest
    static void controllerGetPlayerContracts_validPlayer_returnsContracts() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        FA_Contract__c contract = new FA_Contract__c(
            Player__c = player.Id,
            Type__c = 'Academy',
            Start_Date__c = Date.today(),
            End_Date__c = Date.today().addYears(1),
            Monthly_Fee__c = 500,
            Status__c = 'Active'
        );
        insert contract;
        Test.startTest();
        List<FA_Contract__c> result = FA_PlayerController.getPlayerContracts(player.Id);
        Test.stopTest();
        System.assertEquals(1, result.size(), 'Should return one contract');
    }

    @isTest
    static void controllerGetPlayerGuardians_validPlayer_returnsGuardians() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        FA_Legal_Guardian__c guardian = new FA_Legal_Guardian__c(
            Player__c = player.Id,
            First_Name__c = 'Mohammed',
            Last_Name__c = 'Benali',
            Relationship__c = 'Père',
            Phone__c = '0600000000',
            Is_Primary__c = true
        );
        insert guardian;
        Test.startTest();
        List<FA_Legal_Guardian__c> result = FA_PlayerController.getPlayerGuardians(player.Id);
        Test.stopTest();
        System.assertEquals(1, result.size(), 'Should return one guardian');
    }
}
