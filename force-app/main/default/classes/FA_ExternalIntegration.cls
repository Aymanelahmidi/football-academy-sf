/**
 * @description Integration connector for external systems:
 * - Accounting software (Sage, QuickBooks)
 * - Federation portals (FRMF, FIFA Connect)
 * - Communication platforms (WhatsApp, Email)
 * Uses FA_IntegrationSelector for all SOQL queries.
 * @author Football Academy
 * @date 2026
 */
public with sharing class FA_ExternalIntegration {

    // ==================== ACCOUNTING INTEGRATION ====================

    @AuraEnabled
    public static Integer syncToSage(Date startDate, Date endDate) {
        List<FA_Transaction__c> transactions = FA_IntegrationSelector.getUnsyncedTransactions(startDate, endDate);

        if (transactions.isEmpty()) return 0;

        List<Map<String, Object>> entries = new List<Map<String, Object>>();
        for (FA_Transaction__c t : transactions) {
            entries.add(new Map<String, Object>{
                'date'           => String.valueOf(t.Transaction_Date__c),
                'reference'      => t.Name,
                'description'    => t.Description__c,
                'amount'         => t.Amount__c,
                'type'           => t.Type__c == 'Revenue' ? 'income' : 'expense',
                'category'       => t.Category__c,
                'payment_method' => t.Payment_Method__c
            });
        }

        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:FA_Sage_API/api/v3/journal_entries');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(JSON.serialize(new Map<String, Object>{ 'entries' => entries }));
        req.setTimeout(60000);

        Http http = new Http();
        HttpResponse res = http.send(req);

        if (res.getStatusCode() == 200 || res.getStatusCode() == 201) {
            for (FA_Transaction__c t : transactions) {
                t.Synced_To_Accounting__c = true;
                t.Sync_Date__c = Datetime.now();
            }
            update transactions;
            return transactions.size();
        } else {
            throw new AuraHandledException('Erreur sync Sage: ' + res.getStatusCode());
        }
    }

    // ==================== FEDERATION INTEGRATION ====================

    @AuraEnabled
    public static String exportPlayerRegistrations(Id categoryId) {
        List<FA_Player__c> players = FA_IntegrationSelector.getPlayersForExport(categoryId);

        List<Map<String, Object>> registrations = new List<Map<String, Object>>();
        for (FA_Player__c p : players) {
            Map<String, Object> reg = new Map<String, Object>{
                'firstName'     => p.First_Name__c,
                'lastName'      => p.Last_Name__c,
                'dateOfBirth'   => String.valueOf(p.Date_of_Birth__c),
                'nationality'   => p.Nationality__c,
                'nationalId'    => p.National_ID__c,
                'licenseNumber' => p.License_Number__c,
                'category'      => p.Category__r.Short_Name__c,
                'photoUrl'      => p.Photo_URL__c
            };
            if (!p.Contracts__r.isEmpty()) {
                FA_Contract__c c = p.Contracts__r[0];
                reg.put('contractType',  c.Type__c);
                reg.put('contractStart', String.valueOf(c.Start_Date__c));
                reg.put('contractEnd',   String.valueOf(c.End_Date__c));
            }
            registrations.add(reg);
        }

        return JSON.serializePretty(new Map<String, Object>{
            'academyName' => 'Académie de Football',
            'season'      => String.valueOf(Date.today().year()) + '-' + String.valueOf(Date.today().year() + 1),
            'category'    => categoryId,
            'players'     => registrations,
            'exportDate'  => String.valueOf(Datetime.now())
        });
    }

    @AuraEnabled
    public static String submitLicenseRenewal(Id playerId) {
        FA_Player__c player = FA_IntegrationSelector.getPlayerForLicense(playerId);

        Map<String, Object> payload = new Map<String, Object>{
            'licenseNumber' => player.License_Number__c,
            'firstName'     => player.First_Name__c,
            'lastName'      => player.Last_Name__c,
            'dateOfBirth'   => String.valueOf(player.Date_of_Birth__c),
            'nationalId'    => player.National_ID__c,
            'category'      => player.Category__r.Short_Name__c,
            'season'        => String.valueOf(Date.today().year()) + '-' + String.valueOf(Date.today().year() + 1)
        };

        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:FA_FRMF_API/api/licenses/renew');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(JSON.serialize(payload));
        req.setTimeout(30000);

        Http http = new Http();
        HttpResponse res = http.send(req);

        if (res.getStatusCode() == 200 || res.getStatusCode() == 201) {
            return 'Demande de renouvellement soumise avec succès';
        } else {
            throw new AuraHandledException('Erreur FRMF: ' + res.getStatusCode());
        }
    }

    // ==================== NOTIFICATION INTEGRATION ====================

    @future(callout=true)
    public static void sendWhatsAppNotification(String phoneNumber, String message) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:FA_Twilio_API/2010-04-01/Accounts/{!$Credential.Username}/Messages.json');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setBody(
            'To=whatsapp:' + EncodingUtil.urlEncode(phoneNumber, 'UTF-8') +
            '&From=whatsapp:' + EncodingUtil.urlEncode('{!$Credential.OAuthToken}', 'UTF-8') +
            '&Body=' + EncodingUtil.urlEncode(message, 'UTF-8')
        );

        Http http = new Http();
        HttpResponse res = http.send(req);

        if (res.getStatusCode() != 201) {
            System.debug(LoggingLevel.ERROR, 'WhatsApp send failed: ' + res.getBody());
        }
    }

    @AuraEnabled
    public static Integer notifyGuardians(Id categoryId, String subject, String body, List<String> channels) {
        List<FA_Legal_Guardian__c> guardians = FA_IntegrationSelector.getGuardiansByCategory(categoryId);

        Integer sent = 0;
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        for (FA_Legal_Guardian__c g : guardians) {
            String personalizedBody = body
                .replace('{guardian_name}', g.First_Name__c + ' ' + g.Last_Name__c)
                .replace('{player_name}',   g.Player__r.First_Name__c + ' ' + g.Player__r.Last_Name__c);

            if (channels.contains('email') && String.isNotBlank(g.Email__c)) {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new List<String>{ g.Email__c });
                email.setSubject(subject);
                email.setPlainTextBody(personalizedBody);
                emails.add(email);
                sent++;
            }
            if (channels.contains('whatsapp') && String.isNotBlank(g.Phone__c)) {
                sendWhatsAppNotification(g.Phone__c, personalizedBody);
                sent++;
            }
        }

        if (!emails.isEmpty()) {
            Messaging.sendEmail(emails);
        }

        return sent;
    }

    // ==================== DATA EXPORT ====================

    @AuraEnabled
    public static String exportAcademyData() {
        Map<String, Object> exportData = new Map<String, Object>();
        exportData.put('categories', FA_IntegrationSelector.getCategoriesForExport());
        exportData.put('players',    FA_IntegrationSelector.getActivePlayersForExport());
        exportData.put('exportDate', String.valueOf(Datetime.now()));
        exportData.put('version',    '2.0');
        return JSON.serializePretty(exportData);
    }
}
