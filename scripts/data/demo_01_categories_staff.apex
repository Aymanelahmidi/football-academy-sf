// DEMO 01 - Categories + Staff
// sf apex run --target-org "FA DEMO" --file scripts/data/demo_01_categories_staff.apex
List<FA_Category__c> cats = new List<FA_Category__c>{
    new FA_Category__c(Name='U7',      Short_Name__c='U7',  Age_Min__c=5,  Age_Max__c=7 ),
    new FA_Category__c(Name='U9',      Short_Name__c='U9',  Age_Min__c=7,  Age_Max__c=9 ),
    new FA_Category__c(Name='U11',     Short_Name__c='U11', Age_Min__c=9,  Age_Max__c=11),
    new FA_Category__c(Name='U13',     Short_Name__c='U13', Age_Min__c=11, Age_Max__c=13),
    new FA_Category__c(Name='U15',     Short_Name__c='U15', Age_Min__c=13, Age_Max__c=15),
    new FA_Category__c(Name='U17',     Short_Name__c='U17', Age_Min__c=15, Age_Max__c=17),
    new FA_Category__c(Name='U19',     Short_Name__c='U19', Age_Min__c=17, Age_Max__c=19),
    new FA_Category__c(Name='Seniors', Short_Name__c='SEN', Age_Min__c=19, Age_Max__c=40)
};
insert cats;
System.debug('OK Categories: ' + cats.size());

List<FA_Staff_Profile__c> staff = new List<FA_Staff_Profile__c>{
    new FA_Staff_Profile__c(Name='Mohamed Benali',     Display_Name__c='M. Benali',    Staff_Role__c='Admin'),
    new FA_Staff_Profile__c(Name='Karim Mansouri',     Display_Name__c='K. Mansouri',  Staff_Role__c='Coach'),
    new FA_Staff_Profile__c(Name='Youssef Tahri',      Display_Name__c='Y. Tahri',     Staff_Role__c='Coach'),
    new FA_Staff_Profile__c(Name='Sofiane Ait Ahmed',  Display_Name__c='S. Ait Ahmed', Staff_Role__c='Coach'),
    new FA_Staff_Profile__c(Name='Rachid Bensalem',    Display_Name__c='R. Bensalem',  Staff_Role__c='Analyst'),
    new FA_Staff_Profile__c(Name='Dr Nadia Zouari',    Display_Name__c='Dr. Zouari',   Staff_Role__c='Doctor'),
    new FA_Staff_Profile__c(Name='Tarik Ouled',        Display_Name__c='T. Ouled',     Staff_Role__c='Fitness Coach')
};
insert staff;
System.debug('OK Staff: ' + staff.size());
