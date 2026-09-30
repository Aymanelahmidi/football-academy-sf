// FIX NAMES - Met a jour le champ Name sur tous les records sans nom propre
// sf apex run --target-org "FA DEMO" --file scripts/data/fix_names.apex

// ---- FA_Attendance__c ----
List<FA_Attendance__c> atts = [
    SELECT Id, Name, Player__r.First_Name__c, Player__r.Last_Name__c, Attendance_Date__c
    FROM FA_Attendance__c
];
for(FA_Attendance__c a : atts) {
    String pName = (String.isNotBlank(a.Player__r.First_Name__c) ? a.Player__r.First_Name__c.left(1) + '. ' : '') + a.Player__r.Last_Name__c;
    String d = a.Attendance_Date__c != null ? String.valueOf(a.Attendance_Date__c) : '';
    a.Name = ('Presence ' + pName + ' ' + d).left(80);
}
update atts;
System.debug('Updated Attendances: ' + atts.size());

// ---- FA_Evaluation__c ----
List<FA_Evaluation__c> evals = [
    SELECT Id, Name, Player__r.First_Name__c, Player__r.Last_Name__c, Evaluation_Date__c
    FROM FA_Evaluation__c
];
for(FA_Evaluation__c e : evals) {
    String pName = (String.isNotBlank(e.Player__r.First_Name__c) ? e.Player__r.First_Name__c.left(1) + '. ' : '') + e.Player__r.Last_Name__c;
    String d = e.Evaluation_Date__c != null ? String.valueOf(e.Evaluation_Date__c) : '';
    e.Name = ('Eval ' + pName + ' ' + d).left(80);
}
update evals;
System.debug('Updated Evaluations: ' + evals.size());

// ---- FA_Injury__c ----
List<FA_Injury__c> injuries = [
    SELECT Id, Name, Player__r.Last_Name__c, Type__c, Injury_Date__c
    FROM FA_Injury__c
];
for(FA_Injury__c i : injuries) {
    String t = String.isNotBlank(i.Type__c) ? i.Type__c : 'Blessure';
    String d = i.Injury_Date__c != null ? String.valueOf(i.Injury_Date__c) : '';
    i.Name = (t + ' - ' + i.Player__r.Last_Name__c + ' ' + d).left(80);
}
update injuries;
System.debug('Updated Injuries: ' + injuries.size());

// ---- FA_GPS_Data__c ----
List<FA_GPS_Data__c> gpsList = [
    SELECT Id, Name, Player__r.First_Name__c, Player__r.Last_Name__c, Record_Date__c
    FROM FA_GPS_Data__c
];
for(FA_GPS_Data__c g : gpsList) {
    String pName = (String.isNotBlank(g.Player__r.First_Name__c) ? g.Player__r.First_Name__c.left(1) + '. ' : '') + g.Player__r.Last_Name__c;
    String d = g.Record_Date__c != null ? String.valueOf(g.Record_Date__c) : '';
    g.Name = ('GPS ' + pName + ' ' + d).left(80);
}
update gpsList;
System.debug('Updated GPS: ' + gpsList.size());

// ---- FA_Fitness_Test__c ----
List<FA_Fitness_Test__c> fitnessTests = [
    SELECT Id, Name, Player__r.Last_Name__c, Test_Type__c, Test_Date__c
    FROM FA_Fitness_Test__c
];
for(FA_Fitness_Test__c ft : fitnessTests) {
    String t = String.isNotBlank(ft.Test_Type__c) ? ft.Test_Type__c : 'Test';
    String d = ft.Test_Date__c != null ? String.valueOf(ft.Test_Date__c) : '';
    ft.Name = (t + ' ' + ft.Player__r.Last_Name__c + ' ' + d).left(80);
}
update fitnessTests;
System.debug('Updated Fitness Tests: ' + fitnessTests.size());

// ---- FA_Contract__c ----
List<FA_Contract__c> contracts = [
    SELECT Id, Name, Player__r.First_Name__c, Player__r.Last_Name__c, Start_Date__c, End_Date__c
    FROM FA_Contract__c
];
for(FA_Contract__c c : contracts) {
    String pName = c.Player__r.First_Name__c + ' ' + c.Player__r.Last_Name__c;
    String season = (c.Start_Date__c != null ? String.valueOf(c.Start_Date__c.year()) : '') + '-' + (c.End_Date__c != null ? String.valueOf(c.End_Date__c.year()) : '');
    c.Name = ('Contrat ' + pName + ' ' + season).left(80);
}
update contracts;
System.debug('Updated Contracts: ' + contracts.size());

// ---- FA_Medical_Record__c ----
List<FA_Medical_Record__c> medicals = [
    SELECT Id, Name, Player__r.First_Name__c, Player__r.Last_Name__c
    FROM FA_Medical_Record__c
];
for(FA_Medical_Record__c m : medicals) {
    m.Name = ('Dossier ' + m.Player__r.First_Name__c + ' ' + m.Player__r.Last_Name__c).left(80);
}
update medicals;
System.debug('Updated Medicals: ' + medicals.size());

// ---- FA_Legal_Guardian__c ----
List<FA_Legal_Guardian__c> guardians = [
    SELECT Id, Name, First_Name__c, Last_Name__c
    FROM FA_Legal_Guardian__c
];
for(FA_Legal_Guardian__c g : guardians) {
    g.Name = (g.First_Name__c + ' ' + g.Last_Name__c).left(80);
}
update guardians;
System.debug('Updated Guardians: ' + guardians.size());

// ---- FA_Match_Event__c ----
List<FA_Match_Event__c> events = [
    SELECT Id, Name, Event_Type__c, Match__r.Name
    FROM FA_Match_Event__c
];
Integer evIdx = 1;
for(FA_Match_Event__c ev : events) {
    String t = String.isNotBlank(ev.Event_Type__c) ? ev.Event_Type__c : 'Event';
    String matchName = ev.Match__r.Name != null ? ev.Match__r.Name.left(20) : '';
    ev.Name = (t + ' - ' + matchName + ' #' + evIdx).left(80);
    evIdx++;
}
update events;
System.debug('Updated Match Events: ' + events.size());

// ---- FA_Transaction__c ----
List<FA_Transaction__c> txns = [
    SELECT Id, Name, Category__c, Amount__c, Transaction_Date__c, Type__c
    FROM FA_Transaction__c
];
for(FA_Transaction__c t : txns) {
    String cat = String.isNotBlank(t.Category__c) ? t.Category__c : t.Type__c;
    String d = t.Transaction_Date__c != null ? String.valueOf(t.Transaction_Date__c) : '';
    String amt = t.Amount__c != null ? String.valueOf(t.Amount__c.intValue()) + ' MAD' : '';
    t.Name = (cat + ' ' + amt + ' ' + d).left(80);
}
update txns;
System.debug('Updated Transactions: ' + txns.size());

System.debug('=== FIX NAMES COMPLETE ===');
