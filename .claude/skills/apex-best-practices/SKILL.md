---
name: apex-best-practices
description: Apply whenever writing or reviewing Apex code in this project. Covers bulkification, governor limits, sharing rules, SOQL injection prevention, async patterns, and Football Academy-specific conventions. Activate on any Apex code creation or review.
---

# Skill: Apex Best Practices — Football Academy SF

## Règle #1 — Bulkification (CRITIQUE)

```apex
// ❌ INTERDIT — SOQL dans une boucle
for (FA_Player__c player : players) {
    List<FA_Injury__c> injuries = [SELECT Id FROM FA_Injury__c WHERE Player__c = :player.Id];
}

// ✅ CORRECT — Bulk query avec Map
Set<Id> playerIds = new Map<Id, FA_Player__c>(players).keySet();
Map<Id, List<FA_Injury__c>> injuriesByPlayer = new Map<Id, List<FA_Injury__c>>();
for (FA_Injury__c inj : [SELECT Id, Player__c, Type__c FROM FA_Injury__c WHERE Player__c IN :playerIds]) {
    if (!injuriesByPlayer.containsKey(inj.Player__c)) {
        injuriesByPlayer.put(inj.Player__c, new List<FA_Injury__c>());
    }
    injuriesByPlayer.get(inj.Player__c).add(inj);
}
```

## Règle #2 — SOQL Injection Prevention

```apex
// ❌ DANGEREUX
String query = 'SELECT Id FROM FA_Player__c WHERE Last_Name__c = \'' + searchTerm + '\'';

// ✅ CORRECT — Bind variable
List<FA_Player__c> players = [SELECT Id FROM FA_Player__c WHERE Last_Name__c = :searchTerm];

// ✅ CORRECT — Query dynamique avec échappement
String safe = String.escapeSingleQuotes(searchTerm);
String query = 'SELECT Id FROM FA_Player__c WHERE Last_Name__c LIKE \'%' + safe + '%\'';
List<FA_Player__c> players = Database.query(query);
```

## Règle #3 — Sharing (Sécurité Record-Level)

```apex
// ✅ TOUJOURS with sharing (respecte les règles de partage Salesforce)
public with sharing class FA_PlayerService { ... }

// ⚠️ Justification obligatoire si without sharing
public without sharing class FA_SystemService {
    // JUSTIFICATION : Opération système (nettoyage batch), pas d'accès utilisateur direct
}
```

## Règle #4 — @AuraEnabled Standards

```apex
// ✅ Lectures → cacheable=true
@AuraEnabled(cacheable=true)
public static List<FA_Player__c> getPlayers(Id categoryId) { ... }

// ✅ Mutations → pas de cacheable + try/catch + AuraHandledException
@AuraEnabled
public static FA_Player__c createPlayer(FA_Player__c player) {
    try {
        return FA_PlayerService.createPlayer(player);
    } catch (DmlException e) {
        throw new AuraHandledException('Erreur création joueur: ' + e.getDmlMessage(0));
    } catch (Exception e) {
        throw new AuraHandledException(e.getMessage());
    }
}
```

## Règle #5 — DML Patterns

```apex
// ❌ INTERDIT — DML dans une boucle
for (FA_Player__c p : players) {
    update p;
}

// ✅ CORRECT — Bulk DML
List<FA_Player__c> toUpdate = new List<FA_Player__c>();
for (FA_Player__c p : players) {
    p.Status__c = 'Actif';
    toUpdate.add(p);
}
update toUpdate;
```

## Règle #6 — Async pour les Callouts (GPS/Vidéo)

```apex
// ❌ INTERDIT — callout dans un trigger (après DML)
// ✅ CORRECT — @future avec callout=true
@future(callout=true)
public static void syncGpsDataAsync(String playerIds) {
    FA_GpsIntegration.syncData(playerIds);
}

// ✅ OU Queueable (meilleur contrôle)
public class FA_GpsSyncJob implements Queueable, Database.AllowsCallouts {
    private List<Id> playerIds;
    public FA_GpsSyncJob(List<Id> ids) { this.playerIds = ids; }
    public void execute(QueueableContext ctx) {
        FA_GpsIntegration.syncData(playerIds);
    }
}
System.enqueueJob(new FA_GpsSyncJob(playerIds));
```

## Règle #7 — Sélection de Champs (Performance)

```apex
// ❌ Ne jamais sélectionner des champs inutiles
SELECT Id, Name, First_Name__c, Last_Name__c, Date_of_Birth__c, Nationality__c,
       Category__c, Category__r.Name, Category__r.Short_Name__c, Position__c,
       Preferred_Foot__c, Height__c, Weight__c, Photo_URL__c, Phone__c, Email__c,
       Address__c, Parent_Name__c, Parent_Phone__c, Jersey_Number__c, Status__c,
       Join_Date__c, Is_Active__c, CreatedDate, LastModifiedDate, /* ... 20 champs de plus ... */
FROM FA_Player__c -- pour juste afficher le nom !

// ✅ CORRECT — Sélectionner uniquement ce qui est nécessaire
SELECT Id, First_Name__c, Last_Name__c, Jersey_Number__c, Position__c, Status__c
FROM FA_Player__c
WHERE Is_Active__c = true
```

## Règle #8 — Gestion des Données Mineurs (RGPD)

```apex
// Joueurs mineurs (<18 ans) → accès aux contacts parents restreint
public static Boolean isMinor(FA_Player__c player) {
    if (player.Date_of_Birth__c == null) return false;
    return player.Date_of_Birth__c.addYears(18) > Date.today();
}

// Log d'accès aux données médicales sensibles
public static void logMedicalAccess(Id playerId, String accessType) {
    insert new FA_Medical_Access_Log__c(
        Player__c = playerId,
        Access_Type__c = accessType,
        Accessed_By__c = UserInfo.getUserId(),
        Access_Date__c = DateTime.now()
    );
}
```

## Governor Limits — Seuils à Surveiller

| Limite                  | Valeur     | Risque Football Academy                        |
|-------------------------|------------|------------------------------------------------|
| SOQL queries            | 100/trans  | Faible (services bien structurés)              |
| SOQL rows               | 50,000     | ⚠️ GPS Data (beaucoup de données par joueur)  |
| DML statements          | 150/trans  | Faible                                         |
| DML rows                | 10,000     | ⚠️ Imports de données en masse                |
| Callouts                | 100/trans  | ⚠️ Intégration GPS + Vidéo simultanées        |
| CPU time                | 10,000ms   | ⚠️ Calculs de performance (VMA, indices)      |
| Heap size               | 6MB        | ⚠️ Traitement vidéo (métadonnées)             |

## Pattern Test Standard

```apex
@isTest
public class FA_PlayerServiceTest {

    @TestSetup
    static void setup() {
        FA_TestDataFactory.createTestData(); // Utiliser toujours la factory
    }

    @isTest
    static void testGetPlayers_withCategory_returnsFiltered() {
        // Arrange
        FA_Category__c category = [SELECT Id FROM FA_Category__c LIMIT 1];

        // Act
        Test.startTest();
        List<FA_Player__c> players = FA_PlayerService.getPlayers(category.Id, null, null);
        Test.stopTest();

        // Assert
        System.assert(players.size() > 0, 'Should return players for category');
        for (FA_Player__c p : players) {
            System.assertEquals(category.Id, p.Category__c);
        }
    }
}
```
