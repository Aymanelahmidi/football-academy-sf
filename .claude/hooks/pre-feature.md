---
name: pre-feature
description: Run before starting any new feature, module, or LWC component. Use when the user is about to implement a new story or ticket. Guides through data model, security, API design, governor limits, and test strategy before writing any code.
---

# Hook: Pre-Feature Checklist

Répondre à ces questions avant de commencer à coder une nouvelle feature Football Academy.

## Comprendre le Contexte Fonctionnel
- [ ] La user story / ticket est lue en entier
- [ ] Le domaine fonctionnel est identifié (Joueur / Entraînement / Match / Médical / Performance / Finance / Document)
- [ ] Les utilisateurs cibles sont identifiés (Coach / Médecin / Admin / Parent / Joueur)
- [ ] Les règles métier football spécifiques sont claires

## Questions Modèle de Données
- Un nouveau Custom Object est-il nécessaire ?
- Si oui : préfixe `FA_`, relation avec `FA_Category__c` (par catégorie d'âge) ?
- Des champs existants sur `FA_Player__c` suffisent-ils ?
- Y a-t-il des contraintes sur les données mineurs (RGPD, accès tuteur) ?

## Questions Sécurité & Partage
- Quel profil/rôle accède à cette feature ? (Coach / Admin / Médecin / Parent)
- Le Permission Set `FA_Academy_Admin` doit-il être mis à jour ?
- Les données médicales nécessitent-elles un log dans `FA_Medical_Access_Log__c` ?
- `with sharing` est-il suffisant ou faut-il `without sharing` justifié ?

## Questions Apex
- Un nouveau Service est-il nécessaire, ou peut-on étendre un service existant ?
- Y a-t-il des risques Governor Limits (SOQL, DML, callouts) ?
- Des intégrations externes sont-elles impliquées (GPS, vidéo) ?
- Des opérations asynchrones sont-elles nécessaires (`@future`, Queueable, Batch) ?

## Questions LWC
- Quel composant existant peut être réutilisé ou étendu ?
- Le composant est-il placé sur une page Record, App ou Home ?
- Y a-t-il des données temps réel à afficher (nécessite Streaming / Platform Events) ?

## Questions Tests
- Quels sont les cas nominaux à tester ?
- Quels sont les cas d'erreur (joueur inexistant, catégorie vide, champ obligatoire) ?
- Faut-il des données de test spécifiques dans `FA_TestDataFactory` ?

## Structure Minimum pour un Nouveau Domaine

```
force-app/main/default/
├── classes/
│   ├── FA_<Domaine>Service.cls         ← Logique métier (with sharing)
│   ├── FA_<Domaine>Service.cls-meta.xml
│   ├── FA_<Domaine>Controller.cls      ← @AuraEnabled pour LWC
│   ├── FA_<Domaine>Controller.cls-meta.xml
│   ├── FA_<Domaine>Test.cls            ← Tests (>= 85% coverage)
│   └── FA_<Domaine>Test.cls-meta.xml
├── lwc/
│   └── fa<Domaine>/
│       ├── fa<Domaine>.html
│       ├── fa<Domaine>.js
│       ├── fa<Domaine>.css
│       └── fa<Domaine>.js-meta.xml
└── objects/
    └── FA_<Entity>__c/
        ├── FA_<Entity>__c.object-meta.xml
        └── fields/
            └── *.field-meta.xml
```

## Checklist Feature Complète
- [ ] Custom Object créé (si besoin) avec préfixe `FA_`
- [ ] Service Apex créé avec méthodes CRUD + stats
- [ ] Controller LWC créé (`@AuraEnabled`)
- [ ] Composant LWC créé (html + js + css + meta)
- [ ] Tests Apex créés (>= 85% coverage)
- [ ] `FA_TestDataFactory` mis à jour
- [ ] Permission Set `FA_Academy_Admin` mis à jour
- [ ] `package.xml` mis à jour
- [ ] Validation `sf project deploy validate` passe
- [ ] Tous les tests passent

## Vérifications Avant de Commencer
- [ ] Lire les objets existants pour éviter les doublons
- [ ] Identifier si une liste de valeurs (picklist) est partagée avec d'autres objets
- [ ] Vérifier les relations existantes dans le modèle de données
