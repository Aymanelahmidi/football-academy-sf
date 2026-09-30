@isTest
private class FA_DashboardSelectorTest {
    @TestSetup
    static void setup() {
        FA_TestDataFactory.createFullTestData();
    }

    @isTest
    static void testGetRecentMatches() {
        List<FA_Match__c> matches = FA_DashboardSelector.getRecentMatches();
        System.assertNotEquals(null, matches);
    }

    @isTest
    static void testGetRecentInjuries() {
        List<FA_Injury__c> injuries = FA_DashboardSelector.getRecentInjuries();
        System.assertNotEquals(null, injuries);
    }

    @isTest
    static void testGetUpcomingMatches() {
        FA_Category__c cat = [SELECT Id FROM FA_Category__c LIMIT 1];
        FA_Match__c futureMatch = new FA_Match__c(
            Name = 'Future Match', Category__c = cat.Id, Opponent__c = 'Test',
            Match_Date__c = Date.today().addDays(5), Kickoff_Time__c = '16:00',
            Location__c = 'Stade', Is_Home__c = true, Status__c = 'Scheduled'
        );
        insert futureMatch;
        List<FA_Match__c> matches = FA_DashboardSelector.getUpcomingMatches();
        System.assert(!matches.isEmpty());
    }

    @isTest
    static void testGetUpcomingTrainingSessions() {
        FA_Category__c cat = [SELECT Id FROM FA_Category__c LIMIT 1];
        FA_Staff_Profile__c coach = [SELECT Id FROM FA_Staff_Profile__c LIMIT 1];
        FA_Training_Session__c futureSession = new FA_Training_Session__c(
            Name = 'Future Session', Category__c = cat.Id, Coach__c = coach.Id,
            Session_Date__c = Date.today().addDays(3), Start_Time__c = '09:00',
            End_Time__c = '10:30', Location__c = 'Terrain', Type__c = 'Technical', Status__c = 'Scheduled'
        );
        insert futureSession;
        List<FA_Training_Session__c> sessions = FA_DashboardSelector.getUpcomingTrainingSessions();
        System.assert(!sessions.isEmpty());
    }
}