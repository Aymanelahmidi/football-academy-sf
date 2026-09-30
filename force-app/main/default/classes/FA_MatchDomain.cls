/**
 * @description [DM] Domain class for FA_Match__c business rules.
 * Pure logic on in-memory collections. No SOQL, no DML.
 * @author Football Academy
 * @date 2026
 */
public with sharing class FA_MatchDomain {

    /**
     * @description Calculate win/draw/loss stats and goal tallies from completed matches.
     * @param completedMatches List of completed FA_Match__c records with Goals_For__c and Goals_Against__c.
     * @return Map containing: totalPlayed, wins, draws, losses, goalsFor, goalsAgainst.
     */
    public static Map<String, Object> calculateStats(List<FA_Match__c> completedMatches) {
        Integer wins = 0, draws = 0, losses = 0;
        Integer totalGoalsFor = 0, totalGoalsAgainst = 0;

        for (FA_Match__c m : completedMatches) {
            Integer gf = m.Goals_For__c != null ? Integer.valueOf(m.Goals_For__c) : 0;
            Integer ga = m.Goals_Against__c != null ? Integer.valueOf(m.Goals_Against__c) : 0;
            totalGoalsFor += gf;
            totalGoalsAgainst += ga;
            if (gf > ga) wins++;
            else if (gf == ga) draws++;
            else losses++;
        }

        return new Map<String, Object>{
            'totalPlayed' => completedMatches.size(),
            'wins'        => wins,
            'draws'       => draws,
            'losses'      => losses,
            'goalsFor'    => totalGoalsFor,
            'goalsAgainst'=> totalGoalsAgainst
        };
    }

    /**
     * @description Auto-generate a match Name from home/away and opponent.
     * @param m Match record to update in-memory.
     */
    public static void buildName(FA_Match__c m) {
        m.Name = (m.Is_Home__c ? 'Académie vs ' : '') + m.Opponent__c +
            (m.Is_Home__c ? '' : ' vs Académie') + ' - ' + String.valueOf(m.Match_Date__c);
    }

    /**
     * @description Validate required fields before insert/update.
     * Adds errors directly to records (trigger context).
     * @param matches List of match records to validate.
     */
    public static void validateList(List<FA_Match__c> matches) {
        for (FA_Match__c m : matches) {
            if (String.isBlank(m.Opponent__c)) {
                m.addError('Adversaire obligatoire.');
            }
            if (m.Match_Date__c == null) {
                m.addError('Date du match obligatoire.');
            }
        }
    }
}
