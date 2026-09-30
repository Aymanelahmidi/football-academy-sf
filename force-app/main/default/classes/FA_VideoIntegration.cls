/**
 * @description Integration connector for video analysis platforms.
 * Supports Hudl, Wyscout, InStat, and direct video upload.
 * Uses FA_IntegrationSelector for SOQL queries.
 * @author Football Academy
 * @date 2026
 */
public with sharing class FA_VideoIntegration {

    @AuraEnabled
    public static FA_Video_Analysis__c importFromHudl(Id matchId, String hudlVideoId) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:FA_Hudl_API/api/v1/videos/' + hudlVideoId);
        req.setMethod('GET');
        req.setHeader('Accept', 'application/json');
        req.setTimeout(30000);

        Http http = new Http();
        HttpResponse res = http.send(req);

        if (res.getStatusCode() != 200) {
            throw new AuraHandledException('Erreur API Hudl: ' + res.getStatusCode());
        }

        Map<String, Object> video = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());

        FA_Video_Analysis__c analysis = new FA_Video_Analysis__c(
            Name            = (String) video.get('title'),
            Match__c        = matchId,
            Video_URL__c    = (String) video.get('url'),
            Thumbnail_URL__c= (String) video.get('thumbnail'),
            Duration__c     = (Decimal) video.get('duration'),
            Analysis_Date__c= Date.today(),
            Type__c         = 'Full Match',
            Status__c       = 'In Progress',
            Description__c  = (String) video.get('description'),
            Tags__c         = 'Hudl Import'
        );
        insert analysis;

        List<Object> clips = (List<Object>) video.get('clips');
        if (clips != null && !clips.isEmpty()) {
            List<FA_Video_Annotation__c> annotations = new List<FA_Video_Annotation__c>();
            for (Object clip : clips) {
                Map<String, Object> c = (Map<String, Object>) clip;
                annotations.add(new FA_Video_Annotation__c(
                    Name             = (String) c.get('title'),
                    Video_Analysis__c= analysis.Id,
                    Timestamp__c     = (Decimal) c.get('start_time'),
                    End_Timestamp__c = (Decimal) c.get('end_time'),
                    Type__c          = mapHudlClipType((String) c.get('type')),
                    Label__c         = (String) c.get('title'),
                    Description__c   = (String) c.get('notes')
                ));
            }
            if (!annotations.isEmpty()) insert annotations;
        }

        return analysis;
    }

    @AuraEnabled
    public static FA_Video_Analysis__c importFromWyscout(Id matchId, String wyscoutMatchId) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:FA_Wyscout_API/v3/matches/' + wyscoutMatchId + '/video');
        req.setMethod('GET');
        req.setHeader('Accept', 'application/json');
        req.setTimeout(30000);

        Http http = new Http();
        HttpResponse res = http.send(req);

        if (res.getStatusCode() != 200) {
            throw new AuraHandledException('Erreur API Wyscout: ' + res.getStatusCode());
        }

        Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());

        FA_Video_Analysis__c analysis = new FA_Video_Analysis__c(
            Name            = 'Wyscout - ' + (String) data.get('matchLabel'),
            Match__c        = matchId,
            Video_URL__c    = (String) data.get('videoUrl'),
            Duration__c     = (Decimal) data.get('duration'),
            Analysis_Date__c= Date.today(),
            Type__c         = 'Full Match',
            Status__c       = 'In Progress',
            Tags__c         = 'Wyscout Import'
        );
        insert analysis;

        List<Object> events = (List<Object>) data.get('events');
        if (events != null) {
            List<FA_Video_Annotation__c> annotations = new List<FA_Video_Annotation__c>();
            for (Object evt : events) {
                Map<String, Object> e = (Map<String, Object>) evt;
                annotations.add(new FA_Video_Annotation__c(
                    Name             = (String) e.get('type') + ' @' + e.get('videoTimestamp') + 's',
                    Video_Analysis__c= analysis.Id,
                    Timestamp__c     = (Decimal) e.get('videoTimestamp'),
                    Type__c          = mapWyscoutEventType((String) e.get('type')),
                    Label__c         = (String) e.get('type'),
                    Description__c   = (String) e.get('description')
                ));
            }
            if (!annotations.isEmpty()) insert annotations;
        }

        return analysis;
    }

    public class VideoSyncSchedulable implements Schedulable {
        public void execute(SchedulableContext ctx) {
            List<FA_Academy_Setting__c> settings = FA_IntegrationSelector.getAcademySettings(
                new List<String>{ 'hudl_team_id', 'wyscout_team_id' }
            );
            for (FA_Academy_Setting__c setting : settings) {
                if (setting.Name == 'hudl_team_id') {
                    syncHudlVideos(setting.Value__c);
                }
            }
        }

        private void syncHudlVideos(String teamId) {
            // Implementation: fetch recent videos and create analysis records
        }
    }

    // ==================== PRIVATE HELPERS ====================

    private static String mapHudlClipType(String hudlType) {
        Map<String, String> typeMap = new Map<String, String>{
            'goal' => 'Goal', 'shot' => 'Occasion', 'pass' => 'Tactical',
            'tackle' => 'Défensif', 'save' => 'Défensif', 'foul' => 'Erreur',
            'corner' => 'Tactical', 'free_kick' => 'Tactical'
        };
        return typeMap.containsKey(hudlType) ? typeMap.get(hudlType) : 'Autre';
    }

    private static String mapWyscoutEventType(String wyscoutType) {
        Map<String, String> typeMap = new Map<String, String>{
            'goal' => 'Goal', 'shot' => 'Occasion', 'pass' => 'Tactical',
            'duel' => 'Défensif', 'interception' => 'Défensif',
            'set_piece' => 'Tactical'
        };
        return typeMap.containsKey(wyscoutType) ? typeMap.get(wyscoutType) : 'Autre';
    }
}
