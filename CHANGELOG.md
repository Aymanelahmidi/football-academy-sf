# Changelog

All notable changes to Football Academy SF are documented here.
Format: `[version] YYYY-MM-DD — description`

---

## [1.0.0] 2026-09-25 — Initial Release

### Added
- 24 custom objects (FA_* prefix) covering all academy domains
- 221 custom fields with full English labels
- French translation via Salesforce Translation Workbench (24 CustomObjectTranslation files)
- Permission Sets: FA_Full_Access (166 field permissions), FA_Coach_Access
- 20 Apex classes: services + controllers (FA_ prefix, with sharing)
- 16 Lightning Web Components (fa* prefix)
- Demo data: 410 records across 15 objects (scripts demo_00 → demo_10)
- Bilingual support: English (base) + French (Translation Workbench)
- MCP-ready project structure (.claude/ commands, .env.example)

### Objects
- FA_Category__c, FA_Player__c, FA_Staff_Profile__c
- FA_Training_Session__c, FA_Attendance__c, FA_Session_Exercise__c
- FA_Match__c, FA_Match_Event__c, FA_Competition__c
- FA_Injury__c, FA_Medical_Record__c, FA_Medical_Access_Log__c
- FA_Evaluation__c, FA_GPS_Data__c, FA_Fitness_Test__c
- FA_Morphological_Measure__c, FA_Physical_Program__c
- FA_Transaction__c, FA_Contract__c, FA_Document__c
- FA_Legal_Guardian__c, FA_Video_Analysis__c, FA_Video_Annotation__c
- FA_Academy_Setting__c

---
