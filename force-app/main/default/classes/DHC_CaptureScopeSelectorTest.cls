/**
 * @description Unit tests for DHC_CaptureScopeSelector.
 *
 * Custom metadata (DHC_Capture_Scope__mdt) cannot be inserted in tests.
 * The selector's parsing logic is exposed via the @TestVisible
 * parseTargetObjects() helper, which is tested directly with controlled inputs.
 * getActiveScopeTypes() and getFieldAccessTargetObjects() are covered by
 * smoke tests that verify no exception is thrown regardless of what records
 * are deployed in the org.
 */
@isTest
private class DHC_CaptureScopeSelectorTest {

    // ─── parseTargetObjects — unit tests on the parsing helper ───────────────

    @isTest
    static void parseTargetObjects_csvWithSpaces_returnsTrimmedList() {
        List<String> result = DHC_CaptureScopeSelector.parseTargetObjects(
            'FA_Player__c , FA_Training_Session__c ,  FA_Match__c'
        );
        Assert.areEqual(3, result.size(), 'Three entries expected');
        Assert.areEqual('FA_Player__c',           result[0]);
        Assert.areEqual('FA_Training_Session__c', result[1]);
        Assert.areEqual('FA_Match__c',            result[2]);
    }

    @isTest
    static void parseTargetObjects_singleValue_returnsSingleEntry() {
        List<String> result = DHC_CaptureScopeSelector.parseTargetObjects('FA_Player__c');
        Assert.areEqual(1, result.size());
        Assert.areEqual('FA_Player__c', result[0]);
    }

    @isTest
    static void parseTargetObjects_emptyString_returnsEmptyList() {
        List<String> result = DHC_CaptureScopeSelector.parseTargetObjects('');
        Assert.isNotNull(result);
        Assert.areEqual(0, result.size(), 'Empty string should produce empty list');
    }

    @isTest
    static void parseTargetObjects_blankWithSpaces_returnsEmptyList() {
        List<String> result = DHC_CaptureScopeSelector.parseTargetObjects('   ');
        Assert.isNotNull(result);
        Assert.areEqual(0, result.size(), 'Blank string should produce empty list');
    }

    @isTest
    static void parseTargetObjects_null_returnsEmptyList() {
        List<String> result = DHC_CaptureScopeSelector.parseTargetObjects(null);
        Assert.isNotNull(result);
        Assert.areEqual(0, result.size(), 'Null should produce empty list');
    }

    @isTest
    static void parseTargetObjects_csvWithTrailingComma_skipsBlankEntry() {
        List<String> result = DHC_CaptureScopeSelector.parseTargetObjects('FA_Player__c,');
        Assert.areEqual(1, result.size(), 'Trailing comma should not add a blank entry');
        Assert.areEqual('FA_Player__c', result[0]);
    }

    // ─── getActiveScopeTypes — smoke (custom metadata visible in tests) ───────

    @isTest
    static void getActiveScopeTypes_doesNotThrow_returnsNonNullList() {
        List<String> result = DHC_CaptureScopeSelector.getActiveScopeTypes();
        Assert.isNotNull(result, 'Should return a non-null list regardless of deployed records');
        for (String s : result) {
            Assert.isNotNull(s, 'Each scope type should be non-null');
        }
    }

    // ─── getFieldAccessTargetObjects — smoke ──────────────────────────────────

    @isTest
    static void getFieldAccessTargetObjects_doesNotThrow_returnsNonNullList() {
        List<String> result = DHC_CaptureScopeSelector.getFieldAccessTargetObjects();
        Assert.isNotNull(result, 'Should return a non-null list regardless of deployed records');
        // If a FieldAccess scope is deployed with a Target_Objects__c value,
        // every entry must be a non-blank string (trimming already applied).
        for (String s : result) {
            Assert.isTrue(String.isNotBlank(s), 'Each object name must be non-blank');
        }
    }
}
