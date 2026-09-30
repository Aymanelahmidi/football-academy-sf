/**
 * @description [LC] Lightning controller for Medical and Evaluation pages.
 * Delegates to FA_MedicalService, FA_EvaluationService. No SOQL, no DML.
 *
 * CRITICAL FIX: getMedicalRecord is NOT cacheable because it calls logMedicalAccess (DML).
 * A cacheable=true method must never perform DML.
 * @author Football Academy
 * @date 2026
 */
public with sharing class FA_MedicalController {

    // ==================== MEDICAL ====================

    /**
     * @description Get medical record for a player and log the access for RGPD compliance.
     * NOT cacheable because it performs an audit log DML.
     */
    @AuraEnabled
    public static FA_Medical_Record__c getMedicalRecord(Id playerId) {
        try {
            FA_MedicalService.logMedicalAccess(UserInfo.getUserId(), playerId, 'Consultation', 'Consultation dossier médical');
            return FA_MedicalService.getMedicalRecord(playerId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<FA_Injury__c> getInjuries(Id playerId, String status) {
        return FA_MedicalService.getInjuries(playerId, status);
    }

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getMedicalStats() {
        return FA_MedicalService.getMedicalStats();
    }

    @AuraEnabled
    public static FA_Injury__c createInjury(FA_Injury__c injury) {
        try {
            return FA_MedicalService.createInjury(injury);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static FA_Injury__c updateInjury(FA_Injury__c injury) {
        try {
            return FA_MedicalService.updateInjury(injury);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<FA_Medical_Access_Log__c> getAccessLogs(Id playerId) {
        return FA_MedicalService.getAccessLogs(playerId);
    }

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
