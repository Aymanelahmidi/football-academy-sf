---
name: new-apex-service
description: Use when creating a new Apex module for a new domain in the Football Academy project. Generates all 5 layers of the enterprise architecture (EM Selector + DM Domain + SM Service + TH TriggerHandler + Trigger + LC Controller + Tests). Replace OBJECT and DOMAIN with actual values.
---

# Plugin: Nouveau Module Apex — Football Academy Enterprise Architecture

## Usage
Remplacer :
- `OBJECT` → nom de l'objet Salesforce sans `FA_` et `__c` (ex: `Player`, `Match`, `Training`)
- `DOMAIN` → même valeur, utilisée dans les noms de classe
- `FA_OBJECT__c` → nom complet de l'objet (ex: `FA_Player__c`)

Générer les 7 fichiers suivants dans l'ordre.

---

## 1. [EM] Selector — `FA_OBJECTSelector.cls`

```apex
/**
 * @description [EM] Entity Manager — Data access layer for FA_OBJECT__c.
 * All SOQL queries for this domain are encapsulated here.
 * Uses AccessLevel.USER_MODE to enforce FLS automatically.
 * @author Football Academy
 * @date 2026
 */
public with sharing class FA_OBJECTSelector {

    /**
     * @description Get a single record by Id
     */
    public static FA_OBJECT__c getById(Id recordId) {
        List<SObject> results = Database.queryWithBinds(
            'SELECT Id, Name, Field1__c, Field2__c, Category__c, Category__r.Short_Name__c, ' +
            'CreatedDate, LastModifiedDate ' +
            'FROM FA_OBJECT__c WHERE Id = :recordId LIMIT 1',
            new Map<String, Object>{ 'recordId' => recordId },
            AccessLevel.USER_MODE
        );
        if (results.isEmpty()) throw new AuraHandledException('Enregistrement introuvable.');
        return (FA_OBJECT__c) results[0];
    }

    /**
     * @description Get records with optional filters
     */
    public static List<FA_OBJECT__c> getByFilters(Id categoryId, String status) {
        List<String> conditions = new List<String>{ 'Is_Active__c = true' };
        Map<String, Object> binds = new Map<String, Object>();
        if (categoryId != null) {
            conditions.add('Category__c = :categoryId');
            binds.put('categoryId', categoryId);
        }
        if (String.isNotBlank(status)) {
            conditions.add('Status__c = :status');
            binds.put('status', status);
        }
        String query = 'SELECT Id, Name, Field1__c, Field2__c, Category__c, ' +
                       'Category__r.Short_Name__c, Status__c ' +
                       'FROM FA_OBJECT__c WHERE ' + String.join(conditions, ' AND ') +
                       ' ORDER BY Name ASC LIMIT 200';
        return (List<FA_OBJECT__c>) Database.queryWithBinds(query, binds, AccessLevel.USER_MODE);
    }

    /**
     * @description Get aggregate statistics
     */
    public static Map<String, Object> getStats() {
        Map<String, Object> stats = new Map<String, Object>();
        stats.put('total', [SELECT COUNT() FROM FA_OBJECT__c WHERE Is_Active__c = true]);
        for (AggregateResult ar : [
            SELECT Category__r.Short_Name__c cat, COUNT(Id) cnt
            FROM FA_OBJECT__c WHERE Is_Active__c = true
            GROUP BY Category__r.Short_Name__c
        ]) {
            stats.put((String) ar.get('cat'), (Integer) ar.get('cnt'));
        }
        return stats;
    }
}
```

**Fichier méta (`FA_OBJECTSelector.cls-meta.xml`) :**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<ApexClass xmlns="http://soap.sforce.com/2006/04/metadata">
    <apiVersion>66.0</apiVersion>
    <status>Active</status>
</ApexClass>
```

---

## 2. [DM] Domain — `FA_OBJECTDomain.cls`

```apex
/**
 * @description [DM] Domain Model — Business rules and validation for FA_OBJECT__c.
 * No SOQL. No DML. Returns modified collections for the Service to persist.
 * @author Football Academy
 * @date 2026
 */
