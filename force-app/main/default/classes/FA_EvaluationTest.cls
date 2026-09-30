@isTest
private with sharing class FA_EvaluationTest {

    @TestSetup
    static void setup() {
        FA_Category__c cat = FA_TestDataFactory.createCategory('U13', 'U13', 11, 13);
        FA_Player__c player = FA_TestDataFactory.createPlayer('Hamza', 'Toumi', cat.Id, 'Midfielder');
        FA_Evaluation__c eval = FA_TestDataFactory.createEvaluation(player.Id, Date.today());
    }

    @isTest
    static void getEvaluations_validPlayerId_returnsEvaluations() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        Test.startTest();
        List<FA_Evaluation__c> result = FA_EvaluationService.getEvaluations(player.Id, null);
        Test.stopTest();
        System.assert(result.size() > 0, 'Should return evaluations for player');
    }

    @isTest
    static void createEvaluation_validData_evaluationCreated() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        FA_Evaluation__c newEval = new FA_Evaluation__c(
            Name = 'Eval-Test',
            Player__c = player.Id,
            Evaluation_Date__c = Date.today().addDays(30),
            Type__c = 'Monthly',
            Technical_Score__c = 80,
            Tactical_Score__c = 75,
            Physical_Score__c = 85,
            Mental_Score__c = 78,
            Speed_Score__c = 82,
            Endurance_Score__c = 76,
            Overall_Score__c = 79
        );
        Test.startTest();
        FA_EvaluationService.createEvaluation(newEval);
        Test.stopTest();
        List<FA_Evaluation__c> evals = [SELECT Id FROM FA_Evaluation__c WHERE Player__c = :player.Id];
        System.assertEquals(2, evals.size(), 'Second evaluation should be created');
    }

    @isTest
    static void getTransactions_noFilter_returnsAllTransactions() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        FA_Transaction__c tx = new FA_Transaction__c(
            Name = 'Test TX',
            Player__c = player.Id,
            Type__c = 'Revenue',
            Amount__c = 1000,
            Transaction_Date__c = Date.today(),
            Description__c = 'Test',
            Status__c = 'Payé',
            Payment_Method__c = 'Cash',
            Category__c = 'Registration'
        );
        insert tx;
        Test.startTest();
        List<FA_Transaction__c> result = FA_EvaluationService.getTransactions(null, null, null, null);
        Test.stopTest();
        System.assert(result.size() > 0, 'Should return transactions');
    }

    @isTest
    static void getFinanceStats_returnsStats() {
        Test.startTest();
        Map<String, Object> stats = FA_EvaluationService.getFinanceStats();
        Test.stopTest();
        System.assertNotEquals(null, stats, 'Stats should not be null');
    }

    @isTest
    static void createTransaction_validData_transactionCreated() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        FA_Transaction__c tx = new FA_Transaction__c(
            Player__c = player.Id,
            Type__c = 'Expense',
            Amount__c = 500,
            Transaction_Date__c = Date.today(),
            Description__c = 'Equipment purchase',
            Status__c = 'Payé',
            Payment_Method__c = 'Bank Transfer',
            Category__c = 'Equipment'
        );
        Test.startTest();
        FA_EvaluationService.createTransaction(tx);
        Test.stopTest();
        List<FA_Transaction__c> txs = [SELECT Id FROM FA_Transaction__c WHERE Description__c = 'Equipment purchase'];
        System.assertEquals(1, txs.size(), 'Transaction should be created');
    }

    @isTest
    static void getDocuments_validPlayerId_returnsDocuments() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        FA_Document__c doc = FA_TestDataFactory.createDocument(player.Id, 'Licence');
        Test.startTest();
        List<FA_Document__c> result = FA_EvaluationService.getDocuments(player.Id, null, null);
        Test.stopTest();
        System.assert(result.size() > 0, 'Should return documents for player');
    }

    @isTest
    static void createDocument_validData_documentCreated() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        FA_Document__c doc = new FA_Document__c(
            Name = 'ID Document',
            Player__c = player.Id,
            Type__c = 'Identité',
            Status__c = 'Valide',
            Expiry_Date__c = Date.today().addYears(1),
            File_URL__c = 'https://example.com/id.pdf'
        );
        Test.startTest();
        FA_EvaluationService.createDocument(doc);
        Test.stopTest();
        List<FA_Document__c> docs = [SELECT Id FROM FA_Document__c WHERE Player__c = :player.Id AND Type__c = 'Identité'];
        System.assertEquals(1, docs.size(), 'Document should be created');
    }
}
