# CLAUDE.md — Football Academy SF

## Présentation du projet

**Football Academy SF** est une application Salesforce (SFDX, API v66.0) conçue pour la gestion complète d'une académie de football.
Elle couvre la gestion des joueurs, des entraînements, des matchs, du suivi médical, des performances physiques, de l'analyse vidéo, des finances et des documents.

---

## Stack Technique

| Couche          | Technologie                                      |
|-----------------|--------------------------------------------------|
| Backend         | Apex (classes `with sharing`, services + controllers) |
| Frontend        | Lightning Web Components (LWC)                   |
| Données         | Custom Objects Salesforce (FA_* prefix)          |
| Intégrations    | REST callouts (GPS, Video), FA_GpsRestApi        |
| Tests           | Apex Test Classes (FA_ServiceTest, FA_TestDataFactory) |
| Déploiement     | SFDX CLI / Salesforce CLI (`sf`)                 |
| Org             | Developer Edition / Scratch Org                  |

---

## Architecture des Objets Principaux

```
FA_Category__c              ← Catégories (U7, U9, U11... Senior)
├── FA_Player__c            ← Joueurs (cœur du domaine)
│   ├── FA_Injury__c        ← Blessures
│   ├── FA_Medical_Record__c← Dossier médical
│   ├── FA_Evaluation__c    ← Évaluations sportives
│   ├── FA_GPS_Data__c      ← Données GPS
│   └── FA_Legal_Guardian__c← Tuteurs légaux (mineurs)
├── FA_Training_Session__c  ← Sessions d'entraînement
│   ├── FA_Attendance__c    ← Présences
│   └── FA_Session_Exercise__c ← Exercices
├── FA_Match__c             ← Matchs
│   └── FA_Match_Event__c   ← Événements match (but, carton...)
├── FA_Competition__c       ← Compétitions / championnats
└── FA_Staff_Profile__c     ← Profils staff (coach, médecin...)

FA_Physical_Program__c      ← Programmes de préparation physique
FA_Fitness_Test__c          ← Tests physiques (VMA, Cooper...)
FA_Morphological_Measure__c ← Mesures morphologiques
FA_Video_Analysis__c        ← Analyses vidéo
FA_Video_Annotation__c      ← Annotations vidéo
FA_Transaction__c           ← Transactions financières
FA_Document__c              ← Documents (contrats, licences...)
FA_Contract__c              ← Contrats joueurs
FA_Medical_Access_Log__c    ← Journal d'accès aux données médicales
FA_Academy_Setting__c       ← Configuration de l'académie
```

---

## Architecture Enterprise Apex — 5 Couches

### Structure obligatoire par domaine

```
force-app/main/default/
├── triggers/
│   └── FA_<Object>Trigger.trigger          ← Thin trigger (aucune logique)
└── classes/
    ├── FA_<Object>TriggerHandler.cls        ← [TH] Route les events trigger
    ├── FA_<Object>Domain.cls                ← [DM] Règles métier, validation
    ├── FA_<Object>Service.cls               ← [SM] Orchestration, seul à faire DML
    ├── FA_<Object>Selector.cls              ← [EM] Tout le SOQL encapsulé
    ├── FA_<Object>Controller.cls            ← [LC] @AuraEnabled LWC uniquement
    └── FA_<Object>Test.cls                  ← Tests >= 85% coverage
```

**Exemple concret (domaine Player) :**
```
FA_PlayerTrigger.trigger
FA_PlayerTriggerHandler.cls
FA_PlayerDomain.cls
FA_PlayerService.cls
FA_PlayerSelector.cls
FA_PlayerController.cls
FA_PlayerTest.cls
```

### Règle d'or — Qui peut faire quoi ?

| Couche | SOQL | DML | Logique métier | @AuraEnabled |
|--------|------|-----|----------------|--------------|
| **[EM]** Selector | ✅ | ❌ | ❌ | ❌ |
| **[DM]** Domain | ❌ | ❌ | ✅ | ❌ |
| **[SM]** Service | ❌ | ✅ | ✅ | ❌ |
| **[TH]** TriggerHandler | ❌ | ❌ | ❌ | ❌ |
| **[LC]** Controller | ❌ | ❌ | ❌ | ✅ |

