/**
 * @description Test data factory for Football Academy test classes.
 * Creates consistent test data across all test methods.
 * @author Football Academy Migration
 * @date 2026
 */
@isTest
public class FA_TestDataFactory {

    public static FA_Category__c createCategory(String name, String shortName, Integer ageMin, Integer ageMax) {
        FA_Category__c cat = new FA_Category__c(
            Name = name,
            Short_Name__c = shortName,
            Age_Min__c = ageMin,
            Age_Max__c = ageMax,
            Color__c = '#3b82f6',
            Max_Players__c = 25,
            Is_Active__c = true
        );
        insert cat;
        return cat;
    }

    public static FA_Player__c createPlayer(String firstName, String lastName, Id categoryId, String position) {
        FA_Player__c player = new FA_Player__c(
            Name = firstName + ' ' + lastName,
            First_Name__c = firstName,
            Last_Name__c = lastName,
            Date_of_Birth__c = Date.today().addYears(-15),
            Nationality__c = 'Marocain',
            Category__c = categoryId,
            Position__c = position,
            Preferred_Foot__c = 'Right',
            Height__c = 170,
            Weight__c = 60,
            Jersey_Number__c = 10,
            Status__c = 'Active',
            Join_Date__c = Date.today().addMonths(-6),
            Is_Active__c = true
        );
        insert player;
        return player;
    }

    public static FA_Staff_Profile__c createStaff(String displayName, String role) {
        FA_Staff_Profile__c staff = new FA_Staff_Profile__c(
            Name = displayName,
            Display_Name__c = displayName,
            Staff_Role__c = role,
            User__c = UserInfo.getUserId()
        );
        insert staff;
        return staff;
    }

    public static FA_Training_Session__c createSession(Id categoryId, Id coachId, Date sessionDate) {
        FA_Training_Session__c session = new FA_Training_Session__c(
            Name = 'Entraînement ' + String.valueOf(sessionDate),
            Category__c = categoryId,
            Coach__c = coachId,
            Session_Date__c = sessionDate,
            Start_Time__c = '09:00',
            End_Time__c = '10:30',
            Location__c = 'Terrain Principal',
            Type__c = 'Technical',
            Status__c = 'Scheduled'
        );
        insert session;
        return session;
    }

    public static FA_Match__c createMatch(Id categoryId, String opponent, Date matchDate) {
        FA_Match__c m = new FA_Match__c(
            Name = 'vs ' + opponent + ' - ' + String.valueOf(matchDate),
            Category__c = categoryId,
            Opponent__c = opponent,
            Match_Date__c = matchDate,
            Kickoff_Time__c = '15:00',
            Location__c = 'Stade Municipal',
            Is_Home__c = true,
            Goals_For__c = 2,
            Goals_Against__c = 1,
            Status__c = 'Completed'
        );
        insert m;
        return m;
    }

    public static FA_GPS_Data__c createGpsData(Id playerId, Id sessionId, Date recordDate) {
        FA_GPS_Data__c gps = new FA_GPS_Data__c(
            Name = 'GPS-' + String.valueOf(recordDate),
            Player__c = playerId,
            Training_Session__c = sessionId,
            Record_Date__c = recordDate,
            Context__c = 'Entraînement',
            Total_Distance_Km__c = 8.5,
            Max_Speed_Kmh__c = 28.3,
            Avg_Speed_Kmh__c = 7.2,
            Sprint_Count__c = 12,
            High_Intensity_Distance__c = 1.8,
            Avg_Heart_Rate__c = 155,
            Max_Heart_Rate__c = 188,
            Calories_Burned__c = 650,
            Acute_Load__c = 450,
            Chronic_Load__c = 420,
            ACWR_Ratio__c = 1.07,
            Zone1_Minutes__c = 10,
            Zone2_Minutes__c = 20,
            Zone3_Minutes__c = 25,
            Zone4_Minutes__c = 15,
            Zone5_Minutes__c = 5
        );
        insert gps;
        return gps;
    }

    public static FA_Injury__c createInjury(Id playerId, String type, String bodyPart, Date injuryDate) {
        FA_Injury__c injury = new FA_Injury__c(
            Name = type + ' - ' + bodyPart,
            Player__c = playerId,
            Type__c = type,
            Body_Part__c = bodyPart,
            Severity__c = 'Minor',
            Injury_Date__c = injuryDate,
            Expected_Return_Date__c = injuryDate.addDays(14),
            Status__c = 'In Treatment'
        );
        insert injury;
        return injury;
    }

    public static FA_Evaluation__c createEvaluation(Id playerId, Date evalDate) {
        FA_Evaluation__c eval = new FA_Evaluation__c(
            Name = 'Eval-' + String.valueOf(evalDate),
            Player__c = playerId,
            Evaluation_Date__c = evalDate,
            Type__c = 'Monthly',
            Technical_Score__c = 75,
            Tactical_Score__c = 70,
            Physical_Score__c = 80,
            Mental_Score__c = 72,
            Speed_Score__c = 78,
            Endurance_Score__c = 74,
            Overall_Score__c = 75
        );
        insert eval;
        return eval;
    }

    public static FA_Competition__c createCompetition(String name, String type) {
        FA_Competition__c comp = new FA_Competition__c(
            Name = name,
            Type__c = type,
            Season__c = '2025-2026',
            Start_Date__c = Date.today().addMonths(-3),
            End_Date__c = Date.today().addMonths(3),
            Is_Active__c = true
        );
        insert comp;
        return comp;
    }

