/**
 * @description [DM] Domain class for performance/physical data business rules.
 * Pure logic on in-memory collections. No SOQL, no DML.
 * @author Football Academy
 * @date 2026
 */
public with sharing class FA_PerformanceDomain {

    /**
     * @description Auto-calculate BMI from height and weight.
     * Formula: BMI = weight(kg) / (height(m))^2
     * Only sets BMI__c if height and weight are provided and height > 0.
     * @param measure Morphological measure record to update in-memory.
     */
    public static void calculateBMI(FA_Morphological_Measure__c measure) {
        if (measure.Height_Cm__c != null && measure.Weight_Kg__c != null && measure.Height_Cm__c > 0) {
            Decimal heightM = measure.Height_Cm__c / 100;
            measure.BMI__c = (measure.Weight_Kg__c / (heightM * heightM)).setScale(1);
        }
    }

    /**
     * @description Determine fitness level category from ACWR ratio.
     * @param acwr ACWR ratio value.
     * @return Fitness level label.
     */
    public static String getFitnessLevel(Decimal acwr) {
        if (acwr == null) return 'Unknown';
        if (acwr < 0.8) return 'Under-trained';
        if (acwr <= 1.3) return 'Optimal';
        return 'Over-trained';
    }

    /**
     * @description Validate required fields before insert/update.
     * Adds errors directly to records (trigger context).
     * @param measures List of morphological measure records to validate.
     */
    public static void validateList(List<FA_Morphological_Measure__c> measures) {
        for (FA_Morphological_Measure__c m : measures) {
            if (m.Player__c == null) {
                m.addError('Le joueur est obligatoire.');
            }
            if (m.Measure_Date__c == null) {
                m.addError('La date de mesure est obligatoire.');
            }
        }
    }
}
