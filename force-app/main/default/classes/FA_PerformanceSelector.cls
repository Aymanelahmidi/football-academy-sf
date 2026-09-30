/**
 * @description [EM] Selector for GPS data, physical programs, fitness tests, morphological measures.
 * All SOQL uses Database.queryWithBinds + AccessLevel.USER_MODE to enforce FLS.
 * No DML, no business logic.
 * @author Football Academy
 * @date 2026
 */
public with sharing class FA_PerformanceSelector {

    public static List<FA_GPS_Data__c> getGpsData(Id playerId, Id sessionId, Date startDate, Date endDate) {
        String query =
            'SELECT Id, Name, Player__c, Player__r.First_Name__c, Player__r.Last_Name__c, ' +
            'Player__r.Category__r.Short_Name__c, Training_Session__c, Match__c, ' +
            'Preparateur__c, Preparateur__r.Display_Name__c, Record_Date__c, Context__c, ' +
            'Total_Distance_Km__c, Max_Speed_Kmh__c, Avg_Speed_Kmh__c, Sprint_Count__c, ' +
            'High_Intensity_Distance__c, Avg_Heart_Rate__c, Max_Heart_Rate__c, Calories_Burned__c, ' +
            'Acute_Load__c, Chronic_Load__c, ACWR_Ratio__c, ' +
            'Zone1_Minutes__c, Zone2_Minutes__c, Zone3_Minutes__c, Zone4_Minutes__c, Zone5_Minutes__c, ' +
            'Notes__c, CreatedDate ' +
            'FROM FA_GPS_Data__c WHERE Id != null';

        Map<String, Object> binds = new Map<String, Object>();

        if (playerId != null) {
            query += ' AND Player__c = :playerId';
            binds.put('playerId', playerId);
        }
        if (sessionId != null) {
            query += ' AND Training_Session__c = :sessionId';
            binds.put('sessionId', sessionId);
        }
        if (startDate != null) {
            query += ' AND Record_Date__c >= :startDate';
            binds.put('startDate', startDate);
        }
        if (endDate != null) {
            query += ' AND Record_Date__c <= :endDate';
            binds.put('endDate', endDate);
        }

        query += ' ORDER BY Record_Date__c DESC LIMIT 500';
        return Database.queryWithBinds(query, binds, AccessLevel.USER_MODE);
    }

    public static List<AggregateResult> getPlayerGpsAverages(Id playerId, Date fromDate) {
        String query =
            'SELECT AVG(Total_Distance_Km__c) avgDist, AVG(Max_Speed_Kmh__c) avgMaxSpeed, ' +
            'AVG(Sprint_Count__c) avgSprints, AVG(Avg_Heart_Rate__c) avgHR, ' +
            'AVG(ACWR_Ratio__c) avgACWR, COUNT(Id) cnt ' +
            'FROM FA_GPS_Data__c WHERE Player__c = :playerId AND Record_Date__c >= :fromDate';
        Map<String, Object> binds = new Map<String, Object>{
            'playerId' => playerId,
            'fromDate' => fromDate
        };
        return (List<AggregateResult>) Database.queryWithBinds(query, binds, AccessLevel.USER_MODE);
    }

    public static List<FA_Physical_Program__c> getPhysicalPrograms(Id categoryId, String status) {
        String query =
            'SELECT Id, Name, Category__c, Category__r.Name, ' +
            'Preparateur__c, Preparateur__r.Display_Name__c, Type__c, ' +
            'Start_Date__c, End_Date__c, Objectives__c, Description__c, ' +
            'Weekly_Frequency__c, Status__c, CreatedDate ' +
            'FROM FA_Physical_Program__c WHERE Id != null';

        Map<String, Object> binds = new Map<String, Object>();

        if (categoryId != null) {
            query += ' AND Category__c = :categoryId';
            binds.put('categoryId', categoryId);
        }
        if (String.isNotBlank(status)) {
            query += ' AND Status__c = :status';
            binds.put('status', status);
        }

        query += ' ORDER BY Start_Date__c DESC';
        return Database.queryWithBinds(query, binds, AccessLevel.USER_MODE);
    }

    public static List<FA_Fitness_Test__c> getFitnessTests(Id playerId, String testType) {
        String query =
            'SELECT Id, Name, Player__c, Player__r.First_Name__c, Player__r.Last_Name__c, ' +
            'Player__r.Category__r.Short_Name__c, Test_Date__c, Test_Type__c, ' +
            'Result__c, Unit__c, Percentile__c, ' +
            'Evaluator__c, Evaluator__r.Display_Name__c, Notes__c, CreatedDate ' +
            'FROM FA_Fitness_Test__c WHERE Id != null';

        Map<String, Object> binds = new Map<String, Object>();

        if (playerId != null) {
            query += ' AND Player__c = :playerId';
            binds.put('playerId', playerId);
        }
        if (String.isNotBlank(testType)) {
            query += ' AND Test_Type__c = :testType';
            binds.put('testType', testType);
        }

        query += ' ORDER BY Test_Date__c DESC';
        return Database.queryWithBinds(query, binds, AccessLevel.USER_MODE);
    }

    public static List<FA_Morphological_Measure__c> getMorphologicalMeasures(Id playerId) {
        String query =
            'SELECT Id, Name, Player__c, Measure_Date__c, ' +
            'Height_Cm__c, Weight_Kg__c, Body_Fat_Percent__c, ' +
            'Muscle_Mass_Kg__c, BMI__c, Arm_Span_Cm__c, Notes__c, CreatedDate ' +
            'FROM FA_Morphological_Measure__c WHERE Player__c = :playerId ' +
            'ORDER BY Measure_Date__c DESC';
        Map<String, Object> binds = new Map<String, Object>{ 'playerId' => playerId };
        return Database.queryWithBinds(query, binds, AccessLevel.USER_MODE);
    }
}
