// DEMO 09 - Blessures + GPS + Tests Physiques
// sf apex run --target-org "FA DEMO" --file scripts/data/demo_09_injuries_gps_fitness.apex
List<FA_Player__c> allP = [SELECT Id, Category__r.Short_Name__c FROM FA_Player__c
    WHERE Category__r.Short_Name__c IN ('U15','U17','U19','SEN') ORDER BY Last_Name__c];

List<FA_Injury__c> injuries = new List<FA_Injury__c>();
List<FA_GPS_Data__c> gps = new List<FA_GPS_Data__c>();
List<FA_Fitness_Test__c> tests = new List<FA_Fitness_Test__c>();

String[] injTypes  = new String[]{'Entorse cheville','Dechirure cuisse','Contusion genou','Lombalgie','Elongation mollet'};
String[] bodyParts = new String[]{'Cheville','Cuisse','Genou','Dos','Mollet'};
String[] testTypes = new String[]{'VAMEVAL','Sprint 30m','Yo-Yo','Sprint 10m','Cooper'};
Date[]   injDates  = new Date[]{Date.newInstance(2026,9,5),Date.newInstance(2026,8,20),Date.newInstance(2026,7,15),Date.newInstance(2026,9,1),Date.newInstance(2026,8,5)};
Date     gpsDate   = Date.newInstance(2026,9,14);
Date     testDate  = Date.newInstance(2026,9,10);

Integer idx = 0;
for(FA_Player__c p : allP) {
    if(Math.mod(idx, 4) == 0) {
        injuries.add(new FA_Injury__c(
            Player__c=p.Id,
            Type__c=injTypes[Math.mod(idx,5)],
            Body_Part__c=bodyParts[Math.mod(idx,5)],
            Injury_Date__c=injDates[Math.mod(idx,5)]
        ));
    }
    if(p.Category__r.Short_Name__c == 'SEN') {
        gps.add(new FA_GPS_Data__c(Player__c=p.Id, Record_Date__c=gpsDate));
    }
    if(p.Category__r.Short_Name__c == 'U17' || p.Category__r.Short_Name__c == 'SEN') {
        tests.add(new FA_Fitness_Test__c(Player__c=p.Id, Test_Date__c=testDate, Test_Type__c=testTypes[Math.mod(idx,5)]));
    }
    idx++;
}
if(!injuries.isEmpty()) insert injuries;
if(!gps.isEmpty()) insert gps;
if(!tests.isEmpty()) insert tests;
System.debug('OK Injuries: ' + injuries.size() + ' | GPS: ' + gps.size() + ' | Tests: ' + tests.size());
