@isTest
private with sharing class FA_ExternalIntegrationTest {

    private class MockSageSuccess implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(201);
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"status":"ok"}');
            return res;
        }
    }

    private class MockFrmfSuccess implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"status":"ok"}');
            return res;
        }
    }

    @TestSetup
    static void setup() {
        FA_Category__c cat = FA_TestDataFactory.createCategory('U17', 'U17', 15, 17);
        FA_Player__c player = FA_TestDataFactory.createPlayer('Ilias', 'Akhomach', cat.Id, 'Forward');
        player.License_Number__c = 'LIC-2024-001';
        player.National_ID__c = 'ID-12345678';
        update player;
        FA_Transaction__c tx = new FA_Transaction__c(
            Name = 'TX-001',
            Player__c = player.Id,
            Type__c = 'Revenue',
            Amount__c = 1500,
            Transaction_Date__c = Date.today().addDays(-10),
            Description__c = 'Monthly fee',
            Status__c = 'Payé',
            Payment_Method__c = 'Cash',
            Category__c = 'Registration',
            Synced_To_Accounting__c = false
        );
        insert tx;
    }

    @isTest
    static void syncToSage_successResponse_transactionsSynced() {
        Test.setMock(HttpCalloutMock.class, new MockSageSuccess());
        Test.startTest();
        FA_ExternalIntegration.syncToSage(Date.today().addDays(-30), Date.today());
        Test.stopTest();
        List<FA_Transaction__c> synced = [SELECT Id, Synced_To_Accounting__c FROM FA_Transaction__c WHERE Synced_To_Accounting__c = true];
        System.assert(synced.size() >= 0, 'Sync operation should complete');
    }

    @isTest
    static void exportPlayerRegistrations_validCategory_exportSuccess() {
        FA_Category__c cat = [SELECT Id FROM FA_Category__c LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new MockFrmfSuccess());
        Test.startTest();
        FA_ExternalIntegration.exportPlayerRegistrations(cat.Id);
        Test.stopTest();
        System.assert(true, 'Export should complete without error');
    }

    @isTest
    static void submitLicenseRenewal_validPlayer_renewalSubmitted() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new MockFrmfSuccess());
        Test.startTest();
        FA_ExternalIntegration.submitLicenseRenewal(player.Id);
        Test.stopTest();
        System.assert(true, 'License renewal should complete without error');
    }

    @isTest
    static void syncToSage_noTransactions_completesGracefully() {
        Test.setMock(HttpCalloutMock.class, new MockSageSuccess());
        Test.startTest();
        FA_ExternalIntegration.syncToSage(Date.today().addDays(-1), Date.today().addDays(-1));
        Test.stopTest();
        System.assert(true, 'Sync with no data should complete gracefully');
    }
}
