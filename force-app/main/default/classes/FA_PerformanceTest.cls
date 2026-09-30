@isTest
private with sharing class FA_PerformanceTest {

    @TestSetup
    static void setup() {
        FA_Category__c cat = FA_TestDataFactory.createCategory('U21', 'U21', 19, 21);
        FA_Staff_Profile__c staff = FA_TestDataFactory.createStaff('Prep Physique', 'Fitness Coach');
        FA_Player__c player = FA_TestDataFactory.createPlayer('Saad', 'Regragui', cat.Id, 'Forward');
        FA_Training_Session__c session = FA_TestDataFactory.createSession(cat.Id, staff.Id, Date.today());
        FA_GPS_Data__c gps = FA_TestDataFactory.createGpsData(player.Id, session.Id, Date.today());
    }

    @isTest
    static void getGpsData_validPlayerAndSession_returnsData() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        Test.startTest();
        List<FA_GPS_Data__c> result = FA_PerformanceService.getGpsData(player.Id, null, null, null);
        Test.stopTest();
        System.assert(result.size() > 0, 'Should return GPS data for player');
    }

    @isTest
    static void getPlayerGpsAverages_validPlayer_returnsAverages() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        Test.startTest();
        Map<String, Decimal> result = FA_PerformanceService.getPlayerGpsAverages(player.Id, 30);
        Test.stopTest();
        System.assertNotEquals(null, result, 'GPS averages should not be null');
    }

    @isTest
    static void createGpsData_validData_gpsCreated() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        FA_Training_Session__c session = [SELECT Id FROM FA_Training_Session__c LIMIT 1];
        FA_GPS_Data__c gps = new FA_GPS_Data__c(
            Player__c = player.Id,
            Training_Session__c = session.Id,
            Record_Date__c = Date.today().addDays(1),
            Context__c = 'Entraînement',
            Total_Distance_Km__c = 9.0,
            Max_Speed_Kmh__c = 30.0
        );
        Test.startTest();
        FA_PerformanceService.createGpsData(gps);
        Test.stopTest();
        List<FA_GPS_Data__c> result = [SELECT Id FROM FA_GPS_Data__c WHERE Player__c = :player.Id];
        System.assertEquals(2, result.size(), 'Second GPS record should be created');
    }

    @isTest
    static void getPhysicalPrograms_validCategory_returnsPrograms() {
        FA_Category__c cat = [SELECT Id FROM FA_Category__c LIMIT 1];
        FA_Staff_Profile__c staff = [SELECT Id FROM FA_Staff_Profile__c LIMIT 1];
        FA_Physical_Program__c prog = FA_TestDataFactory.createPhysicalProgram(cat.Id, staff.Id);
        Test.startTest();
        List<FA_Physical_Program__c> result = FA_PerformanceService.getPhysicalPrograms(cat.Id, null);
        Test.stopTest();
        System.assert(result.size() > 0, 'Should return physical programs');
    }

    @isTest
    static void createPhysicalProgram_validData_programCreated() {
        FA_Category__c cat = [SELECT Id FROM FA_Category__c LIMIT 1];
        FA_Staff_Profile__c staff = [SELECT Id FROM FA_Staff_Profile__c LIMIT 1];
        FA_Physical_Program__c prog = new FA_Physical_Program__c(
            Name = 'Programme Test',
            Category__c = cat.Id,
            Preparateur__c = staff.Id,
            Type__c = 'Endurance',
            Status__c = 'Active',
            Start_Date__c = Date.today(),
            End_Date__c = Date.today().addMonths(3),
            Weekly_Frequency__c = 4
        );
        Test.startTest();
        FA_PerformanceService.createPhysicalProgram(prog);
        Test.stopTest();
        List<FA_Physical_Program__c> progs = [SELECT Id FROM FA_Physical_Program__c WHERE Category__c = :cat.Id];
        System.assertEquals(1, progs.size(), 'Physical program should be created');
    }

    @isTest
    static void getFitnessTests_validPlayer_returnsTests() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        FA_Staff_Profile__c staff = [SELECT Id FROM FA_Staff_Profile__c LIMIT 1];
        FA_Fitness_Test__c ft = FA_TestDataFactory.createFitnessTest(player.Id, staff.Id, 'Cooper');
        Test.startTest();
        List<FA_Fitness_Test__c> result = FA_PerformanceService.getFitnessTests(player.Id, null);
        Test.stopTest();
        System.assert(result.size() > 0, 'Should return fitness tests');
    }

    @isTest
    static void createFitnessTest_validData_testCreated() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        FA_Staff_Profile__c staff = [SELECT Id FROM FA_Staff_Profile__c LIMIT 1];
        FA_Fitness_Test__c ft = new FA_Fitness_Test__c(
            Player__c = player.Id,
            Evaluator__c = staff.Id,
            Test_Date__c = Date.today(),
            Test_Type__c = 'Sprint 30m',
            Result__c = 4.2,
            Unit__c = 'seconds'
        );
        Test.startTest();
        FA_PerformanceService.createFitnessTest(ft);
        Test.stopTest();
        List<FA_Fitness_Test__c> tests = [SELECT Id FROM FA_Fitness_Test__c WHERE Player__c = :player.Id AND Test_Type__c = 'Sprint 30m'];
        System.assertEquals(1, tests.size(), 'Fitness test should be created');
    }

    @isTest
    static void getMorphologicalMeasures_validPlayer_returnsMeasures() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        FA_Morphological_Measure__c measure = FA_TestDataFactory.createMorphologicalMeasure(player.Id);
        Test.startTest();
        List<FA_Morphological_Measure__c> result = FA_PerformanceService.getMorphologicalMeasures(player.Id);
        Test.stopTest();
        System.assert(result.size() > 0, 'Should return morphological measures');
    }

    @isTest
    static void createMorphologicalMeasure_validData_measureCreated() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        FA_Morphological_Measure__c measure = new FA_Morphological_Measure__c(
            Player__c = player.Id,
            Measure_Date__c = Date.today().addDays(30),
            Height_Cm__c = 176,
            Weight_Kg__c = 70,
            BMI__c = 22.6,
            Body_Fat_Percent__c = 13.0,
            Muscle_Mass_Kg__c = 56.0
        );
        Test.startTest();
        FA_PerformanceService.createMorphologicalMeasure(measure);
        Test.stopTest();
        List<FA_Morphological_Measure__c> measures = [SELECT Id FROM FA_Morphological_Measure__c WHERE Player__c = :player.Id];
        System.assertEquals(1, measures.size(), 'Measure should be created');
    }
}
