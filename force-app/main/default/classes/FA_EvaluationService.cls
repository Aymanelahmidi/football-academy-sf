/**
 * @description [SM] Service class for evaluations, finances, and documents.
 * Orchestrates FA_EvaluationSelector (SOQL) and FA_EvaluationDomain (logic).
 * Only layer authorized to perform DML.
 * @author Football Academy
 * @date 2026
 */
public with sharing class FA_EvaluationService {

    // ==================== EVALUATIONS ====================

    public static List<FA_Evaluation__c> getEvaluations(Id playerId, String evalType) {
        return FA_EvaluationSelector.getEvaluations(playerId, evalType);
    }

    public static FA_Evaluation__c createEvaluation(FA_Evaluation__c eval) {
        FA_EvaluationDomain.calculateOverallScore(eval);
        FA_EvaluationDomain.buildName(eval);
        insert eval;
        return eval;
    }

    // ==================== FINANCES ====================

    public static List<FA_Transaction__c> getTransactions(String transType, String status, Date startDate, Date endDate) {
        return FA_EvaluationSelector.getTransactions(transType, status, startDate, endDate);
    }

    public static Map<String, Object> getFinanceStats() {
        Map<String, Object> stats = new Map<String, Object>();

        List<AggregateResult> byType = FA_EvaluationSelector.getFinanceStatsByType();
        Decimal totalRevenue = 0, totalExpenses = 0;
        for (AggregateResult ar : byType) {
            String t = (String) ar.get('t');
            Decimal amount = (Decimal) ar.get('total');
            if (t == 'Revenue')      totalRevenue  = amount;
            else if (t == 'Expense') totalExpenses = amount;
        }
        stats.put('totalRevenue',  totalRevenue);
        stats.put('totalExpenses', totalExpenses);
        stats.put('balance', totalRevenue - totalExpenses);

        Decimal pending = 0;
        List<AggregateResult> pendingAgg = FA_EvaluationSelector.getPendingTransactionTotal();
        if (!pendingAgg.isEmpty() && pendingAgg[0].get('total') != null) {
            pending = (Decimal) pendingAgg[0].get('total');
        }
        stats.put('pendingAmount', pending);

        return stats;
    }

    public static FA_Transaction__c createTransaction(FA_Transaction__c trans) {
        trans.Name = trans.Type__c + ' - ' + trans.Description__c;
        insert trans;
        return trans;
    }

    // ==================== DOCUMENTS ====================

    public static List<FA_Document__c> getDocuments(Id playerId, String docType, String status) {
        return FA_EvaluationSelector.getDocuments(playerId, docType, status);
    }

    public static FA_Document__c createDocument(FA_Document__c doc) {
        insert doc;
        return doc;
    }
}
