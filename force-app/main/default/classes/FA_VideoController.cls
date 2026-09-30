/**
 * @description Lightning controller for Video Analysis pages.
 * @author Football Academy Migration
 * @date 2026
 */
public with sharing class FA_VideoController {

    @AuraEnabled(cacheable=true)
    public static List<FA_Video_Analysis__c> getVideoAnalyses(Id matchId, String analysisType, String status) {
        return FA_VideoService.getVideoAnalyses(matchId, analysisType, status);
    }

    @AuraEnabled(cacheable=true)
    public static FA_Video_Analysis__c getVideoAnalysisById(Id videoId) {
        return FA_VideoService.getVideoAnalysisById(videoId);
    }

    @AuraEnabled
    public static FA_Video_Analysis__c createVideoAnalysis(FA_Video_Analysis__c video) {
        return FA_VideoService.createVideoAnalysis(video);
    }

    @AuraEnabled
    public static FA_Video_Annotation__c addAnnotation(FA_Video_Annotation__c annotation) {
        return FA_VideoService.addAnnotation(annotation);
    }

    @AuraEnabled
    public static List<FA_Video_Annotation__c> bulkAddAnnotations(List<FA_Video_Annotation__c> annotations) {
        return FA_VideoService.bulkAddAnnotations(annotations);
    }
}
