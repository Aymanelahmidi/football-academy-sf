---
name: salesforce-security
description: Apply when implementing or reviewing security in the Football Academy app. Covers with sharing, FLS, CRUD, Permission Sets, OWD, Sharing Rules, RGPD compliance for minor players, medical data protection, and security testing.
---

# Skill: Sécurité Salesforce — Football Academy SF

## Stack Sécurité du Projet

- **Sharing Model :** with sharing sur toutes les classes
- **Accès Record :** OWD Private + Sharing Rules par catégorie
- **Accès Champ :** Field-Level Security via Permission Sets
- **Données Sensibles :** Mineurs (<18 ans) + Données médicales
- **Audit :** FA_Medical_Access_Log__c pour accès données santé

---

## Règle #1 — with sharing OBLIGATOIRE

```apex
// ✅ TOUTES les classes utilisent with sharing
public with sharing class FA_PlayerService { ... }
public with sharing class FA_MedicalService { ... }
public with sharing class FA_PlayerController { ... }

// ⚠️ without sharing seulement si absolument justifié (Batch système, pas d'accès user direct)
public without sharing class FA_SystemCleanupBatch implements Database.Batchable<SObject> {
    // JUSTIFICATION: Nettoyage système nocturne, pas d'exposition utilisateur
}
```

## Règle #2 — Protection des Données Médicales (CRITIQUE)

```apex
// Tout accès aux données médicales doit être logué
public with sharing class FA_MedicalService {

    public static FA_Medical_Record__c getMedicalRecord(Id recordId) {
        // 1. Vérifier l'accès (Permission Set FA_Medical_Access)
        if (!FeatureManagement.checkPermission('FA_Medical_Access')) {
            throw new SecurityException('Accès aux données médicales non autorisé.');
        }

        // 2. Logger l'accès
        FA_Medical_Access_Log__c log = new FA_Medical_Access_Log__c(
            Player__c = [SELECT Player__c FROM FA_Medical_Record__c WHERE Id = :recordId].Player__c,
            Access_Type__c = 'READ',
            Accessed_By__c = UserInfo.getUserId(),
            Access_Date__c = DateTime.now(),
            Record_Id__c = recordId
        );
        insert log;

        // 3. Retourner les données
        return [SELECT Id, Medical_History__c, Allergies__c, Blood_Type__c
                FROM FA_Medical_Record__c WHERE Id = :recordId LIMIT 1];
    }
}
```

## Règle #3 — Protection des Mineurs (RGPD)

```apex
// Vérifier si un joueur est mineur
public static Boolean isMinor(FA_Player__c player) {
    if (player.Date_of_Birth__c == null) return false;
    return player.Date_of_Birth__c.addYears(18) > Date.today();
}

// Restreindre l'accès aux coordonnées des mineurs
public static Map<String, Object> getPlayerContact(Id playerId) {
    FA_Player__c player = [SELECT Id, Date_of_Birth__c, Email__c, Phone__c,
                                   Parent_Name__c, Parent_Phone__c
                           FROM FA_Player__c WHERE Id = :playerId LIMIT 1];

    if (isMinor(player)) {
        // Retourner les coordonnées du tuteur, pas du joueur
        return new Map<String, Object>{
            'contactType' => 'guardian',
            'name' => player.Parent_Name__c,
            'phone' => player.Parent_Phone__c,
            'email' => null // Email direct du mineur masqué
        };
    }

    return new Map<String, Object>{
        'contactType' => 'player',
        'name' => player.Name,
        'phone' => player.Phone__c,
        'email' => player.Email__c
    };
}
```

## Règle #4 — FLS (Field-Level Security)

```apex
// Toujours vérifier FLS avant d'accéder à un champ (surtout si sans sharing)
// Schema describe pour vérifier la lisibilité
public static Boolean isFieldReadable(String objectName, String fieldName) {
    Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectName);
    Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
    Schema.DescribeFieldResult fieldDescribe = objDescribe.fields.getMap().get(fieldName).getDescribe();
    return fieldDescribe.isAccessible();
}

// OU utiliser Security.stripInaccessible (API 48.0+)
List<FA_Player__c> players = [SELECT Id, First_Name__c, Phone__c, Email__c FROM FA_Player__c];
SObjectAccessDecision decision = Security.stripInaccessible(AccessType.READABLE, players);
List<FA_Player__c> safeList = (List<FA_Player__c>) decision.getRecords();
```

