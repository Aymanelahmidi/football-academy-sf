@isTest
private class FA_EvaluationDomainTest {

    @isTest
    static void testCalculateOverallScore_allScores() {
        FA_Evaluation__c eval = new FA_Evaluation__c(
            Technical_Score__c = 80,
            Tactical_Score__c = 70,
            Physical_Score__c = 90,
            Mental_Score__c = 60,
            Speed_Score__c = 75,
            Endurance_Score__c = 65
        );
        FA_EvaluationDomain.calculateOverallScore(eval);
        System.assertNotEquals(null, eval.Overall_Score__c);
        // Average = (80+70+90+60+75+65)/6 = 73.33 -> 73
        System.assertEquals(73, (Integer) eval.Overall_Score__c);
    }

    @isTest
    static void testCalculateOverallScore_partialScores() {
        FA_Evaluation__c eval = new FA_Evaluation__c(
            Technical_Score__c = 80,
            Tactical_Score__c = 60
        );
        FA_EvaluationDomain.calculateOverallScore(eval);
        System.assertEquals(70, (Integer) eval.Overall_Score__c);
    }

    @isTest
    static void testCalculateOverallScore_alreadySet() {
        FA_Evaluation__c eval = new FA_Evaluation__c(
            Overall_Score__c = 99,
            Technical_Score__c = 50
        );
        FA_EvaluationDomain.calculateOverallScore(eval);
        System.assertEquals(99, (Integer) eval.Overall_Score__c, 'Should not overwrite existing score');
    }

    @isTest
    static void testCalculateOverallScore_noScores() {
        FA_Evaluation__c eval = new FA_Evaluation__c();
        FA_EvaluationDomain.calculateOverallScore(eval);
        System.assertEquals(null, eval.Overall_Score__c);
    }

    @isTest
    static void testBuildName() {
        FA_Evaluation__c eval = new FA_Evaluation__c(Evaluation_Date__c = Date.newInstance(2026, 1, 15));
        FA_EvaluationDomain.buildName(eval);
        System.assertEquals('Eval-2026-01-15', eval.Name);
    }
}