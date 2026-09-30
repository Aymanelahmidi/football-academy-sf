@isTest
private with sharing class FA_MedicalTest {

    @TestSetup
    static void setup() {
        FA_Category__c cat = FA_TestDataFactory.createCategory('U19', 'U19', 17, 19);
        FA_Staff_Profile__c staff = FA_TestDataFactory.createStaff('Dr. Hassan', 'Doctor');
        FA_Player__c player = FA_TestDataFactory.createPlayer('Rachid', 'Alami', cat.Id, 'Defender');
        FA_Medical_Record__c record = FA_TestDataFactory.createMedicalRecord(player.Id);
        FA_Injury__c injury = FA_TestDataFactory.createInjury(player.Id, 'Sprain', 'Ankle', Date.today().addDays(-7));
    }

    @isTest
    static void getMedicalRecord_validPlayerId_returnsRecord() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        Test.startTest();
        FA_Medical_Record__c result = FA_MedicalService.getMedicalRecord(player.Id);
        Test.stopTest();
        System.assertNotEquals(null, result, 'Medical record should not be null');
        System.assertEquals(player.Id, result.Player__c, 'Should return record for correct player');
    }

    @isTest
    static void getInjuries_validPlayerId_returnsInjuries() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        Test.startTest();
        List<FA_Injury__c> result = FA_MedicalService.getInjuries(player.Id, null);
        Test.stopTest();
        System.assert(result.size() > 0, 'Should return injuries for player');
    }

    @isTest
    static void getMedicalStats_returnsStats() {
        Test.startTest();
        Map<String, Object> stats = FA_MedicalService.getMedicalStats();
        Test.stopTest();
        System.assertNotEquals(null, stats, 'Stats should not be null');
    }

    @isTest
    static void createInjury_validData_injuryCreated() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        FA_Injury__c newInjury = new FA_Injury__c(
            Name = 'Fracture - Wrist',
            Player__c = player.Id,
            Type__c = 'Fracture',
            Body_Part__c = 'Wrist',
            Severity__c = 'Severe',
            Injury_Date__c = Date.today(),
            Expected_Return_Date__c = Date.today().addDays(30),
            Status__c = 'In Treatment'
        );
        Test.startTest();
        FA_MedicalService.createInjury(newInjury);
        Test.stopTest();
        List<FA_Injury__c> injuries = [SELECT Id FROM FA_Injury__c WHERE Type__c = 'Fracture' AND Player__c = :player.Id];
        System.assertEquals(1, injuries.size(), 'Injury should be created');
    }

    @isTest
    static void updateInjury_validData_injuryUpdated() {
        FA_Injury__c injury = [SELECT Id, Status__c FROM FA_Injury__c LIMIT 1];
        injury.Status__c = 'Rehabilitation';
        Test.startTest();
        FA_MedicalService.updateInjury(injury);
        Test.stopTest();
        FA_Injury__c updated = [SELECT Status__c FROM FA_Injury__c WHERE Id = :injury.Id];
        System.assertEquals('Rehabilitation', updated.Status__c, 'Status should be updated');
    }

    @isTest
    static void logMedicalAccess_validData_logCreated() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        Test.startTest();
        FA_MedicalService.logMedicalAccess(UserInfo.getUserId(), player.Id, 'Consultation', 'Accessed medical record');
        Test.stopTest();
        List<FA_Medical_Access_Log__c> logs = [SELECT Id FROM FA_Medical_Access_Log__c WHERE Player__c = :player.Id];
        System.assertEquals(1, logs.size(), 'Access log should be created');
    }

    @isTest
    static void setPlayersInjured_validIds_playersSetInjured() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        Set<Id> playerIds = new Set<Id>{ player.Id };
        Test.startTest();
        FA_MedicalService.setPlayersInjured(playerIds);
        Test.stopTest();
        FA_Player__c updated = [SELECT Status__c FROM FA_Player__c WHERE Id = :player.Id];
        System.assertEquals('Injured', updated.Status__c, 'Player status should be Injured');
    }

    @isTest
    static void controllerGetMedicalRecord_validPlayer_returnsRecord() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        Test.startTest();
        FA_Medical_Record__c result = FA_MedicalController.getMedicalRecord(player.Id);
        Test.stopTest();
        System.assertNotEquals(null, result, 'Controller should return medical record');
    }
}
