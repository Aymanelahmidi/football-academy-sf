@isTest
private with sharing class FA_PerformanceControllerTest {

    @TestSetup
    static void setup() {
        FA_Category__c cat = FA_TestDataFactory.createCategory('U21', 'U21', 19, 21);
        FA_Staff_Profile__c staff = FA_TestDataFactory.createStaff('Preparateur Physique', 'Fitness Coach');
        FA_Player__c player = FA_TestDataFactory.createPlayer('Tarik', 'Tissoudali', cat.Id, 'Midfielder');
        FA_Training_Session__c session = FA_TestDataFactory.createSession(cat.Id, staff.Id, Date.today());
        FA_GPS_Data__c gps = FA_TestDataFactory.createGpsData(player.Id, session.Id, Date.today());
    }

    @isTest
    static void controllerGetGpsData_validPlayer_returnsData() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        Test.startTest();
        List<FA_GPS_Data__c> result = FA_PerformanceController.getGpsData(player.Id, null, null, null);
        Test.stopTest();
        System.assert(result.size() > 0, 'Controller should return GPS data');
    }

    @isTest
    static void controllerGetPlayerGpsAverages_validPlayer_returnsAverages() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        Test.startTest();
        Map<String, Object> result = FA_PerformanceController.getPlayerGpsAverages(player.Id, 30);
        Test.stopTest();
        System.assertNotEquals(null, result, 'Controller should return GPS averages');
    }

    @isTest
    static void controllerCreateGpsData_validData_gpsCreated() {
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
        FA_PerformanceController.createGpsData(gps);
        Test.stopTest();
        List<FA_GPS_Data__c> result = [SELECT Id FROM FA_GPS_Data__c WHERE Player__c = :player.Id];
        System.assertEquals(2, result.size(), 'GPS data should be created via controller');
    }

    @isTest
    static void controllerBulkImportGpsData_multipleRecords_allCreated() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        FA_Training_Session__c session = [SELECT Id FROM FA_Training_Session__c LIMIT 1];
        List<FA_GPS_Data__c> gpsDataList = new List<FA_GPS_Data__c>{
            new FA_GPS_Data__c(
                Player__c = player.Id,
                Training_Session__c = session.Id,
                Record_Date__c = Date.today().addDays(2),
                Context__c = 'Entraînement',
                Total_Distance_Km__c = 8.0,
                Max_Speed_Kmh__c = 27.0
            ),
            new FA_GPS_Data__c(
                Player__c = player.Id,
                Training_Session__c = session.Id,
                Record_Date__c = Date.today().addDays(3),
                Context__c = 'Entraînement',
                Total_Distance_Km__c = 9.5,
                Max_Speed_Kmh__c = 29.0
            )
        };
        Test.startTest();
        FA_PerformanceController.bulkImportGpsData(gpsDataList);
        Test.stopTest();
        List<FA_GPS_Data__c> result = [SELECT Id FROM FA_GPS_Data__c WHERE Player__c = :player.Id];
        System.assertEquals(3, result.size(), 'Bulk GPS data should be created via controller');
    }

    @isTest
    static void controllerGetPhysicalPrograms_validCategory_returnsPrograms() {
        FA_Category__c cat = [SELECT Id FROM FA_Category__c LIMIT 1];
        FA_Staff_Profile__c staff = [SELECT Id FROM FA_Staff_Profile__c LIMIT 1];
        FA_Physical_Program__c prog = FA_TestDataFactory.createPhysicalProgram(cat.Id, staff.Id);
        Test.startTest();
        List<FA_Physical_Program__c> result = FA_PerformanceController.getPhysicalPrograms(cat.Id, null);
        Test.stopTest();
        System.assert(result.size() > 0, 'Controller should return physical programs');
    }

    @isTest
    static void controllerGetFitnessTests_validPlayer_returnsTests() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        FA_Staff_Profile__c staff = [SELECT Id FROM FA_Staff_Profile__c LIMIT 1];
        FA_Fitness_Test__c ft = FA_TestDataFactory.createFitnessTest(player.Id, staff.Id, 'Cooper');
        Test.startTest();
        List<FA_Fitness_Test__c> result = FA_PerformanceController.getFitnessTests(player.Id, null);
        Test.stopTest();
        System.assert(result.size() > 0, 'Controller should return fitness tests');
    }
}