    public static FA_Medical_Record__c createMedicalRecord(Id playerId) {
        FA_Medical_Record__c record = new FA_Medical_Record__c(
            Name = 'Dossier-' + playerId,
            Player__c = playerId,
            Blood_Type__c = 'O+',
            Fitness_Status__c = 'Fit',
            Last_Checkup_Date__c = Date.today().addMonths(-1),
            Allergies__c = 'None',
            Chronic_Conditions__c = 'None'
        );
        insert record;
        return record;
    }

    public static FA_Physical_Program__c createPhysicalProgram(Id categoryId, Id staffId) {
        FA_Physical_Program__c prog = new FA_Physical_Program__c(
            Name = 'Programme Préparation Physique',
            Category__c = categoryId,
            Preparateur__c = staffId,
            Type__c = 'Strength',
            Status__c = 'Active',
            Start_Date__c = Date.today(),
            End_Date__c = Date.today().addMonths(2),
            Objectives__c = 'Améliorer la force et la résistance',
            Weekly_Frequency__c = 3
        );
        insert prog;
        return prog;
    }

    public static FA_Fitness_Test__c createFitnessTest(Id playerId, Id evaluatorId, String testType) {
        FA_Fitness_Test__c test = new FA_Fitness_Test__c(
            Name = testType + ' - ' + String.valueOf(Date.today()),
            Player__c = playerId,
            Evaluator__c = evaluatorId,
            Test_Date__c = Date.today(),
            Test_Type__c = testType,
            Result__c = 55.0,
            Unit__c = 'ml/kg/min',
            Percentile__c = 75
        );
        insert test;
        return test;
    }

    public static FA_Morphological_Measure__c createMorphologicalMeasure(Id playerId) {
        FA_Morphological_Measure__c measure = new FA_Morphological_Measure__c(
            Name = 'Mesure-' + String.valueOf(Date.today()),
            Player__c = playerId,
            Measure_Date__c = Date.today(),
            Height_Cm__c = 175,
            Weight_Kg__c = 68,
            BMI__c = 22.2,
            Body_Fat_Percent__c = 12.5,
            Muscle_Mass_Kg__c = 55.0,
            Arm_Span_Cm__c = 180
        );
        insert measure;
        return measure;
    }

    public static FA_Video_Analysis__c createVideoAnalysis(Id matchId, Id analystId) {
        FA_Video_Analysis__c video = new FA_Video_Analysis__c(
            Name = 'Analyse Vidéo - ' + String.valueOf(Date.today()),
            Match__c = matchId,
            Analyst__c = analystId,
            Analysis_Date__c = Date.today(),
            Type__c = 'Full Match',
            Status__c = 'In Progress',
            Duration__c = 90,
            Description__c = 'Analyse complète du match'
        );
        insert video;
        return video;
    }

    public static FA_Transaction__c createTransaction(Id playerId, String type, Decimal amount) {
        FA_Transaction__c trans = new FA_Transaction__c(
            Name = type + ' - ' + String.valueOf(Date.today()),
            Player__c = playerId,
            Type__c = type,
            Amount__c = amount,
            Transaction_Date__c = Date.today(),
            Description__c = 'Transaction test',
            Category__c = 'Registration',
            Payment_Method__c = 'Bank Transfer',
            Status__c = 'Payé'
        );
        insert trans;
        return trans;
    }

    public static FA_Document__c createDocument(Id playerId, String type) {
        FA_Document__c doc = new FA_Document__c(
            Name = type + ' - ' + String.valueOf(Date.today()),
            Player__c = playerId,
            Type__c = type,
            Status__c = 'Valide',
            Expiry_Date__c = Date.today().addYears(1),
            File_URL__c = 'https://example.com/doc.pdf'
        );
        insert doc;
        return doc;
    }

    public static FA_Contract__c createContract(Id playerId) {
        FA_Contract__c contract = new FA_Contract__c(
            Name = 'Contrat - ' + String.valueOf(Date.today()),
            Player__c = playerId,
            Type__c = 'Academy',
            Start_Date__c = Date.today(),
            End_Date__c = Date.today().addYears(1),
            Monthly_Fee__c = 500,
            Status__c = 'Active'
        );
        insert contract;
        return contract;
    }

    public static FA_Legal_Guardian__c createLegalGuardian(Id playerId) {
        FA_Legal_Guardian__c guardian = new FA_Legal_Guardian__c(
            Name = 'Tuteur Test',
            Player__c = playerId,
            First_Name__c = 'Ahmed',
            Last_Name__c = 'Benali',
            Relationship__c = 'Père',
            Phone__c = '+212600000000',
            Email__c = 'ahmed.benali@example.com',
            Is_Primary__c = true
        );
        insert guardian;
        return guardian;
    }

    /**
     * @description Create a full test dataset with all related records
     */
    public static Map<String, Object> createFullTestData() {
        Map<String, Object> data = new Map<String, Object>();

        FA_Category__c cat = createCategory('U15', 'U15', 14, 15);
        data.put('category', cat);

        FA_Staff_Profile__c coach = createStaff('Coach Dupont', 'Coach');
        data.put('coach', coach);

        FA_Player__c player = createPlayer('Youssef', 'Benali', cat.Id, 'Midfielder');
        data.put('player', player);

        FA_Training_Session__c session = createSession(cat.Id, coach.Id, Date.today());
        data.put('session', session);

        FA_Match__c match = createMatch(cat.Id, 'AS Rabat', Date.today().addDays(-7));
        data.put('match', match);

        FA_GPS_Data__c gps = createGpsData(player.Id, session.Id, Date.today());
        data.put('gps', gps);

        return data;
    }
}
