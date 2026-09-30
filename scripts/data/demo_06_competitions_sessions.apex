// DEMO 06 - Competitions + Seances
// sf apex run --file scripts/data/demo_06_competitions_sessions.apex
Map<String, Id> catId = new Map<String, Id>();
for(FA_Category__c c : [SELECT Id, Short_Name__c FROM FA_Category__c]) { catId.put(c.Short_Name__c, c.Id); }
Map<String, Id> staffId = new Map<String, Id>();
for(FA_Staff_Profile__c s : [SELECT Id, Name FROM FA_Staff_Profile__c]) { staffId.put(s.Name, s.Id); }

List<FA_Competition__c> comps = new List<FA_Competition__c>{
    new FA_Competition__c(Name='Champ Regional U9 2026-2027',   Type__c='League', Season__c='2026-2027', Category__c=catId.get('U9'),  Start_Date__c=Date.newInstance(2026,9,15), End_Date__c=Date.newInstance(2027,5,31), Is_Active__c=true),
    new FA_Competition__c(Name='Champ Regional U11 2026-2027',  Type__c='League', Season__c='2026-2027', Category__c=catId.get('U11'), Start_Date__c=Date.newInstance(2026,9,15), End_Date__c=Date.newInstance(2027,5,31), Is_Active__c=true),
    new FA_Competition__c(Name='Champ Regional U13 2026-2027',  Type__c='League', Season__c='2026-2027', Category__c=catId.get('U13'), Start_Date__c=Date.newInstance(2026,9,15), End_Date__c=Date.newInstance(2027,5,31), Is_Active__c=true),
    new FA_Competition__c(Name='Champ Regional U15 2026-2027',  Type__c='League', Season__c='2026-2027', Category__c=catId.get('U15'), Start_Date__c=Date.newInstance(2026,9,15), End_Date__c=Date.newInstance(2027,5,31), Is_Active__c=true),
    new FA_Competition__c(Name='Champ National U17 2026-2027',  Type__c='League', Season__c='2026-2027', Category__c=catId.get('U17'), Start_Date__c=Date.newInstance(2026,9,15), End_Date__c=Date.newInstance(2027,5,31), Is_Active__c=true),
    new FA_Competition__c(Name='Champ National U19 2026-2027',  Type__c='League', Season__c='2026-2027', Category__c=catId.get('U19'), Start_Date__c=Date.newInstance(2026,9,15), End_Date__c=Date.newInstance(2027,5,31), Is_Active__c=true),
    new FA_Competition__c(Name='Division Nationale Senior 2026-2027', Type__c='League', Season__c='2026-2027', Category__c=catId.get('SEN'), Start_Date__c=Date.newInstance(2026,9,1), End_Date__c=Date.newInstance(2027,5,31), Is_Active__c=true),
    new FA_Competition__c(Name='Coupe Nationale Juniors 2026',  Type__c='Cup',       Season__c='2026-2027', Category__c=catId.get('U17'), Start_Date__c=Date.newInstance(2026,10,1), End_Date__c=Date.newInstance(2027,3,31), Is_Active__c=true),
    new FA_Competition__c(Name='Tournoi de la Fete 2026',       Type__c='Tournament',     Season__c='2026-2027', Category__c=catId.get('U13'), Start_Date__c=Date.newInstance(2026,11,1), End_Date__c=Date.newInstance(2026,11,3), Is_Active__c=true)
};
insert comps;

Id cU79  = staffId.get('Karim Mansouri');
Id cU13  = staffId.get('Youssef Tahri');
Id cU17  = staffId.get('Sofiane Ait Ahmed');
Id cSEN  = staffId.get('Rachid Bensalem');

