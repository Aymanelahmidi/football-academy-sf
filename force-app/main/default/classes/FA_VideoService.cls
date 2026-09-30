/**
 * @description [SM] Service class for video analysis and annotations.
 * Orchestrates FA_VideoSelector (SOQL). Only layer authorized to perform DML.
 * @author Football Academy
 * @date 2026
 */
public with sharing class FA_VideoService {

    public static List<FA_Video_Analysis__c> getVideoAnalyses(Id matchId, String analysisType, String status) {
        return FA_VideoSelector.getVideoAnalyses(matchId, analysisType, status);
    }

    public static FA_Video_Analysis__c getVideoAnalysisById(Id videoId) {
        return FA_VideoSelector.getVideoAnalysisById(videoId);
    }

    public static FA_Video_Analysis__c createVideoAnalysis(FA_Video_Analysis__c video) {
        insert video;
        return FA_VideoSelector.getVideoAnalysisById(video.Id);
    }

    public static FA_Video_Annotation__c addAnnotation(FA_Video_Annotation__c annotation) {
        annotation.Name = annotation.Label__c != null
            ? annotation.Label__c
            : annotation.Type__c + ' @' + annotation.Timestamp__c + 's';
        insert annotation;
        return annotation;
    }

    public static List<FA_Video_Annotation__c> bulkAddAnnotations(List<FA_Video_Annotation__c> annotations) {
        for (FA_Video_Annotation__c a : annotations) {
            a.Name = a.Label__c != null
                ? a.Label__c
                : a.Type__c + ' @' + a.Timestamp__c + 's';
        }
        insert annotations;
        return annotations;
    }
}
