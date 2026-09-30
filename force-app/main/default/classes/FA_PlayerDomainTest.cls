@isTest
private class FA_PlayerDomainTest {

    @isTest
    static void testBuildName_setsNameCorrectly() {
        FA_Player__c p = new FA_Player__c(First_Name__c = 'Ali', Last_Name__c = 'Hassan');
        FA_PlayerDomain.buildName(p);
        System.assertEquals('Ali Hassan', p.Name);
    }

    @isTest
    static void testBuildName_blankFirstName_noChange() {
        FA_Player__c p = new FA_Player__c(Last_Name__c = 'Hassan');
        p.Name = 'Original';
        FA_PlayerDomain.buildName(p);
        System.assertEquals('Original', p.Name);
    }

    @isTest
    static void testSetDefaults_setsStatusAndActive() {
        FA_Player__c p = new FA_Player__c(First_Name__c = 'Ali', Last_Name__c = 'Hassan');
        FA_PlayerDomain.setDefaults(new List<FA_Player__c>{ p });
        System.assertEquals('Active', p.Status__c);
        System.assertEquals(true, p.Is_Active__c);
    }

    @isTest
    static void testValidateList_validPlayer_noErrors() {
        FA_Player__c p = new FA_Player__c(First_Name__c = 'Ali', Last_Name__c = 'Hassan');
        // Should not throw
        FA_PlayerDomain.validateList(new List<FA_Player__c>{ p });
    }

    @isTest
    static void testValidateForSave_valid() {
        FA_Player__c p = new FA_Player__c(First_Name__c = 'Ali', Last_Name__c = 'Hassan');
        FA_PlayerDomain.validateForSave(p);
    }

    @isTest
    static void testValidateForSave_missingFirstName() {
        FA_Player__c p = new FA_Player__c(Last_Name__c = 'Hassan');
        try {
            FA_PlayerDomain.validateForSave(p);
            System.assert(false, 'Should throw');
        } catch (AuraHandledException e) {
            System.assert(e.getMessage().contains('prénom'));
        }
    }

    @isTest
    static void testValidateForSave_missingLastName() {
        FA_Player__c p = new FA_Player__c(First_Name__c = 'Ali');
        try {
            FA_PlayerDomain.validateForSave(p);
            System.assert(false, 'Should throw');
        } catch (AuraHandledException e) {
            System.assert(e.getMessage().contains('nom'));
        }
    }
}