// DEMO 05 - Tuteurs Legaux (mineurs U7-U17)
// sf apex run --target-org "FA DEMO" --file scripts/data/demo_05_guardians.apex
List<FA_Player__c> minors = [SELECT Id, Last_Name__c FROM FA_Player__c
    WHERE Category__r.Short_Name__c IN ('U7','U9','U11','U13','U15','U17')
    ORDER BY Category__r.Short_Name__c, Last_Name__c];
List<FA_Legal_Guardian__c> guardians = new List<FA_Legal_Guardian__c>();
Integer idx = 0;
String[] fnames = new String[]{'Hassan','Fatima','Karim','Nadia','Omar','Zineb','Rachid','Amina','Sofiane','Hanane','Tarek','Meriem','Bilal','Souad','Farid'};
for(FA_Player__c p : minors) {
    guardians.add(new FA_Legal_Guardian__c(
        Player__c=p.Id,
        First_Name__c=fnames[Math.mod(idx, fnames.size())],
        Last_Name__c=p.Last_Name__c,
        Phone__c='+21266' + String.valueOf(1200000 + idx)
    ));
    idx++;
}
insert guardians;
System.debug('OK Guardians: ' + guardians.size());
