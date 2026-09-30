@isTest
private class FA_EvaluationSelectorTest {
    @TestSetup
    static void setup() {
        FA_TestDataFactory.createFullTestData();
    }

    @isTest
    static void testGetEvaluations_noFilters() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        FA_TestDataFactory.createEvaluation(player.Id, Date.today());
        List<FA_Evaluation__c> evals = FA_EvaluationSelector.getEvaluations(null, null);
        System.assert(!evals.isEmpty());
    }

    @isTest
    static void testGetEvaluations_withFilters() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        FA_TestDataFactory.createEvaluation(player.Id, Date.today());
        List<FA_Evaluation__c> evals = FA_EvaluationSelector.getEvaluations(player.Id, 'Monthly');
        System.assertNotEquals(null, evals);
    }

    @isTest
    static void testGetTransactions_noFilters() {
        List<FA_Transaction__c> trans = FA_EvaluationSelector.getTransactions(null, null, null, null);
        System.assertNotEquals(null, trans);
    }

    @isTest
    static void testGetTransactions_withFilters() {
        FA_Transaction__c t = new FA_Transaction__c(
            Type__c = 'Revenue', Category__c = 'Test',
            Description__c = 'Test', Amount__c = 100,
            Transaction_Date__c = Date.today(), Status__c = 'Payé'
        );
        insert t;
        List<FA_Transaction__c> results = FA_EvaluationSelector.getTransactions(
            'Revenue', 'Payé', Date.today().addDays(-1), Date.today().addDays(1)
        );
        System.assert(!results.isEmpty());
    }

    @isTest
    static void testGetFinanceStatsByType() {
        List<AggregateResult> results = FA_EvaluationSelector.getFinanceStatsByType();
        System.assertNotEquals(null, results);
    }

    @isTest
    static void testGetPendingTransactionTotal() {
        List<AggregateResult> results = FA_EvaluationSelector.getPendingTransactionTotal();
        System.assertNotEquals(null, results);
    }

    @isTest
    static void testGetDocuments() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        List<FA_Document__c> docs = FA_EvaluationSelector.getDocuments(player.Id, null, null);
        System.assertNotEquals(null, docs);
    }
}