public with sharing class FA_OBJECTDomain {

    /**
     * @description Validate records before insert/update
     */
    public static void validate(List<FA_OBJECT__c> records) {
        for (FA_OBJECT__c r : records) {
            if (String.isBlank(r.Name)) {
                r.addError('Le nom est obligatoire.');
            }
            // Ajouter les règles métier spécifiques ici
        }
    }

    /**
     * @description Set default values before insert
     */
    public static void setDefaults(List<FA_OBJECT__c> records) {
        for (FA_OBJECT__c r : records) {
            if (r.Is_Active__c == null) r.Is_Active__c = true;
            // Ajouter les valeurs par défaut spécifiques ici
        }
    }

    /**
     * @description Prepare records for status update (returns list, SM does DML)
     */
    public static List<FA_OBJECT__c> buildStatusUpdate(Set<Id> recordIds, String newStatus) {
        List<FA_OBJECT__c> toUpdate = new List<FA_OBJECT__c>();
        for (Id rid : recordIds) {
            toUpdate.add(new FA_OBJECT__c(Id = rid, Status__c = newStatus));
        }
        return toUpdate;
    }
}
```

**Fichier méta (`FA_OBJECTDomain.cls-meta.xml`) :**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<ApexClass xmlns="http://soap.sforce.com/2006/04/metadata">
    <apiVersion>66.0</apiVersion>
    <status>Active</status>
</ApexClass>
```

---

## 3. [SM] Service — `FA_OBJECTService.cls`

```apex
/**
 * @description [SM] Service Manager — Orchestration layer for FA_OBJECT__c.
 * Only layer authorized to perform DML. Delegates reads to Selector, rules to Domain.
 * @author Football Academy
 * @date 2026
 */
public with sharing class FA_OBJECTService {

    // ─── Reads (delegate to Selector) ────────────────────────────────────

    public static List<FA_OBJECT__c> getOBJECTs(Id categoryId, String status) {
        return FA_OBJECTSelector.getByFilters(categoryId, status);
    }

    public static FA_OBJECT__c getOBJECTById(Id recordId) {
        return FA_OBJECTSelector.getById(recordId);
    }

    public static Map<String, Object> getOBJECTStats() {
        return FA_OBJECTSelector.getStats();
    }

    // ─── Writes (Domain validates, Service does DML) ──────────────────────

    public static FA_OBJECT__c createOBJECT(FA_OBJECT__c record) {
        FA_OBJECTDomain.setDefaults(new List<FA_OBJECT__c>{ record });
        FA_OBJECTDomain.validate(new List<FA_OBJECT__c>{ record });
        insert record;
        return FA_OBJECTSelector.getById(record.Id);
    }

    public static FA_OBJECT__c updateOBJECT(FA_OBJECT__c record) {
        FA_OBJECTDomain.validate(new List<FA_OBJECT__c>{ record });
        update record;
        return FA_OBJECTSelector.getById(record.Id);
    }

    public static void deactivateOBJECT(Id recordId) {
        update new FA_OBJECT__c(Id = recordId, Is_Active__c = false);
    }
}
```

**Fichier méta (`FA_OBJECTService.cls-meta.xml`) :**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<ApexClass xmlns="http://soap.sforce.com/2006/04/metadata">
    <apiVersion>66.0</apiVersion>
    <status>Active</status>
</ApexClass>
```

---

## 4. [TH] Trigger Handler — `FA_OBJECTTriggerHandler.cls`

```apex
/**
 * @description [TH] Trigger Handler — Routes trigger events for FA_OBJECT__c.
 * No SOQL. No DML. Delegates to Domain (rules) and Service (cross-domain).
 * @author Football Academy
 * @date 2026
 */
public with sharing class FA_OBJECTTriggerHandler {

    public static void beforeInsert(List<FA_OBJECT__c> newList) {
        FA_OBJECTDomain.setDefaults(newList);
        FA_OBJECTDomain.validate(newList);
    }

    public static void beforeUpdate(List<FA_OBJECT__c> newList, Map<Id, FA_OBJECT__c> oldMap) {
        FA_OBJECTDomain.validate(newList);
    }

    public static void afterInsert(List<FA_OBJECT__c> newList) {
        // Ajouter la logique post-insert ici (cross-domain via Service)
    }

    public static void afterUpdate(List<FA_OBJECT__c> newList, Map<Id, FA_OBJECT__c> oldMap) {
        // Ajouter la logique post-update ici
    }

    public static void afterDelete(List<FA_OBJECT__c> oldList) {
        // Ajouter la logique post-delete ici
    }
}
```

**Fichier méta (`FA_OBJECTTriggerHandler.cls-meta.xml`) :**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<ApexClass xmlns="http://soap.sforce.com/2006/04/metadata">
    <apiVersion>66.0</apiVersion>
    <status>Active</status>
</ApexClass>
```

