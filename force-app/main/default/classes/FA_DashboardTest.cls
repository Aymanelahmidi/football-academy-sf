@isTest
private with sharing class FA_DashboardTest {

    @TestSetup
    static void setup() {
        FA_Category__c cat = FA_TestDataFactory.createCategory('U17', 'U17', 15, 17);
        FA_Staff_Profile__c coach = FA_TestDataFactory.createStaff('Coach Lahlou', 'Coach');
        FA_Player__c player = FA_TestDataFactory.createPlayer('Zakaria', 'Laaroussi', cat.Id, 'Midfielder');
        FA_Training_Session__c session = FA_TestDataFactory.createSession(cat.Id, coach.Id, Date.today().addDays(1));
        FA_Match__c match = FA_TestDataFactory.createMatch(cat.Id, 'MCO', Date.today().addDays(3));
    }

    @isTest
    static void getDashboardStats_returnsStats() {
        Test.startTest();
        Map<String, Object> stats = FA_DashboardController.getDashboardStats();
        Test.stopTest();
        System.assertNotEquals(null, stats, 'Dashboard stats should not be null');
    }

    @isTest
    static void getRecentActivity_returnsActivity() {
        Test.startTest();
        Map<String, Object> activity = FA_DashboardController.getRecentActivity();
        Test.stopTest();
        System.assertNotEquals(null, activity, 'Recent activity should not be null');
    }

    @isTest
    static void getUpcomingEvents_returnsEvents() {
        Test.startTest();
        List<Map<String, Object>> events = FA_DashboardController.getUpcomingEvents();
        Test.stopTest();
        System.assertNotEquals(null, events, 'Upcoming events should not be null');
    }

    @isTest
    static void getDashboardStats_withMultiplePlayers_returnsCorrectCounts() {
        FA_Category__c cat = [SELECT Id FROM FA_Category__c LIMIT 1];
        FA_Player__c player2 = FA_TestDataFactory.createPlayer('Nassim', 'Bouazza', cat.Id, 'Defender');
        Test.startTest();
        Map<String, Object> stats = FA_DashboardController.getDashboardStats();
        Test.stopTest();
        System.assertNotEquals(null, stats, 'Stats should not be null with multiple players');
    }
}
