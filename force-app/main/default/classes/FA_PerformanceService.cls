/**
 * @description [SM] Service class for GPS data, physical programs, fitness tests,
 * and morphological measures.
 * Orchestrates FA_PerformanceSelector (SOQL) and FA_PerformanceDomain (logic).
 * Only layer authorized to perform DML.
 * @author Football Academy
 * @date 2026
 */
public with sharing class FA_PerformanceService {

    // ==================== GPS DATA ====================

    public static List<FA_GPS_Data__c> getGpsData(Id playerId, Id sessionId, Date startDate, Date endDate) {
        return FA_PerformanceSelector.getGpsData(playerId, sessionId, startDate, endDate);
    }

    public static Map<String, Decimal> getPlayerGpsAverages(Id playerId, Integer lastNDays) {
        Date fromDate = Date.today().addDays(-lastNDays);
        List<AggregateResult> agg = FA_PerformanceSelector.getPlayerGpsAverages(playerId, fromDate);

        Map<String, Decimal> result = new Map<String, Decimal>();
        if (!agg.isEmpty()) {
            AggregateResult ar = agg[0];
            result.put('avgDistance',   (Decimal) ar.get('avgDist'));
            result.put('avgMaxSpeed',   (Decimal) ar.get('avgMaxSpeed'));
            result.put('avgSprints',    (Decimal) ar.get('avgSprints'));
            result.put('avgHeartRate',  (Decimal) ar.get('avgHR'));
            result.put('avgACWR',       (Decimal) ar.get('avgACWR'));
            result.put('sessionCount',  (Decimal) ar.get('cnt'));
        }
        return result;
    }

    public static FA_GPS_Data__c createGpsData(FA_GPS_Data__c gps) {
        gps.Name = 'GPS-' + String.valueOf(gps.Record_Date__c);
        insert gps;
        return gps;
    }

    public static List<FA_GPS_Data__c> bulkImportGpsData(List<FA_GPS_Data__c> records) {
        for (FA_GPS_Data__c r : records) {
            r.Name = 'GPS-' + String.valueOf(r.Record_Date__c);
        }
        insert records;
        return records;
    }

    // ==================== PHYSICAL PROGRAMS ====================

    public static List<FA_Physical_Program__c> getPhysicalPrograms(Id categoryId, String status) {
        return FA_PerformanceSelector.getPhysicalPrograms(categoryId, status);
    }

    public static FA_Physical_Program__c createPhysicalProgram(FA_Physical_Program__c prog) {
        insert prog;
        return prog;
    }

    // ==================== FITNESS TESTS ====================

    public static List<FA_Fitness_Test__c> getFitnessTests(Id playerId, String testType) {
        return FA_PerformanceSelector.getFitnessTests(playerId, testType);
    }

    public static FA_Fitness_Test__c createFitnessTest(FA_Fitness_Test__c test) {
        test.Name = test.Test_Type__c + ' - ' + String.valueOf(test.Test_Date__c);
        insert test;
        return test;
    }

    // ==================== MORPHOLOGICAL MEASURES ====================

    public static List<FA_Morphological_Measure__c> getMorphologicalMeasures(Id playerId) {
        return FA_PerformanceSelector.getMorphologicalMeasures(playerId);
    }

    public static FA_Morphological_Measure__c createMorphologicalMeasure(FA_Morphological_Measure__c measure) {
        FA_PerformanceDomain.calculateBMI(measure);
        measure.Name = 'Mesure-' + String.valueOf(measure.Measure_Date__c);
        insert measure;
        return measure;
    }
}
