/**
 * @description REST API endpoint for external GPS devices to push data.
 * FIXED: Added null/type validation on payload fields.
 */
@RestResource(urlMapping='/gps/import')
global with sharing class FA_GpsRestApi {
    @HttpPost
    global static String importData() {
        RestRequest req = RestContext.request;
        if (req == null || req.requestBody == null) {
            RestContext.response.statusCode = 400;
            return '{"success": false, "error": "Empty request body"}';
        }

        String body = req.requestBody.toString();
        Map<String, Object> payload;
        try {
            payload = (Map<String, Object>) JSON.deserializeUntyped(body);
        } catch (Exception e) {
            RestContext.response.statusCode = 400;
            return '{"success": false, "error": "Invalid JSON"}';
        }

        Object dataObj = payload.get('data');
        if (!(dataObj instanceof List<Object>)) {
            RestContext.response.statusCode = 400;
            return '{"success": false, "error": "Missing or invalid data array"}';
        }

        List<Object> dataPoints = (List<Object>) dataObj;
        List<FA_GPS_Data__c> records = new List<FA_GPS_Data__c>();

        for (Object dp : dataPoints) {
            if (!(dp instanceof Map<String, Object>)) continue;
            Map<String, Object> point = (Map<String, Object>) dp;

            Object playerIdObj = point.get('playerId');
            Object dateObj     = point.get('date');
            if (playerIdObj == null || dateObj == null) continue;

            try {
                FA_GPS_Data__c gps = new FA_GPS_Data__c(
                    Name                 = 'GPS-API-' + String.valueOf(Date.today()),
                    Player__c            = (Id) String.valueOf(playerIdObj),
                    Record_Date__c       = Date.valueOf((String) dateObj),
                    Context__c           = point.get('context') != null ? (String) point.get('context') : 'Entraînement',
                    Total_Distance_Km__c = getDecimal(point, 'distanceKm'),
                    Max_Speed_Kmh__c     = getDecimal(point, 'maxSpeed'),
                    Avg_Speed_Kmh__c     = getDecimal(point, 'avgSpeed'),
                    Sprint_Count__c      = getDecimal(point, 'sprints'),
                    Avg_Heart_Rate__c    = getDecimal(point, 'avgHR'),
                    Max_Heart_Rate__c    = getDecimal(point, 'maxHR'),
                    Calories_Burned__c   = getDecimal(point, 'calories')
                );
                records.add(gps);
            } catch (Exception e) {
                System.debug(LoggingLevel.WARN, 'Skipping GPS data point due to error: ' + e.getMessage());
            }
        }

        if (!records.isEmpty()) {
            insert records;
        }
        return '{"success": true, "count": ' + records.size() + '}';
    }

    private static Decimal getDecimal(Map<String, Object> m, String key) {
        Object val = m.get(key);
        if (val == null) return null;
        if (val instanceof Decimal) return (Decimal) val;
        if (val instanceof Integer) return Decimal.valueOf((Integer) val);
        try { return Decimal.valueOf(String.valueOf(val)); } catch (Exception e) { return null; }
    }
}
