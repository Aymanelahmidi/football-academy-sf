// DEMO 04 - Contrats + Dossiers Medicaux
// sf apex run --target-org "FA DEMO" --file scripts/data/demo_04_contracts_medical.apex
List<FA_Player__c> allP = [SELECT Id FROM FA_Player__c ORDER BY CreatedDate];
List<FA_Contract__c> contracts = new List<FA_Contract__c>();
List<FA_Medical_Record__c> medicals = new List<FA_Medical_Record__c>();
for(FA_Player__c p : allP) {
    contracts.add(new FA_Contract__c(
        Player__c=p.Id,
        Start_Date__c=Date.newInstance(2026,9,1),
        End_Date__c=Date.newInstance(2027,6,30)
    ));
    medicals.add(new FA_Medical_Record__c(Player__c=p.Id));
}
insert contracts;
insert medicals;
System.debug('OK Contracts: ' + contracts.size() + ' | Medicals: ' + medicals.size());
