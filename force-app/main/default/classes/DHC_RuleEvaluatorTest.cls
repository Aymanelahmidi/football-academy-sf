/**
 * @description Unit tests for DHC_RuleEvaluator.
 * No DML, no SOQL — all rules are built in memory with `new DHC_Rule__mdt(...)`.
 *
 * Coverage strategy:
 *   - One test per operator, triggered and not-triggered cases.
 *   - Every Non évaluable path is tested explicitly (missing state, absent key,
 *     bad type, invalid boolean, LESS_THAN on String, null vs 'null').
 *   - Token substitution tested directly via renderMessage().
 *   - parseState() tested for valid JSON, invalid JSON, and blank inputs.
 */
@IsTest
private class DHC_RuleEvaluatorTest {

    // ─── Rule factory ─────────────────────────────────────────────────────────

    private static DHC_Rule__mdt rule(
        String componentType, String attribute, String operator,
        String expectedValue, String severity
    ) {
        return new DHC_Rule__mdt(
            DHC_Component_Type__c = componentType,
            DHC_Attribute__c      = attribute,
            DHC_Operator__c       = operator,
            DHC_Expected_Value__c = expectedValue,
            DHC_Severity__c       = severity,
            DHC_Message__c        = '{component} : attr={attribute} val={value} exp={expected}'
        );
    }

    // ─── EQUALS ───────────────────────────────────────────────────────────────

    @IsTest
    static void equals_matchingString_triggered() {
        DHC_Rule__mdt r = rule('Flow', 'ProcessType', 'EQUALS', 'AutoLaunchedFlow', 'Critique');
        DHC_RuleEvaluator.Verdict v = DHC_RuleEvaluator.evaluate(r, null,
            new Map<String, Object>{ 'ProcessType' => 'AutoLaunchedFlow' }, false);

        System.assertEquals(true,         v.triggered);
        System.assertEquals('Critique',   v.severity);
        System.assertEquals('AutoLaunchedFlow', v.evaluatedValue);
    }

    @IsTest
    static void equals_nonMatchingString_notTriggered() {
        DHC_Rule__mdt r = rule('Flow', 'ProcessType', 'EQUALS', 'AutoLaunchedFlow', 'Critique');
        DHC_RuleEvaluator.Verdict v = DHC_RuleEvaluator.evaluate(r, null,
            new Map<String, Object>{ 'ProcessType' => 'Flow' }, false);

        System.assertEquals(false, v.triggered);
    }

    @IsTest
    static void equals_noCurrentState_nonEvaluable() {
        DHC_Rule__mdt r = rule('Flow', 'IsActive', 'EQUALS', 'true', 'Critique');
        DHC_RuleEvaluator.Verdict v = DHC_RuleEvaluator.evaluate(r, null, null, false);

        System.assertEquals('Non évaluable', v.severity);
        System.assert(v.message.contains('current'), 'Message must mention current state');
    }

    // ─── NOT_EQUALS ───────────────────────────────────────────────────────────

    @IsTest
    static void notEquals_differentValue_triggered() {
        DHC_Rule__mdt r = rule('EntityDef', 'DeploymentStatus', 'NOT_EQUALS', 'Deployed', 'Avertissement');
        DHC_RuleEvaluator.Verdict v = DHC_RuleEvaluator.evaluate(r, null,
            new Map<String, Object>{ 'DeploymentStatus' => 'InDevelopment' }, false);

        System.assertEquals(true,            v.triggered);
        System.assertEquals('Avertissement', v.severity);
    }

    @IsTest
    static void notEquals_sameValue_notTriggered() {
        DHC_Rule__mdt r = rule('EntityDef', 'DeploymentStatus', 'NOT_EQUALS', 'Deployed', 'Avertissement');
        DHC_RuleEvaluator.Verdict v = DHC_RuleEvaluator.evaluate(r, null,
            new Map<String, Object>{ 'DeploymentStatus' => 'Deployed' }, false);

        System.assertEquals(false, v.triggered);
    }

    // ─── LESS_THAN ────────────────────────────────────────────────────────────

