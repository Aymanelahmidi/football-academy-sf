// DEMO 03 - Joueurs U15 au Senior
// sf apex run --target-org "FA DEMO" --file scripts/data/demo_03_players_seniors.apex
Map<String, Id> cId = new Map<String, Id>();
for(FA_Category__c c : [SELECT Id, Short_Name__c FROM FA_Category__c WHERE Short_Name__c IN ('U15','U17','U19','SEN')]) {
    cId.put(c.Short_Name__c, c.Id);
}
List<FA_Player__c> pl = new List<FA_Player__c>{
    // U15
    new FA_Player__c(First_Name__c='Anas',     Last_Name__c='Kaci',       Date_of_Birth__c=Date.newInstance(2011,3,20),  Category__c=cId.get('U15'), Position__c='Goalkeeper'),
    new FA_Player__c(First_Name__c='Yacine',   Last_Name__c='Brahimi',    Date_of_Birth__c=Date.newInstance(2012,7,5),   Category__c=cId.get('U15'), Position__c='Defender'),
    new FA_Player__c(First_Name__c='Djamel',   Last_Name__c='Ouali',      Date_of_Birth__c=Date.newInstance(2011,10,14), Category__c=cId.get('U15'), Position__c='Defender'),
    new FA_Player__c(First_Name__c='Amir',     Last_Name__c='Benhaddou',  Date_of_Birth__c=Date.newInstance(2012,4,28),  Category__c=cId.get('U15'), Position__c='Defender'),
    new FA_Player__c(First_Name__c='Hocine',   Last_Name__c='Rahmani',    Date_of_Birth__c=Date.newInstance(2011,8,9),   Category__c=cId.get('U15'), Position__c='Midfielder'),
    new FA_Player__c(First_Name__c='Ibrahim',  Last_Name__c='Ziani',      Date_of_Birth__c=Date.newInstance(2012,5,16),  Category__c=cId.get('U15'), Position__c='Forward'),
    // U17
    new FA_Player__c(First_Name__c='Malek',    Last_Name__c='Boudiaf',    Date_of_Birth__c=Date.newInstance(2009,2,17),  Category__c=cId.get('U17'), Position__c='Goalkeeper'),
    new FA_Player__c(First_Name__c='Riad',     Last_Name__c='Mahrez',     Date_of_Birth__c=Date.newInstance(2010,6,4),   Category__c=cId.get('U17'), Position__c='Defender'),
    new FA_Player__c(First_Name__c='Billel',   Last_Name__c='Ourabah',    Date_of_Birth__c=Date.newInstance(2009,9,30),  Category__c=cId.get('U17'), Position__c='Defender'),
    new FA_Player__c(First_Name__c='Nassim',   Last_Name__c='Touati',     Date_of_Birth__c=Date.newInstance(2010,3,11),  Category__c=cId.get('U17'), Position__c='Midfielder'),
    new FA_Player__c(First_Name__c='Zinedine', Last_Name__c='Ferhat',     Date_of_Birth__c=Date.newInstance(2009,7,21),  Category__c=cId.get('U17'), Position__c='Midfielder'),
    new FA_Player__c(First_Name__c='Adel',     Last_Name__c='Arabi',      Date_of_Birth__c=Date.newInstance(2010,11,8),  Category__c=cId.get('U17'), Position__c='Midfielder'),
    new FA_Player__c(First_Name__c='Islem',    Last_Name__c='Aouad',      Date_of_Birth__c=Date.newInstance(2009,4,26),  Category__c=cId.get('U17'), Position__c='Forward'),
    // U19
    new FA_Player__c(First_Name__c='Farid',    Last_Name__c='Ghilas',     Date_of_Birth__c=Date.newInstance(2007,5,12),  Category__c=cId.get('U19'), Position__c='Goalkeeper'),
    new FA_Player__c(First_Name__c='Idir',     Last_Name__c='Ouled',      Date_of_Birth__c=Date.newInstance(2008,8,3),   Category__c=cId.get('U19'), Position__c='Defender'),
    new FA_Player__c(First_Name__c='Karim',    Last_Name__c='Ziani',      Date_of_Birth__c=Date.newInstance(2007,11,19), Category__c=cId.get('U19'), Position__c='Defender'),
    new FA_Player__c(First_Name__c='Anis',     Last_Name__c='Belhaj',     Date_of_Birth__c=Date.newInstance(2007,9,24),  Category__c=cId.get('U19'), Position__c='Midfielder'),
    new FA_Player__c(First_Name__c='Mourad',   Last_Name__c='Bessah',     Date_of_Birth__c=Date.newInstance(2008,6,16),  Category__c=cId.get('U19'), Position__c='Midfielder'),
    new FA_Player__c(First_Name__c='Djamel',   Last_Name__c='Benmansour', Date_of_Birth__c=Date.newInstance(2007,2,28),  Category__c=cId.get('U19'), Position__c='Forward'),
    new FA_Player__c(First_Name__c='Amine',    Last_Name__c='Djahnine',   Date_of_Birth__c=Date.newInstance(2008,12,5),  Category__c=cId.get('U19'), Position__c='Forward'),
    // SENIORS
    new FA_Player__c(First_Name__c='Ayoub',    Last_Name__c='Zerrouk',    Date_of_Birth__c=Date.newInstance(2001,4,18),  Category__c=cId.get('SEN'), Position__c='Goalkeeper'),
    new FA_Player__c(First_Name__c='Said',     Last_Name__c='Mansouri',   Date_of_Birth__c=Date.newInstance(1998,8,7),   Category__c=cId.get('SEN'), Position__c='Defender'),
    new FA_Player__c(First_Name__c='Mohamed',  Last_Name__c='Yahia',      Date_of_Birth__c=Date.newInstance(2000,12,23), Category__c=cId.get('SEN'), Position__c='Defender'),
    new FA_Player__c(First_Name__c='Bachir',   Last_Name__c='Amrani',     Date_of_Birth__c=Date.newInstance(2002,6,30),  Category__c=cId.get('SEN'), Position__c='Defender'),
    new FA_Player__c(First_Name__c='Lamine',   Last_Name__c='Benzerga',   Date_of_Birth__c=Date.newInstance(1997,10,9),  Category__c=cId.get('SEN'), Position__c='Midfielder'),
    new FA_Player__c(First_Name__c='Tarek',    Last_Name__c='Belhadj',    Date_of_Birth__c=Date.newInstance(2000,1,25),  Category__c=cId.get('SEN'), Position__c='Midfielder'),
    new FA_Player__c(First_Name__c='Nabil',    Last_Name__c='Ghilas',     Date_of_Birth__c=Date.newInstance(1999,7,17),  Category__c=cId.get('SEN'), Position__c='Midfielder'),
    new FA_Player__c(First_Name__c='Sofiane',  Last_Name__c='Feghouli',   Date_of_Birth__c=Date.newInstance(2001,9,5),   Category__c=cId.get('SEN'), Position__c='Forward'),
    new FA_Player__c(First_Name__c='Rachid',   Last_Name__c='Benyahia',   Date_of_Birth__c=Date.newInstance(1998,2,13),  Category__c=cId.get('SEN'), Position__c='Forward'),
    new FA_Player__c(First_Name__c='Omar',     Last_Name__c='Khazri',     Date_of_Birth__c=Date.newInstance(2003,5,21),  Category__c=cId.get('SEN'), Position__c='Forward')
};
insert pl;
System.debug('OK Players U15-Senior: ' + pl.size());
