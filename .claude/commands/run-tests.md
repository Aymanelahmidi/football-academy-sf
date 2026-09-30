---
name: run-tests
description: Use when running Apex tests, checking code coverage, verifying that all tests pass before a deploy, or testing a specific service. Provides all sf CLI commands for unit tests, coverage reports, and CI simulation.
---

# Command: Run Tests Apex

## Tous les Tests Locaux
```bash
# Lancer tous les tests locaux
sf apex run test --test-level RunLocalTests --output-dir .sfdx/tools/testresults

# Avec format lisible
sf apex run test \
  --test-level RunLocalTests \
  --output-dir .sfdx/tools/testresults \
  --result-format human

# Format JSON (pour CI/CD)
sf apex run test \
  --test-level RunLocalTests \
  --output-dir .sfdx/tools/testresults \
  --result-format json
```

## Tests par Classe
```bash
# FA_ServiceTest (classe principale)
sf apex run test --class-names FA_ServiceTest --result-format human

# Plusieurs classes
sf apex run test \
  --class-names FA_ServiceTest,FA_PlayerTest,FA_TrainingTest \
  --result-format human
```

## Tests par Méthode Spécifique
```bash
# Une méthode précise
sf apex run test \
  --tests FA_ServiceTest.testGetPlayers \
  --result-format human

# Plusieurs méthodes
sf apex run test \
  --tests FA_ServiceTest.testGetPlayers,FA_ServiceTest.testCreatePlayer \
  --result-format human
```

## Rapport de Couverture
```bash
# Rapport coverage détaillé par classe
sf apex run test \
  --test-level RunLocalTests \
  --code-coverage \
  --result-format human \
  --output-dir .sfdx/tools/testresults

# Vérifier la couverture d'une classe spécifique
sf data query \
  --query "SELECT ApexClassOrTrigger.Name, NumLinesCovered, NumLinesUncovered, Coverage FROM ApexCodeCoverageAggregate WHERE ApexClassOrTrigger.Name = 'FA_PlayerService'" \
  --use-tooling-api
```

## Simulation CI Locale (avant push)
```bash
# Ce que fait le pipeline CI exactement
sf project deploy validate \
  --source-dir force-app \
  --test-level RunLocalTests \
  --json
```

## Résultats Attendus

| Classe de Test       | Méthodes | Statut     |
|----------------------|----------|------------|
| FA_ServiceTest       | 10+      | PASS       |
| (à créer) FA_PlayerControllerTest | 5+ | PASS |
| (à créer) FA_MatchControllerTest  | 5+ | PASS |

## Logs de Test (Format Attendu)
```
=== Test Summary
Outcome:       Passed
Tests Ran:     15
Pass Rate:     100%
Test Run Id:   707...
```

## Couverture Minimale par Classe

| Domaine           | Couverture Cible |
|-------------------|-----------------|
| Services          | >= 85%          |
| Controllers       | >= 85%          |
| Intégrations      | >= 75%          |
| **Global**        | **>= 85%**      |

## Analyse Rapide des Tests Échoués
```bash
# Voir les erreurs de test dans .sfdx/tools/testresults
powershell -Command "Get-Content .sfdx/tools/testresults/*.json | ConvertFrom-Json | Select-Object -ExpandProperty tests | Where-Object { $_.outcome -eq 'Fail' }"
```
