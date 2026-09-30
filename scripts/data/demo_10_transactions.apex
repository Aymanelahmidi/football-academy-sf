// DEMO 10 - Transactions Financieres
// sf apex run --target-org "FA DEMO" --file scripts/data/demo_10_transactions.apex
List<FA_Transaction__c> txns = new List<FA_Transaction__c>{
    new FA_Transaction__c(Type__c='Revenue',   Category__c='Cotisation',     Amount__c=4200, Transaction_Date__c=Date.newInstance(2026,9,5),  Description__c='Cotisations Sept - Seniors (12 joueurs)'),
    new FA_Transaction__c(Type__c='Revenue',   Category__c='Cotisation',     Amount__c=1200, Transaction_Date__c=Date.newInstance(2026,9,6),  Description__c='Cotisations Sept - U13'),
    new FA_Transaction__c(Type__c='Revenue',   Category__c='Cotisation',     Amount__c=1200, Transaction_Date__c=Date.newInstance(2026,9,6),  Description__c='Cotisations Sept - U15'),
    new FA_Transaction__c(Type__c='Revenue',   Category__c='Cotisation',     Amount__c=1750, Transaction_Date__c=Date.newInstance(2026,9,7),  Description__c='Cotisations Sept - U17'),
    new FA_Transaction__c(Type__c='Revenue',   Category__c='Cotisation',     Amount__c=1950, Transaction_Date__c=Date.newInstance(2026,9,8),  Description__c='Cotisations Sept - U19'),
    new FA_Transaction__c(Type__c='Revenue',   Category__c='Cotisation',     Amount__c=900,  Transaction_Date__c=Date.newInstance(2026,9,8),  Description__c='Cotisations Sept - U7/U9'),
    new FA_Transaction__c(Type__c='Revenue',   Category__c='Sponsor',        Amount__c=5000, Transaction_Date__c=Date.newInstance(2026,9,1),  Description__c='Partenariat Al-Nour Sport Maroc Q4'),
    new FA_Transaction__c(Type__c='Revenue',   Category__c='Match Recette',  Amount__c=1200, Transaction_Date__c=Date.newInstance(2026,9,7),  Description__c='Recette match J1 vs Raja Benmellal'),
    new FA_Transaction__c(Type__c='Revenue',   Category__c='Match Recette',  Amount__c=1650, Transaction_Date__c=Date.newInstance(2026,9,21), Description__c='Recette match J3 vs FUS Rabat'),
    new FA_Transaction__c(Type__c='Revenue',   Category__c='Subvention',     Amount__c=3000, Transaction_Date__c=Date.newInstance(2026,9,15), Description__c='Subvention Municipalite Q3 2026'),
    new FA_Transaction__c(Type__c='Expense', Category__c='Equipement', Amount__c=2800, Transaction_Date__c=Date.newInstance(2026,9,2),  Description__c='Maillots et shorts saison 2026-27'),
    new FA_Transaction__c(Type__c='Expense', Category__c='Equipement', Amount__c=650,  Transaction_Date__c=Date.newInstance(2026,9,3),  Description__c='Ballons entrainement 20 unites'),
    new FA_Transaction__c(Type__c='Expense', Category__c='Medical',    Amount__c=890,  Transaction_Date__c=Date.newInstance(2026,9,10), Description__c='Pharmacie et kinesitherapie'),
    new FA_Transaction__c(Type__c='Expense', Category__c='Transport',  Amount__c=1200, Transaction_Date__c=Date.newInstance(2026,9,14), Description__c='Transport deplacement J2 Wydad Settat'),
    new FA_Transaction__c(Type__c='Expense', Category__c='Transport',  Amount__c=950,  Transaction_Date__c=Date.newInstance(2026,9,20), Description__c='Transport U17 deplacement Olympic Safi'),
    new FA_Transaction__c(Type__c='Expense', Category__c='Salaires',   Amount__c=8500, Transaction_Date__c=Date.newInstance(2026,9,30), Description__c='Salaires staff septembre 2026'),
    new FA_Transaction__c(Type__c='Expense', Category__c='Infrastructure', Amount__c=450, Transaction_Date__c=Date.newInstance(2026,9,5), Description__c='Entretien pelouse terrains A et B'),
    new FA_Transaction__c(Type__c='Expense', Category__c='Academy',  Amount__c=600,  Transaction_Date__c=Date.newInstance(2026,9,12), Description__c='Formation UEFA Grassroots K.Mansouri')
};
insert txns;
System.debug('OK Transactions: ' + txns.size());
System.debug('=== DEMO DATA COMPLETE ===');
