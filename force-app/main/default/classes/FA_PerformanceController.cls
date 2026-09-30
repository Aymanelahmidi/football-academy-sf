/**
 * @description Lightning controller for GPS, Physical Prep, Fitness Tests, and Morphology pages.
 * @author Football Academy Migration
 * @date 2026
 */
public with sharing class FA_PerformanceController {

    // ==================== GPS ====================

    @AuraEnabled(cacheable=true)
    public static List<FA_GPS_Data__c> getGpsData(Id playerId, Id sessionId, Date startDate, Date endDate) {
        return FA_PerformanceService.getGpsData(playerId, sessionId, startDate, endDate);
    }

    @AuraEnabled(cacheable=true)
    public static Map<String, Decimal> getPlayerGpsAverages(Id playerId, Integer lastNDays) {
        return FA_PerformanceService.getPlayerGpsAverages(playerId, lastNDays);
    }

    @AuraEnabled
    public static FA_GPS_Data__c createGpsData(FA_GPS_Data__c gps) {
        return FA_PerformanceService.createGpsData(gps);
    }

    @AuraEnabled
    public static List<FA_GPS_Data__c> bulkImportGpsData(List<FA_GPS_Data__c> records) {
        return FA_PerformanceService.bulkImportGpsData(records);
    }

    // ==================== PHYSICAL PROGRAMS ====================

    @AuraEnabled(cacheable=true)
    public static List<FA_Physical_Program__c> getPhysicalPrograms(Id categoryId, String status) {
        return FA_PerformanceService.getPhysicalPrograms(categoryId, status);
    }

    @AuraEnabled
    public static FA_Physical_Program__c createPhysicalProgram(FA_Physical_Program__c prog) {
        return FA_PerformanceService.createPhysicalProgram(prog);
    }

    // ==================== FITNESS TESTS ====================

    @AuraEnabled(cacheable=true)
    public static List<FA_Fitness_Test__c> getFitnessTests(Id playerId, String testType) {
        return FA_PerformanceService.getFitnessTests(playerId, testType);
    }

    @AuraEnabled
    public static FA_Fitness_Test__c createFitnessTest(FA_Fitness_Test__c test) {
        return FA_PerformanceService.createFitnessTest(test);
    }

    // ==================== MORPHOLOGY ====================

    @AuraEnabled(cacheable=true)
    public static List<FA_Morphological_Measure__c> getMorphologicalMeasures(Id playerId) {
        return FA_PerformanceService.getMorphologicalMeasures(playerId);
    }

    @AuraEnabled
    public static FA_Morphological_Measure__c createMorphologicalMeasure(FA_Morphological_Measure__c measure) {
        return FA_PerformanceService.createMorphologicalMeasure(measure);
    }
}
