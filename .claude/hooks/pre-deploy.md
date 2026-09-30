---
name: pre-deploy
description: Run before every deploy to the org (especially Production). Use when the user is about to deploy, asks for a deploy checklist, or wants to verify code quality before pushing. Checks coverage, SOQL safety, sharing rules, and LWC validity.
---

# Hook: Pre-Deploy Checklist

Vérifier cette liste avant tout déploiement vers l'org (surtout Production).

## Qualité Apex
- [ ] Toutes les classes sont `with sharing` (pas de classes sans déclaration)
- [ ] Aucun SOQL dans les boucles `for`
- [ ] `String.escapeSingleQuotes()` appliqué à toutes les variables dans les queries dynamiques
- [ ] Pas de `System.debug` laissé dans du code critique
- [ ] Méthodes `@AuraEnabled` de lecture ont `cacheable=true`

## Tests & Couverture
- [ ] `sf apex run test --test-level RunLocalTests` passe à 100%
- [ ] Couverture globale >= 85% sur toutes les classes FA_
- [ ] Nouveaux services ont leurs tests correspondants
- [ ] `FA_TestDataFactory` utilisé (pas de données hardcodées dans les tests)

## SOQL & Governor Limits
- [ ] Pas de requête SELECT sans LIMIT si objet peut dépasser 50k records
- [ ] Pas de DML dans les boucles
- [ ] Queries en bulk (listes) plutôt qu'itératives
- [ ] Callouts REST (GPS, Vidéo) dans des méthodes `@future` ou Queueable

## Sécurité
- [ ] Permission Sets mis à jour pour les nouveaux objets / champs
- [ ] Aucune donnée médicale exposée sans vérification d'accès (`FA_Medical_Access_Log__c`)
- [ ] Données joueurs mineurs protégées (tuteurs légaux uniquement)
- [ ] Champs sensibles (téléphone, email, date de naissance) avec FLS respecté

## LWC
- [ ] Validation `sf project deploy validate` passe sans erreur
- [ ] Gestion des erreurs dans chaque composant (catch + toast lightning)
- [ ] Pas d'appels Apex redondants (utiliser `@wire` pour les lectures)

## Métadonnées
- [ ] `package.xml` à jour avec les nouveaux composants
- [ ] Les nouveaux Custom Objects ont leurs Labels (EN + FR)
- [ ] Les nouveaux champs sont dans le Permission Set `FA_Academy_Admin`
- [ ] FlexiPages mises à jour si nouveau composant à afficher

## Commandes de Vérification Finale
```bash
# 1. Valider le déploiement (check-only)
sf project deploy validate --source-dir force-app --test-level RunLocalTests

# 2. Lancer les tests
sf apex run test --test-level RunLocalTests --result-format human

# 3. Vérifier la couverture
sf data query \
  --query "SELECT ApexClassOrTrigger.Name, NumLinesCovered, NumLinesUncovered FROM ApexCodeCoverageAggregate WHERE ApexClassOrTrigger.Name LIKE 'FA_%'" \
  --use-tooling-api --result-format human

# 4. Scanner qualité (si disponible)
sf scanner run --target force-app/main/default/classes --format table --severity-threshold 2
```
