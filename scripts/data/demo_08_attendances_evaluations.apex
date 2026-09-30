// DEMO 08 - Presences + Evaluations
// sf apex run --target-org "FA DEMO" --file scripts/data/demo_08_attendances_evaluations.apex
List<FA_Training_Session__c> sessions = [SELECT Id, Session_Date__c, Category__c FROM FA_Training_Session__c
    WHERE Session_Date__c < TODAY ORDER BY Session_Date__c];
Map<Id, List<FA_Player__c>> byCat = new Map<Id, List<FA_Player__c>>();
for(FA_Player__c p : [SELECT Id, Category__c FROM FA_Player__c]) {
    if(!byCat.containsKey(p.Category__c)) byCat.put(p.Category__c, new List<FA_Player__c>());
    byCat.get(p.Category__c).add(p);
}
List<FA_Attendance__c> atts = new List<FA_Attendance__c>();
for(FA_Training_Session__c s : sessions) {
    List<FA_Player__c> ps = byCat.get(s.Category__c);
    if(ps == null) continue;
    for(FA_Player__c p : ps) {
        atts.add(new FA_Attendance__c(Player__c=p.Id, Training_Session__c=s.Id, Attendance_Date__c=s.Session_Date__c));
    }
}
if(!atts.isEmpty()) insert atts;

List<FA_Player__c> evalPs = [SELECT Id FROM FA_Player__c
    WHERE Category__r.Short_Name__c IN ('U13','U17','SEN') ORDER BY Last_Name__c];
List<FA_Evaluation__c> evals = new List<FA_Evaluation__c>();
for(FA_Player__c p : evalPs) {
    evals.add(new FA_Evaluation__c(Player__c=p.Id, Evaluation_Date__c=Date.newInstance(2026,9,15)));
}
insert evals;
System.debug('OK Attendances: ' + atts.size() + ' | Evaluations: ' + evals.size());
