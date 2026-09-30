---
name: deploy-org
description: Use when deploying metadata to the Salesforce org, validating before a release, or pushing a quick change. Provides commands for full deploy, validation-only, targeted deploy by component type, and post-deploy checks.
---

# Command: Déployer vers l'Org Salesforce

## Déploiement Standard (force-app complet)
```bash
# Déployer tout le projet
sf project deploy start --source-dir force-app

# Déployer avec exécution des tests locaux
sf project deploy start --source-dir force-app --test-level RunLocalTests

# Déployer avec tous les tests (Production)
sf project deploy start --source-dir force-app --test-level RunAllTestsInOrg
```

## Validation Seule (sans modifier l'org)
```bash
# Check-only — idéal avant release en Production
sf project deploy validate \
  --source-dir force-app \
  --test-level RunLocalTests

# Récupérer le Job ID pour suivre la validation
sf project deploy resume --job-id <JOB_ID>
```

## Déploiement Ciblé (composant spécifique)
```bash
# Une seule classe Apex
sf project deploy start \
  --metadata ApexClass:FA_PlayerService

# Un LWC
sf project deploy start \
  --metadata LightningComponentBundle:faPlayerList

# Un objet custom + ses champs
sf project deploy start \
  --metadata CustomObject:FA_Player__c

# Plusieurs types
sf project deploy start \
  --metadata ApexClass:FA_PlayerService,ApexClass:FA_PlayerController,LightningComponentBundle:faPlayerList
```

## Récupérer depuis l'Org (retrieve)
```bash
# Récupérer tout force-app
sf project retrieve start --source-dir force-app

# Récupérer un composant spécifique
sf project retrieve start --metadata ApexClass:FA_PlayerService

# Récupérer via manifest
sf project retrieve start --manifest manifest/package.xml
```

## Vérification Post-Déploiement
```bash
# Vérifier le statut du dernier déploiement
sf project deploy report

# Lancer les tests Apex après déploiement
sf apex run test \
  --test-level RunLocalTests \
  --output-dir .sfdx/tools/testresults \
  --result-format human

# Vérifier l'état de l'org
sf org display
```

## Résultats Attendus

| Classe / Module        | Tests | Coverage |
|------------------------|-------|----------|
| FA_PlayerService       | ✅    | >= 85%   |
| FA_TrainingService     | ✅    | >= 85%   |
| FA_MatchService        | ✅    | >= 85%   |
| FA_MedicalService      | ✅    | >= 85%   |
| FA_PerformanceService  | ✅    | >= 85%   |
| FA_EvaluationService   | ✅    | >= 85%   |
| FA_VideoService        | ✅    | >= 85%   |
| **Couverture totale**  |       | **>= 85%** |

## Dépannage Déploiement

```bash
# Voir les erreurs détaillées
sf project deploy report --json | jq '.result.details.componentFailures'

# Annuler un déploiement en cours
sf project deploy cancel --job-id <JOB_ID>

# Forcer le déploiement malgré les conflits
sf project deploy start --source-dir force-app --ignore-conflicts
```
