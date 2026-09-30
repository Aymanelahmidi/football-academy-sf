@isTest
private class FA_InjuryTriggerHandlerTest {

    @isTest
    static void testAfterInsert_setsPlayerToInjured() {
        FA_Category__c cat = FA_TestDataFactory.createCategory('U16', 'U16', 15, 16);
        FA_Player__c player = FA_TestDataFactory.createPlayer('Test', 'Player', cat.Id, 'Midfielder');
        System.assertEquals('Active', [SELECT Status__c FROM FA_Player__c WHERE Id = :player.Id].Status__c);

        FA_Injury__c injury = new FA_Injury__c(
            Name = 'Test Injury',
            Player__c = player.Id,
            Type__c = 'Entorse',
            Body_Part__c = 'Cheville',
            Severity__c = 'Minor',
            Injury_Date__c = Date.today(),
            Status__c = 'In Treatment'
        );
        insert injury;

        FA_Player__c updated = [SELECT Status__c FROM FA_Player__c WHERE Id = :player.Id];
        System.assertEquals('Injured', updated.Status__c);
    }

    @isTest
    static void testAfterUpdate_recoveredInjury_resetsPlayerStatus() {
        FA_Category__c cat = FA_TestDataFactory.createCategory('U17', 'U17', 16, 17);
        FA_Player__c player = FA_TestDataFactory.createPlayer('Test', 'Player2', cat.Id, 'Defender');

        FA_Injury__c injury = new FA_Injury__c(
            Name = 'Test Injury',
            Player__c = player.Id,
            Type__c = 'Entorse',
            Body_Part__c = 'Genou',
            Severity__c = 'Minor',
            Injury_Date__c = Date.today(),
            Status__c = 'In Treatment'
        );
        insert injury;

        injury.Status__c = 'Recovered';
        injury.Actual_Return_Date__c = Date.today();
        update injury;

        FA_Player__c result = [SELECT Status__c FROM FA_Player__c WHERE Id = :player.Id];
        System.assertEquals('Active', result.Status__c);
    }

    @isTest
    static void testAfterUpdate_twoInjuries_recoveredOne_staysInjured() {
        FA_Category__c cat = FA_TestDataFactory.createCategory('U18', 'U18', 17, 18);
        FA_Player__c player = FA_TestDataFactory.createPlayer('Test', 'Player3', cat.Id, 'Goalkeeper');

        FA_Injury__c inj1 = new FA_Injury__c(
            Name = 'Injury1', Player__c = player.Id, Type__c = 'Entorse',
            Body_Part__c = 'Cheville', Severity__c = 'Minor',
            Injury_Date__c = Date.today(), Status__c = 'In Treatment'
        );
        FA_Injury__c inj2 = new FA_Injury__c(
            Name = 'Injury2', Player__c = player.Id, Type__c = 'Fracture',
            Body_Part__c = 'Bras', Severity__c = 'Severe',
            Injury_Date__c = Date.today(), Status__c = 'In Treatment'
        );
        insert new List<FA_Injury__c>{ inj1, inj2 };

        // Recover only first injury
        inj1.Status__c = 'Recovered';
        inj1.Actual_Return_Date__c = Date.today();
        update inj1;

        FA_Player__c result = [SELECT Status__c FROM FA_Player__c WHERE Id = :player.Id];
        System.assertEquals('Injured', result.Status__c, 'Player should remain Injured with active injury remaining');
    }
}