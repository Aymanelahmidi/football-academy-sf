---
name: enterprise-architecture
description: Enforce the Football Academy 4-layer enterprise architecture (TH → DM → SM → EM) for every new Apex module. Apply when creating or reviewing any Apex class, trigger, or domain. Ensures consistent layering, naming conventions, and responsibility separation across the entire codebase.
---

# Skill: Enterprise Architecture — Football Academy SF

## Architecture globale (5 couches)

```
┌──────────────────────────────────────────────────────┐
│                    LWC Component                     │
└──────────────────────┬───────────────────────────────┘
                       │ @AuraEnabled
┌──────────────────────▼───────────────────────────────┐
│  [LC]  FA_<Object>Controller.cls                     │
│  Point d'entrée LWC uniquement. Try/catch. Délègue.  │
└──────────────────────┬───────────────────────────────┘
                       │
         ┌─────────────┴─────────────┐
         │                           │
┌────────▼────────┐       ┌──────────▼──────────────────┐
│ FA_<Object>     │       │ [TH] FA_<Object>             │
│ Trigger.trigger │──────▶│ TriggerHandler.cls           │
│ (thin, 1 ligne) │       │ Route before/after events    │
└─────────────────┘       └──────────┬──────────────────┘
                                     │
┌────────────────────────────────────▼─────────────────┐
│  [DM]  FA_<Object>Domain.cls                         │
│  Règles métier, validation, calculs sur collections   │
│  Jamais de SOQL. Jamais de DML direct.               │
└────────────────────────────────────┬─────────────────┘
                                     │
┌────────────────────────────────────▼─────────────────┐
│  [SM]  FA_<Object>Service.cls                        │
│  Orchestration, cross-domain, seul autorisé à DML    │
└────────────────────────────────────┬─────────────────┘
                                     │
┌────────────────────────────────────▼─────────────────┐
│  [EM]  FA_<Object>Selector.cls                       │
│  Tout le SOQL encapsulé ici. Jamais ailleurs.        │
│  Database.queryWithBinds + AccessLevel.USER_MODE     │
└──────────────────────────────────────────────────────┘
```

---

## Nommage des fichiers (convention obligatoire)

| Couche | Fichier | Répertoire |
|--------|---------|------------|
| **Trigger** | `FA_<Object>Trigger.trigger` | `triggers/` |
| **TH** — Trigger Handler | `FA_<Object>TriggerHandler.cls` | `classes/` |
| **DM** — Domain Model | `FA_<Object>Domain.cls` | `classes/` |
| **SM** — Service Manager | `FA_<Object>Service.cls` | `classes/` |
| **EM** — Entity Manager (Selector) | `FA_<Object>Selector.cls` | `classes/` |
| **LC** — Lightning Controller | `FA_<Object>Controller.cls` | `classes/` |
| **Tests** | `FA_<Object>Test.cls` | `classes/` |

**Exemples concrets pour le domaine Player :**
```
FA_PlayerTrigger.trigger
FA_PlayerTriggerHandler.cls
FA_PlayerDomain.cls
FA_PlayerService.cls
FA_PlayerSelector.cls
FA_PlayerController.cls
FA_PlayerTest.cls
```

---

## Responsabilités strictes par couche

### [EM] Selector — Entity Manager (accès données uniquement)

**Règles :**
- TOUT le SOQL est ici, jamais dans une autre couche
- `Database.queryWithBinds` + `AccessLevel.USER_MODE` → FLS enforced automatiquement
- Toujours un `LIMIT` sur les listes (max 200 par défaut)
- Jamais de logique métier, jamais de DML
- Méthodes nommées : `getById`, `getBy<Filtre>`, `getAll`, `getStats`

```apex
public with sharing class FA_PlayerSelector {

    public static FA_Player__c getById(Id playerId) {
        List<SObject> results = Database.queryWithBinds(
            'SELECT Id, Name, First_Name__c, Last_Name__c, Status__c, ' +
            'Category__c, Category__r.Short_Name__c, Position__c, Jersey_Number__c ' +
            'FROM FA_Player__c WHERE Id = :playerId LIMIT 1',
            new Map<String, Object>{ 'playerId' => playerId },
            AccessLevel.USER_MODE
        );
        if (results.isEmpty()) throw new AuraHandledException('Joueur introuvable.');
        return (FA_Player__c) results[0];
    }

    public static List<FA_Player__c> getByFilters(Id categoryId, String status, String search) {
        List<String> conditions = new List<String>{ 'Is_Active__c = true' };
        Map<String, Object> binds = new Map<String, Object>();
        if (categoryId != null) {
            conditions.add('Category__c = :categoryId');
            binds.put('categoryId', categoryId);
        }
        if (String.isNotBlank(status)) {
            conditions.add('Status__c = :status');
            binds.put('status', status);
        }
        if (String.isNotBlank(search)) {
            String s = '%' + String.escapeSingleQuotes(search) + '%';
            conditions.add('(First_Name__c LIKE :s OR Last_Name__c LIKE :s)');
            binds.put('s', s);
        }
        String query = 'SELECT Id, Name, First_Name__c, Last_Name__c, Position__c, ' +
                       'Status__c, Jersey_Number__c, Category__r.Short_Name__c ' +
                       'FROM FA_Player__c WHERE ' + String.join(conditions, ' AND ') +
                       ' ORDER BY Last_Name__c ASC LIMIT 200';
        return (List<FA_Player__c>) Database.queryWithBinds(query, binds, AccessLevel.USER_MODE);
    }

    public static Map<String, Object> getStats() {
        Map<String, Object> stats = new Map<String, Object>();
        stats.put('total', [SELECT COUNT() FROM FA_Player__c WHERE Is_Active__c = true]);
        for (AggregateResult ar : [
            SELECT Status__c s, COUNT(Id) cnt FROM FA_Player__c
            WHERE Is_Active__c = true GROUP BY Status__c
        ]) {
            stats.put((String) ar.get('s'), (Integer) ar.get('cnt'));
        }
        return stats;
    }
}
```

