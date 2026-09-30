@isTest
private class FA_IntegrationSelectorTest {
    @TestSetup
    static void setup() {
        FA_TestDataFactory.createFullTestData();
    }

    @isTest
    static void testGetPlayersByCategory() {
        FA_Category__c cat = [SELECT Id FROM FA_Category__c LIMIT 1];
        List<FA_Player__c> players = FA_IntegrationSelector.getPlayersByCategory(cat.Id);
        System.assert(!players.isEmpty());
    }

    @isTest
    static void testGetPlayersForExport() {
        FA_Category__c cat = [SELECT Id FROM FA_Category__c LIMIT 1];
        List<FA_Player__c> players = FA_IntegrationSelector.getPlayersForExport(cat.Id);
        System.assertNotEquals(null, players);
    }

    @isTest
    static void testGetPlayerForLicense() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        FA_Player__c result = FA_IntegrationSelector.getPlayerForLicense(player.Id);
        System.assertNotEquals(null, result);
    }

    @isTest
    static void testGetUnsyncedTransactions() {
        FA_Transaction__c t = new FA_Transaction__c(
            Type__c = 'Revenue', Category__c = 'Test', Description__c = 'Test',
            Amount__c = 100, Transaction_Date__c = Date.today(),
            Status__c = 'Payé', Synced_To_Accounting__c = false
        );
        insert t;
        List<FA_Transaction__c> results = FA_IntegrationSelector.getUnsyncedTransactions(
            Date.today().addDays(-1), Date.today().addDays(1)
        );
        System.assert(!results.isEmpty());
    }

    @isTest
    static void testGetGuardiansByCategory() {
        FA_Category__c cat = [SELECT Id FROM FA_Category__c LIMIT 1];
        List<FA_Legal_Guardian__c> guardians = FA_IntegrationSelector.getGuardiansByCategory(cat.Id);
        System.assertNotEquals(null, guardians);
    }

    @isTest
    static void testGetAcademySettings() {
        FA_Academy_Setting__c setting = new FA_Academy_Setting__c(
            Name = 'test_setting', Setting_Key__c = 'test_setting', Value__c = 'value1'
        );
        insert setting;
        List<FA_Academy_Setting__c> settings = FA_IntegrationSelector.getAcademySettings(
            new List<String>{ 'test_setting' }
        );
        System.assert(!settings.isEmpty());
    }

    @isTest
    static void testGetCategoriesForExport() {
        List<FA_Category__c> cats = FA_IntegrationSelector.getCategoriesForExport();
        System.assert(!cats.isEmpty());
    }

    @isTest
    static void testGetActivePlayersForExport() {
        List<FA_Player__c> players = FA_IntegrationSelector.getActivePlayersForExport();
        System.assert(!players.isEmpty());
    }
}