---

## 5. Trigger — `FA_OBJECTTrigger.trigger`

```apex
/**
 * @description Thin trigger for FA_OBJECT__c.
 * No logic here — delegates everything to FA_OBJECTTriggerHandler.
 * @author Football Academy
 * @date 2026
 */
trigger FA_OBJECTTrigger on FA_OBJECT__c (
    before insert, before update, before delete,
    after insert, after update, after delete
) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) FA_OBJECTTriggerHandler.beforeInsert(Trigger.new);
        if (Trigger.isUpdate) FA_OBJECTTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
    }
    if (Trigger.isAfter) {
        if (Trigger.isInsert)  FA_OBJECTTriggerHandler.afterInsert(Trigger.new);
        if (Trigger.isUpdate)  FA_OBJECTTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
        if (Trigger.isDelete)  FA_OBJECTTriggerHandler.afterDelete(Trigger.old);
    }
}
```

**Fichier méta (`FA_OBJECTTrigger.trigger-meta.xml`) :**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<ApexTrigger xmlns="http://soap.sforce.com/2006/04/metadata">
    <apiVersion>66.0</apiVersion>
    <status>Active</status>
</ApexTrigger>
```

---

## 6. [LC] Controller — `FA_OBJECTController.cls`

```apex
/**
 * @description [LC] Lightning Controller — LWC entry point for FA_OBJECT__c.
 * Only @AuraEnabled methods. Delegates 100% to Service. Try/catch on all mutations.
 * @author Football Academy
 * @date 2026
 */
