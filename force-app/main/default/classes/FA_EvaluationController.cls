/**
 * @description [LC] Lightning controller for Evaluation, Finance, and Document pages.
 * Delegates 100% to FA_EvaluationService. No SOQL, no DML.
 * @author Football Academy
 * @date 2026
 */
public with sharing class FA_EvaluationController {

    // ==================== EVALUATIONS ====================

    @AuraEnabled(cacheable=true)
    public static List<FA_Evaluation__c> getEvaluations(Id playerId, String evalType) {
        return FA_EvaluationService.getEvaluations(playerId, evalType);
    }

    @AuraEnabled
    public static FA_Evaluation__c createEvaluation(FA_Evaluation__c eval) {
        try {
            return FA_EvaluationService.createEvaluation(eval);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    // ==================== FINANCES ====================

    @AuraEnabled(cacheable=true)
    public static List<FA_Transaction__c> getTransactions(String transType, String status, Date startDate, Date endDate) {
        return FA_EvaluationService.getTransactions(transType, status, startDate, endDate);
    }

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getFinanceStats() {
        return FA_EvaluationService.getFinanceStats();
    }

    @AuraEnabled
    public static FA_Transaction__c createTransaction(FA_Transaction__c trans) {
        try {
            return FA_EvaluationService.createTransaction(trans);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    // ==================== DOCUMENTS ====================

    @AuraEnabled(cacheable=true)
    public static List<FA_Document__c> getDocuments(Id playerId, String docType, String status) {
        return FA_EvaluationService.getDocuments(playerId, docType, status);
    }

    @AuraEnabled
    public static FA_Document__c createDocument(FA_Document__c doc) {
        try {
            return FA_EvaluationService.createDocument(doc);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
