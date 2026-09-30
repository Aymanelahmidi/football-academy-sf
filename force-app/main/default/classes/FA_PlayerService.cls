/**
 * @description [SM] Service class for FA_Player__c operations.
 * Orchestrates FA_PlayerSelector (SOQL) and FA_PlayerDomain (logic).
 * Only layer authorized to perform DML.
 * @author Football Academy
 * @date 2026
 */
public with sharing class FA_PlayerService {

    public static List<FA_Player__c> getPlayers(Id categoryId, String status, String searchTerm) {
        return FA_PlayerSelector.getPlayers(categoryId, status, searchTerm);
    }

    public static FA_Player__c getPlayerById(Id playerId) {
        return FA_PlayerSelector.getPlayerById(playerId);
    }

    public static Map<String, Object> getPlayerStats() {
        Map<String, Object> stats = new Map<String, Object>();

        stats.put('totalPlayers', FA_PlayerSelector.getTotalActivePlayers());

        List<AggregateResult> byCategory = FA_PlayerSelector.getPlayersByCategory();
        List<Map<String, Object>> categoryList = new List<Map<String, Object>>();
        for (AggregateResult ar : byCategory) {
            categoryList.add(new Map<String, Object>{
                'category' => (String) ar.get('catName'),
                'count'    => (Integer) ar.get('cnt')
            });
        }
        stats.put('byCategory', categoryList);

        List<AggregateResult> byPosition = FA_PlayerSelector.getPlayersByPosition();
        Map<String, Integer> positionMap = new Map<String, Integer>();
        for (AggregateResult ar : byPosition) {
            positionMap.put((String) ar.get('pos'), (Integer) ar.get('cnt'));
        }
        stats.put('byPosition', positionMap);

        List<AggregateResult> byStatus = FA_PlayerSelector.getPlayersByStatus();
        Map<String, Integer> statusMap = new Map<String, Integer>();
        for (AggregateResult ar : byStatus) {
            statusMap.put((String) ar.get('st'), (Integer) ar.get('cnt'));
        }
        stats.put('byStatus', statusMap);

        return stats;
    }

    public static FA_Player__c createPlayer(FA_Player__c player) {
        FA_PlayerDomain.buildName(player);
        insert player;
        return FA_PlayerSelector.getPlayerById(player.Id);
    }

    public static FA_Player__c updatePlayer(FA_Player__c player) {
        FA_PlayerDomain.buildName(player);
        update player;
        return FA_PlayerSelector.getPlayerById(player.Id);
    }

    public static void deactivatePlayer(Id playerId) {
        FA_Player__c player = new FA_Player__c(Id = playerId, Is_Active__c = false);
        update player;
    }

    public static List<Map<String, Object>> getPlayersWithInjuryStatus(Id categoryId) {
        List<FA_Player__c> players = FA_PlayerSelector.getPlayersWithInjuryStatus(categoryId);

        List<Map<String, Object>> result = new List<Map<String, Object>>();
        for (FA_Player__c p : players) {
            Map<String, Object> playerMap = new Map<String, Object>{
                'id'             => p.Id,
                'firstName'      => p.First_Name__c,
                'lastName'       => p.Last_Name__c,
                'position'       => p.Position__c,
                'jerseyNumber'   => p.Jersey_Number__c,
                'status'         => p.Status__c,
                'hasActiveInjury'=> !p.Injuries__r.isEmpty()
            };
            if (!p.Injuries__r.isEmpty()) {
                FA_Injury__c injury = p.Injuries__r[0];
                playerMap.put('injuryType',   injury.Type__c);
                playerMap.put('injuryStatus', injury.Status__c);
                playerMap.put('expectedReturn', injury.Expected_Return_Date__c);
            }
            result.add(playerMap);
        }
        return result;
    }
}
