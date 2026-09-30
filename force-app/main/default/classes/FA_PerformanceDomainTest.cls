@isTest
private class FA_PerformanceDomainTest {

    @isTest
    static void testCalculateBMI_normalValues() {
        FA_Morphological_Measure__c m = new FA_Morphological_Measure__c(
            Height_Cm__c = 175,
            Weight_Kg__c = 70
        );
        FA_PerformanceDomain.calculateBMI(m);
        System.assertNotEquals(null, m.BMI__c);
        // BMI = 70 / (1.75^2) = 70 / 3.0625 = 22.857... -> 22.9
        System.assertEquals(22.9, m.BMI__c);
    }

    @isTest
    static void testCalculateBMI_nullHeight() {
        FA_Morphological_Measure__c m = new FA_Morphological_Measure__c(Weight_Kg__c = 70);
        FA_PerformanceDomain.calculateBMI(m);
        System.assertEquals(null, m.BMI__c);
    }

    @isTest
    static void testCalculateBMI_zeroHeight() {
        FA_Morphological_Measure__c m = new FA_Morphological_Measure__c(
            Height_Cm__c = 0, Weight_Kg__c = 70
        );
        FA_PerformanceDomain.calculateBMI(m);
        System.assertEquals(null, m.BMI__c);
    }

    @isTest
    static void testGetFitnessLevel_optimal() {
        System.assertEquals('Optimal', FA_PerformanceDomain.getFitnessLevel(1.0));
        System.assertEquals('Optimal', FA_PerformanceDomain.getFitnessLevel(0.8));
        System.assertEquals('Optimal', FA_PerformanceDomain.getFitnessLevel(1.3));
    }

    @isTest
    static void testGetFitnessLevel_undertrained() {
        System.assertEquals('Under-trained', FA_PerformanceDomain.getFitnessLevel(0.5));
    }

    @isTest
    static void testGetFitnessLevel_overtrained() {
        System.assertEquals('Over-trained', FA_PerformanceDomain.getFitnessLevel(1.5));
    }

    @isTest
    static void testGetFitnessLevel_null() {
        System.assertEquals('Unknown', FA_PerformanceDomain.getFitnessLevel(null));
    }
}