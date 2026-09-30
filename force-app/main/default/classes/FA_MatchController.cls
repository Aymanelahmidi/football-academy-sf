/**
 * @description [LC] Lightning controller for Match management pages.
 * Delegates to FA_MatchService and FA_MatchSelector. No SOQL, no DML.
 * @author Football Academy
 * @date 2026
 */
public with sharing class FA_MatchController {

    @AuraEnabled(cacheable=true)
    public static List<FA_Match__c> getMatches(Id categoryId, String status, Date startDate, Date endDate) {
        return FA_MatchService.getMatches(categoryId, status, startDate, endDate);
    }

    @AuraEnabled(cacheable=true)
    public static FA_Match__c getMatchById(Id matchId) {
        return FA_MatchService.getMatchById(matchId);
    }

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getMatchStats() {
        return FA_MatchService.getMatchStats();
    }

    @AuraEnabled
    public static FA_Match__c createMatch(FA_Match__c m) {
        try {
            return FA_MatchService.createMatch(m);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static FA_Match_Event__c addMatchEvent(FA_Match_Event__c evt) {
        try {
            return FA_MatchService.addMatchEvent(evt);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<FA_Competition__c> getCompetitions() {
        return FA_MatchSelector.getCompetitions();
    }
}
