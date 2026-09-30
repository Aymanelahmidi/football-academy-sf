/**
 * @description [DM] Domain class for FA_Video_Analysis__c and FA_Video_Annotation__c business rules.
 * Pure logic on in-memory collections. No SOQL, no DML.
 * @author Football Academy
 * @date 2026
 */
public with sharing class FA_VideoDomain {

    /**
     * @description Auto-generate a video analysis Name from type and date.
     * @param video Video analysis record to update in-memory.
     */
    public static void buildName(FA_Video_Analysis__c video) {
        String type = String.isNotBlank(video.Type__c) ? video.Type__c + ' - ' : '';
        String dateStr = video.Analysis_Date__c != null
            ? String.valueOf(video.Analysis_Date__c)
            : String.valueOf(Date.today());
        video.Name = type + dateStr;
    }

    /**
     * @description Set default values on new video analysis records.
     * @param videos List of new video analysis records.
     */
    public static void setDefaults(List<FA_Video_Analysis__c> videos) {
        for (FA_Video_Analysis__c v : videos) {
            if (String.isBlank(v.Status__c)) {
                v.Status__c = 'Draft';
            }
            if (v.Analysis_Date__c == null) {
                v.Analysis_Date__c = Date.today();
            }
            if (String.isBlank(v.Name)) {
                buildName(v);
            }
        }
    }

    /**
     * @description Validate required fields before insert/update.
     * Adds errors directly to records (trigger context).
     * @param videos List of video analysis records to validate.
     */
    public static void validateList(List<FA_Video_Analysis__c> videos) {
        for (FA_Video_Analysis__c v : videos) {
            if (String.isBlank(v.Type__c)) {
                v.addError('Le type d\'analyse vidéo est obligatoire.');
            }
        }
    }
}