List<FA_Training_Session__c> sessions = new List<FA_Training_Session__c>{
    new FA_Training_Session__c(Name='U9 - Technique balle au pied',  Category__c=catId.get('U9'),  Coach__c=cU79,  Session_Date__c=Date.newInstance(2026,9,8),  Start_Time__c='09:00', End_Time__c='10:30', Location__c='Terrain B', Type__c='Technical',    Objectives__c='Conduction, feintes simples', Status__c='Completed'),
    new FA_Training_Session__c(Name='U9 - Jeu collectif passes',     Category__c=catId.get('U9'),  Coach__c=cU79,  Session_Date__c=Date.newInstance(2026,9,15), Start_Time__c='09:00', End_Time__c='10:30', Location__c='Terrain B', Type__c='Tactical',     Objectives__c='Passes courtes, soutiens', Status__c='Completed'),
    new FA_Training_Session__c(Name='U9 - Coordination vitesse',     Category__c=catId.get('U9'),  Coach__c=cU79,  Session_Date__c=Date.newInstance(2026,9,29), Start_Time__c='09:00', End_Time__c='10:30', Location__c='Terrain B', Type__c='Physical',     Objectives__c='Coordination, equilibre', Status__c='Scheduled'),
    new FA_Training_Session__c(Name='U13 - Pressing haut',           Category__c=catId.get('U13'), Coach__c=cU13,  Session_Date__c=Date.newInstance(2026,9,10), Start_Time__c='17:00', End_Time__c='19:00', Location__c='Terrain A', Type__c='Tactical',     Objectives__c='Organisation pressing, transitions', Status__c='Completed'),
    new FA_Training_Session__c(Name='U13 - Corners et coups francs', Category__c=catId.get('U13'), Coach__c=cU13,  Session_Date__c=Date.newInstance(2026,9,17), Start_Time__c='17:00', End_Time__c='19:00', Location__c='Terrain A', Type__c='Technical',    Objectives__c='Phases arretees offensives', Status__c='Completed'),
    new FA_Training_Session__c(Name='U13 - Endurance et frappe',     Category__c=catId.get('U13'), Coach__c=cU13,  Session_Date__c=Date.newInstance(2026,9,24), Start_Time__c='17:00', End_Time__c='19:00', Location__c='Terrain A', Type__c='Physical',     Objectives__c='Foncier, interval training', Status__c='Scheduled'),
    new FA_Training_Session__c(Name='U17 - Bloc defensif 4-4-2',    Category__c=catId.get('U17'), Coach__c=cU17,  Session_Date__c=Date.newInstance(2026,9,9),  Start_Time__c='17:30', End_Time__c='19:30', Location__c='Terrain A', Type__c='Tactical',     Objectives__c='Organisation defensive', Status__c='Completed'),
    new FA_Training_Session__c(Name='U17 - Sprint et vivacite',      Category__c=catId.get('U17'), Coach__c=cU17,  Session_Date__c=Date.newInstance(2026,9,16), Start_Time__c='17:30', End_Time__c='19:30', Location__c='Terrain A', Type__c='Physical',     Objectives__c='Sprint 30m, acceleration', Status__c='Completed'),
    new FA_Training_Session__c(Name='U17 - Contre-attaque rapide',   Category__c=catId.get('U17'), Coach__c=cU17,  Session_Date__c=Date.newInstance(2026,9,23), Start_Time__c='17:30', End_Time__c='19:30', Location__c='Terrain A', Type__c='Tactical',     Objectives__c='Transition def-att', Status__c='Scheduled'),
    new FA_Training_Session__c(Name='Senior - Preparation physique', Category__c=catId.get('SEN'), Coach__c=cSEN,  Session_Date__c=Date.newInstance(2026,9,7),  Start_Time__c='18:00', End_Time__c='20:00', Location__c='Stade Al-Nour', Type__c='Physical',  Objectives__c='PPG, foncier, seuil aerobie', Status__c='Completed'),
    new FA_Training_Session__c(Name='Senior - Tactique 4-3-3',       Category__c=catId.get('SEN'), Coach__c=cSEN,  Session_Date__c=Date.newInstance(2026,9,14), Start_Time__c='18:00', End_Time__c='20:00', Location__c='Stade Al-Nour', Type__c='Tactical',  Objectives__c='Placement 4-3-3, rotations', Status__c='Completed'),
    new FA_Training_Session__c(Name='Senior - Match interne 11v11',  Category__c=catId.get('SEN'), Coach__c=cSEN,  Session_Date__c=Date.newInstance(2026,9,18), Start_Time__c='18:00', End_Time__c='20:00', Location__c='Stade Al-Nour', Type__c='Friendly Match', Objectives__c='Evaluation collective', Status__c='Completed'),
    new FA_Training_Session__c(Name='Senior - Recuperation video',   Category__c=catId.get('SEN'), Coach__c=cSEN,  Session_Date__c=Date.newInstance(2026,10,5), Start_Time__c='18:00', End_Time__c='19:30', Location__c='Stade Al-Nour', Type__c='Recovery', Objectives__c='Stretching + analyse video', Status__c='Scheduled')
};
insert sessions;
System.debug('OK Competitions: ' + comps.size() + ' | Sessions: ' + sessions.size());
