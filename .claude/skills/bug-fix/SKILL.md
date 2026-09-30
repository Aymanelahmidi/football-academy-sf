---
name: bug-fix
description: Systematic diagnosis and resolution of bugs in the Football Academy Salesforce app. Use when a runtime error occurs, a test fails, an LWC doesn't load, a deploy fails, or data is not showing as expected.
agents: [main_agent, general_purpose]
---

# Bug Fix Skill — Football Academy SF

## Catégories de Bugs

| Catégorie               | Symptômes                                                           |
|-------------------------|---------------------------------------------------------------------|
| **Governor Limits**     | `System.LimitException`, query timeout, `Too many SOQL queries`    |
| **SOQL / Data**         | Liste vide alors que données existent, `QueryException`            |
| **Sharing / Sécurité**  | Utilisateur ne voit pas ses données, accès refusé inattendu        |
| **LWC Wire**            | Composant ne se charge pas, data `undefined` dans le template      |
| **Apex DML**            | `DmlException`, `Required fields are missing`, duplication         |
| **Déploiement**         | Échec deploy, coverage insuffisante, `Compile Error`               |
| **Intégration GPS/API** | `CalloutException`, timeout, données GPS manquantes                |
| **Tests**               | Test qui passe en local mais échoue en CI, `System.AssertException`|
| **Performance**         | LWC lent, spinner permanent, timeout API                           |

---

## Workflow de Diagnostic

### Étape 1 — Reproduire
1. Identifier le scénario exact (quel utilisateur, quelle action, quel objet)
2. Collecter : message d'erreur exact, stack trace, timestamp
3. Identifier si le bug est reproductible ou intermittent

### Étape 2 — Localiser dans la Stack
```
LWC (HTML/JS)
    └── @wire ou Imperative Call → FA_<Domaine>Controller.cls
            └── Service → FA_<Domaine>Service.cls
                    └── SOQL / DML / Callout
```

### Étape 3 — Diagnostics Spécifiques

#### Bug LWC — Données non affichées
```javascript
// Ajouter des logs temporaires dans le wire handler
@wire(getPlayers, { categoryId: '$selectedCategory' })
wiredPlayers(result) {
    console.log('Wire result:', JSON.stringify(result));  // Debug
    if (result.data) {
        console.log('Data count:', result.data.length);
    } else if (result.error) {
        console.error('Wire error:', JSON.stringify(result.error));
    }
}
```

#### Bug Apex — Données SOQL vides
```apex
// Vérifier en Apex Anonyme (Developer Console / sf apex run)
List<FA_Player__c> test = [
    SELECT Id, Name, Is_Active__c, Category__c
    FROM FA_Player__c
    WHERE Is_Active__c = true
    LIMIT 5
];
System.debug('Players found: ' + test.size());
for (FA_Player__c p : test) {
    System.debug('Player: ' + p.Name + ' | Category: ' + p.Category__c);
}
```

```bash
# Via CLI — query directe sur l'org
sf data query \
  --query "SELECT Id, Name, Is_Active__c, Category__r.Name FROM FA_Player__c WHERE Is_Active__c = true LIMIT 5" \
  --result-format human
```

#### Bug Sharing — Utilisateur ne voit pas ses données
```apex
// Test en Apex Anonyme avec System.runAs
User coach = [SELECT Id FROM User WHERE Username = 'coach@football.test' LIMIT 1];
System.runAs(coach) {
    List<FA_Player__c> visible = [SELECT Id, Name, Category__c FROM FA_Player__c];
    System.debug('Visible to coach: ' + visible.size());
}
```

#### Bug Governor Limits
```bash
# Vérifier les logs Apex pour les limites
sf data query \
  --query "SELECT Id, Status, LastModifiedDate FROM AsyncApexJob ORDER BY LastModifiedDate DESC LIMIT 10" \
  --result-format human

# Dans les logs, chercher :
# "Maximum CPU time exceeded"
# "Too many SOQL queries: 101"
# "Too many DML rows: 10001"
```

