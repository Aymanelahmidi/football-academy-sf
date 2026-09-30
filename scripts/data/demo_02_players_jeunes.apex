// DEMO 02 - Joueurs U7 a U13
// sf apex run --target-org "FA DEMO" --file scripts/data/demo_02_players_jeunes.apex
Map<String, Id> cId = new Map<String, Id>();
for(FA_Category__c c : [SELECT Id, Short_Name__c FROM FA_Category__c WHERE Short_Name__c IN ('U7','U9','U11','U13')]) {
    cId.put(c.Short_Name__c, c.Id);
}
List<FA_Player__c> pl = new List<FA_Player__c>{
    // U7
    new FA_Player__c(First_Name__c='Adam',     Last_Name__c='Chaoui',    Date_of_Birth__c=Date.newInstance(2020,3,12),  Category__c=cId.get('U7'),  Position__c='Goalkeeper'),
    new FA_Player__c(First_Name__c='Ilyas',    Last_Name__c='Berrada',   Date_of_Birth__c=Date.newInstance(2019,7,22),  Category__c=cId.get('U7'),  Position__c='Defender'),
    new FA_Player__c(First_Name__c='Yassine',  Last_Name__c='Hamidi',    Date_of_Birth__c=Date.newInstance(2020,1,5),   Category__c=cId.get('U7'),  Position__c='Midfielder'),
    new FA_Player__c(First_Name__c='Amine',    Last_Name__c='Saidi',     Date_of_Birth__c=Date.newInstance(2019,11,18), Category__c=cId.get('U7'),  Position__c='Forward'),
    new FA_Player__c(First_Name__c='Rayan',    Last_Name__c='Bouaziz',   Date_of_Birth__c=Date.newInstance(2020,5,30),  Category__c=cId.get('U7'),  Position__c='Defender'),
    new FA_Player__c(First_Name__c='Omar',     Last_Name__c='Naceri',    Date_of_Birth__c=Date.newInstance(2019,9,8),   Category__c=cId.get('U7'),  Position__c='Midfielder'),
    // U9
    new FA_Player__c(First_Name__c='Soufiane', Last_Name__c='Khelifi',   Date_of_Birth__c=Date.newInstance(2018,2,14),  Category__c=cId.get('U9'),  Position__c='Goalkeeper'),
    new FA_Player__c(First_Name__c='Mehdi',    Last_Name__c='Lazrak',    Date_of_Birth__c=Date.newInstance(2017,6,20),  Category__c=cId.get('U9'),  Position__c='Defender'),
    new FA_Player__c(First_Name__c='Hamza',    Last_Name__c='Guerrout',  Date_of_Birth__c=Date.newInstance(2018,10,3),  Category__c=cId.get('U9'),  Position__c='Defender'),
    new FA_Player__c(First_Name__c='Nabil',    Last_Name__c='Ouazzani',  Date_of_Birth__c=Date.newInstance(2017,4,17),  Category__c=cId.get('U9'),  Position__c='Midfielder'),
    new FA_Player__c(First_Name__c='Karim',    Last_Name__c='Belkacem',  Date_of_Birth__c=Date.newInstance(2017,12,11), Category__c=cId.get('U9'),  Position__c='Forward'),
    new FA_Player__c(First_Name__c='Anass',    Last_Name__c='Zerrouki',  Date_of_Birth__c=Date.newInstance(2018,3,29),  Category__c=cId.get('U9'),  Position__c='Forward'),
    // U11
    new FA_Player__c(First_Name__c='Othmane',  Last_Name__c='Bouzid',    Date_of_Birth__c=Date.newInstance(2016,1,8),   Category__c=cId.get('U11'), Position__c='Goalkeeper'),
    new FA_Player__c(First_Name__c='Walid',    Last_Name__c='Chebbah',   Date_of_Birth__c=Date.newInstance(2015,5,19),  Category__c=cId.get('U11'), Position__c='Defender'),
    new FA_Player__c(First_Name__c='Zakaria',  Last_Name__c='Hadjadj',   Date_of_Birth__c=Date.newInstance(2015,11,27), Category__c=cId.get('U11'), Position__c='Midfielder'),
    new FA_Player__c(First_Name__c='Younes',   Last_Name__c='Kerchaoui', Date_of_Birth__c=Date.newInstance(2015,3,6),   Category__c=cId.get('U11'), Position__c='Forward'),
    new FA_Player__c(First_Name__c='Nassim',   Last_Name__c='Rahmani',   Date_of_Birth__c=Date.newInstance(2016,12,22), Category__c=cId.get('U11'), Position__c='Forward'),
    new FA_Player__c(First_Name__c='Bilal',    Last_Name__c='Meziani',   Date_of_Birth__c=Date.newInstance(2016,7,14),  Category__c=cId.get('U11'), Position__c='Midfielder'),
    // U13
    new FA_Player__c(First_Name__c='Fares',    Last_Name__c='Bouhired',  Date_of_Birth__c=Date.newInstance(2014,2,28),  Category__c=cId.get('U13'), Position__c='Defender'),
    new FA_Player__c(First_Name__c='Khalil',   Last_Name__c='Mellouk',   Date_of_Birth__c=Date.newInstance(2013,8,10),  Category__c=cId.get('U13'), Position__c='Defender'),
    new FA_Player__c(First_Name__c='Wassim',   Last_Name__c='Bendjema',  Date_of_Birth__c=Date.newInstance(2013,11,19), Category__c=cId.get('U13'), Position__c='Midfielder'),
    new FA_Player__c(First_Name__c='Redouane', Last_Name__c='Cherif',    Date_of_Birth__c=Date.newInstance(2014,1,7),   Category__c=cId.get('U13'), Position__c='Midfielder'),
    new FA_Player__c(First_Name__c='Sami',     Last_Name__c='Benaouf',   Date_of_Birth__c=Date.newInstance(2013,6,25),  Category__c=cId.get('U13'), Position__c='Forward'),
    new FA_Player__c(First_Name__c='Ryad',     Last_Name__c='Larbaoui',  Date_of_Birth__c=Date.newInstance(2014,9,13),  Category__c=cId.get('U13'), Position__c='Forward')
};
insert pl;
System.debug('OK Players U7-U13: ' + pl.size());
