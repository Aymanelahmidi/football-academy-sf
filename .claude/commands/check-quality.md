---
name: check-quality
description: Use when auditing code quality, checking Apex best practices, detecting SOQL in loops, verifying sharing rules, checking LWC accessibility, or reviewing governor limit risks. Run before any PR or release.
---

# Command: Audit Qualité Code

## 1. Détection SOQL dans les Boucles (CRITIQUE)
```bash
# Chercher des patterns SOQL dans des boucles for
grep -rn "for (" force-app/main/default/classes/ --include="*.cls" -A5 | grep -B3 "SELECT\|Database\.query"

# Plus précis avec powershell
powershell -Command "
  Get-Content force-app/main/default/classes/*.cls |
  Select-String -Pattern 'for \(.*\)' -Context 0,5 |
  Select-String 'SELECT|Database\.query'
"
```

## 2. Vérification `with sharing` sur toutes les classes
```bash
# Toute classe doit avoir 'with sharing' (sécurité record-level)
grep -rn "^public class\|^public virtual class\|^public abstract class" \
  force-app/main/default/classes/ --include="*.cls" | grep -v "with sharing\|without sharing\|inherited sharing"
```

## 3. Vérification @AuraEnabled sans cacheable
```bash
# Méthodes @AuraEnabled non cacheable (lectures sans cacheable=true)
grep -rn "@AuraEnabled" force-app/main/default/classes/ --include="*.cls" -A1 | grep -v "cacheable=true\|--"
```

## 4. Détection String.escapeSingleQuotes manquant (SOQL Injection)
```bash
# Requêtes dynamiques sans échappement
grep -rn "Database\.query\|query +=" force-app/main/default/classes/ --include="*.cls" -B2 | grep -v "escapeSingleQuotes\|--"
```

## 5. Vérification Coverage (après déploiement)
```bash
# Coverage de toutes les classes FA_
sf data query \
  --query "SELECT ApexClassOrTrigger.Name, NumLinesCovered, NumLinesUncovered, Coverage FROM ApexCodeCoverageAggregate WHERE ApexClassOrTrigger.Name LIKE 'FA_%' ORDER BY Coverage ASC" \
  --use-tooling-api \
  --result-format human
```

## 6. Audit des Permissions Sets
```bash
# Lister tous les permission sets FA
sf data query \
  --query "SELECT Name, Label, Description FROM PermissionSet WHERE NamespacePrefix = null AND Name LIKE 'FA_%'" \
  --result-format human
```

## 7. Analyse des Custom Objects (champs obligatoires)
```bash
# Lister les objets FA_ et leurs champs requis
sf data query \
  --query "SELECT QualifiedApiName, Label FROM EntityDefinition WHERE QualifiedApiName LIKE 'FA_%'" \
  --use-tooling-api \
  --result-format human
```

## 8. Vérification LWC — erreurs de compilation
```bash
# Via IDE diagnostics (si disponible)
# Ou via déploiement validate
sf project deploy validate --source-dir force-app/main/default/lwc --test-level NoTestRun
```

## 9. Analyse Code Salesforce Scanner
```bash
# Si sf-code-analyzer est installé
sf scanner run \
  --target force-app/main/default/classes \
  --format table \
  --category "Best Practices,Security,Performance"

# Règles critiques seulement
sf scanner run \
  --target force-app/main/default/classes \
  --format table \
  --severity-threshold 2
```

---

## Checklist Qualité Manuelle

### Apex
- [ ] Toutes les classes sont `with sharing`
- [ ] Aucun SOQL dans les boucles
- [ ] `String.escapeSingleQuotes()` sur toutes les queries dynamiques
- [ ] Pas de `System.debug` en production (ou limité)
- [ ] Méthodes > 50 lignes → refactoriser
- [ ] `@AuraEnabled` avec `cacheable=true` sur toutes les lectures

### SOQL
- [ ] Sélectionner uniquement les champs nécessaires (pas `SELECT *`)
- [ ] Limites explicites (`LIMIT`) sur les queries volumineuses
- [ ] Index sur les champs filtrés fréquemment (`Category__c`, `Is_Active__c`)
- [ ] Pas de filtres non-sélectifs sur des objets > 100k records

### LWC
- [ ] Pas d'appels Apex dans `connectedCallback` sans `@wire`
- [ ] Gestion des erreurs (catch + affichage toast)
- [ ] Labels externalisés pour l'internationalisation
- [ ] Accessibilité : `aria-label` sur les éléments interactifs

### Sécurité
- [ ] Pas de données sensibles en `System.debug`
- [ ] `CRUD/FLS` respecté (utiliser `with sharing`)
- [ ] Permission Sets définis pour chaque rôle utilisateur
