/**
 * @description [EM] Selector for FA_Evaluation__c, FA_Transaction__c, FA_Document__c.
 * All SOQL uses Database.queryWithBinds + AccessLevel.USER_MODE to enforce FLS.
 * No DML, no business logic.
 * @author Football Academy
 * @date 2026
 */
public with sharing class FA_EvaluationSelector {

    public static List<FA_Evaluation__c> getEvaluations(Id playerId, String evalType) {
        String query =
            'SELECT Id, Name, Player__c, Player__r.First_Name__c, Player__r.Last_Name__c, ' +
            'Player__r.Category__r.Short_Name__c, Evaluator__c, Evaluator__r.Display_Name__c, ' +
            'Evaluation_Date__c, Type__c, Technical_Score__c, Tactical_Score__c, ' +
            'Physical_Score__c, Mental_Score__c, Speed_Score__c, Endurance_Score__c, ' +
            'Overall_Score__c, Strengths__c, Weaknesses__c, Recommendations__c, Notes__c, CreatedDate ' +
            'FROM FA_Evaluation__c WHERE Id != null';

        Map<String, Object> binds = new Map<String, Object>();

        if (playerId != null) {
            query += ' AND Player__c = :playerId';
            binds.put('playerId', playerId);
        }
        if (String.isNotBlank(evalType)) {
            query += ' AND Type__c = :evalType';
            binds.put('evalType', evalType);
        }

        query += ' ORDER BY Evaluation_Date__c DESC';
        return Database.queryWithBinds(query, binds, AccessLevel.USER_MODE);
    }

    public static List<FA_Transaction__c> getTransactions(String transType, String status, Date startDate, Date endDate) {
        String query =
            'SELECT Id, Name, Type__c, Category__c, Description__c, Amount__c, ' +
            'Transaction_Date__c, Player__c, Player__r.First_Name__c, Player__r.Last_Name__c, ' +
            'Status__c, Payment_Method__c, Reference__c, Notes__c, CreatedDate ' +
            'FROM FA_Transaction__c WHERE Id != null';

        Map<String, Object> binds = new Map<String, Object>();

        if (String.isNotBlank(transType)) {
            query += ' AND Type__c = :transType';
            binds.put('transType', transType);
        }
        if (String.isNotBlank(status)) {
            query += ' AND Status__c = :status';
            binds.put('status', status);
        }
        if (startDate != null) {
            query += ' AND Transaction_Date__c >= :startDate';
            binds.put('startDate', startDate);
        }
        if (endDate != null) {
            query += ' AND Transaction_Date__c <= :endDate';
            binds.put('endDate', endDate);
        }

        query += ' ORDER BY Transaction_Date__c DESC';
        return Database.queryWithBinds(query, binds, AccessLevel.USER_MODE);
    }

    public static List<AggregateResult> getFinanceStatsByType() {
        String query =
            'SELECT Type__c t, SUM(Amount__c) total ' +
            'FROM FA_Transaction__c WHERE Status__c = :status GROUP BY Type__c';
        Map<String, Object> binds = new Map<String, Object>{ 'status' => 'Payé' };
        return (List<AggregateResult>) Database.queryWithBinds(query, binds, AccessLevel.USER_MODE);
    }

    public static List<AggregateResult> getPendingTransactionTotal() {
        String query =
            'SELECT SUM(Amount__c) total FROM FA_Transaction__c WHERE Status__c = :status';
        Map<String, Object> binds = new Map<String, Object>{ 'status' => 'En Attente' };
        return (List<AggregateResult>) Database.queryWithBinds(query, binds, AccessLevel.USER_MODE);
    }

    public static List<FA_Document__c> getDocuments(Id playerId, String docType, String status) {
        String query =
            'SELECT Id, Name, Type__c, File_URL__c, File_Size__c, ' +
            'Player__c, Player__r.First_Name__c, Player__r.Last_Name__c, ' +
            'Status__c, Expiry_Date__c, Notes__c, CreatedDate ' +
            'FROM FA_Document__c WHERE Id != null';

        Map<String, Object> binds = new Map<String, Object>();

        if (playerId != null) {
            query += ' AND Player__c = :playerId';
            binds.put('playerId', playerId);
        }
        if (String.isNotBlank(docType)) {
            query += ' AND Type__c = :docType';
            binds.put('docType', docType);
        }
        if (String.isNotBlank(status)) {
            query += ' AND Status__c = :status';
            binds.put('status', status);
        }

        query += ' ORDER BY CreatedDate DESC';
        return Database.queryWithBinds(query, binds, AccessLevel.USER_MODE);
    }
}