---

### [DM] Domain — Domain Model (règles métier)

**Règles :**
- Logique métier pure : validation, calculs, règles d'intégrité
- Méthodes statiques qui opèrent sur des **collections** (bulk-safe)
- Appelé par le TriggerHandler ET le Service
- **Jamais de SOQL**, **jamais de DML direct**
- Retourne des listes modifiées → le SM fait le DML

```apex
public with sharing class FA_PlayerDomain {

    // Validation avant insert/update
    public static void validate(List<FA_Player__c> players) {
        for (FA_Player__c p : players) {
            if (p.Date_of_Birth__c == null) {
                p.addError('La date de naissance est obligatoire.');
            }
            if (p.Jersey_Number__c != null &&
               (p.Jersey_Number__c < 1 || p.Jersey_Number__c > 99)) {
                p.Jersey_Number__c.addError('Numéro de maillot invalide (1-99).');
            }
        }
    }

    // Valeurs par défaut avant insert
    public static void setDefaults(List<FA_Player__c> players) {
        for (FA_Player__c p : players) {
            if (p.Join_Date__c == null) p.Join_Date__c = Date.today();
            if (p.Status__c == null)    p.Status__c = 'Active';
            if (p.Is_Active__c == null) p.Is_Active__c = true;
        }
    }

    // Règle métier : préparer la mise à jour statut après blessure (bulk)
    public static List<FA_Player__c> buildStatusUpdate(Set<Id> playerIds, String status) {
        List<FA_Player__c> toUpdate = new List<FA_Player__c>();
        for (Id pid : playerIds) {
            toUpdate.add(new FA_Player__c(Id = pid, Status__c = status));
        }
        return toUpdate; // Le SM fait le DML
    }

    // Vérification mineur RGPD
    public static Boolean isMinor(FA_Player__c player) {
        return player.Date_of_Birth__c != null &&
               player.Date_of_Birth__c.addYears(18) > Date.today();
    }
}
```

---

### [SM] Service — Service Manager (orchestration)

**Règles :**
- Coordonne les appels entre Selector, Domain, et autres Services
- **Seule couche autorisée à faire du DML**
- Gère les transactions complexes, callouts async (via Queueable)
- Appelle le Selector pour lire, le Domain pour les règles, fait le DML

```apex
public with sharing class FA_PlayerService {

    // Lecture → délègue au Selector [EM]
    public static List<FA_Player__c> getPlayers(Id categoryId, String status, String search) {
        return FA_PlayerSelector.getByFilters(categoryId, status, search);
    }

    public static FA_Player__c getPlayerById(Id playerId) {
        return FA_PlayerSelector.getById(playerId);
    }

    public static Map<String, Object> getPlayerStats() {
        return FA_PlayerSelector.getStats();
    }

    // Écriture → Domain [DM] valide, SM fait le DML
    public static FA_Player__c createPlayer(FA_Player__c player) {
        FA_PlayerDomain.setDefaults(new List<FA_Player__c>{ player });
        FA_PlayerDomain.validate(new List<FA_Player__c>{ player });
        insert player;
        return FA_PlayerSelector.getById(player.Id);
    }

    public static FA_Player__c updatePlayer(FA_Player__c player) {
        FA_PlayerDomain.validate(new List<FA_Player__c>{ player });
        update player;
        return FA_PlayerSelector.getById(player.Id);
    }

    public static void deactivatePlayer(Id playerId) {
        update new FA_Player__c(Id = playerId, Is_Active__c = false, Status__c = 'Inactive');
    }

    // Cross-domain : blessure créée → mettre à jour statut joueur
    public static void onInjuryCreated(List<FA_Injury__c> injuries) {
        Set<Id> playerIds = new Set<Id>();
        for (FA_Injury__c inj : injuries) playerIds.add(inj.Player__c);
        List<FA_Player__c> toUpdate = FA_PlayerDomain.buildStatusUpdate(playerIds, 'Injured');
        if (!toUpdate.isEmpty()) update toUpdate;
    }
}
```

