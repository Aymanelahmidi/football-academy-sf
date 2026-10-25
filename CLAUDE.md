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

## Architecture de l'interface — React dans Salesforce

Le source React vit dans `dhc-ui/` à la racine, **hors de `force-app`**.
Salesforce ne voit jamais les `.jsx` ni `node_modules`.

Chaîne : `dhc-ui/src` → build Vite → `force-app/main/default/staticresources/DHC_UI.js` → chargé par le wrapper LWC `dhcApp`.

Trois contraintes non négociables :
- le bundle est un **IIFE en un seul fichier** (`loadScript` ne gère pas les modules ES ni les imports dynamiques)
- React **n'importe jamais `@salesforce/apex`** : c'est le wrapper LWC qui importe les méthodes et les passe à React au montage
- Lightning Web Security **interdit `eval` et `new Function`** dans le bundle

L'UI se construit en **session 4**, pas avant.

---

## Répartition des rôles

Claude Code écrit le métadata et maintient le manifest.
Le déploiement et Git sont faits par l'utilisateur, jamais par Claude Code.

- Ne jamais lancer `sf project deploy`, `sf project retrieve`, `git add`, `git commit` ou `git push`
- Après chaque session, mettre à jour `manifest/package-dhc.xml` avec les composants créés, et annoncer ce qui a été ajouté
- Le manifest ne contient que des composants préfixés `DHC_`
- Un seul bloc `<types>` par nom de métadonnée dans le `package.xml`

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
- **`containsKey()` vs valeur null** — `JSON.deserializeUntyped` peut retourner une clé présente avec une valeur `null` (ex. `{"TriggerType":null}`). `map.get('TriggerType')` retourne `null` dans les deux cas : clé absente ET clé présente/null. Utiliser `map.containsKey('TriggerType')` pour distinguer les deux. Un attribut absent du map → Non évaluable ; une valeur null présente → non-match mais pas Non évaluable.
- **Finding en 'Corrigé' ou 'Accepté' = décision humaine** — Ces findings portent une `DHC_Justification__c` saisie par un opérateur. Ne jamais les supprimer lors d'une relance du moteur de règles. Seuls les findings en 'Ouvert' sont purgés pour l'idempotence.
- **'Non évaluable' ≠ 'non conforme'** — Un verdict 'Non évaluable' signifie que la règle n'a pas pu s'appliquer (état absent, attribut manquant, type incompatible). Il est surfacé comme finding mais ne compte JAMAIS dans `Critical_Count` ni `Warning_Count`. Un verdict forcé en 'non conforme' alors que l'évaluation est impossible constitue un faux positif.
- **`apexClassAccesses` dans PermissionSet XML** — Le parseur de l'API Metadata rejette `<apexClassAccesses>` à toutes les positions testées (début, milieu, fin du fichier). Ajouter l'accès Apex à un permission set **uniquement via l'UI Setup** : Setup > Permission Sets > [nom] > Apex Class Access > Edit. Ne jamais tenter de déployer `apexClassAccesses` via XML.
- **`componentInstances` dans FlexiPage XML** — `componentInstances` est refusé avec "not valid in version 66.0 / 68.0" à toutes les positions testées via `sf project deploy`. Le format correct en API v68+ est `<itemInstances><componentInstance><componentName>c:dhcApp</componentName><identifier>…</identifier></componentInstance></itemInstances>` à l'intérieur de `<flexiPageRegions>`. Ce format ne passe pas non plus par SFDX deploy mais fonctionne via `PUT /headless/metadata` (API Metadata directe). Pour déployer programmatiquement : utiliser l'endpoint `/headless/metadata` PUT avec `xmlRep` contenant le bon format `itemInstances`.
- **`FlexiPage — componentInstances` est top-level** — `<componentInstances>` est un enfant direct de `<FlexiPage>`, pas de `<flexiPageRegions>`. Imbriquer `componentInstances` dans `flexiPageRegions` provoque l'erreur "Property 'componentInstances' not valid at this location".
- **`WITH USER_MODE` en SOQL statique** — La clause `WITH USER_MODE` (ou `WITH SECURITY_ENFORCED`) doit apparaître **avant** `ORDER BY` et `LIMIT`. L'ordre correct : `FROM … WHERE … WITH USER_MODE ORDER BY … LIMIT …`. La placer après `LIMIT` provoque une erreur de compilation (`Expecting ']' but was: 'WITH'`).
- **`PermissionSet` — ordre des éléments** — `<apexClassAccesses>` et `<applicationVisibilities>` doivent apparaître **avant** `<fieldPermissions>` et `<objectPermissions>` dans le XML. L'API refuse un fichier où ces éléments sont dans le mauvais ordre. Mettre `apexClassAccesses` / `applicationVisibilities` au début du `<PermissionSet>`, avant `<label>`.
- **FlexiPage — `componentInstances` est top-level** — `<componentInstances>` est un enfant direct de `<FlexiPage>`, pas de `<flexiPageRegions>`. Imbriquer `componentInstances` dans `flexiPageRegions` provoque l'erreur "Property 'componentInstances' not valid at this location".
- **IIFE + Lightning Web Security** — Le bundle React doit être au format IIFE (`lib.formats: ['iife']` dans Vite). `eval` et `new Function` sont interdits par LWS à l'exécution. React doit être bundlé inline (pas de CDN). `inlineDynamicImports: true` est obligatoire car `loadScript` ne supporte pas les modules ES ni les imports dynamiques.
- **`lwc:dom="manual"`** — Obligatoire sur le div conteneur React. Sans cette directive, le moteur LWC écrase le DOM React à chaque re-render du composant wrapper (dès qu'une propriété réactive change).
- **`loadScript` guard dans `renderedCallback`** — `renderedCallback()` est appelé à chaque re-render. L'import du script doit être protégé par un flag booléen (`_scriptLoaded`). Sans ce guard, `loadScript` est appelé en boucle et React est remonté à chaque render.
- **`unmount` dans `disconnectedCallback`** — Appeler `window.DHC_UI.unmount(container)` dans `disconnectedCallback()`. Sans cela, les React roots et event listeners persistent en mémoire après la navigation dans Lightning.
- **Injection de l'API React** — React n'importe jamais `@salesforce/apex`. Le wrapper LWC importe les méthodes Apex, construit un objet `api` contenant des wrappers async, et le passe à `window.DHC_UI.mount(container, api)`. React reçoit cet objet comme prop et ne connaît pas les détails de l'implémentation Apex.
- **CSS dans un bundle IIFE Vite** — Un `import './styles.css'` dans un build lib IIFE extrait le CSS dans un fichier `.css` séparé. `loadScript` ne charge que le `.js` ; le CSS n'est jamais appliqué. Solution : déclarer le CSS comme chaîne de caractères dans un `.js` et l'injecter via `document.createElement('style')` au montage (pattern `injectStyles()`). Ne jamais importer de `.css` dans les sources du bundle.
- **`@AuraEnabled(cacheable=true)` et polling** — Les réponses des méthodes `cacheable=true` sont mises en cache ~30 secondes par la plateforme Lightning, même si les données ont changé. Un polling auto-refresh sur ces méthodes est peu fiable. Privilégier un bouton « Rafraîchir » manuel. Si un auto-refresh est indispensable, le limiter à 10 tentatives maximum (jamais infini).
- **`react-router` interdit dans Lightning** — `react-router` manipule `window.history` et `window.location`, ce qui interfère avec la navigation Lightning Experience. Utiliser une navigation purement par état local React : `const [nav, setNav] = useState({ screen: 'dashboard', params: {} })`. Jamais de `BrowserRouter`, `HashRouter`, ni de `Link` react-router dans un bundle LWC.
- **Custom Metadata Types et mode utilisateur** — Les objets `__mdt` ne supportent ni `WITH USER_MODE`, ni `AccessLevel.USER_MODE`, ni `Security.stripInaccessible`. Ils ne sont pas soumis au CRUD/FLS ; la plateforme rejette ces modificateurs avec "sObject type 'X__mdt' is not supported". Utiliser `AccessLevel.SYSTEM_MODE` ou la SOQL statique sans modificateur de mode pour toutes les requêtes sur `__mdt`.
- **Queueable et profondeur de pile en test** — En contexte de test, un Queueable ne peut enchaîner qu'un seul Queueable. Une chaîne multi-scope casse au deuxième maillon avec "Maximum stack depth has been reached". Pattern correct : `if (!Test.isRunningTest()) { System.enqueueJob(new DHC_Collector(...)); }`. Ne placer ce garde que sur l'enchaînement — aucune autre logique ne doit se comporter différemment en test. Couvrir chaque scope individuellement avec un test dédié qui injecte des données via `@TestVisible`.
- **Tout chemin d'échec async doit clore le déploiement** — Un `Queueable.execute()` ou un `Batchable.finish()` qui plante silencieusement laisse le `DHC_Deployment__c` en "En cours" indéfiniment. Envelopper le corps de `execute()` et de `finish()` dans un try/catch ; en cas d'exception non récupérable, mettre le déploiement à "Échoué" avant de laisser l'exception remonter ou de l'absorber.
- **`useEffect` — retourner le cleanup synchronement** — La fonction de nettoyage (`() => { cancelled = true; }`) doit être retournée **synchronement** par le callback `useEffect`. Ne pas la retourner depuis une `.then()` ou une `async function` interne : React n'utilisera jamais cette valeur de retour différée. Pattern correct : déclarer `let cancelled = false`, lancer une `async function` interne sans `await`, retourner `() => { cancelled = true; }` à la fin du callback synchrone.
- **Collecteur Flow — `ManageableState = 'unmanaged'` volontaire** — `DHC_Collector.queryFlowDefinitions()` filtre sur `ManageableState = 'unmanaged'` pour exclure les flows des packages managés installés, qui sont non modifiables par l'organisation. Une org sans aucun flow non managé retourne zéro composant Flow : c'est le comportement correct, pas un bug. Ne pas supprimer ou assouplir ce filtre.
- **Chaîne séquentielle DHC : Collector → FieldAccessBatch → RuleEngineBatch** — `DHC_AppController.startCapture()` enqueue uniquement `DHC_Collector`. Le Collector, quand `remainingScopes` est vide (dernier maillon), lance `DHC_FieldAccessBatch`. `DHC_FieldAccessBatch.finish()` en mode CURRENT lance `DHC_RuleEngineBatch` ; en mode BASELINE, il met le déploiement à 'Terminé' directement. Chaque enchaînement est gardé par `!Test.isRunningTest()`. Ne jamais lancer `DHC_FieldAccessBatch` en parallèle depuis `startCapture` — c'est le bug originel qui laissait les déploiements 'En cours' indéfiniment.
