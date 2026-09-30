// DEMO 06 - Seances d'entrainement
// sf apex run --target-org "FA DEMO" --file scripts/data/demo_06_sessions.apex
Map<String, Id> cId = new Map<String, Id>();
for(FA_Category__c c : [SELECT Id, Short_Name__c FROM FA_Category__c]) { cId.put(c.Short_Name__c, c.Id); }

List<FA_Training_Session__c> sess = new List<FA_Training_Session__c>{
    new FA_Training_Session__c(Name='U9  - Technique balle au pied',  Category__c=cId.get('U9'),  Session_Date__c=Date.newInstance(2026,9,8),  Start_Time__c='09:00', End_Time__c='10:30'),
    new FA_Training_Session__c(Name='U9  - Jeu collectif passes',     Category__c=cId.get('U9'),  Session_Date__c=Date.newInstance(2026,9,15), Start_Time__c='09:00', End_Time__c='10:30'),
    new FA_Training_Session__c(Name='U9  - Coordination vitesse',     Category__c=cId.get('U9'),  Session_Date__c=Date.newInstance(2026,9,29), Start_Time__c='09:00', End_Time__c='10:30'),
    new FA_Training_Session__c(Name='U13 - Pressing haut',            Category__c=cId.get('U13'), Session_Date__c=Date.newInstance(2026,9,10), Start_Time__c='17:00', End_Time__c='19:00'),
    new FA_Training_Session__c(Name='U13 - Corners et coups francs',  Category__c=cId.get('U13'), Session_Date__c=Date.newInstance(2026,9,17), Start_Time__c='17:00', End_Time__c='19:00'),
    new FA_Training_Session__c(Name='U13 - Endurance et frappe',      Category__c=cId.get('U13'), Session_Date__c=Date.newInstance(2026,9,24), Start_Time__c='17:00', End_Time__c='19:00'),
    new FA_Training_Session__c(Name='U17 - Bloc defensif 4-4-2',      Category__c=cId.get('U17'), Session_Date__c=Date.newInstance(2026,9,9),  Start_Time__c='17:30', End_Time__c='19:30'),
    new FA_Training_Session__c(Name='U17 - Sprint et vivacite',       Category__c=cId.get('U17'), Session_Date__c=Date.newInstance(2026,9,16), Start_Time__c='17:30', End_Time__c='19:30'),
    new FA_Training_Session__c(Name='U17 - Contre-attaque rapide',    Category__c=cId.get('U17'), Session_Date__c=Date.newInstance(2026,9,23), Start_Time__c='17:30', End_Time__c='19:30'),
    new FA_Training_Session__c(Name='SEN - Preparation physique',     Category__c=cId.get('SEN'), Session_Date__c=Date.newInstance(2026,9,7),  Start_Time__c='18:00', End_Time__c='20:00'),
    new FA_Training_Session__c(Name='SEN - Tactique 4-3-3',           Category__c=cId.get('SEN'), Session_Date__c=Date.newInstance(2026,9,14), Start_Time__c='18:00', End_Time__c='20:00'),
    new FA_Training_Session__c(Name='SEN - Match interne 11v11',      Category__c=cId.get('SEN'), Session_Date__c=Date.newInstance(2026,9,18), Start_Time__c='18:00', End_Time__c='20:00'),
    new FA_Training_Session__c(Name='SEN - Recuperation video',       Category__c=cId.get('SEN'), Session_Date__c=Date.newInstance(2026,10,5), Start_Time__c='18:00', End_Time__c='19:30')
};
insert sess;
System.debug('OK Sessions: ' + sess.size());