---

### [TH] Trigger Handler — Routage des événements

**Règles :**
- **Un TriggerHandler par objet Salesforce**
- Reçoit les événements du trigger, délègue au Domain ou Service
- **Jamais de SOQL**, **jamais de DML direct**
- Méthodes nommées selon l'event : `beforeInsert`, `afterUpdate`, etc.

```apex
public with sharing class FA_PlayerTriggerHandler {

    public static void beforeInsert(List<FA_Player__c> newPlayers) {
        FA_PlayerDomain.setDefaults(newPlayers);
        FA_PlayerDomain.validate(newPlayers);
    }

    public static void beforeUpdate(List<FA_Player__c> newList, Map<Id, FA_Player__c> oldMap) {
        FA_PlayerDomain.validate(newList);
    }

    public static void afterInsert(List<FA_Player__c> newPlayers) {
        // Ex: initialiser dossier médical automatiquement
        // FA_MedicalService.initMedicalRecords(new Map<Id, FA_Player__c>(newPlayers).keySet());
    }

    public static void afterUpdate(List<FA_Player__c> newList, Map<Id, FA_Player__c> oldMap) {
        // Ex: notifier le staff si statut change
        Set<Id> statusChanged = new Set<Id>();
        for (FA_Player__c p : newList) {
            if (p.Status__c != oldMap.get(p.Id).Status__c) statusChanged.add(p.Id);
        }
        // if (!statusChanged.isEmpty()) FA_NotificationService.notifyStatusChange(statusChanged);
    }
}
```

---

### Trigger — Thin (délègue uniquement)

**Règles :**
- **1 trigger par objet**, dans `force-app/main/default/triggers/`
- **Aucune logique** dans le trigger — tout va au TriggerHandler
- Fichier méta : `FA_<Object>Trigger.trigger-meta.xml`

```apex
trigger FA_PlayerTrigger on FA_Player__c (
    before insert, before update,
    after insert, after update
) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) FA_PlayerTriggerHandler.beforeInsert(Trigger.new);
        if (Trigger.isUpdate) FA_PlayerTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
    }
    if (Trigger.isAfter) {
        if (Trigger.isInsert) FA_PlayerTriggerHandler.afterInsert(Trigger.new);
        if (Trigger.isUpdate) FA_PlayerTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
    }
}
```

---

### [LC] Controller — Point d'entrée LWC uniquement

**Règles :**
- Uniquement des `@AuraEnabled`, délègue 100% au Service
- `cacheable=true` sur les lectures (sans DML ni side-effects)
- Try/catch sur toutes les mutations → `AuraHandledException`
- **Jamais de SOQL** dans le controller

```apex
public with sharing class FA_PlayerController {

    @AuraEnabled(cacheable=true)
    public static List<FA_Player__c> getPlayers(Id categoryId, String status, String search) {
        return FA_PlayerService.getPlayers(categoryId, status, search);
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
        } catch (DmlException e) {
            throw new AuraHandledException(e.getDmlMessage(0));
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
}
```

---

## Règle d'or : qui peut faire quoi ?

| Couche | SOQL | DML | Logique métier | @AuraEnabled |
|--------|------|-----|----------------|--------------|
| **EM** Selector | ✅ Oui | ❌ Non | ❌ Non | ❌ Non |
| **DM** Domain | ❌ Non | ❌ Non | ✅ Oui | ❌ Non |
| **SM** Service | ❌ Non | ✅ Oui | ✅ Oui | ❌ Non |
| **TH** TriggerHandler | ❌ Non | ❌ Non | ❌ Non | ❌ Non |
| **LC** Controller | ❌ Non | ❌ Non | ❌ Non | ✅ Oui |

---

## Checklist avant de coder un nouveau module

- [ ] `FA_<Object>Selector.cls` créé — tout le SOQL dedans, `AccessLevel.USER_MODE`
- [ ] `FA_<Object>Domain.cls` créé — validation + calculs, zéro SOQL/DML
- [ ] `FA_<Object>Service.cls` créé — orchestre, seul à faire le DML
- [ ] `FA_<Object>TriggerHandler.cls` créé — un par objet, zéro SOQL/DML
- [ ] `FA_<Object>Trigger.trigger` créé — thin, délègue au handler
- [ ] `FA_<Object>Controller.cls` créé — @AuraEnabled uniquement
- [ ] `FA_<Object>Test.cls` mis à jour — coverage >= 85%
- [ ] `with sharing` sur toutes les classes
- [ ] Aucun SOQL dans Controller, Domain, TriggerHandler
- [ ] Aucun DML dans Selector, Domain, TriggerHandler, Controller
