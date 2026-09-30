/**
 * @description [TH] Trigger handler for FA_Morphological_Measure__c.
 * Routes trigger events to Domain logic. No SOQL, no DML.
 * @author Football Academy
 * @date 2026
 */
public with sharing class FA_PerformanceTriggerHandler {

    /**
     * @description Handle before insert: calculate BMI and build name.
     * @param newMeasures List of new morphological measure records.
     */
    public static void handleBeforeInsert(List<FA_Morphological_Measure__c> newMeasures) {
        for (FA_Morphological_Measure__c m : newMeasures) {
            FA_PerformanceDomain.calculateBMI(m);
            if (String.isBlank(m.Name) && m.Measure_Date__c != null) {
                m.Name = 'Mesure-' + String.valueOf(m.Measure_Date__c);
            }
        }
        FA_PerformanceDomain.validateList(newMeasures);
    }

    /**
     * @description Handle before update: recalculate BMI if height or weight changed.
     * @param newMeasures List of updated measure records (new values).
     * @param oldMap Map of old measure record values.
     */
    public static void handleBeforeUpdate(List<FA_Morphological_Measure__c> newMeasures, Map<Id, FA_Morphological_Measure__c> oldMap) {
        for (FA_Morphological_Measure__c m : newMeasures) {
            FA_Morphological_Measure__c old = oldMap.get(m.Id);
            Boolean bodyMetricsChanged = m.Height_Cm__c != old.Height_Cm__c
                || m.Weight_Kg__c != old.Weight_Kg__c;
            if (bodyMetricsChanged) {
                FA_PerformanceDomain.calculateBMI(m);
            }
        }
        FA_PerformanceDomain.validateList(newMeasures);
    }
}
