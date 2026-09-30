// DEMO 00 - Cleanup all demo data (run before re-inserting)
// sf apex run --target-org "FA DEMO" --file scripts/data/demo_00_cleanup.apex
delete [SELECT Id FROM FA_Video_Annotation__c LIMIT 2000];
delete [SELECT Id FROM FA_Video_Analysis__c LIMIT 2000];
delete [SELECT Id FROM FA_Fitness_Test__c LIMIT 2000];
delete [SELECT Id FROM FA_GPS_Data__c LIMIT 2000];
delete [SELECT Id FROM FA_Morphological_Measure__c LIMIT 2000];
delete [SELECT Id FROM FA_Physical_Program__c LIMIT 2000];
delete [SELECT Id FROM FA_Transaction__c LIMIT 2000];
delete [SELECT Id FROM FA_Evaluation__c LIMIT 2000];
delete [SELECT Id FROM FA_Injury__c LIMIT 2000];
delete [SELECT Id FROM FA_Medical_Access_Log__c LIMIT 2000];
delete [SELECT Id FROM FA_Medical_Record__c LIMIT 2000];
delete [SELECT Id FROM FA_Legal_Guardian__c LIMIT 2000];
delete [SELECT Id FROM FA_Document__c LIMIT 2000];
delete [SELECT Id FROM FA_Contract__c LIMIT 2000];
delete [SELECT Id FROM FA_Match_Event__c LIMIT 2000];
delete [SELECT Id FROM FA_Session_Exercise__c LIMIT 2000];
delete [SELECT Id FROM FA_Attendance__c LIMIT 2000];
delete [SELECT Id FROM FA_Player__c LIMIT 2000];
delete [SELECT Id FROM FA_Staff_Profile__c LIMIT 2000];
delete [SELECT Id FROM FA_Training_Session__c LIMIT 2000];
delete [SELECT Id FROM FA_Match__c LIMIT 2000];
delete [SELECT Id FROM FA_Competition__c LIMIT 2000];
delete [SELECT Id FROM FA_Category__c LIMIT 2000];
System.debug('=== CLEANUP COMPLETE ===');