#### Bug Déploiement — Compile Error
```bash
# Voir les erreurs de compilation détaillées
sf project deploy validate --source-dir force-app --test-level NoTestRun --json | \
  powershell -Command "& {$input | ConvertFrom-Json | Select-Object -ExpandProperty result | Select-Object -ExpandProperty details | Select-Object -ExpandProperty componentFailures}"
```

#### Bug Tests — Coverage Insuffisante
```bash
# Identifier les classes sous 85%
sf data query \
  --query "SELECT ApexClassOrTrigger.Name, NumLinesCovered, NumLinesUncovered, Coverage FROM ApexCodeCoverageAggregate WHERE ApexClassOrTrigger.Name LIKE 'FA_%' AND Coverage < 0.85" \
  --use-tooling-api --result-format human
```

---

## Corrections Communes

### Fix: Wire ne se déclenche pas (LWC)

**Symptôme :** La méthode `@wire` ne s'appelle jamais, le composant reste vide.

**Cause fréquente :** La propriété réactive est `undefined` au premier render.

```javascript
// ❌ Problème — categoryId peut être undefined au départ
@wire(getPlayers, { categoryId: '$selectedCategory' })

// ✅ Solution 1 — Valeur par défaut
@track selectedCategory = null;  // null est OK, undefined bloque le wire

// ✅ Solution 2 — Permettre null dans le Controller Apex
@AuraEnabled(cacheable=true)
public static List<FA_Player__c> getPlayers(Id categoryId) {
    // categoryId = null → retourne tous les joueurs (pas d'erreur)
    if (categoryId != null) {
        return [SELECT Id FROM FA_Player__c WHERE Category__c = :categoryId AND Is_Active__c = true];
    }
    return [SELECT Id FROM FA_Player__c WHERE Is_Active__c = true];
}
```

### Fix: `refreshApex` ne rafraîchit pas (LWC)

```javascript
// ❌ Problème — wiredResult non stocké
@wire(getPlayers) players;

// ✅ Solution — Stocker le résultat complet du wire
wiredPlayersResult; // Stocker pour refreshApex

@wire(getPlayers, { categoryId: '$selectedCategory' })
wiredPlayers(result) {
    this.wiredPlayersResult = result;  // ← Stocker ici
    if (result.data) this.players = result.data;
}

// Dans le handler de mutation
handleSave() {
    createPlayer({ player: this.playerData })
        .then(() => refreshApex(this.wiredPlayersResult));  // ← Utiliser ici
}
```

### Fix: SOQL injection dans les queries dynamiques

```apex
// ❌ Vulnérabilité
String query = 'SELECT Id FROM FA_Player__c WHERE Last_Name__c = \'' + searchTerm + '\'';

// ✅ Fix
String safeTerm = String.escapeSingleQuotes(searchTerm);
String query = 'SELECT Id FROM FA_Player__c WHERE Last_Name__c = \'' + safeTerm + '\'';
// OU mieux, utiliser bind variable (pas de query dynamique nécessaire ici)
List<FA_Player__c> players = [SELECT Id FROM FA_Player__c WHERE Last_Name__c = :searchTerm];
```

### Fix: Test qui échoue à cause de DML mixed (Insert + Future)

```apex
// ❌ Erreur : "You have uncommitted work pending"
Test.startTest();
insert player;
FA_PlayerService.syncGpsDataAsync(player.Id); // @future callout
Test.stopTest();

// ✅ Fix : @future s'exécute après stopTest()
Test.startTest();
insert player;
// @future callout sera exécuté dans Test.stopTest()
Test.stopTest();
// Vérifier les résultats après stopTest
```

---

## Format de Rapport de Bug

```
## Bug Report

**Catégorie:** [Governor Limits / Sharing / LWC Wire / DML / Déploiement / ...]
**Composant:** [FA_PlayerService / faPlayerList / ...]
**Cause racine:** [Une phrase]

## Fix

[Fichier et lignes modifiés]
[Code corrigé]

## Test de Vérification

[Commande ou méthode de test]
[Résultat attendu après fix]

## Checklist Post-Fix
- [ ] Tests locaux passent
- [ ] Couverture maintenue >= 85%
- [ ] Pas de régression sur les fonctionnalités liées
- [ ] Validate deploy réussit
```