public with sharing class FA_OBJECTController {

    @AuraEnabled(cacheable=true)
    public static List<FA_OBJECT__c> getOBJECTs(Id categoryId, String status) {
        return FA_OBJECTService.getOBJECTs(categoryId, status);
    }

    @AuraEnabled(cacheable=true)
    public static FA_OBJECT__c getOBJECTById(Id recordId) {
        return FA_OBJECTService.getOBJECTById(recordId);
    }

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getOBJECTStats() {
        return FA_OBJECTService.getOBJECTStats();
    }

    @AuraEnabled
    public static FA_OBJECT__c createOBJECT(FA_OBJECT__c record) {
        try {
            return FA_OBJECTService.createOBJECT(record);
        } catch (DmlException e) {
            throw new AuraHandledException(e.getDmlMessage(0));
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static FA_OBJECT__c updateOBJECT(FA_OBJECT__c record) {
        try {
            return FA_OBJECTService.updateOBJECT(record);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void deactivateOBJECT(Id recordId) {
        try {
            FA_OBJECTService.deactivateOBJECT(recordId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
```

**Fichier méta (`FA_OBJECTController.cls-meta.xml`) :**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<ApexClass xmlns="http://soap.sforce.com/2006/04/metadata">
    <apiVersion>66.0</apiVersion>
    <status>Active</status>
</ApexClass>
```

---

## 7. Tests — `FA_OBJECTTest.cls`

```apex
/**
 * @description Test class for FA_OBJECT__c enterprise architecture layers.
 * Covers: Selector [EM], Domain [DM], Service [SM], Controller [LC].
 * Coverage target: >= 85%
 * @author Football Academy
 * @date 2026
 */
@isTest
public class FA_OBJECTTest {

    @TestSetup
    static void setup() {
        FA_TestDataFactory.createFullTestData();
        // Ajouter ici les données spécifiques à OBJECT si nécessaire
    }

    // ─── Selector [EM] ────────────────────────────────────────────────────

    @isTest
    static void testSelector_getById_returnsRecord() {
        FA_OBJECT__c record = [SELECT Id FROM FA_OBJECT__c LIMIT 1];
        Test.startTest();
        FA_OBJECT__c result = FA_OBJECTSelector.getById(record.Id);
        Test.stopTest();
        System.assertNotEquals(null, result, 'Should return record');
        System.assertEquals(record.Id, result.Id);
    }

    @isTest
    static void testSelector_getByFilters_noFilter_returnsAll() {
        Test.startTest();
        List<FA_OBJECT__c> results = FA_OBJECTSelector.getByFilters(null, null);
        Test.stopTest();
        System.assertNotEquals(null, results);
        System.assert(!results.isEmpty(), 'Should return records');
    }

    @isTest
    static void testSelector_getStats_returnsMap() {
        Test.startTest();
        Map<String, Object> stats = FA_OBJECTSelector.getStats();
        Test.stopTest();
        System.assertNotEquals(null, stats);
        System.assert(stats.containsKey('total'));
    }

    // ─── Domain [DM] ─────────────────────────────────────────────────────

    @isTest
    static void testDomain_validate_missingName_addsError() {
        FA_OBJECT__c invalid = new FA_OBJECT__c(); // Name vide
        Test.startTest();
        FA_OBJECTDomain.validate(new List<FA_OBJECT__c>{ invalid });
        Test.stopTest();
        System.assert(invalid.hasErrors(), 'Should have validation error');
    }

    @isTest
    static void testDomain_setDefaults_setsIsActive() {
        FA_OBJECT__c record = new FA_OBJECT__c(Name = 'Test');
        FA_OBJECTDomain.setDefaults(new List<FA_OBJECT__c>{ record });
        System.assertEquals(true, record.Is_Active__c, 'Should default Is_Active to true');
    }

    // ─── Service [SM] ─────────────────────────────────────────────────────

    @isTest
    static void testService_getOBJECTs_returnsResults() {
        Test.startTest();
        List<FA_OBJECT__c> results = FA_OBJECTService.getOBJECTs(null, null);
        Test.stopTest();
        System.assertNotEquals(null, results);
    }

    @isTest
    static void testService_createOBJECT_success() {
        FA_Category__c cat = [SELECT Id FROM FA_Category__c LIMIT 1];
        FA_OBJECT__c record = new FA_OBJECT__c(
            Name = 'Test OBJECT',
            Category__c = cat.Id
            // Ajouter les champs obligatoires
        );
        Test.startTest();
        FA_OBJECT__c result = FA_OBJECTService.createOBJECT(record);
        Test.stopTest();
        System.assertNotEquals(null, result.Id, 'Record should be created');
    }

    @isTest
    static void testService_deactivateOBJECT_success() {
        FA_OBJECT__c record = [SELECT Id FROM FA_OBJECT__c LIMIT 1];
        Test.startTest();
        FA_OBJECTService.deactivateOBJECT(record.Id);
        Test.stopTest();
        FA_OBJECT__c updated = [SELECT Id, Is_Active__c FROM FA_OBJECT__c WHERE Id = :record.Id];
        System.assertEquals(false, updated.Is_Active__c, 'Should be deactivated');
    }

    // ─── Controller [LC] ──────────────────────────────────────────────────

    @isTest
    static void testController_getOBJECTs_returnsResults() {
        Test.startTest();
        List<FA_OBJECT__c> results = FA_OBJECTController.getOBJECTs(null, null);
        Test.stopTest();
        System.assertNotEquals(null, results);
    }

    @isTest
    static void testController_createOBJECT_success() {
        FA_Category__c cat = [SELECT Id FROM FA_Category__c LIMIT 1];
        FA_OBJECT__c record = new FA_OBJECT__c(
            Name = 'Controller Test',
            Category__c = cat.Id
        );
        Test.startTest();
        FA_OBJECT__c result = FA_OBJECTController.createOBJECT(record);
        Test.stopTest();
        System.assertNotEquals(null, result.Id);
    }

    // ─── Trigger Handler [TH] ─────────────────────────────────────────────

    @isTest
    static void testTrigger_beforeInsert_setsDefaults() {
        FA_Category__c cat = [SELECT Id FROM FA_Category__c LIMIT 1];
        FA_OBJECT__c record = new FA_OBJECT__c(
            Name = 'Trigger Test',
            Category__c = cat.Id
        );
        Test.startTest();
        insert record; // Déclenche le trigger → TriggerHandler → Domain
        Test.stopTest();
        FA_OBJECT__c inserted = [SELECT Id, Is_Active__c FROM FA_OBJECT__c WHERE Id = :record.Id];
        System.assertEquals(true, inserted.Is_Active__c, 'Trigger should set Is_Active default');
    }
}
```

**Fichier méta (`FA_OBJECTTest.cls-meta.xml`) :**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<ApexClass xmlns="http://soap.sforce.com/2006/04/metadata">
    <apiVersion>66.0</apiVersion>
    <status>Active</status>
</ApexClass>
```