    @IsTest
    static void lessThan_integerBelow_triggered() {
        DHC_Rule__mdt r = rule('PermissionSet', 'AssignmentCount', 'LESS_THAN', '1', 'Critique');
        DHC_RuleEvaluator.Verdict v = DHC_RuleEvaluator.evaluate(r, null,
            new Map<String, Object>{ 'AssignmentCount' => 0 }, false);

        System.assertEquals(true, v.triggered);
        System.assertEquals('0',  v.evaluatedValue);
    }

    @IsTest
    static void lessThan_integerAbove_notTriggered() {
        DHC_Rule__mdt r = rule('PermissionSet', 'AssignmentCount', 'LESS_THAN', '1', 'Critique');
        DHC_RuleEvaluator.Verdict v = DHC_RuleEvaluator.evaluate(r, null,
            new Map<String, Object>{ 'AssignmentCount' => 5 }, false);

        System.assertEquals(false, v.triggered);
    }

    @IsTest
    static void lessThan_stringValue_nonEvaluable() {
        DHC_Rule__mdt r = rule('Flow', 'ProcessType', 'LESS_THAN', '1', 'Critique');
        DHC_RuleEvaluator.Verdict v = DHC_RuleEvaluator.evaluate(r, null,
            new Map<String, Object>{ 'ProcessType' => 'AutoLaunchedFlow' }, false);

        System.assertEquals('Non évaluable', v.severity);
        System.assert(v.message.contains('LESS_THAN'), 'Message must mention LESS_THAN');
    }

    @IsTest
    static void lessThan_booleanValue_nonEvaluable() {
        DHC_Rule__mdt r = rule('Flow', 'IsActive', 'LESS_THAN', '1', 'Critique');
        DHC_RuleEvaluator.Verdict v = DHC_RuleEvaluator.evaluate(r, null,
            new Map<String, Object>{ 'IsActive' => true }, false);

        System.assertEquals('Non évaluable', v.severity);
    }

    // ─── CHANGED_TO ───────────────────────────────────────────────────────────

    @IsTest
    static void changedTo_baselineNotExpected_currentExpected_triggered() {
        DHC_Rule__mdt r = rule('ObjectAccess', 'AnyModifyAll', 'CHANGED_TO', 'true', 'Critique');
        DHC_RuleEvaluator.Verdict v = DHC_RuleEvaluator.evaluate(r,
            new Map<String, Object>{ 'AnyModifyAll' => false },
            new Map<String, Object>{ 'AnyModifyAll' => true  }, false);

        System.assertEquals(true,      v.triggered);
        System.assertEquals('Critique', v.severity);
    }

    @IsTest
    static void changedTo_alreadyExpectedInBaseline_notTriggered() {
        DHC_Rule__mdt r = rule('ObjectAccess', 'AnyModifyAll', 'CHANGED_TO', 'true', 'Critique');
        DHC_RuleEvaluator.Verdict v = DHC_RuleEvaluator.evaluate(r,
            new Map<String, Object>{ 'AnyModifyAll' => true },
            new Map<String, Object>{ 'AnyModifyAll' => true }, false);

        System.assertEquals(false, v.triggered);
    }

    @IsTest
    static void changedTo_noBaseline_nonEvaluable() {
        DHC_Rule__mdt r = rule('ObjectAccess', 'AnyModifyAll', 'CHANGED_TO', 'true', 'Critique');
        DHC_RuleEvaluator.Verdict v = DHC_RuleEvaluator.evaluate(r, null,
            new Map<String, Object>{ 'AnyModifyAll' => true }, false);

        System.assertEquals('Non évaluable', v.severity);
        System.assert(v.message.contains('baseline'),
            'Message must state that baseline is missing');
    }

    @IsTest
    static void changedTo_noCurrent_nonEvaluable() {
        DHC_Rule__mdt r = rule('ObjectAccess', 'AnyModifyAll', 'CHANGED_TO', 'true', 'Critique');
        DHC_RuleEvaluator.Verdict v = DHC_RuleEvaluator.evaluate(r,
            new Map<String, Object>{ 'AnyModifyAll' => false }, null, false);

        System.assertEquals('Non évaluable', v.severity);
    }