## Architecture des Permissions

### Permission Sets (Recommandés)

```
FA_Academy_Admin          → Accès complet (directeur académie)
FA_Coach_Full             → Joueurs + Entraînements + Matchs de sa catégorie
FA_Medical_Staff          → + Données médicales toutes catégories
FA_Physical_Coach         → + Performance + GPS
FA_Video_Analyst          → + Vidéo + Annotations
FA_Finance_Manager        → + Transactions + Contrats
FA_Parent_Access          → Profil enfant uniquement (Experience Cloud)
```

### OWD Recommandés

```
FA_Player__c              → Private
FA_Medical_Record__c      → Private
FA_Injury__c              → Private
FA_GPS_Data__c            → Private
FA_Transaction__c         → Private
FA_Contract__c            → Private
FA_Training_Session__c    → Public Read Only (coachs voient tous les entraînements)
FA_Match__c               → Public Read Only
FA_Video_Analysis__c      → Private
FA_Document__c            → Private
FA_Evaluation__c          → Private
FA_Academy_Setting__c     → Public Read Only
```

### Sharing Rules (Critiques)

```
Règle 1 : Coachs voient les joueurs de leur catégorie
  → Critère : FA_Player__c.Category__c = [Catégorie du coach dans FA_Staff_Profile__c]
  → Accès : Read/Write

Règle 2 : Médecins voient tous les joueurs (pour urgences)
  → Critère : User has Permission Set FA_Medical_Staff
  → Accès : Read Only

Règle 3 : Admin voit tout
  → Via Permission Set FA_Academy_Admin
```

## Tests de Sécurité

```apex
@isTest
public class FA_SecurityTest {

    @isTest
    static void testCoachCannotSeeOtherCategoryPlayers() {
        // Créer 2 catégories + 2 coachs
        User coach1 = FA_TestDataFactory.createCoachUser('U11');
        User coach2 = FA_TestDataFactory.createCoachUser('U13');
        FA_Player__c playerU11 = FA_TestDataFactory.createPlayer('U11');

        System.runAs(coach2) {
            // Coach U13 ne doit PAS voir les joueurs U11
            List<FA_Player__c> visible = [SELECT Id FROM FA_Player__c WHERE Id = :playerU11.Id];
            System.assertEquals(0, visible.size(), 'Coach U13 ne doit pas voir les joueurs U11');
        }
    }

    @isTest
    static void testMedicalDataRequiresPermission() {
        User coachUser = FA_TestDataFactory.createCoachUser('U11'); // Pas de FA_Medical_Access
        FA_Medical_Record__c medRecord = FA_TestDataFactory.createMedicalRecord(playerU11.Id);

        System.runAs(coachUser) {
            try {
                FA_MedicalService.getMedicalRecord(medRecord.Id);
                System.assert(false, 'Doit lever une exception de sécurité');
            } catch (SecurityException e) {
                System.assert(true, 'Exception sécurité correctement levée');
            }
        }
    }

    @isTest
    static void testMinorContactDataMasked() {
        FA_Player__c minor = FA_TestDataFactory.createMinorPlayer(); // DOB = 10 ans

        Map<String, Object> contact = FA_PlayerService.getPlayerContact(minor.Id);

        System.assertEquals('guardian', contact.get('contactType'), 'Mineur → coordonnées tuteur');
        System.assertEquals(null, contact.get('email'), 'Email mineur masqué');
    }
}
```

## Checklist Sécurité Pré-Déploiement

- [ ] Toutes les classes `with sharing`
- [ ] Aucune donnée médicale sans log dans `FA_Medical_Access_Log__c`
- [ ] Contacts des joueurs mineurs masqués (redirection vers tuteurs)
- [ ] `Security.stripInaccessible` utilisé si données multi-profil
- [ ] Permission Sets créés et assignés pour tous les nouveaux objets/champs
- [ ] Tests `System.runAs()` pour chaque profil utilisateur
- [ ] OWD Private sur les objets sensibles (Médical, Finance, Documents)
- [ ] Aucun ID utilisateur ou données perso en `System.debug`
