/**
 * @description [LC] Lightning controller for the Dashboard page.
 * Aggregates data from all services for the main dashboard view.
 * No direct SOQL — delegates to Services and FA_DashboardSelector.
 * @author Football Academy
 * @date 2026
 */
public with sharing class FA_DashboardController {

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getDashboardStats() {
        Map<String, Object> dashboard = new Map<String, Object>();
        dashboard.put('playerStats',     FA_PlayerService.getPlayerStats());
        dashboard.put('matchStats',      FA_MatchService.getMatchStats());
        dashboard.put('medicalStats',    FA_MedicalService.getMedicalStats());
        dashboard.put('financeStats',    FA_EvaluationService.getFinanceStats());
        dashboard.put('attendanceStats', FA_TrainingService.getAttendanceStats());
        return dashboard;
    }

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getRecentActivity() {
        Map<String, Object> activity = new Map<String, Object>();
        activity.put('recentMatches',   FA_DashboardSelector.getRecentMatches());
        activity.put('recentInjuries',  FA_DashboardSelector.getRecentInjuries());
        return activity;
    }

    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getUpcomingEvents() {
        List<Map<String, Object>> events = new List<Map<String, Object>>();

        for (FA_Match__c m : FA_DashboardSelector.getUpcomingMatches()) {
            events.add(new Map<String, Object>{
                'id'       => m.Id,
                'type'     => 'match',
                'title'    => (m.Is_Home__c ? 'vs ' : '@ ') + m.Opponent__c,
                'date'     => m.Match_Date__c,
                'time'     => m.Kickoff_Time__c,
                'location' => m.Location__c,
                'category' => m.Category__r.Short_Name__c
            });
        }

        for (FA_Training_Session__c s : FA_DashboardSelector.getUpcomingTrainingSessions()) {
            events.add(new Map<String, Object>{
                'id'       => s.Id,
                'type'     => 'training',
                'title'    => s.Name,
                'date'     => s.Session_Date__c,
                'time'     => s.Start_Time__c,
                'location' => s.Location__c,
                'category' => s.Category__r.Short_Name__c
            });
        }

        return events;
    }
}
