// DEMO 07 - Matchs + Evenements
// sf apex run --target-org "FA DEMO" --file scripts/data/demo_07_matches_events.apex
Map<String, Id> cId = new Map<String, Id>();
for(FA_Category__c c : [SELECT Id, Short_Name__c FROM FA_Category__c]) { cId.put(c.Short_Name__c, c.Id); }

List<FA_Match__c> matches = new List<FA_Match__c>{
    new FA_Match__c(Name='J1 SEN - Al-Nour vs Raja Benmellal', Category__c=cId.get('SEN'), Opponent__c='Raja Benmellal',    Match_Date__c=Date.newInstance(2026,9,7) ),
    new FA_Match__c(Name='J2 SEN - Wydad Settat vs Al-Nour',   Category__c=cId.get('SEN'), Opponent__c='Wydad Settat',      Match_Date__c=Date.newInstance(2026,9,14)),
    new FA_Match__c(Name='J3 SEN - Al-Nour vs FUS Rabat',      Category__c=cId.get('SEN'), Opponent__c='FUS Rabat',         Match_Date__c=Date.newInstance(2026,9,21)),
    new FA_Match__c(Name='J4 SEN - Chabab Moham vs Al-Nour',   Category__c=cId.get('SEN'), Opponent__c='Chabab Mohammedia', Match_Date__c=Date.newInstance(2026,10,5)),
    new FA_Match__c(Name='J5 SEN - Al-Nour vs Ittihad Tanger', Category__c=cId.get('SEN'), Opponent__c='Ittihad Tanger',    Match_Date__c=Date.newInstance(2026,10,19)),
    new FA_Match__c(Name='J1 U17 - Al-Nour vs AS Ain Sbaa',    Category__c=cId.get('U17'), Opponent__c='AS Ain Sbaa',       Match_Date__c=Date.newInstance(2026,9,13)),
    new FA_Match__c(Name='J2 U17 - Olympic Safi vs Al-Nour',   Category__c=cId.get('U17'), Opponent__c='Olympic Safi',      Match_Date__c=Date.newInstance(2026,9,20)),
    new FA_Match__c(Name='J3 U17 - Al-Nour vs MAS Fes',        Category__c=cId.get('U17'), Opponent__c='MAS Fes',           Match_Date__c=Date.newInstance(2026,10,4)),
    new FA_Match__c(Name='J1 U13 - Al-Nour vs JS Hay Moham',   Category__c=cId.get('U13'), Opponent__c='JS Hay Mohammadi',  Match_Date__c=Date.newInstance(2026,9,12)),
    new FA_Match__c(Name='J2 U13 - RC Bouregreg vs Al-Nour',   Category__c=cId.get('U13'), Opponent__c='RC Bouregreg',      Match_Date__c=Date.newInstance(2026,9,19)),
    new FA_Match__c(Name='J3 U13 - Al-Nour vs AS Kenitra',     Category__c=cId.get('U13'), Opponent__c='AS Kenitra',        Match_Date__c=Date.newInstance(2026,10,3)),
    new FA_Match__c(Name='J1 U9  - Al-Nour vs AS Manar',       Category__c=cId.get('U9'),  Opponent__c='AS Manar',          Match_Date__c=Date.newInstance(2026,9,14))
};
insert matches;

Map<String, Id> mId = new Map<String, Id>();
for(FA_Match__c m : matches) { mId.put(m.Name, m.Id); }

List<FA_Match_Event__c> events = new List<FA_Match_Event__c>{
    new FA_Match_Event__c(Match__c=mId.get('J1 SEN - Al-Nour vs Raja Benmellal'), Event_Type__c='Goal'),
    new FA_Match_Event__c(Match__c=mId.get('J1 SEN - Al-Nour vs Raja Benmellal'), Event_Type__c='Goal'),
    new FA_Match_Event__c(Match__c=mId.get('J1 SEN - Al-Nour vs Raja Benmellal'), Event_Type__c='Yellow Card'),
    new FA_Match_Event__c(Match__c=mId.get('J1 SEN - Al-Nour vs Raja Benmellal'), Event_Type__c='Assist'),
    new FA_Match_Event__c(Match__c=mId.get('J2 SEN - Wydad Settat vs Al-Nour'),   Event_Type__c='Goal'),
    new FA_Match_Event__c(Match__c=mId.get('J2 SEN - Wydad Settat vs Al-Nour'),   Event_Type__c='Yellow Card'),
    new FA_Match_Event__c(Match__c=mId.get('J3 SEN - Al-Nour vs FUS Rabat'),      Event_Type__c='Goal'),
    new FA_Match_Event__c(Match__c=mId.get('J3 SEN - Al-Nour vs FUS Rabat'),      Event_Type__c='Goal'),
    new FA_Match_Event__c(Match__c=mId.get('J3 SEN - Al-Nour vs FUS Rabat'),      Event_Type__c='Goal'),
    new FA_Match_Event__c(Match__c=mId.get('J3 SEN - Al-Nour vs FUS Rabat'),      Event_Type__c='Assist'),
    new FA_Match_Event__c(Match__c=mId.get('J1 U17 - Al-Nour vs AS Ain Sbaa'),    Event_Type__c='Goal'),
    new FA_Match_Event__c(Match__c=mId.get('J1 U17 - Al-Nour vs AS Ain Sbaa'),    Event_Type__c='Goal'),
    new FA_Match_Event__c(Match__c=mId.get('J1 U17 - Al-Nour vs AS Ain Sbaa'),    Event_Type__c='Goal'),
    new FA_Match_Event__c(Match__c=mId.get('J2 U17 - Olympic Safi vs Al-Nour'),   Event_Type__c='Goal'),
    new FA_Match_Event__c(Match__c=mId.get('J2 U17 - Olympic Safi vs Al-Nour'),   Event_Type__c='Red Card'),
    new FA_Match_Event__c(Match__c=mId.get('J1 U13 - Al-Nour vs JS Hay Moham'),   Event_Type__c='Goal'),
    new FA_Match_Event__c(Match__c=mId.get('J1 U13 - Al-Nour vs JS Hay Moham'),   Event_Type__c='Goal'),
    new FA_Match_Event__c(Match__c=mId.get('J2 U13 - RC Bouregreg vs Al-Nour'),   Event_Type__c='Goal')
};
insert events;
System.debug('OK Matches: ' + matches.size() + ' | Events: ' + events.size());
