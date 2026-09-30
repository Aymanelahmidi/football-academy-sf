/**
 * @description [SM] Service class for FA_Match__c and FA_Match_Event__c operations.
 * Orchestrates FA_MatchSelector (SOQL) and FA_MatchDomain (logic).
 * Only layer authorized to perform DML.
 * @author Football Academy
 * @date 2026
 */
public with sharing class FA_MatchService {

    public static List<FA_Match__c> getMatches(Id categoryId, String status, Date startDate, Date endDate) {
        return FA_MatchSelector.getMatches(categoryId, status, startDate, endDate);
    }

    public static FA_Match__c getMatchById(Id matchId) {
        return FA_MatchSelector.getMatchById(matchId);
    }

    public static Map<String, Object> getMatchStats() {
        List<FA_Match__c> completedMatches = FA_MatchSelector.getCompletedMatches();
        Map<String, Object> stats = FA_MatchDomain.calculateStats(completedMatches);
        stats.put('upcomingMatches', FA_MatchSelector.getUpcomingMatchesCount());
        return stats;
    }

    public static FA_Match__c createMatch(FA_Match__c m) {
        FA_MatchDomain.buildName(m);
        insert m;
        return FA_MatchSelector.getMatchById(m.Id);
    }

    public static FA_Match_Event__c addMatchEvent(FA_Match_Event__c evt) {
        insert evt;
        return evt;
    }
}
