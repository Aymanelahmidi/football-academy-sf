@isTest
private class FA_PlayerTriggerHandlerTest {

    @isTest
    static void testBeforeInsert_setsDefaultsAndName() {
        FA_Category__c cat = FA_TestDataFactory.createCategory('U13', 'U13', 12, 13);
        FA_Player__c player = new FA_Player__c(
            First_Name__c = 'Mourad',
            Last_Name__c = 'Tahir',
            Date_of_Birth__c = Date.today().addYears(-13),
            Category__c = cat.Id,
            Position__c = 'Forward',
            Is_Active__c = true
        );
        // Trigger fires on insert
        insert player;
        FA_Player__c result = [SELECT Name, Status__c, Is_Active__c FROM FA_Player__c WHERE Id = :player.Id];
        System.assertEquals('Mourad Tahir', result.Name);
        System.assertEquals('Active', result.Status__c);
    }

    @isTest
    static void testBeforeUpdate_rebuildsNameOnChange() {
        FA_Category__c cat = FA_TestDataFactory.createCategory('U13b', 'U13b', 12, 13);
        FA_Player__c player = FA_TestDataFactory.createPlayer('Mourad', 'Tahir', cat.Id, 'Forward');
        player.First_Name__c = 'Mohamed';
        update player;
        FA_Player__c result = [SELECT Name FROM FA_Player__c WHERE Id = :player.Id];
        System.assertEquals('Mohamed Tahir', result.Name);
    }
}