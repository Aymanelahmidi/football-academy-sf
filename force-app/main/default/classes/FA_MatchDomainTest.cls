@isTest
private class FA_MatchDomainTest {

    @isTest
    static void testCalculateStats_win() {
        List<FA_Match__c> matches = new List<FA_Match__c>{
            new FA_Match__c(Goals_For__c = 2, Goals_Against__c = 1)
        };
        Map<String, Object> stats = FA_MatchDomain.calculateStats(matches);
        System.assertEquals(1, (Integer) stats.get('wins'));
        System.assertEquals(0, (Integer) stats.get('draws'));
        System.assertEquals(0, (Integer) stats.get('losses'));
        System.assertEquals(1, (Integer) stats.get('totalPlayed'));
    }

    @isTest
    static void testCalculateStats_draw() {
        List<FA_Match__c> matches = new List<FA_Match__c>{
            new FA_Match__c(Goals_For__c = 1, Goals_Against__c = 1)
        };
        Map<String, Object> stats = FA_MatchDomain.calculateStats(matches);
        System.assertEquals(0, (Integer) stats.get('wins'));
        System.assertEquals(1, (Integer) stats.get('draws'));
        System.assertEquals(0, (Integer) stats.get('losses'));
    }

    @isTest
    static void testCalculateStats_loss() {
        List<FA_Match__c> matches = new List<FA_Match__c>{
            new FA_Match__c(Goals_For__c = 0, Goals_Against__c = 3)
        };
        Map<String, Object> stats = FA_MatchDomain.calculateStats(matches);
        System.assertEquals(0, (Integer) stats.get('wins'));
        System.assertEquals(0, (Integer) stats.get('draws'));
        System.assertEquals(1, (Integer) stats.get('losses'));
    }

    @isTest
    static void testCalculateStats_nullGoals() {
        List<FA_Match__c> matches = new List<FA_Match__c>{
            new FA_Match__c(Goals_For__c = null, Goals_Against__c = null)
        };
        Map<String, Object> stats = FA_MatchDomain.calculateStats(matches);
        System.assertEquals(1, (Integer) stats.get('draws'));
        System.assertEquals(0, (Integer) stats.get('goalsFor'));
    }

    @isTest
    static void testBuildName_homeMatch() {
        FA_Match__c m = new FA_Match__c(
            Is_Home__c = true, Opponent__c = 'FAR Rabat', Match_Date__c = Date.today()
        );
        FA_MatchDomain.buildName(m);
        System.assert(m.Name.startsWith('Académie vs FAR Rabat'));
    }

    @isTest
    static void testBuildName_awayMatch() {
        FA_Match__c m = new FA_Match__c(
            Is_Home__c = false, Opponent__c = 'FAR Rabat', Match_Date__c = Date.today()
        );
        FA_MatchDomain.buildName(m);
        System.assert(m.Name.contains('vs Académie'));
    }
}