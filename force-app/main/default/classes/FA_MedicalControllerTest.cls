@isTest
private with sharing class FA_MedicalControllerTest {

    @TestSetup
    static void setup() {
        FA_Category__c cat = FA_TestDataFactory.createCategory('U19', 'U19', 17, 19);
        FA_Staff_Profile__c doctor = FA_TestDataFactory.createStaff('Dr. Alaoui', 'Doctor');
        FA_Player__c player = FA_TestDataFactory.createPlayer('Abderrazak', 'Hamdallah', cat.Id, 'Forward');
        FA_Medical_Record__c record = FA_TestDataFactory.createMedicalRecord(player.Id);
        FA_Injury__c injury = FA_TestDataFactory.createInjury(player.Id, 'Muscle Strain', 'Hamstring', Date.today().addDays(-14));
    }

    @isTest
    static void controllerGetMedicalRecord_validPlayer_returnsRecord() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        Test.startTest();
        FA_Medical_Record__c result = FA_MedicalController.getMedicalRecord(player.Id);
        Test.stopTest();
        System.assertNotEquals(null, result, 'Controller should return medical record');
    }

    @isTest
    static void controllerGetInjuries_validPlayer_returnsInjuries() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        Test.startTest();
        List<FA_Injury__c> result = FA_MedicalController.getInjuries(player.Id, null);
        Test.stopTest();
        System.assert(result.size() > 0, 'Controller should return injuries');
    }

    @isTest
    static void controllerGetMedicalStats_returnsStats() {
        Test.startTest();
        Map<String, Object> stats = FA_MedicalController.getMedicalStats();
        Test.stopTest();
        System.assertNotEquals(null, stats, 'Controller should return medical stats');
    }

    @isTest
    static void controllerCreateInjury_validData_injuryCreated() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        FA_Injury__c newInjury = new FA_Injury__c(
            Name = 'Ligament Tear - Knee',
            Player__c = player.Id,
            Type__c = 'Ligament Tear',
            Body_Part__c = 'Knee',
            Severity__c = 'Severe',
            Injury_Date__c = Date.today(),
            Status__c = 'In Treatment'
        );
        Test.startTest();
        FA_MedicalController.createInjury(newInjury);
        Test.stopTest();
        List<FA_Injury__c> injuries = [SELECT Id FROM FA_Injury__c WHERE Type__c = 'Ligament Tear' AND Player__c = :player.Id];
        System.assertEquals(1, injuries.size(), 'Injury should be created via controller');
    }

    @isTest
    static void controllerUpdateInjury_validData_injuryUpdated() {
        FA_Injury__c injury = [SELECT Id, Status__c, Player__c FROM FA_Injury__c LIMIT 1];
        injury.Status__c = 'Recovered';
        Test.startTest();
        FA_MedicalController.updateInjury(injury);
        Test.stopTest();
        FA_Injury__c updated = [SELECT Status__c FROM FA_Injury__c WHERE Id = :injury.Id];
        System.assertEquals('Recovered', updated.Status__c, 'Status should be updated via controller');
    }

    @isTest
    static void controllerGetEvaluations_validPlayer_returnsEvaluations() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        FA_Evaluation__c eval = FA_TestDataFactory.createEvaluation(player.Id, Date.today());
        Test.startTest();
        List<FA_Evaluation__c> result = FA_MedicalController.getEvaluations(player.Id, null);
        Test.stopTest();
        System.assert(result.size() > 0, 'Controller should return evaluations');
    }

    @isTest
    static void controllerGetFinanceStats_returnsStats() {
        Test.startTest();
        Map<String, Object> stats = FA_MedicalController.getFinanceStats();
        Test.stopTest();
        System.assertNotEquals(null, stats, 'Controller should return finance stats');
    }

    @isTest
    static void controllerGetDocuments_validPlayer_returnsDocuments() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        FA_Document__c doc = FA_TestDataFactory.createDocument(player.Id, 'Certificat Médical');
        Test.startTest();
        List<FA_Document__c> result = FA_MedicalController.getDocuments(player.Id, null, null);
        Test.stopTest();
        System.assert(result.size() > 0, 'Controller should return documents');
    }
}
