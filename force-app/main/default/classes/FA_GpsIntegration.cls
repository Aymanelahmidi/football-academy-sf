/**
 * @description Integration connector for GPS tracking devices.
 * Supports Catapult, STATSports, Playertek, and generic CSV import.
 * FIXED: Changed from 'global' to 'public with sharing'.
 * @author Football Academy
 * @date 2026
 */
public with sharing class FA_GpsIntegration {

    @AuraEnabled
    public static Integer importFromCatapult(Date sessionDate, Id categoryId) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:FA_Catapult_API/v6/activities?from_date=' +
            String.valueOf(sessionDate) + '&to_date=' + String.valueOf(sessionDate));
        req.setMethod('GET');
        req.setHeader('Accept', 'application/json');
        req.setTimeout(30000);

        Http http = new Http();
        HttpResponse res = http.send(req);

        if (res.getStatusCode() != 200) {
            throw new AuraHandledException('Erreur API Catapult: ' + res.getStatusCode() + ' ' + res.getBody());
        }

        List<FA_GPS_Data__c> records = parseCatapultResponse(res.getBody(), sessionDate, categoryId);
        if (!records.isEmpty()) {
            insert records;
        }
        return records.size();
    }

    @AuraEnabled
    public static Integer importFromSTATSports(Date sessionDate, Id categoryId) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:FA_STATSports_API/api/v2/sessions?date=' + String.valueOf(sessionDate));
        req.setMethod('GET');
        req.setHeader('Accept', 'application/json');
        req.setTimeout(30000);

        Http http = new Http();
        HttpResponse res = http.send(req);

        if (res.getStatusCode() != 200) {
            throw new AuraHandledException('Erreur API STATSports: ' + res.getStatusCode());
        }

        List<FA_GPS_Data__c> records = parseSTATSportsResponse(res.getBody(), sessionDate, categoryId);
        if (!records.isEmpty()) {
            insert records;
        }
        return records.size();
    }

    @AuraEnabled
    public static Integer importFromCSV(String csvContent, Id categoryId) {
        List<FA_GPS_Data__c> records = new List<FA_GPS_Data__c>();

        Map<String, Id> playerMap = buildPlayerMap(categoryId);

        List<String> lines = csvContent.split('\n');
        for (Integer i = 1; i < lines.size(); i++) {
            String line = lines[i].trim();
            if (String.isBlank(line)) continue;

            List<String> cols = line.split(',');
            if (cols.size() < 10) continue;

            String playerName = cols[0].trim().toLowerCase();
            Id playerId = playerMap.get(playerName);
            if (playerId == null) continue;

            FA_GPS_Data__c gps = new FA_GPS_Data__c(
                Name                    = 'GPS-Import-' + cols[1].trim(),
                Player__c               = playerId,
                Record_Date__c          = Date.valueOf(cols[1].trim()),
                Context__c              = 'Entraînement',
                Total_Distance_Km__c    = Decimal.valueOf(cols[2].trim()),
                Max_Speed_Kmh__c        = Decimal.valueOf(cols[3].trim()),
                Avg_Speed_Kmh__c        = Decimal.valueOf(cols[4].trim()),
                Sprint_Count__c         = Decimal.valueOf(cols[5].trim()),
                High_Intensity_Distance__c = Decimal.valueOf(cols[6].trim()),
                Avg_Heart_Rate__c       = Decimal.valueOf(cols[7].trim()),
                Max_Heart_Rate__c       = Decimal.valueOf(cols[8].trim()),
                Calories_Burned__c      = Decimal.valueOf(cols[9].trim())
            );

            if (cols.size() > 12) {
                gps.Acute_Load__c   = Decimal.valueOf(cols[10].trim());
                gps.Chronic_Load__c = Decimal.valueOf(cols[11].trim());
                gps.ACWR_Ratio__c   = Decimal.valueOf(cols[12].trim());
            }
            if (cols.size() > 17) {
                gps.Zone1_Minutes__c = Decimal.valueOf(cols[13].trim());
                gps.Zone2_Minutes__c = Decimal.valueOf(cols[14].trim());
                gps.Zone3_Minutes__c = Decimal.valueOf(cols[15].trim());
                gps.Zone4_Minutes__c = Decimal.valueOf(cols[16].trim());
                gps.Zone5_Minutes__c = Decimal.valueOf(cols[17].trim());
            }

            records.add(gps);
        }

        if (!records.isEmpty()) {
            insert records;
        }
        return records.size();
    }

    // ==================== PRIVATE HELPERS ====================

    private static List<FA_GPS_Data__c> parseCatapultResponse(String jsonBody, Date sessionDate, Id categoryId) {
        List<FA_GPS_Data__c> records = new List<FA_GPS_Data__c>();
        Map<String, Object> response = (Map<String, Object>) JSON.deserializeUntyped(jsonBody);
        List<Object> activities = (List<Object>) response.get('activities');

        Map<String, Id> playerMap = buildPlayerMap(categoryId);

        if (activities != null) {
            for (Object act : activities) {
                Map<String, Object> activity = (Map<String, Object>) act;
                List<Object> athletes = (List<Object>) activity.get('athletes');
                if (athletes == null) continue;

                for (Object ath : athletes) {
                    Map<String, Object> athlete = (Map<String, Object>) ath;
                    String firstName = (String) athlete.get('first_name');
                    String lastName  = (String) athlete.get('last_name');
                    if (firstName == null || lastName == null) continue;
                    String name = (firstName + ' ' + lastName).toLowerCase();
                    Id playerId = playerMap.get(name);
                    if (playerId == null) continue;

                    Map<String, Object> metrics = (Map<String, Object>) athlete.get('metrics');
                    if (metrics == null) continue;

                    records.add(new FA_GPS_Data__c(
                        Name                       = 'GPS-Catapult-' + String.valueOf(sessionDate),
                        Player__c                  = playerId,
                        Record_Date__c             = sessionDate,
                        Context__c                 = 'Entraînement',
                        Total_Distance_Km__c       = getDecimal(metrics, 'total_distance') / 1000,
                        Max_Speed_Kmh__c           = getDecimal(metrics, 'max_velocity') * 3.6,
                        Sprint_Count__c            = getDecimal(metrics, 'sprint_count'),
                        High_Intensity_Distance__c = getDecimal(metrics, 'high_speed_running') / 1000,
                        Avg_Heart_Rate__c          = getDecimal(metrics, 'avg_heart_rate'),
                        Max_Heart_Rate__c          = getDecimal(metrics, 'max_heart_rate')
                    ));
                }
            }
        }
        return records;
    }

    private static List<FA_GPS_Data__c> parseSTATSportsResponse(String jsonBody, Date sessionDate, Id categoryId) {
        List<FA_GPS_Data__c> records = new List<FA_GPS_Data__c>();
        Map<String, Object> response = (Map<String, Object>) JSON.deserializeUntyped(jsonBody);
        List<Object> sessions = (List<Object>) response.get('sessions');

        Map<String, Id> playerMap = buildPlayerMap(categoryId);

        if (sessions != null) {
            for (Object sess : sessions) {
                Map<String, Object> session = (Map<String, Object>) sess;
                List<Object> players = (List<Object>) session.get('players');
                if (players == null) continue;

                for (Object pl : players) {
                    Map<String, Object> player = (Map<String, Object>) pl;
                    String nameVal = (String) player.get('name');
                    if (nameVal == null) continue;
                    Id playerId = playerMap.get(nameVal.toLowerCase());
                    if (playerId == null) continue;

                    records.add(new FA_GPS_Data__c(
                        Name                 = 'GPS-STATSports-' + String.valueOf(sessionDate),
                        Player__c            = playerId,
                        Record_Date__c       = sessionDate,
                        Context__c           = 'Entraînement',
                        Total_Distance_Km__c = getDecimal(player, 'total_distance'),
                        Max_Speed_Kmh__c     = getDecimal(player, 'top_speed'),
                        Sprint_Count__c      = getDecimal(player, 'number_of_sprints'),
                        Avg_Heart_Rate__c    = getDecimal(player, 'average_heart_rate'),
                        Max_Heart_Rate__c    = getDecimal(player, 'max_heart_rate'),
                        Calories_Burned__c   = getDecimal(player, 'calories')
                    ));
                }
            }
        }
        return records;
    }

    private static Map<String, Id> buildPlayerMap(Id categoryId) {
        Map<String, Id> playerMap = new Map<String, Id>();
        for (FA_Player__c p : FA_IntegrationSelector.getPlayersByCategory(categoryId)) {
            playerMap.put((p.First_Name__c + ' ' + p.Last_Name__c).toLowerCase(), p.Id);
        }
        return playerMap;
    }

    private static Decimal getDecimal(Map<String, Object> m, String key) {
        Object val = m.get(key);
        if (val == null) return 0;
        if (val instanceof Decimal) return (Decimal) val;
        if (val instanceof Integer) return Decimal.valueOf((Integer) val);
        return Decimal.valueOf(String.valueOf(val));
    }
}
