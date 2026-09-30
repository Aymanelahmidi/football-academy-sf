@isTest
private with sharing class FA_PlayerControllerTest {

    @TestSetup
    static void setup() {
        FA_Category__c cat = FA_TestDataFactory.createCategory('U17', 'U17', 15, 17);
        FA_Player__c player = FA_TestDataFactory.createPlayer('Achraf', 'Hakimi', cat.Id, 'Defender');
        FA_Contract__c contract = FA_TestDataFactory.createContract(player.Id);
        FA_Legal_Guardian__c guardian = FA_TestDataFactory.createLegalGuardian(player.Id);
    }

    @isTest
    static void controllerGetPlayers_noFilter_returnsPlayers() {
        Test.startTest();
        List<FA_Player__c> result = FA_PlayerController.getPlayers(null, null, null);
        Test.stopTest();
        System.assert(result.size() > 0, 'Controller should return players');
    }

    @isTest
    static void controllerGetPlayerById_validId_returnsPlayer() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        Test.startTest();
        FA_Player__c result = FA_PlayerController.getPlayerById(player.Id);
        Test.stopTest();
        System.assertEquals(player.Id, result.Id, 'Controller should return correct player');
    }

    @isTest
    static void controllerGetPlayerStats_returnsStats() {
        Test.startTest();
        Map<String, Object> stats = FA_PlayerController.getPlayerStats();
        Test.stopTest();
        System.assertNotEquals(null, stats, 'Controller should return player stats');
    }

    @isTest
    static void controllerCreatePlayer_validData_playerCreated() {
        FA_Category__c cat = [SELECT Id FROM FA_Category__c LIMIT 1];
        FA_Player__c newPlayer = new FA_Player__c(
            First_Name__c = 'Romain',
            Last_Name__c = 'Saïss',
            Category__c = cat.Id,
            Position__c = 'Defender',
            Status__c = 'Active',
            Date_of_Birth__c = Date.today().addYears(-20),
            Nationality__c = 'Moroccan'
        );
        Test.startTest();
        FA_Player__c result = FA_PlayerController.createPlayer(newPlayer);
        Test.stopTest();
        System.assertNotEquals(null, result, 'Controller should return created player');
        List<FA_Player__c> players = [SELECT Id FROM FA_Player__c WHERE Last_Name__c = 'Saïss'];
        System.assertEquals(1, players.size(), 'Player should be created via controller');
    }

    @isTest
    static void controllerUpdatePlayer_validData_playerUpdated() {
        FA_Player__c player = [SELECT Id, First_Name__c, Last_Name__c, Status__c FROM FA_Player__c LIMIT 1];
        player.Status__c = 'Suspended';
        Test.startTest();
        FA_Player__c result = FA_PlayerController.updatePlayer(player);
        Test.stopTest();
        FA_Player__c updated = [SELECT Status__c FROM FA_Player__c WHERE Id = :player.Id];
        System.assertEquals('Suspended', updated.Status__c, 'Status should be updated via controller');
    }

    @isTest
    static void controllerDeactivatePlayer_validId_playerDeactivated() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        Test.startTest();
        FA_PlayerController.deactivatePlayer(player.Id);
        Test.stopTest();
        FA_Player__c updated = [SELECT Is_Active__c FROM FA_Player__c WHERE Id = :player.Id];
        System.assertEquals(false, updated.Is_Active__c, 'Player should be deactivated via controller');
    }

    @isTest
    static void controllerGetCategories_returnsCategories() {
        Test.startTest();
        List<FA_Category__c> result = FA_PlayerController.getCategories();
        Test.stopTest();
        System.assert(result.size() > 0, 'Controller should return categories');
    }

    @isTest
    static void controllerGetPlayerContracts_validPlayer_returnsContracts() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        Test.startTest();
        List<FA_Contract__c> result = FA_PlayerController.getPlayerContracts(player.Id);
        Test.stopTest();
        System.assert(result.size() > 0, 'Controller should return player contracts');
    }

    @isTest
    static void controllerGetPlayerGuardians_validPlayer_returnsGuardians() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        Test.startTest();
        List<FA_Legal_Guardian__c> result = FA_PlayerController.getPlayerGuardians(player.Id);
        Test.stopTest();
        System.assert(result.size() > 0, 'Controller should return player guardians');
    }
}
