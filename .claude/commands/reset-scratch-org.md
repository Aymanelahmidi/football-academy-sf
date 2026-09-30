---
name: reset-scratch-org
description: Use when the scratch org is broken, data is corrupted, you need a fresh environment, or after pulling major schema changes. Provides commands for full scratch org reset, partial data reset, and post-reset verification.
---

# Command: Reset Environnement / Scratch Org

## Reset Complet (supprimer + recréer la scratch org)
```bash
# 1. Supprimer la scratch org actuelle
sf org delete scratch --no-prompt

# 2. Créer une nouvelle scratch org (30 jours)
sf org create scratch \
  --definition-file config/project-scratch-def.json \
  --alias football-academy-dev \
  --duration-days 30 \
  --set-default

# 3. Déployer tout le projet
sf project deploy start --source-dir force-app

# 4. Assigner le Permission Set principal
sf org assign permset --name FA_Academy_Admin

# 5. Charger les données de test
sf data import tree --plan data/sample-data-plan.json
```

## Reset Partiel — Données Seulement
```bash
# Supprimer toutes les données FA_ (en gardant la config)
sf data delete bulk \
  --object FA_Player__c \
  --where "Is_Active__c = true OR Is_Active__c = false" \
  --async

sf data delete bulk --object FA_Training_Session__c --where "Id != null" --async
sf data delete bulk --object FA_Match__c --where "Id != null" --async

# Recharger les données de démo
sf data import tree --plan data/sample-data-plan.json
```

## Ouvrir l'Org dans le Navigateur
```bash
# Ouvrir l'org par défaut
sf org open

# Ouvrir sur une page spécifique
sf org open --path /lightning/n/Football_Academy

# Ouvrir Setup
sf org open --path /lightning/setup/home
```

## Vérification Post-Reset
```bash
echo "=== Statut de l'org ==="
sf org display

echo ""
echo "=== Composants déployés ==="
sf data query \
  --query "SELECT DeveloperName, ApiVersion FROM ApexClass WHERE NamespacePrefix = null AND Name LIKE 'FA_%'" \
  --result-format human

echo ""
echo "=== Tests Apex ==="
sf apex run test --test-level RunLocalTests --result-format human

echo ""
echo "=== Données de démo ==="
sf data query --query "SELECT COUNT() FROM FA_Player__c" --result-format human
sf data query --query "SELECT COUNT() FROM FA_Training_Session__c" --result-format human
sf data query --query "SELECT COUNT() FROM FA_Match__c" --result-format human
```

## Données de Test Post-Reset (Apex anonyme)
```bash
# Créer des données de test via Apex anonyme
sf apex run --file scripts/apex/create-demo-data.apex

# Vérifier un joueur créé
sf data query \
  --query "SELECT Id, Name, First_Name__c, Last_Name__c, Category__r.Name, Position__c FROM FA_Player__c LIMIT 5" \
  --result-format human
```

## Liste des Orgs Disponibles
```bash
sf org list --all
```

## Changer d'Org par Défaut
```bash
sf config set target-org <alias-ou-username>
```