    // ─── CHANGED_FROM ─────────────────────────────────────────────────────────

    @IsTest
    static void changedFrom_baselineExpected_currentDifferent_triggered() {
        DHC_Rule__mdt r = rule('ObjectAccess', 'AnyRead', 'CHANGED_FROM', 'true', 'Avertissement');
        DHC_RuleEvaluator.Verdict v = DHC_RuleEvaluator.evaluate(r,
            new Map<String, Object>{ 'AnyRead' => true  },
            new Map<String, Object>{ 'AnyRead' => false }, false);

        System.assertEquals(true,            v.triggered);
        System.assertEquals('Avertissement', v.severity);
    }

    @IsTest
    static void changedFrom_baselineDifferent_notTriggered() {
        DHC_Rule__mdt r = rule('ObjectAccess', 'AnyRead', 'CHANGED_FROM', 'true', 'Avertissement');
        DHC_RuleEvaluator.Verdict v = DHC_RuleEvaluator.evaluate(r,
            new Map<String, Object>{ 'AnyRead' => false },
            new Map<String, Object>{ 'AnyRead' => false }, false);

        System.assertEquals(false, v.triggered);
    }

    // ─── ABSENT_AFTER ─────────────────────────────────────────────────────────

    @IsTest
    static void absentAfter_componentIsAbsent_triggered() {
        DHC_Rule__mdt r = rule('Flow', null, 'ABSENT_AFTER', null, 'Critique');
        DHC_RuleEvaluator.Verdict v = DHC_RuleEvaluator.evaluate(r, null, null, true);

        System.assertEquals(true,      v.triggered);
        System.assertEquals('Critique', v.severity);
    }

    @IsTest
    static void absentAfter_componentPresent_notTriggered() {
        DHC_Rule__mdt r = rule('Flow', null, 'ABSENT_AFTER', null, 'Critique');
        DHC_RuleEvaluator.Verdict v = DHC_RuleEvaluator.evaluate(r, null, null, false);

        System.assertEquals(false, v.triggered);
    }

    // ─── Key absent vs value null — CRITICAL distinction ─────────────────────

    @IsTest
    static void equals_attributeAbsentFromMap_nonEvaluable() {
        // Key 'TriggerType' is NOT in the map — must be Non évaluable, not false
        DHC_Rule__mdt r = rule('Flow', 'TriggerType', 'EQUALS', 'RecordBeforeSave', 'Critique');
        DHC_RuleEvaluator.Verdict v = DHC_RuleEvaluator.evaluate(r, null,
            new Map<String, Object>{ 'IsActive' => true }, false);

        System.assertEquals('Non évaluable', v.severity);
        System.assert(v.message.contains('TriggerType'), 'Must name the missing attribute');
    }

    @IsTest
    static void equals_keyPresentValueNull_neverMatchesEvenStringNull() {
        // Key 'TriggerType' IS present but has null value
        DHC_Rule__mdt r = rule('Flow', 'TriggerType', 'EQUALS', 'null', 'Critique');
        DHC_RuleEvaluator.Verdict v = DHC_RuleEvaluator.evaluate(r, null,
            new Map<String, Object>{ 'TriggerType' => null }, false);

        // actual null must NEVER match, even when expected is the string 'null'
        System.assertEquals(false, v.triggered,
            'null actual must not match \'null\' expected string');
    }

    // ─── Boolean case-insensitive matching ───────────────────────────────────

    @IsTest
    static void booleanTrue_lowercase_matches() {
        DHC_Rule__mdt r = rule('Flow', 'IsActive', 'EQUALS', 'true', 'Critique');
        System.assertEquals(true,
            DHC_RuleEvaluator.evaluate(r, null,
                new Map<String, Object>{ 'IsActive' => true }, false).triggered);
    }

    @IsTest
    static void booleanTrue_uppercase_matches() {
        DHC_Rule__mdt r = rule('Flow', 'IsActive', 'EQUALS', 'TRUE', 'Critique');
        System.assertEquals(true,
            DHC_RuleEvaluator.evaluate(r, null,
                new Map<String, Object>{ 'IsActive' => true }, false).triggered);
    }

