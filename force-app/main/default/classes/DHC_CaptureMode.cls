/**
 * @description Capture mode for DHC_Collector.
 * BASELINE — writes DHC_Baseline_State__c / DHC_Baseline_Hash__c.
 * CURRENT  — writes DHC_Current_State__c / DHC_Current_Hash__c / DHC_Last_Checked__c.
 */
public enum DHC_CaptureMode {
    BASELINE,
    CURRENT
}
