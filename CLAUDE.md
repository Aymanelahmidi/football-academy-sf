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

---

## Pièges connus — Metadata API

- **TextArea** n'accepte pas `<length>` : il est figé à 255 caractères. Seul **LongTextArea** prend `<length>`, et il exige aussi `<visibleLines>`.
- **Custom Metadata Type** (`__mdt`) n'accepte pas `<deploymentStatus>` ni `<sharingModel>` ni `<nameField>`. Seuls `<label>`, `<pluralLabel>` et `<visibility>` sont valides dans l'object-meta.xml.
- **PermissionSet** : l'élément pour les permissions système (ex. ViewSetup) s'appelle `<userPermissions>`, pas `<systemPermissions>`.
- **Champ Required** (`<required>true</required>`) : ne pas l'inclure dans les `<fieldPermissions>` d'un permission set — l'API le refuse avec "cannot deploy to a required field".
- **CustomApplication Lightning** : `<formFactors>Large</formFactors>` est obligatoire. `Small` est interdit pour les Lightning apps (réservé aux mobile-only apps).
- **Permission ViewSetup** : dépend de `ViewRoles`. Les deux doivent être déclarés ensemble dans `<userPermissions>` sinon l'API refuse le déploiement.
- **`modifyAllRecords`** ("Modify All") implique `allowDelete`. Sans `allowDelete>true`, l'API refuse. Si on ne veut pas le delete, mettre `modifyAllRecords>false`.
- Le déploiement vers une org réelle est le seul test de validité du métadata. Un fichier bien formé peut être refusé par l'API Metadata.
- **`Database.Stateful` + bind dans `start()`** — Dans un batch `Database.Stateful`, les variables d'instance utilisées dans un SOQL inline de `start()` peuvent être non fiables après désérialisation. Utiliser `Database.getQueryLocatorWithBinds(query, binds, accessLevel)` à la place de `Database.getQueryLocator([... WHERE x IN :instanceVar])`.
- **Flush sur changement de clé, jamais sur fin de chunk** — Dans un `Batchable` dont les lignes sont triées par une clé (`ORDER BY Field ASC`), flusher en fin d'`execute()` fractionne l'agrégat en cas de chevauchement de chunk. Pattern correct : flush-on-change dans la boucle + flush-last dans `finish()`. Implémenter `Database.Stateful` pour que l'accumulateur survive entre les chunks.
- **`Database.upsert` partiel : vérifier les `UpsertResult`** — `Database.upsert(list, externalId, false)` (allOrNone=false) ne lève pas d'exception sur les échecs partiels. Chaque `Database.UpsertResult` doit être inspecté avec `isSuccess()` / `getErrors()`. Sans cette vérification, des composants non upsertés passent silencieusement.
- **`containsKey()` vs valeur null** — `JSON.deserializeUntyped` peut retourner une clé présente avec une valeur `null` (ex. `{"TriggerType":null}`). `map.get('TriggerType')` retourne `null` dans les deux cas : clé absente ET clé présente/null. Utiliser `map.containsKey('TriggerType')` pour distinguer les deux.
- **`apexClassAccesses` dans PermissionSet XML** — Le parseur de l'API Metadata rejette `<apexClassAccesses>` à toutes les positions testées (début, milieu, fin du fichier). Ajouter l'accès Apex à un permission set **uniquement via l'UI Setup** : Setup > Permission Sets > [nom] > Apex Class Access > Edit. Ne jamais tenter de déployer `apexClassAccesses` via XML.
- **`FlexiPage — componentInstances` est top-level** — `<componentInstances>` est un enfant direct de `<FlexiPage>`, pas de `<flexiPageRegions>`. Imbriquer `componentInstances` dans `flexiPageRegions` provoque l'erreur "Property 'componentInstances' not valid at this location".
- **`WITH USER_MODE` en SOQL statique** — La clause `WITH USER_MODE` (ou `WITH SECURITY_ENFORCED`) doit apparaître **avant** `ORDER BY` et `LIMIT`. L'ordre correct : `FROM … WHERE … WITH USER_MODE ORDER BY … LIMIT …`. La placer après `LIMIT` provoque une erreur de compilation (`Expecting ']' but was: 'WITH'`).
- **`PermissionSet` — ordre des éléments** — `<apexClassAccesses>` et `<applicationVisibilities>` doivent apparaître **avant** `<fieldPermissions>` et `<objectPermissions>` dans le XML. L'API refuse un fichier où ces éléments sont dans le mauvais ordre. Mettre `apexClassAccesses` / `applicationVisibilities` au début du `<PermissionSet>`, avant `<label>`.
- **`@AuraEnabled(cacheable=true)` et polling** — Les réponses des méthodes `cacheable=true` sont mises en cache ~30 secondes par la plateforme Lightning, même si les données ont changé. Un polling auto-refresh sur ces méthodes est peu fiable. Privilégier un bouton « Rafraîchir » manuel. Si un auto-refresh est indispensable, le limiter à 10 tentatives maximum (jamais infini).
- **Custom Metadata Types et mode utilisateur** — Les objets `__mdt` ne supportent ni `WITH USER_MODE`, ni `AccessLevel.USER_MODE`, ni `Security.stripInaccessible`. Ils ne sont pas soumis au CRUD/FLS ; la plateforme rejette ces modificateurs avec "sObject type 'X__mdt' is not supported". Utiliser `AccessLevel.SYSTEM_MODE` ou la SOQL statique sans modificateur de mode pour toutes les requêtes sur `__mdt`.
- **Queueable et profondeur de pile en test** — En contexte de test, un Queueable ne peut enchaîner qu'un seul Queueable. Une chaîne multi-scope casse au deuxième maillon avec "Maximum stack depth has been reached". Pattern correct : `if (!Test.isRunningTest()) { System.enqueueJob(nextJob); }`. Couvrir chaque scope individuellement avec un test dédié.
- **SetupAuditTrail** — Ne supporte pas les agrégats (`COUNT()`, `GROUP BY`). `CreatedBy` peut être `null` pour les entrées système. Nécessite la permission `ViewSetup` (View Setup and Configuration) ; sans elle, la query retourne zéro ligne ou échoue. Regrouper les résultats côté Apex.
- **PermissionSet — `tabSettings` obligatoire pour la visibilité des onglets** — Un permission set redéployé sans `<tabSettings>` remet ses onglets à non visible dans l'app.
- **Un permission set déployé remplace `classAccesses` ET `tabSettings`** — Un élément absent du fichier est retiré dans l'org. Toujours déployer le fichier complet avec tous les accès, onglets et permissions souhaités.
- **`tabSettings` — noms d'onglets objets custom** — Les onglets de custom objects utilisent le nom API de l'objet directement (ex. `MyObject__c`), pas `standard-MyObject__c`. Le préfixe `standard-` est réservé aux objets standard (Account, Contact, etc.).
