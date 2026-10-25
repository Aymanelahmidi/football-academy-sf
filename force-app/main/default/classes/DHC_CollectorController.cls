/**
 * @description [LC] AuraEnabled entry points for DHC capture jobs.
 *
 * Queueable capture (captureBaseline / captureCurrent):
 *   Reads active scopes from DHC_CaptureScopeSelector, then enqueues DHC_Collector.
 *   No parameters from the client — the scope list is built server-side only.
 *
 * Batch capture (runFieldAccessCapture):
 *   Launches DHC_FieldAccessBatch via Database.executeBatch.
 *   Queueable chain and Batch are separate triggers — no forced chaining between them.
 */
public with sharing class DHC_CollectorController {

    private static final Set<String> VALID_MODES = new Set<String>{ 'BASELINE', 'CURRENT' };

    /**
     * AuraHandledException.getMessage() returns "Script-thrown exception" when
     * the message is only passed to the constructor. Calling setMessage() ensures
     * the real message propagates to the client and to test assertions.
     */
    private static AuraHandledException buildError(String msg) {
        AuraHandledException e = new AuraHandledException(msg);
        e.setMessage(msg);
        return e;
    }

    private static void assertCanCapture() {
        if (!Schema.SObjectType.DHC_Component__c.isCreateable()) {
            throw buildError(
                'Permission insuffisante : création de DHC_Component__c non autorisée.');
        }
    }

    @AuraEnabled
    public static Id captureBaseline() {
        try {
            assertCanCapture();
            List<String> scopes = DHC_CaptureScopeSelector.getActiveScopeTypes();
            return System.enqueueJob(new DHC_Collector(DHC_CaptureMode.BASELINE, scopes));
        } catch (AuraHandledException ahe) {
            throw ahe;
        } catch (Exception e) {
            throw buildError(e.getMessage());
        }
    }

    @AuraEnabled
    public static Id captureCurrent() {
        try {
            assertCanCapture();
            List<String> scopes = DHC_CaptureScopeSelector.getActiveScopeTypes();
            return System.enqueueJob(new DHC_Collector(DHC_CaptureMode.CURRENT, scopes));
        } catch (AuraHandledException ahe) {
            throw ahe;
        } catch (Exception e) {
            throw buildError(e.getMessage());
        }
    }

    /**
     * Launches a DHC_FieldAccessBatch job for FLS capture.
     *
     * @param mode          'BASELINE' or 'CURRENT'
     * @param deploymentId  Optional DHC_Deployment__c Id to associate the job with
     * @return              Batch job Id (AsyncApexJob)
     * @throws AuraHandledException on invalid mode or insufficient permissions.
     */
    @AuraEnabled
    public static Id runFieldAccessCapture(String mode, Id deploymentId) {
        try {
            if (!VALID_MODES.contains(mode)) {
                throw buildError('Mode de capture non autorisé : ' + mode);
            }
            assertCanCapture();
            DHC_CaptureMode captureMode = (mode == 'BASELINE')
                ? DHC_CaptureMode.BASELINE
                : DHC_CaptureMode.CURRENT;
            return Database.executeBatch(
                new DHC_FieldAccessBatch(captureMode, deploymentId)
            );
        } catch (AuraHandledException ahe) {
            throw ahe;
        } catch (Exception e) {
            throw buildError(e.getMessage());
        }
    }
}
