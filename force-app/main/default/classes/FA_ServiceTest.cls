/**
 * @description Test class for all Football Academy service and controller classes.
 * Provides >75% code coverage for deployment.
 * @author Football Academy Migration
 * @date 2026
 */
@isTest
private class FA_ServiceTest {

    @TestSetup
    static void setup() {
        FA_TestDataFactory.createFullTestData();
    }

    // ==================== PLAYER TESTS ====================

    @isTest
    static void testGetPlayers() {
        FA_Category__c cat = [SELECT Id FROM FA_Category__c LIMIT 1];
        List<FA_Player__c> players = FA_PlayerService.getPlayers(cat.Id, 'Active', null);
        System.assert(!players.isEmpty(), 'Should return at least one player');
    }

    @isTest
    static void testGetPlayerById() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        FA_Player__c result = FA_PlayerService.getPlayerById(player.Id);
        System.assertNotEquals(null, result, 'Should return a player');
        System.assertEquals('Youssef', result.First_Name__c);
    }

    @isTest
    static void testGetPlayerStats() {
        Map<String, Object> stats = FA_PlayerService.getPlayerStats();
        System.assert(stats.containsKey('totalPlayers'), 'Should contain totalPlayers');
        System.assertEquals(1, (Integer) stats.get('totalPlayers'));
    }

    @isTest
    static void testCreatePlayer() {
        FA_Category__c cat = [SELECT Id FROM FA_Category__c LIMIT 1];
        FA_Player__c newPlayer = new FA_Player__c(
            First_Name__c = 'Karim',
            Last_Name__c = 'Zidane',
            Date_of_Birth__c = Date.today().addYears(-14),
            Category__c = cat.Id,
            Position__c = 'Forward',
            Status__c = 'Active',
            Is_Active__c = true
        );
        FA_Player__c result = FA_PlayerService.createPlayer(newPlayer);
        System.assertNotEquals(null, result.Id, 'Should have an Id');
        System.assertEquals('Karim Zidane', result.Name);
    }

    @isTest
    static void testDeactivatePlayer() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        FA_PlayerService.deactivatePlayer(player.Id);
        FA_Player__c updated = [SELECT Is_Active__c FROM FA_Player__c WHERE Id = :player.Id];
        System.assertEquals(false, updated.Is_Active__c);
    }

    @isTest
    static void testPlayerController() {
        FA_Category__c cat = [SELECT Id FROM FA_Category__c LIMIT 1];
        List<FA_Player__c> players = FA_PlayerController.getPlayers(cat.Id, null, null);
        System.assert(!players.isEmpty());

        List<FA_Category__c> categories = FA_PlayerController.getCategories();
        System.assert(!categories.isEmpty());
    }

    // ==================== TRAINING TESTS ====================

    @isTest
    static void testGetSessions() {
        List<FA_Training_Session__c> sessions = FA_TrainingService.getSessions(null, null, null);
        System.assert(!sessions.isEmpty(), 'Should return sessions');
    }

    @isTest
    static void testGetSessionById() {
        FA_Training_Session__c session = [SELECT Id FROM FA_Training_Session__c LIMIT 1];
        FA_Training_Session__c result = FA_TrainingService.getSessionById(session.Id);
        System.assertNotEquals(null, result);
    }

    @isTest
    static void testAttendance() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        FA_Training_Session__c session = [SELECT Id FROM FA_Training_Session__c LIMIT 1];

        FA_Attendance__c att = new FA_Attendance__c(
            Player__c = player.Id,
            Training_Session__c = session.Id,
            Attendance_Date__c = Date.today(),
            Status__c = 'Present'
        );
        FA_Attendance__c result = FA_TrainingService.upsertAttendance(att);
        System.assertNotEquals(null, result.Id);

        List<FA_Attendance__c> attendanceList = FA_TrainingService.getAttendanceForSession(session.Id);
        System.assert(!attendanceList.isEmpty());
    }

    @isTest
    static void testAttendanceStats() {
        Map<String, Object> stats = FA_TrainingService.getAttendanceStats();
        System.assert(stats.containsKey('totalRecords'));
    }

    // ==================== MATCH TESTS ====================

    @isTest
    static void testGetMatches() {
        List<FA_Match__c> matches = FA_MatchService.getMatches(null, null, null, null);
        System.assert(!matches.isEmpty());
    }

    @isTest
    static void testGetMatchStats() {
        Map<String, Object> stats = FA_MatchService.getMatchStats();
        System.assert(stats.containsKey('wins'));
        System.assertEquals(1, (Integer) stats.get('wins'));
    }

    // ==================== MEDICAL TESTS ====================

    @isTest
    static void testCreateAndGetInjury() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        FA_Injury__c injury = FA_TestDataFactory.createInjury(player.Id, 'Entorse', 'Cheville', Date.today());

        List<FA_Injury__c> injuries = FA_MedicalService.getInjuries(player.Id, null);
        System.assert(!injuries.isEmpty());

        // Test healing
        injury.Status__c = 'Recovered';
        injury.Actual_Return_Date__c = Date.today();
        FA_MedicalService.updateInjury(injury);

        FA_Player__c updated = [SELECT Status__c FROM FA_Player__c WHERE Id = :player.Id];
        System.assertEquals('Active', updated.Status__c);
    }

    @isTest
    static void testMedicalAccessLog() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        FA_MedicalService.logMedicalAccess(UserInfo.getUserId(), player.Id, 'Consultation', 'Test access');

        List<FA_Medical_Access_Log__c> logs = FA_MedicalService.getAccessLogs(player.Id);
        System.assert(!logs.isEmpty());
    }

    // ==================== GPS TESTS ====================

    @isTest
    static void testGetGpsData() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        List<FA_GPS_Data__c> data = FA_PerformanceService.getGpsData(player.Id, null, null, null);
        System.assert(!data.isEmpty());
    }

    @isTest
    static void testGetPlayerGpsAverages() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        Map<String, Decimal> avgs = FA_PerformanceService.getPlayerGpsAverages(player.Id, 30);
        System.assert(avgs.containsKey('avgDistance'));
    }

    // ==================== EVALUATION TESTS ====================

    @isTest
    static void testCreateEvaluation() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        FA_Evaluation__c eval = FA_TestDataFactory.createEvaluation(player.Id, Date.today());
        System.assertNotEquals(null, eval.Id);

        List<FA_Evaluation__c> evals = FA_EvaluationService.getEvaluations(player.Id, null);
        System.assert(!evals.isEmpty());
    }

    // ==================== FINANCE TESTS ====================

    @isTest
    static void testFinances() {
        FA_Transaction__c trans = new FA_Transaction__c(
            Type__c = 'Revenue',
            Category__c = 'Cotisation',
            Description__c = 'Cotisation mensuelle',
            Amount__c = 500,
            Transaction_Date__c = Date.today(),
            Status__c = 'Payé'
        );
        FA_Transaction__c result = FA_EvaluationService.createTransaction(trans);
        System.assertNotEquals(null, result.Id);

        Map<String, Object> stats = FA_EvaluationService.getFinanceStats();
        System.assert(stats.containsKey('totalRevenue'));
    }

    // ==================== DASHBOARD TESTS ====================

    @isTest
    static void testDashboardStats() {
        Map<String, Object> stats = FA_DashboardController.getDashboardStats();
        System.assert(stats.containsKey('playerStats'));
        System.assert(stats.containsKey('matchStats'));
        System.assert(stats.containsKey('medicalStats'));
    }

    @isTest
    static void testRecentActivity() {
        Map<String, Object> activity = FA_DashboardController.getRecentActivity();
        System.assert(activity.containsKey('recentMatches'));
    }

    @isTest
    static void testUpcomingEvents() {
        List<Map<String, Object>> events = FA_DashboardController.getUpcomingEvents();
        System.assertNotEquals(null, events);
    }

    // ==================== VIDEO TESTS ====================

    @isTest
    static void testVideoAnalysis() {
        FA_Match__c m = [SELECT Id FROM FA_Match__c LIMIT 1];
        FA_Video_Analysis__c video = new FA_Video_Analysis__c(
            Name = 'Analyse Match Test',
            Match__c = m.Id,
            Analysis_Date__c = Date.today(),
            Type__c = 'Full Match',
            Status__c = 'In Progress'
        );
        FA_Video_Analysis__c result = FA_VideoService.createVideoAnalysis(video);
        System.assertNotEquals(null, result.Id);

        FA_Video_Annotation__c annotation = new FA_Video_Annotation__c(
            Video_Analysis__c = result.Id,
            Timestamp__c = 45,
            Type__c = 'Goal',
            Label__c = 'But de Youssef'
        );
        FA_Video_Annotation__c annResult = FA_VideoService.addAnnotation(annotation);
        System.assertNotEquals(null, annResult.Id);

        List<FA_Video_Analysis__c> analyses = FA_VideoService.getVideoAnalyses(m.Id, null, null);
        System.assert(!analyses.isEmpty());
    }

    // ==================== PHYSICAL PROGRAM TESTS ====================

    @isTest
    static void testPhysicalPrograms() {
        FA_Category__c cat = [SELECT Id FROM FA_Category__c LIMIT 1];
        FA_Physical_Program__c prog = new FA_Physical_Program__c(
            Name = 'Programme Force U15',
            Category__c = cat.Id,
            Type__c = 'Strength',
            Start_Date__c = Date.today(),
            End_Date__c = Date.today().addMonths(3),
            Weekly_Frequency__c = 3,
            Status__c = 'Active'
        );
        FA_Physical_Program__c result = FA_PerformanceService.createPhysicalProgram(prog);
        System.assertNotEquals(null, result.Id);
    }

    // ==================== MORPHOLOGY TESTS ====================

    @isTest
    static void testMorphologicalMeasures() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        FA_Morphological_Measure__c measure = new FA_Morphological_Measure__c(
            Player__c = player.Id,
            Measure_Date__c = Date.today(),
            Height_Cm__c = 172,
            Weight_Kg__c = 62,
            Body_Fat_Percent__c = 12
        );
        FA_Morphological_Measure__c result = FA_PerformanceService.createMorphologicalMeasure(measure);
        System.assertNotEquals(null, result.Id);
        System.assertNotEquals(null, result.BMI__c, 'BMI should be auto-calculated');

        List<FA_Morphological_Measure__c> measures = FA_PerformanceService.getMorphologicalMeasures(player.Id);
        System.assert(!measures.isEmpty());
    }

    // ==================== MATCH CONTROLLER TESTS ====================

    @isTest
    static void testMatchControllerFull() {
        FA_Category__c cat = [SELECT Id FROM FA_Category__c LIMIT 1];
        FA_Match__c m = [SELECT Id FROM FA_Match__c LIMIT 1];

        // getMatches with category filter
        List<FA_Match__c> matches = FA_MatchController.getMatches(cat.Id, 'Completed', null, null);
        System.assert(!matches.isEmpty());

        // getMatchById
        FA_Match__c result = FA_MatchController.getMatchById(m.Id);
        System.assertNotEquals(null, result);

        // getMatchStats
        Map<String, Object> stats = FA_MatchController.getMatchStats();
        System.assert(stats.containsKey('wins'));

        // createMatch (auto-generates Name)
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        FA_Match__c newMatch = new FA_Match__c(
            Category__c = cat.Id,
            Opponent__c = 'FAR Rabat',
            Match_Date__c = Date.today().addDays(10),
            Kickoff_Time__c = '15:00',
            Location__c = 'Stade Test',
            Is_Home__c = true,
            Status__c = 'Scheduled'
        );
        FA_Match__c created = FA_MatchController.createMatch(newMatch);
        System.assertNotEquals(null, created.Id);

        // addMatchEvent
        FA_Match_Event__c evt = new FA_Match_Event__c(
            Match__c = created.Id,
            Player__c = player.Id,
            Event_Type__c = 'Goal',
            Minute__c = 45
        );
        FA_Match_Event__c evtResult = FA_MatchController.addMatchEvent(evt);
        System.assertNotEquals(null, evtResult.Id);

        // getCompetitions
        List<FA_Competition__c> comps = FA_MatchController.getCompetitions();
        System.assertNotEquals(null, comps);
    }

    @isTest
    static void testMatchFilters() {
        // getMatches with all filter combinations
        List<FA_Match__c> all = FA_MatchService.getMatches(null, null, null, null);
        System.assert(!all.isEmpty());

        List<FA_Match__c> withDate = FA_MatchService.getMatches(null, null, Date.today().addDays(-30), Date.today());
        System.assertNotEquals(null, withDate);
    }

    // ==================== TRAINING CONTROLLER TESTS ====================

    @isTest
    static void testTrainingControllerFull() {
        FA_Category__c cat = [SELECT Id FROM FA_Category__c LIMIT 1];
        FA_Staff_Profile__c coach = [SELECT Id FROM FA_Staff_Profile__c LIMIT 1];
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        FA_Training_Session__c existingSession = [SELECT Id FROM FA_Training_Session__c LIMIT 1];

        // getSessions with filters
        List<FA_Training_Session__c> sessions = FA_TrainingController.getSessions(cat.Id, Date.today().addDays(-7), Date.today().addDays(7));
        System.assertNotEquals(null, sessions);

        // getSessionById via controller
        FA_Training_Session__c sessionById = FA_TrainingController.getSessionById(existingSession.Id);
        System.assertNotEquals(null, sessionById);

        // createSession
        FA_Training_Session__c newSess = new FA_Training_Session__c(
            Name = 'Controller Test Session',
            Category__c = cat.Id,
            Coach__c = coach.Id,
            Session_Date__c = Date.today().addDays(3),
            Start_Time__c = '10:00',
            End_Time__c = '11:30',
            Location__c = 'Terrain B',
            Type__c = 'Physical',
            Status__c = 'Scheduled'
        );
        FA_Training_Session__c created = FA_TrainingController.createSession(newSess);
        System.assertNotEquals(null, created.Id);

        // updateSession
        created.Location__c = 'Terrain C';
        FA_Training_Session__c updated = FA_TrainingController.updateSession(created);
        System.assertEquals('Terrain C', updated.Location__c);

        // getAttendanceForSession
        List<FA_Attendance__c> attList = FA_TrainingController.getAttendanceForSession(created.Id);
        System.assertNotEquals(null, attList);

        // upsertAttendance - insert path
        FA_Attendance__c att = new FA_Attendance__c(
            Player__c = player.Id,
            Training_Session__c = created.Id,
            Attendance_Date__c = Date.today().addDays(3),
            Status__c = 'Present'
        );
        FA_Attendance__c attResult = FA_TrainingController.upsertAttendance(att);
        System.assertNotEquals(null, attResult.Id);

        // upsertAttendance - update path (same player+session)
        FA_Attendance__c att2 = new FA_Attendance__c(
            Player__c = player.Id,
            Training_Session__c = created.Id,
            Attendance_Date__c = Date.today().addDays(3),
            Status__c = 'Late'
        );
        FA_TrainingController.upsertAttendance(att2);

        // bulkUpsertAttendance - insert then update paths
        FA_Category__c cat2 = FA_TestDataFactory.createCategory('U10', 'U10', 9, 10);
        FA_Staff_Profile__c coach2 = FA_TestDataFactory.createStaff('Coach Test', 'Coach');
        FA_Player__c player2 = FA_TestDataFactory.createPlayer('Ali', 'Hassan', cat2.Id, 'Goalkeeper');
        FA_Training_Session__c sess2 = FA_TestDataFactory.createSession(cat2.Id, coach2.Id, Date.today().addDays(4));

        List<FA_Attendance__c> attBulk = new List<FA_Attendance__c>{
            new FA_Attendance__c(Player__c = player2.Id, Training_Session__c = sess2.Id, Attendance_Date__c = Date.today().addDays(4), Status__c = 'Present')
        };
        FA_TrainingController.bulkUpsertAttendance(attBulk);
        // Run again to trigger update path
        FA_TrainingController.bulkUpsertAttendance(attBulk);

        // getAttendanceStats
        Map<String, Object> stats = FA_TrainingController.getAttendanceStats();
        System.assert(stats.containsKey('totalRecords'));

        // deleteSession
        FA_Training_Session__c toDelete = FA_TestDataFactory.createSession(cat.Id, coach.Id, Date.today().addDays(5));
        FA_TrainingController.deleteSession(toDelete.Id);
    }

    // ==================== MEDICAL CONTROLLER TESTS ====================

    @isTest
    static void testMedicalControllerFull() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];

        // getMedicalRecord is no longer cacheable (performs DML for audit log)
        FA_Medical_Record__c medRecord = FA_MedicalController.getMedicalRecord(player.Id);
        // getInjuries via controller
        List<FA_Injury__c> injuries = FA_MedicalController.getInjuries(player.Id, null);
        System.assertNotEquals(null, injuries);

        // getMedicalStats via controller
        Map<String, Object> medStats = FA_MedicalController.getMedicalStats();
        System.assert(medStats.containsKey('activeInjuries'));

        // createInjury via controller (triggers player status update)
        FA_Injury__c newInjury = new FA_Injury__c(
            Player__c = player.Id,
            Type__c = 'Contusion',
            Body_Part__c = 'Knee',
            Severity__c = 'Minor',
            Injury_Date__c = Date.today(),
            Expected_Return_Date__c = Date.today().addDays(7),
            Status__c = 'In Treatment'
        );
        FA_Injury__c createdInjury = FA_MedicalController.createInjury(newInjury);
        System.assertNotEquals(null, createdInjury.Id);

        // updateInjury via controller
        createdInjury.Status__c = 'Recovered';
        createdInjury.Actual_Return_Date__c = Date.today();
        FA_MedicalController.updateInjury(createdInjury);

        // getAccessLogs via controller
        List<FA_Medical_Access_Log__c> logs = FA_MedicalController.getAccessLogs(player.Id);
        System.assertNotEquals(null, logs);

        // getEvaluations via controller with type filter
        List<FA_Evaluation__c> evals = FA_MedicalController.getEvaluations(player.Id, 'Monthly');
        System.assertNotEquals(null, evals);

        // createEvaluation via controller (auto-calculates score)
        FA_Evaluation__c newEval = new FA_Evaluation__c(
            Player__c = player.Id,
            Evaluation_Date__c = Date.today().addDays(1),
            Type__c = 'Monthly',
            Technical_Score__c = 80,
            Tactical_Score__c = 75,
            Physical_Score__c = 85,
            Mental_Score__c = 70
        );
        FA_Evaluation__c createdEval = FA_MedicalController.createEvaluation(newEval);
        System.assertNotEquals(null, createdEval.Id);

        // getTransactions with filters via controller
        List<FA_Transaction__c> trans = FA_MedicalController.getTransactions('Revenue', null, Date.today().addMonths(-1), Date.today());
        System.assertNotEquals(null, trans);

        // getFinanceStats via controller
        Map<String, Object> finStats = FA_MedicalController.getFinanceStats();
        System.assert(finStats.containsKey('totalRevenue'));

        // createTransaction via controller
        FA_Transaction__c newTrans = new FA_Transaction__c(
            Type__c = 'Expense',
            Category__c = 'Equipement',
            Description__c = 'Ballon de foot',
            Amount__c = 250,
            Transaction_Date__c = Date.today(),
            Status__c = 'Payé'
        );
        FA_Transaction__c createdTrans = FA_MedicalController.createTransaction(newTrans);
        System.assertNotEquals(null, createdTrans.Id);

        // getDocuments with filters
        List<FA_Document__c> docs = FA_MedicalController.getDocuments(player.Id, 'Licence', null);
        System.assertNotEquals(null, docs);

        // createDocument
        FA_Document__c newDoc = new FA_Document__c(
            Player__c = player.Id,
            Type__c = 'Licence',
            Name = 'Licence Test'
        );
        FA_Document__c createdDoc = FA_MedicalController.createDocument(newDoc);
        System.assertNotEquals(null, createdDoc.Id);
    }

    // ==================== PERFORMANCE CONTROLLER TESTS ====================

    @isTest
    static void testPerformanceControllerFull() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        FA_Training_Session__c session = [SELECT Id FROM FA_Training_Session__c LIMIT 1];
        FA_Category__c cat = [SELECT Id FROM FA_Category__c LIMIT 1];

        // getGpsData with filters via controller
        List<FA_GPS_Data__c> gpsData = FA_PerformanceController.getGpsData(player.Id, session.Id, Date.today().addDays(-7), Date.today());
        System.assertNotEquals(null, gpsData);

        // getPlayerGpsAverages via controller
        Map<String, Decimal> avgs = FA_PerformanceController.getPlayerGpsAverages(player.Id, 30);
        System.assert(avgs.containsKey('avgDistance'));

        // createGpsData via controller
        FA_GPS_Data__c newGps = new FA_GPS_Data__c(
            Player__c = player.Id,
            Record_Date__c = Date.today().addDays(-1),
            Context__c = 'Entraînement',
            Total_Distance_Km__c = 9.2,
            Max_Speed_Kmh__c = 29.0
        );
        FA_GPS_Data__c createdGps = FA_PerformanceController.createGpsData(newGps);
        System.assertNotEquals(null, createdGps.Id);

        // bulkImportGpsData via controller
        List<FA_GPS_Data__c> bulkGps = new List<FA_GPS_Data__c>{
            new FA_GPS_Data__c(Player__c = player.Id, Record_Date__c = Date.today().addDays(-2), Context__c = 'Match', Total_Distance_Km__c = 10.5, Max_Speed_Kmh__c = 31.0)
        };
        List<FA_GPS_Data__c> imported = FA_PerformanceController.bulkImportGpsData(bulkGps);
        System.assertEquals(1, imported.size());

        // getPhysicalPrograms with filters
        List<FA_Physical_Program__c> progs = FA_PerformanceController.getPhysicalPrograms(cat.Id, 'Active');
        System.assertNotEquals(null, progs);

        // createPhysicalProgram via controller
        FA_Physical_Program__c prog = new FA_Physical_Program__c(
            Name = 'Programme Test',
            Category__c = cat.Id,
            Type__c = 'Endurance',
            Start_Date__c = Date.today(),
            End_Date__c = Date.today().addMonths(2),
            Weekly_Frequency__c = 3,
            Status__c = 'Active'
        );
        FA_PerformanceController.createPhysicalProgram(prog);

        // getFitnessTests with filter
        List<FA_Fitness_Test__c> tests = FA_PerformanceController.getFitnessTests(player.Id, 'Cooper');
        System.assertNotEquals(null, tests);

        // createFitnessTest via controller
        FA_Fitness_Test__c fitnessTest = new FA_Fitness_Test__c(
            Player__c = player.Id,
            Test_Date__c = Date.today(),
            Test_Type__c = 'Cooper',
            Result__c = 2800,
            Unit__c = 'metres'
        );
        FA_Fitness_Test__c createdTest = FA_PerformanceController.createFitnessTest(fitnessTest);
        System.assertNotEquals(null, createdTest.Id);

        // getMorphologicalMeasures via controller
        List<FA_Morphological_Measure__c> morphs = FA_PerformanceController.getMorphologicalMeasures(player.Id);
        System.assertNotEquals(null, morphs);

        // createMorphologicalMeasure via controller
        FA_Morphological_Measure__c measure = new FA_Morphological_Measure__c(
            Player__c = player.Id,
            Measure_Date__c = Date.today().addDays(-1),
            Height_Cm__c = 173,
            Weight_Kg__c = 63
        );
        FA_PerformanceController.createMorphologicalMeasure(measure);
    }

    // ==================== VIDEO CONTROLLER TESTS ====================

    @isTest
    static void testVideoControllerFull() {
        FA_Match__c m = [SELECT Id FROM FA_Match__c LIMIT 1];

        // createVideoAnalysis via controller
        FA_Video_Analysis__c video = new FA_Video_Analysis__c(
            Name = 'Controller Video Test',
            Match__c = m.Id,
            Analysis_Date__c = Date.today(),
            Type__c = 'Full Match',
            Status__c = 'In Progress'
        );
        FA_Video_Analysis__c created = FA_VideoController.createVideoAnalysis(video);
        System.assertNotEquals(null, created.Id);

        // getVideoAnalysisById via controller
        FA_Video_Analysis__c byId = FA_VideoController.getVideoAnalysisById(created.Id);
        System.assertNotEquals(null, byId);

        // getVideoAnalyses with filters
        List<FA_Video_Analysis__c> analyses = FA_VideoController.getVideoAnalyses(m.Id, 'Full Match', 'In Progress');
        System.assert(!analyses.isEmpty());

        // addAnnotation via controller (with null Label — uses Type+Timestamp format)
        FA_Video_Annotation__c ann = new FA_Video_Annotation__c(
            Video_Analysis__c = created.Id,
            Timestamp__c = 30,
            Type__c = 'Goal',
            Label__c = 'Test Goal'
        );
        FA_Video_Annotation__c addedAnn = FA_VideoController.addAnnotation(ann);
        System.assertNotEquals(null, addedAnn.Id);

        // bulkAddAnnotations via controller
        FA_Video_Annotation__c ann2 = new FA_Video_Annotation__c(
            Video_Analysis__c = created.Id,
            Timestamp__c = 60,
            Type__c = 'Tactical'
        );
        List<FA_Video_Annotation__c> bulkAnns = FA_VideoController.bulkAddAnnotations(new List<FA_Video_Annotation__c>{ ann2 });
        System.assertEquals(1, bulkAnns.size());
    }

    // ==================== PLAYER CONTROLLER FULL TESTS ====================

    @isTest
    static void testPlayerControllerFullMethods() {
        FA_Category__c cat = [SELECT Id FROM FA_Category__c LIMIT 1];
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];

        // getPlayerById via controller
        FA_Player__c byId = FA_PlayerController.getPlayerById(player.Id);
        System.assertNotEquals(null, byId);

        // getPlayerStats via controller
        Map<String, Object> stats = FA_PlayerController.getPlayerStats();
        System.assert(stats.containsKey('totalPlayers'));

        // createPlayer via controller
        FA_Player__c newPlayer = new FA_Player__c(
            First_Name__c = 'Omar',
            Last_Name__c = 'Khalid',
            Date_of_Birth__c = Date.today().addYears(-16),
            Category__c = cat.Id,
            Position__c = 'Defender',
            Status__c = 'Active',
            Is_Active__c = true
        );
        FA_Player__c created = FA_PlayerController.createPlayer(newPlayer);
        System.assertNotEquals(null, created.Id);

        // updatePlayer via controller
        created.First_Name__c = 'Omar2';
        FA_Player__c updatedPlayer = FA_PlayerController.updatePlayer(created);
        System.assertEquals('Omar2', updatedPlayer.First_Name__c);

        // deactivatePlayer via controller
        FA_PlayerController.deactivatePlayer(created.Id);
        FA_Player__c deactivated = [SELECT Is_Active__c FROM FA_Player__c WHERE Id = :created.Id];
        System.assertEquals(false, deactivated.Is_Active__c);

        // getPlayersWithInjuryStatus via controller (no injury)
        List<Map<String, Object>> withStatus = FA_PlayerController.getPlayersWithInjuryStatus(cat.Id);
        System.assertNotEquals(null, withStatus);

        // Create injury to test the 'hasActiveInjury' path
        FA_Injury__c injury = FA_TestDataFactory.createInjury(player.Id, 'Entorse', 'Genou', Date.today().addDays(-3));
        List<Map<String, Object>> withInjury = FA_PlayerController.getPlayersWithInjuryStatus(cat.Id);
        System.assertNotEquals(null, withInjury);

        // getPlayerContracts via controller
        List<FA_Contract__c> contracts = FA_PlayerController.getPlayerContracts(player.Id);
        System.assertNotEquals(null, contracts);

        // Create contract and test
        FA_Contract__c contract = new FA_Contract__c(
            Player__c = player.Id,
            Type__c = 'Academy',
            Start_Date__c = Date.today(),
            End_Date__c = Date.today().addYears(1),
            Monthly_Fee__c = 300,
            Status__c = 'Active'
        );
        insert contract;
        contracts = FA_PlayerController.getPlayerContracts(player.Id);
        System.assert(!contracts.isEmpty());

        // getPlayerGuardians via controller
        List<FA_Legal_Guardian__c> guardians = FA_PlayerController.getPlayerGuardians(player.Id);
        System.assertNotEquals(null, guardians);

        // getPlayers with search term
        List<FA_Player__c> searched = FA_PlayerService.getPlayers(null, null, 'You');
        System.assert(!searched.isEmpty());
    }

    // ==================== UPCOMING EVENTS WITH SCHEDULED DATA ====================

    @isTest
    static void testUpcomingEventsScheduled() {
        FA_Category__c cat = [SELECT Id FROM FA_Category__c LIMIT 1];
        FA_Staff_Profile__c coach = [SELECT Id FROM FA_Staff_Profile__c LIMIT 1];

        // Create future scheduled match
        FA_Match__c futureMatch = new FA_Match__c(
            Name = 'Future Match',
            Category__c = cat.Id,
            Opponent__c = 'OC Khouribga',
            Match_Date__c = Date.today().addDays(5),
            Kickoff_Time__c = '16:00',
            Location__c = 'Stade Futur',
            Is_Home__c = false,
            Status__c = 'Scheduled'
        );
        insert futureMatch;

        // Create future scheduled session
        FA_Training_Session__c futureSession = new FA_Training_Session__c(
            Name = 'Future Session',
            Category__c = cat.Id,
            Coach__c = coach.Id,
            Session_Date__c = Date.today().addDays(2),
            Start_Time__c = '09:00',
            End_Time__c = '10:30',
            Location__c = 'Terrain C',
            Type__c = 'Technical',
            Status__c = 'Scheduled'
        );
        insert futureSession;

        List<Map<String, Object>> events = FA_DashboardController.getUpcomingEvents();
        System.assertNotEquals(null, events);
        System.assert(!events.isEmpty(), 'Should have upcoming events');
    }

    // ==================== PLAYER SERVICE EXTRA PATHS ====================

    @isTest
    static void testPlayerUpdateAndExternalIntegration() {
        FA_Player__c player = [SELECT Id, First_Name__c, Last_Name__c FROM FA_Player__c LIMIT 1];
        FA_Category__c cat = [SELECT Id FROM FA_Category__c LIMIT 1];

        // updatePlayer service
        player.First_Name__c = 'YoussefUpdated';
        FA_Player__c updated = FA_PlayerService.updatePlayer(player);
        System.assertEquals('YoussefUpdated', updated.First_Name__c);

        // exportPlayerRegistrations (no HTTP)
        String json = FA_ExternalIntegration.exportPlayerRegistrations(cat.Id);
        System.assertNotEquals(null, json);
        System.assert(json.contains('players'));

        // exportAcademyData (no HTTP)
        String exportData = FA_ExternalIntegration.exportAcademyData();
        System.assertNotEquals(null, exportData);
        System.assert(exportData.contains('players'));

        // notifyGuardians with email channel — no guardians with Is_Primary__c=true → returns 0
        Integer sent = FA_ExternalIntegration.notifyGuardians(cat.Id, 'Test Subject', 'Hello {guardian_name}', new List<String>{'email'});
        System.assertEquals(0, sent);
    }

    // ==================== GPS IMPORT CSV TEST ====================

    @isTest
    static void testGpsImportCSV() {
        FA_Category__c cat = [SELECT Id FROM FA_Category__c LIMIT 1];
        FA_Player__c player = [SELECT Id, First_Name__c, Last_Name__c FROM FA_Player__c LIMIT 1];

        String playerFullName = player.First_Name__c + ' ' + player.Last_Name__c;
        String csvContent = 'player_name,date,distance_km,max_speed,avg_speed,sprints,high_intensity,avg_hr,max_hr,calories\n' +
            playerFullName + ',' + String.valueOf(Date.today()) + ',8.5,28.3,7.2,12,1.8,155,185,650\n' +
            'Unknown Player,' + String.valueOf(Date.today()) + ',7.0,26.0,6.5,10,1.5,150,180,600\n';

        Integer count = FA_GpsIntegration.importFromCSV(csvContent, cat.Id);
        System.assertEquals(1, count, 'Should import 1 record for matched player');
    }

    @isTest
    static void testGpsImportCSVWithExtraColumns() {
        FA_Category__c cat = [SELECT Id FROM FA_Category__c LIMIT 1];
        FA_Player__c player = [SELECT Id, First_Name__c, Last_Name__c FROM FA_Player__c LIMIT 1];

        String playerFullName = player.First_Name__c + ' ' + player.Last_Name__c;
        // CSV with 18 columns (includes ACWR and heart rate zones)
        String csvContent = 'player_name,date,distance_km,max_speed,avg_speed,sprints,high_intensity,avg_hr,max_hr,calories,acute,chronic,acwr,z1,z2,z3,z4,z5\n' +
            playerFullName + ',' + String.valueOf(Date.today().addDays(-1)) + ',9.0,29.0,7.5,14,2.0,158,190,700,480,440,1.09,8,18,27,18,4\n';

        Integer count = FA_GpsIntegration.importFromCSV(csvContent, cat.Id);
        System.assertEquals(1, count);
    }

    // ==================== GPS REST API TEST ====================

    @isTest
    static void testGpsRestApiImport() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];

        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/gps/import';
        req.httpMethod = 'POST';

        Map<String, Object> point = new Map<String, Object>{
            'playerId' => (String) player.Id,
            'date' => String.valueOf(Date.today()),
            'context' => 'Entraînement',
            'distanceKm' => 8.5,
            'maxSpeed' => 28.3,
            'avgSpeed' => 7.2,
            'sprints' => 12,
            'avgHR' => 155,
            'maxHR' => 185,
            'calories' => 650
        };
        Map<String, Object> payload = new Map<String, Object>{
            'data' => new List<Object>{ point }
        };

        req.requestBody = Blob.valueOf(JSON.serialize(payload));
        RestContext.request = req;
        RestContext.response = new RestResponse();

        String response = FA_GpsRestApi.importData();
        System.assert(response.contains('true'));
    }

    // ==================== HTTP CALLOUT MOCK TESTS ====================

    @isTest
    static void testGpsImportCatapult() {
        FA_Category__c cat = [SELECT Id FROM FA_Category__c LIMIT 1];
        FA_Player__c player = [SELECT Id, First_Name__c, Last_Name__c FROM FA_Player__c LIMIT 1];

        String catapultJson = '{"activities":[{"athletes":[{"first_name":"' + player.First_Name__c + '","last_name":"' + player.Last_Name__c + '","metrics":{"total_distance":8500,"max_velocity":7.86,"sprint_count":12,"high_speed_running":1800,"avg_heart_rate":155,"max_heart_rate":185}}]}]}';

        Test.setMock(HttpCalloutMock.class, new FA_MockHttpCallout(200, catapultJson));
        Test.startTest();
        Integer count = FA_GpsIntegration.importFromCatapult(Date.today(), cat.Id);
        Test.stopTest();
        System.assertEquals(1, count);
    }

    @isTest
    static void testGpsImportSTATSports() {
        FA_Category__c cat = [SELECT Id FROM FA_Category__c LIMIT 1];
        FA_Player__c player = [SELECT Id, First_Name__c, Last_Name__c FROM FA_Player__c LIMIT 1];

        String playerName = (player.First_Name__c + ' ' + player.Last_Name__c).toLowerCase();
        String statsJson = '{"sessions":[{"players":[{"name":"' + playerName + '","total_distance":8.5,"top_speed":28.3,"number_of_sprints":12,"average_heart_rate":155,"max_heart_rate":185,"calories":650}]}]}';

        Test.setMock(HttpCalloutMock.class, new FA_MockHttpCallout(200, statsJson));
        Test.startTest();
        Integer count = FA_GpsIntegration.importFromSTATSports(Date.today(), cat.Id);
        Test.stopTest();
        System.assertEquals(1, count);
    }

    @isTest
    static void testGpsImportCatapultError() {
        FA_Category__c cat = [SELECT Id FROM FA_Category__c LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new FA_MockHttpCallout(401, '{"error":"Unauthorized"}'));
        Test.startTest();
        try {
            FA_GpsIntegration.importFromCatapult(Date.today(), cat.Id);
            System.assert(false, 'Should throw exception');
        } catch (AuraHandledException e) {
            System.assert(e.getMessage() != null);
        }
        Test.stopTest();
    }

    @isTest
    static void testVideoImportHudl() {
        FA_Match__c m = [SELECT Id FROM FA_Match__c LIMIT 1];
        String hudlJson = '{"title":"Match vs Rabat","url":"https://hudl.com/v/test","thumbnail":"https://hudl.com/t/test","duration":90,"description":"Full match","clips":null}';

        Test.setMock(HttpCalloutMock.class, new FA_MockHttpCallout(200, hudlJson));
        Test.startTest();
        FA_Video_Analysis__c result = FA_VideoIntegration.importFromHudl(m.Id, 'hudl-vid-123');
        Test.stopTest();
        System.assertNotEquals(null, result.Id);
        System.assertEquals('Full Match', result.Type__c);
    }

    @isTest
    static void testVideoImportWyscout() {
        FA_Match__c m = [SELECT Id FROM FA_Match__c LIMIT 1];
        String wyscoutJson = '{"matchLabel":"Academie vs FAR","videoUrl":"https://wyscout.com/v/test","duration":90,"events":null}';

        Test.setMock(HttpCalloutMock.class, new FA_MockHttpCallout(200, wyscoutJson));
        Test.startTest();
        FA_Video_Analysis__c result = FA_VideoIntegration.importFromWyscout(m.Id, 'wyscout-123');
        Test.stopTest();
        System.assertNotEquals(null, result.Id);
    }

    @isTest
    static void testVideoImportHudlError() {
        FA_Match__c m = [SELECT Id FROM FA_Match__c LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new FA_MockHttpCallout(404, '{"error":"Not Found"}'));
        Test.startTest();
        try {
            FA_VideoIntegration.importFromHudl(m.Id, 'bad-id');
            System.assert(false, 'Should throw');
        } catch (AuraHandledException e) {
            System.assert(e.getMessage() != null);
        }
        Test.stopTest();
    }

    @isTest
    static void testVideoSyncSchedulable() {
        FA_Academy_Setting__c setting = new FA_Academy_Setting__c(
            Name = 'hudl_team_id',
            Setting_Key__c = 'hudl_team_id',
            Value__c = 'team-123'
        );
        insert setting;

        FA_VideoIntegration.VideoSyncSchedulable job = new FA_VideoIntegration.VideoSyncSchedulable();
        System.schedule('Test Video Sync ' + DateTime.now().getTime(), '0 0 0 1 1 ? 2099', job);
    }

    @isTest
    static void testExternalSyncSage() {
        // Create an unsynced transaction
        FA_Transaction__c trans = new FA_Transaction__c(
            Type__c = 'Revenue',
            Category__c = 'Cotisation',
            Description__c = 'Test',
            Amount__c = 500,
            Transaction_Date__c = Date.today(),
            Status__c = 'Payé',
            Synced_To_Accounting__c = false
        );
        insert trans;

        String sageResponse = '{"status":"ok","imported":1}';
        Test.setMock(HttpCalloutMock.class, new FA_MockHttpCallout(200, sageResponse));
        Test.startTest();
        Integer count = FA_ExternalIntegration.syncToSage(Date.today().addDays(-1), Date.today().addDays(1));
        Test.stopTest();
        System.assertEquals(1, count);
    }

    @isTest
    static void testExternalSyncSageError() {
        FA_Transaction__c trans = new FA_Transaction__c(
            Type__c = 'Revenue',
            Category__c = 'Test',
            Description__c = 'Error Test',
            Amount__c = 100,
            Transaction_Date__c = Date.today(),
            Status__c = 'Payé',
            Synced_To_Accounting__c = false
        );
        insert trans;

        Test.setMock(HttpCalloutMock.class, new FA_MockHttpCallout(500, '{"error":"Internal Server Error"}'));
        Test.startTest();
        try {
            FA_ExternalIntegration.syncToSage(Date.today().addDays(-1), Date.today().addDays(1));
            System.assert(false, 'Should throw');
        } catch (AuraHandledException e) {
            System.assert(e.getMessage() != null);
        }
        Test.stopTest();
    }

    @isTest
    static void testExternalSyncSageEmpty() {
        // No unsynced transactions → returns 0 immediately without HTTP call
        Integer count = FA_ExternalIntegration.syncToSage(Date.today().addDays(-100), Date.today().addDays(-99));
        System.assertEquals(0, count);
    }

    @isTest
    static void testExternalSubmitLicense() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new FA_MockHttpCallout(200, '{"status":"submitted"}'));
        Test.startTest();
        String result = FA_ExternalIntegration.submitLicenseRenewal(player.Id);
        Test.stopTest();
        System.assertNotEquals(null, result);
    }

    @isTest
    static void testExternalSubmitLicenseError() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new FA_MockHttpCallout(400, '{"error":"Bad Request"}'));
        Test.startTest();
        try {
            FA_ExternalIntegration.submitLicenseRenewal(player.Id);
            System.assert(false, 'Should throw');
        } catch (AuraHandledException e) {
            System.assert(e.getMessage() != null);
        }
        Test.stopTest();
    }

    // ==================== HTTP CALLOUT MOCK CLASS ====================

    @isTest
    static void testMedicalServiceGetRecord() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];

        // Create medical record
        FA_Medical_Record__c rec = new FA_Medical_Record__c(
            Player__c = player.Id,
            Blood_Type__c = 'A+',
            Last_Checkup_Date__c = Date.today()
        );
        insert rec;

        // getMedicalRecord should return non-null now
        FA_Medical_Record__c result = FA_MedicalService.getMedicalRecord(player.Id);
        System.assertNotEquals(null, result);

        // getMedicalStats with data
        Map<String, Object> stats = FA_MedicalService.getMedicalStats();
        System.assert(stats.containsKey('activeInjuries'));
    }

    @isTest
    static void testEvaluationAndTransactionFilters() {
        FA_Player__c player = [SELECT Id FROM FA_Player__c LIMIT 1];

        // getEvaluations with type filter
        List<FA_Evaluation__c> evals = FA_EvaluationService.getEvaluations(player.Id, 'Monthly');
        System.assertNotEquals(null, evals);

        // getTransactions with all filters
        FA_Transaction__c trans = new FA_Transaction__c(
            Type__c = 'Revenue',
            Category__c = 'Test Cat',
            Description__c = 'Filter Test',
            Amount__c = 100,
            Transaction_Date__c = Date.today(),
            Status__c = 'Payé'
        );
        insert trans;

        List<FA_Transaction__c> withFilters = FA_EvaluationService.getTransactions('Revenue', 'Payé', Date.today().addDays(-1), Date.today().addDays(1));
        System.assert(!withFilters.isEmpty());

        // getDocuments with filters
        List<FA_Document__c> docs = FA_EvaluationService.getDocuments(player.Id, null, null);
        System.assertNotEquals(null, docs);
    }
}