### Règles impératives
- Toutes les classes sont `with sharing` (sécurité record-level)
- **[EM]** utilise `Database.queryWithBinds` + `AccessLevel.USER_MODE` → FLS enforced
- **[LC]** utilise `@AuraEnabled(cacheable=true)` pour les lectures sans DML
- **[LC]** utilise try/catch → `AuraHandledException` sur toutes les mutations
- **[TH]** : 1 trigger + 1 handler par objet Salesforce
- Aucun SOQL dans Controller, Domain, TriggerHandler
- Aucun DML dans Selector, Domain, TriggerHandler, Controller
- Pas de SOQL dans les boucles (governor limits)
- SOQL dynamique : `Database.queryWithBinds` avec `Map<String, Object>` de binds

### Intégrations REST externes
```
FA_<Type>Integration.cls     ← Callouts vers APIs externes (GPS, Vidéo)
FA_<Type>RestApi.cls         ← Endpoints REST entrants (@RestResource)
```

---

## Conventions LWC

### Préfixe de composants
Tous les composants LWC utilisent le préfixe `fa` (camelCase) :
```
faPlayerList, faPlayerProfile, faTrainingSessions,
faMatchList, faDashboard, faMedicalTracking...
```

### Pattern standard
```javascript
// Utiliser @wire pour les données cacheable
@wire(getPlayers, { categoryId: '$selectedCategory' })
wiredPlayers({ error, data }) { ... }

// Utiliser imperative calls pour les mutations
handleSave() {
    createPlayer({ player: this.playerData })
        .then(result => { ... })
        .catch(error => { ... });
}
```

---

## Codes de Statut Standard

### Joueur (FA_Player__c.Status__c)
| Valeur       | Signification              |
|--------------|----------------------------|
| Actif        | Joueur en activité normale |
| Blessé       | Blessure en cours          |
| Suspendu     | Suspension disciplinaire   |
| Prêté        | En prêt à un autre club    |
| Inactif      | Désactivé                  |

### Match (FA_Match__c.Status__c)
| Valeur     | Signification         |
|------------|-----------------------|
| Planifié   | Match à venir         |
| En cours   | Match en direct       |
| Terminé    | Match joué            |
| Annulé     | Match annulé          |
| Reporté    | Match reporté         |

### Blessure (FA_Injury__c.Status__c)
| Valeur       | Signification              |
|--------------|----------------------------|
| Active       | Blessure en cours          |
| En rééducation | Phase de rééducation     |
| Guéri        | Blessure guérie            |

---

## Règles SOQL / Governor Limits

```apex
// INTERDIT — SOQL dans une boucle
for (FA_Player__c p : players) {
    List<FA_Injury__c> injuries = [SELECT Id FROM FA_Injury__c WHERE Player__c = :p.Id]; // ❌
}

// CORRECT — Query bulk + Map
Map<Id, List<FA_Injury__c>> injuriesMap = new Map<Id, List<FA_Injury__c>>();
List<FA_Injury__c> allInjuries = [SELECT Id, Player__c FROM FA_Injury__c WHERE Player__c IN :playerIds]; // ✅
```

---

## Tests Apex — Règles

- Coverage minimum: **85%** sur toutes les classes
- Utiliser `FA_TestDataFactory` pour créer des données de test
- Toujours utiliser `@isTest` et `System.runAs(testUser)` pour tester les permissions
- Séparer les méthodes de test : une méthode = un scénario
- Pattern : `methodName_scenario_expectedResult()`

---

## Déploiement

```bash
# Déployer vers l'org par défaut
sf project deploy start --source-dir force-app

# Déployer avec tests
sf project deploy start --source-dir force-app --test-level RunLocalTests

# Valider sans déployer (check-only)
sf project deploy validate --source-dir force-app --test-level RunLocalTests

# Récupérer depuis l'org
sf project retrieve start --source-dir force-app
```

---

## Intégrations Externes

| Intégration         | Classe              | Description                        |
|---------------------|---------------------|------------------------------------|
| GPS / Wearables     | FA_GpsIntegration   | Données GPS joueurs (vitesse, km)  |
| API GPS REST        | FA_GpsRestApi       | Endpoint REST entrant GPS          |
| Vidéo               | FA_VideoIntegration | Plateforme vidéo externe           |
| Intégration générale| FA_ExternalIntegration | Callouts génériques             |

---

## Org Salesforce

- **Login URL**: https://login.salesforce.com
- **API Version**: 66.0
- **Namespace**: (vide — pas de namespace)
- **Alias org**: voir `.sf/config.json`
