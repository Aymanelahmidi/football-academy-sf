---
name: soql-optimization
description: Apply when writing SOQL queries, reviewing query performance, analyzing governor limit risks, or working with large datasets (GPS data, match events, training attendance). Use when queries are slow or hitting limits.
---

# Skill: Optimisation SOQL — Football Academy SF

## Contexte Volumes de Données

| Objet                    | Volume Estimé    | Risque           |
|--------------------------|------------------|------------------|
| FA_Player__c             | ~500 joueurs     | Faible           |
| FA_Training_Session__c   | ~200/an          | Faible           |
| FA_Attendance__c         | ~10,000/an       | Moyen            |
| FA_Match__c              | ~100/an          | Faible           |
| FA_Match_Event__c        | ~1,000/an        | Faible           |
| FA_GPS_Data__c           | **~500,000/an**  | **CRITIQUE**     |
| FA_Video_Annotation__c   | ~5,000/an        | Moyen            |
| FA_Medical_Record__c     | ~2,000/an        | Moyen            |

---

## Règle #1 — Index sur les Champs de Filtrage

Les champs suivants doivent être **indexés** (External ID ou custom index) :
- `FA_Player__c.Is_Active__c`
- `FA_GPS_Data__c.Player__c` + `FA_GPS_Data__c.Session_Date__c`
- `FA_Attendance__c.Training_Session__c`
- `FA_Match_Event__c.Match__c`

---

## Règle #2 — Queries GPS Data (CRITIQUE)

```apex
// ❌ DANGEREUX — Peut retourner des millions de lignes
List<FA_GPS_Data__c> allGps = [SELECT Id FROM FA_GPS_Data__c WHERE Player__c = :playerId];

// ✅ TOUJOURS filtrer par plage de dates + LIMIT
List<FA_GPS_Data__c> gpsData = [
    SELECT Id, Distance__c, Max_Speed__c, Avg_Heart_Rate__c, Session_Date__c
    FROM FA_GPS_Data__c
    WHERE Player__c = :playerId
        AND Session_Date__c >= :startDate
        AND Session_Date__c <= :endDate
    ORDER BY Session_Date__c DESC
    LIMIT 90  // Max 90 sessions (3 mois)
];

// ✅ Pour les agrégats (statistiques), utiliser AggregateResult
AggregateResult[] gpsStats = [
    SELECT AVG(Distance__c) avgDist, AVG(Max_Speed__c) avgSpeed, COUNT(Id) sessions
    FROM FA_GPS_Data__c
    WHERE Player__c = :playerId
        AND Session_Date__c = THIS_MONTH
];
```

---

## Règle #3 — Jointures Efficaces

```apex
// ✅ Toujours préférer les relationship queries aux queries séparées
List<FA_Player__c> playersWithInjuries = [
    SELECT Id, First_Name__c, Last_Name__c, Position__c,
        (SELECT Id, Type__c, Status__c, Expected_Return_Date__c
         FROM Injuries__r
         WHERE Status__c != 'Guéri'
         ORDER BY CreatedDate DESC
         LIMIT 1)
    FROM FA_Player__c
    WHERE Category__c = :categoryId AND Is_Active__c = true
    ORDER BY Last_Name__c ASC
];

// ✅ Plutôt que 2 queries séparées :
// List<FA_Player__c> players = [SELECT Id FROM FA_Player__c WHERE ...]; // Query 1
// List<FA_Injury__c> injuries = [SELECT Id FROM FA_Injury__c WHERE Player__c IN :playerIds]; // Query 2
```

---

## Règle #4 — Agrégats pour le Dashboard

```apex
// ✅ Utiliser COUNT/SUM/AVG/MAX/MIN plutôt que de charger tous les records
public static Map<String, Object> getMatchStats() {
    Map<String, Object> stats = new Map<String, Object>();

    // Total matchs par statut
    for (AggregateResult ar : [
        SELECT Status__c status, COUNT(Id) cnt
        FROM FA_Match__c
        GROUP BY Status__c
    ]) {
        stats.put('matches_' + ar.get('status'), ar.get('cnt'));
    }

    // Buts marqués cette saison
    AggregateResult[] goals = [
        SELECT SUM(Goals_For__c) totalFor, SUM(Goals_Against__c) totalAgainst
        FROM FA_Match__c
        WHERE Status__c = 'Terminé' AND Match_Date__c = THIS_YEAR
    ];
    if (!goals.isEmpty()) {
        stats.put('goalsFor', goals[0].get('totalFor'));
        stats.put('goalsAgainst', goals[0].get('totalAgainst'));
    }

    return stats;
}
```

---

## Règle #5 — Pagination pour les Grandes Listes

```apex
// ✅ Pagination via LIMIT/OFFSET pour la datatable LWC
public static List<FA_Player__c> getPlayersPaged(Integer pageSize, Integer pageNumber) {
    Integer offset = (pageNumber - 1) * pageSize;
    return [
        SELECT Id, First_Name__c, Last_Name__c, Position__c, Category__r.Name
        FROM FA_Player__c
        WHERE Is_Active__c = true
        ORDER BY Last_Name__c ASC, First_Name__c ASC
        LIMIT :pageSize OFFSET :offset
    ];
}

// ATTENTION : OFFSET max = 2000 dans Salesforce
// Pour les grandes tables (GPS), utiliser SOQL Cursor ou des filtres de date
```

---

## Règle #6 — Batch Apex pour les Calculs Lourds

```apex
// ✅ Pour les calculs de performance sur toute la saison
public class FA_PerformanceBatch implements Database.Batchable<SObject> {

    public Database.QueryLocator start(Database.BatchableContext ctx) {
        return Database.getQueryLocator([
            SELECT Id, Player__c, Distance__c, Max_Speed__c
            FROM FA_GPS_Data__c
            WHERE Session_Date__c = THIS_YEAR
        ]);
    }

    public void execute(Database.BatchableContext ctx, List<FA_GPS_Data__c> scope) {
        // Traiter par lots de 200 (batch size par défaut)
        // Calculer les moyennes, mettre à jour FA_Player__c.Performance_Score__c
    }

    public void finish(Database.BatchableContext ctx) {
        // Notification email / Platform Event quand le calcul est terminé
    }
}

// Lancer avec un batch size adapté aux GPS data (200 recommandé)
Database.executeBatch(new FA_PerformanceBatch(), 200);
```

---

## Queries de Diagnostic

```bash
# Chercher les queries SOQL sans LIMIT (risque governor)
grep -rn "FROM FA_GPS_Data__c\|FROM FA_Attendance__c\|FROM FA_Video_Annotation__c" \
  force-app/main/default/classes/ --include="*.cls" | grep -v "LIMIT\|COUNT"

# Queries dynamiques sans bind (risque injection)
grep -rn "Database\.query" force-app/main/default/classes/ --include="*.cls" \
  | grep -v "escapeSingleQuotes"
```
