@isTest
private class FA_MedicalDomainTest {

    @isTest
    static void testNeedsPlayerStatusReset_noOtherInjuries() {
        System.assertEquals(true, FA_MedicalDomain.needsPlayerStatusReset(0));
    }

    @isTest
    static void testNeedsPlayerStatusReset_hasOtherInjuries() {
        System.assertEquals(false, FA_MedicalDomain.needsPlayerStatusReset(1));
        System.assertEquals(false, FA_MedicalDomain.needsPlayerStatusReset(3));
    }

    @isTest
    static void testValidateList_valid() {
        FA_Category__c cat = FA_TestDataFactory.createCategory('U15', 'U15', 14, 15);
        FA_Player__c player = FA_TestDataFactory.createPlayer('Test', 'Player', cat.Id, 'Forward');
        FA_Injury__c inj = new FA_Injury__c(
            Player__c = player.Id,
            Injury_Date__c = Date.today()
        );
        FA_MedicalDomain.validateList(new List<FA_Injury__c>{ inj });
    }
}