@isTest
private class FA_MedicalSelectorTest {
    @TestSetup
    static void setup() {
        FA_TestDataFactory.createFullTestData();
    }

    @isTest
    static void testGetMedicalRecord_noRecord() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        List<FA_Medical_Record__c> records = FA_MedicalSelector.getMedicalRecord(player.Id);
        System.assertNotEquals(null, records);
    }

    @isTest
    static void testGetMedicalRecord_withRecord() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        FA_Medical_Record__c rec = new FA_Medical_Record__c(
            Player__c = player.Id, Blood_Type__c = 'A+'
        );
        insert rec;
        List<FA_Medical_Record__c> records = FA_MedicalSelector.getMedicalRecord(player.Id);
        System.assertEquals(1, records.size());
    }

    @isTest
    static void testGetInjuries_noFilters() {
        List<FA_Injury__c> injuries = FA_MedicalSelector.getInjuries(null, null);
        System.assertNotEquals(null, injuries);
    }

    @isTest
    static void testGetInjuries_withPlayerFilter() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        FA_TestDataFactory.createInjury(player.Id, 'Entorse', 'Cheville', Date.today());
        List<FA_Injury__c> injuries = FA_MedicalSelector.getInjuries(player.Id, null);
        System.assert(!injuries.isEmpty());
    }

    @isTest
    static void testGetInjuries_withStatusFilter() {
        List<FA_Injury__c> injuries = FA_MedicalSelector.getInjuries(null, 'In Treatment');
        System.assertNotEquals(null, injuries);
    }

    @isTest
    static void testGetMedicalStatsByFitness() {
        List<AggregateResult> results = FA_MedicalSelector.getMedicalStatsByFitness();
        System.assertNotEquals(null, results);
    }

    @isTest
    static void testGetActiveInjuriesCount() {
        Integer count = FA_MedicalSelector.getActiveInjuriesCount();
        System.assert(count >= 0);
    }

    @isTest
    static void testGetMedicalStatsBySeverity() {
        List<AggregateResult> results = FA_MedicalSelector.getMedicalStatsBySeverity();
        System.assertNotEquals(null, results);
    }

    @isTest
    static void testGetOtherActiveInjuriesCount() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        FA_Injury__c inj = FA_TestDataFactory.createInjury(player.Id, 'Contusion', 'Genou', Date.today());
        Integer count = FA_MedicalSelector.getOtherActiveInjuriesCount(player.Id, inj.Id);
        System.assertEquals(0, count);
    }

    @isTest
    static void testGetAccessLogs() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        FA_MedicalService.logMedicalAccess(UserInfo.getUserId(), player.Id, 'Consultation', 'Test details');
        List<FA_Medical_Access_Log__c> logs = FA_MedicalSelector.getAccessLogs(player.Id);
        System.assert(!logs.isEmpty());
    }
}