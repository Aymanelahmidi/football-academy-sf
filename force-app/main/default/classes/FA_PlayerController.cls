/**
 * @description [LC] Lightning controller for Player management pages.
 * Delegates 100% to FA_PlayerService (mutations) or FA_PlayerSelector (read-only).
 * No SOQL, no DML.
 * @author Football Academy
 * @date 2026
 */
public with sharing class FA_PlayerController {

    @AuraEnabled(cacheable=true)
    public static List<FA_Player__c> getPlayers(Id categoryId, String status, String searchTerm) {
        return FA_PlayerService.getPlayers(categoryId, status, searchTerm);
    }

    @AuraEnabled(cacheable=true)
    public static FA_Player__c getPlayerById(Id playerId) {
        return FA_PlayerService.getPlayerById(playerId);
    }

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getPlayerStats() {
        return FA_PlayerService.getPlayerStats();
    }

    @AuraEnabled
    public static FA_Player__c createPlayer(FA_Player__c player) {
        try {
            return FA_PlayerService.createPlayer(player);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static FA_Player__c updatePlayer(FA_Player__c player) {
        try {
            return FA_PlayerService.updatePlayer(player);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void deactivatePlayer(Id playerId) {
        try {
            FA_PlayerService.deactivatePlayer(playerId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getPlayersWithInjuryStatus(Id categoryId) {
        return FA_PlayerService.getPlayersWithInjuryStatus(categoryId);
    }

    @AuraEnabled(cacheable=true)
    public static List<FA_Category__c> getCategories() {
        return FA_PlayerSelector.getCategories();
    }

    @AuraEnabled(cacheable=true)
    public static List<FA_Contract__c> getPlayerContracts(Id playerId) {
        return FA_PlayerSelector.getPlayerContracts(playerId);
    }

    @AuraEnabled(cacheable=true)
    public static List<FA_Legal_Guardian__c> getPlayerGuardians(Id playerId) {
        return FA_PlayerSelector.getPlayerGuardians(playerId);
    }
}