    @IsTest
    static void booleanTrue_mixedCase_matches() {
        DHC_Rule__mdt r = rule('Flow', 'IsActive', 'EQUALS', 'True', 'Critique');
        System.assertEquals(true,
            DHC_RuleEvaluator.evaluate(r, null,
                new Map<String, Object>{ 'IsActive' => true }, false).triggered);
    }

    @IsTest
    static void booleanTrue_invalidExpected_nonEvaluable() {
        // 'oui' is not a valid boolean — must be Non évaluable, not false
        DHC_Rule__mdt r = rule('Flow', 'IsActive', 'EQUALS', 'oui', 'Critique');
        DHC_RuleEvaluator.Verdict v = DHC_RuleEvaluator.evaluate(r, null,
            new Map<String, Object>{ 'IsActive' => true }, false);

        System.assertEquals('Non évaluable', v.severity,
            '\'oui\' is not a valid boolean — must be Non évaluable');
    }

    // ─── Token substitution ───────────────────────────────────────────────────

    @IsTest
    static void renderMessage_allTokens_allSubstituted() {
        String result = DHC_RuleEvaluator.renderMessage(
            '{component} changed to {value} (expected {expected})',
            'MyFlow', 'true', 'false'
        );
        System.assertEquals('MyFlow changed to true (expected false)', result);
    }

    @IsTest
    static void renderMessage_nullValue_tokenRemoved() {
        String result = DHC_RuleEvaluator.renderMessage(
            '{component} changed to {value}',
            'MyFlow', null, null
        );
        // Tokens with no value must be removed, not written as 'null'
        System.assertEquals('MyFlow changed to ', result);
    }

    @IsTest
    static void renderMessage_blankTemplate_emptyString() {
        System.assertEquals('', DHC_RuleEvaluator.renderMessage(null,  'label', 'val', 'exp'));
        System.assertEquals('', DHC_RuleEvaluator.renderMessage('',    'label', 'val', 'exp'));
        System.assertEquals('', DHC_RuleEvaluator.renderMessage('   ', 'label', 'val', 'exp'));
    }

    // ─── parseState ───────────────────────────────────────────────────────────

    @IsTest
    static void parseState_validJson_returnsPopulatedMap() {
        Map<String, Object> result = DHC_RuleEvaluator.parseState(
            '{"IsActive":true,"VersionNumber":3,"ProcessType":"Flow"}'
        );
        System.assertNotEquals(null, result);
        System.assertEquals(true, result.get('IsActive'));
        System.assertEquals(3,    result.get('VersionNumber'));
        System.assertEquals('Flow', result.get('ProcessType'));
    }

    @IsTest
    static void parseState_invalidJson_returnsNullNoException() {
        Map<String, Object> result = DHC_RuleEvaluator.parseState('{{ not valid json }}');
        System.assertEquals(null, result,
            'Invalid JSON must return null — no exception must propagate');
    }

    @IsTest
    static void parseState_blankOrNull_returnsNull() {
        System.assertEquals(null, DHC_RuleEvaluator.parseState(null));
        System.assertEquals(null, DHC_RuleEvaluator.parseState(''));
        System.assertEquals(null, DHC_RuleEvaluator.parseState('   '));
    }

    // ─── CHANGED_TO — attribute absent from baseline ─────────────────────────

    @IsTest
    static void changedTo_attributeAbsentFromBaseline_nonEvaluable() {
        DHC_Rule__mdt r = rule('Flow', 'TriggerType', 'CHANGED_TO', 'RecordBeforeSave', 'Critique');
        DHC_RuleEvaluator.Verdict v = DHC_RuleEvaluator.evaluate(r,
            new Map<String, Object>{ 'IsActive' => false }, // TriggerType absent
            new Map<String, Object>{ 'TriggerType' => 'RecordBeforeSave' }, false);

        System.assertEquals('Non évaluable', v.severity);
        System.assert(v.message.contains('TriggerType'));
    }
}
