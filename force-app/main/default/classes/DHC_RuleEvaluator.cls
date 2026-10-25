/**
 * @description [SM] Pure evaluation engine — no DML, no SOQL, no state.
 * All methods are static. Designed to be testable without any database interaction.
 *
 * RELIABILITY CONTRACT:
 *   A verdict of 'Non évaluable' is returned — never 'non conforme' — when the evaluator
 *   cannot justify its conclusion. This includes: missing state, absent attribute key,
 *   unparseable JSON, wrong types, and empty Expected_Value when required.
 *
 *   'Non évaluable' is NEVER counted in Critical_Count or Warning_Count.
 *   It is surfaced as a finding so operators can investigate the gap.
 *
 * TYPE COERCION:
 *   JSON.deserializeUntyped produces: Boolean, Integer, Decimal, String.
 *   DHC_Expected_Value__c is always String.
 *   valuesMatch() bridges the two without silent type coercion:
 *     - Boolean vs 'true'/'false' (case-insensitive) — else Non évaluable
 *     - Numeric vs numeric string via Decimal — else Non évaluable
 *     - String vs String — strict case-sensitive equality
 *     - null actual — never matches, even 'null'
 *   Any mismatch is Non évaluable, never false.
 *
 * OPERATORS:
 *   EQUALS        — current == expected
 *   NOT_EQUALS    — current != expected
 *   LESS_THAN     — current < expected (numeric only)
 *   CHANGED_TO    — baseline != expected AND current == expected (both states required)
 *   CHANGED_FROM  — baseline == expected AND current != expected (both states required)
 *   ABSENT_AFTER  — isAbsent == true (attribute field ignored)
 */
public with sharing class DHC_RuleEvaluator {

    // ─── Verdict ─────────────────────────────────────────────────────────────

    public class Verdict {
        /** True when the rule fires (either triggered OR non-evaluable). */
        public final Boolean triggered;
        /** 'Critique', 'Avertissement', 'Info', or 'Non évaluable'. */
        public final String  severity;
        /**
         * For triggered rules    : rule.DHC_Message__c (raw template, {tokens} not yet replaced).
         * For Non évaluable      : the explanation message (no tokens).
         * Token substitution ({component}, {value}, {expected}) is done by the caller (batch).
         */
        public final String  message;
        /** String representation of the current attribute value (null if unavailable). */
        public final String  evaluatedValue;

        @TestVisible
        public Verdict(
            Boolean triggered, String severity,
            String message,    String evaluatedValue
        ) {
            this.triggered      = triggered;
            this.severity       = severity;
            this.message        = message;
            this.evaluatedValue = evaluatedValue;
        }
    }

    // ─── State parser ─────────────────────────────────────────────────────────

    /**
     * Safely parses a JSON state string into a flat Map<String, Object>.
     * Returns null if the input is blank or if parsing fails — callers treat
     * null as "state not captured" and operators that require state return
     * Non évaluable.
     *
     * Never propagates JSONException or TypeException to the caller.
     */
    public static Map<String, Object> parseState(String stateJson) {
        if (String.isBlank(stateJson)) return null;
        try {
            return (Map<String, Object>) JSON.deserializeUntyped(stateJson);
        } catch (Exception e) {
            // Covers JSONException (bad JSON) and TypeException (non-object root)
            return null;
        }
    }

    // ─── Central evaluate ─────────────────────────────────────────────────────

    /**
     * Evaluates one rule against one component's captured states.
     *
     * @param rule          Active DHC_Rule__mdt record.
     * @param baselineState Parsed baseline state, or null if not yet captured.
     * @param currentState  Parsed current state, or null if not yet captured.
     * @param isAbsent      DHC_Component__c.DHC_Is_Absent__c — true if the component
     *                      no longer exists in the org.
     * @return              Verdict with triggered=true when the rule fires.
     *                      triggered=false means the component is compliant for this rule.
     */
    public static Verdict evaluate(
        DHC_Rule__mdt       rule,
        Map<String, Object> baselineState,
        Map<String, Object> currentState,
        Boolean             isAbsent
    ) {
        String operator = rule.DHC_Operator__c;
        String attr     = rule.DHC_Attribute__c;
        String expected = rule.DHC_Expected_Value__c;

        try {

            // ── ABSENT_AFTER — only the isAbsent flag matters ─────────────────
            if (operator == 'ABSENT_AFTER') {
                if (isAbsent == true) {
                    return new Verdict(true, rule.DHC_Severity__c,
                        rule.DHC_Message__c, 'absent');
                }
                return notTriggered();
            }

            // ── EQUALS / NOT_EQUALS / LESS_THAN — current state only ──────────
            if (operator == 'EQUALS' || operator == 'NOT_EQUALS' || operator == 'LESS_THAN') {

                if (currentState == null) {
                    return nonEvaluable(
                        'Non évaluable : aucun état current capturé pour ce composant.');
                }
                // containsKey() distinguishes "key absent" from "key present, value null"
                if (!currentState.containsKey(attr)) {
                    return nonEvaluable(
                        'Non évaluable : l\'attribut \'' + attr +
                        '\' est absent de l\'état current.');
                }

                Object curVal = currentState.get(attr);
                String curStr = curVal != null ? String.valueOf(curVal) : null;

                if (operator == 'EQUALS') {
                    if (String.isBlank(expected)) {
                        return nonEvaluable(
                            'Non évaluable : DHC_Expected_Value__c est vide pour l\'opérateur EQUALS.');
                    }
                    MatchResult mr = valuesMatch(curVal, expected);
                    if (mr.isNonEvaluable) return nonEvaluable(mr.reason);
                    return mr.matched
                        ? new Verdict(true, rule.DHC_Severity__c, rule.DHC_Message__c, curStr)
                        : notTriggered();
                }

                if (operator == 'NOT_EQUALS') {
                    if (String.isBlank(expected)) {
                        // No expected → triggers when current is not null
                        return curVal != null
                            ? new Verdict(true, rule.DHC_Severity__c, rule.DHC_Message__c, curStr)
                            : notTriggered();
                    }
                    MatchResult mr = valuesMatch(curVal, expected);
                    if (mr.isNonEvaluable) return nonEvaluable(mr.reason);
                    return !mr.matched
                        ? new Verdict(true, rule.DHC_Severity__c, rule.DHC_Message__c, curStr)
                        : notTriggered();
                }

                if (operator == 'LESS_THAN') {
                    if (String.isBlank(expected)) {
                        return nonEvaluable(
                            'Non évaluable : DHC_Expected_Value__c est vide pour l\'opérateur LESS_THAN.');
                    }
                    LessResult lr = lessThan(curVal, expected);
                    if (lr.isNonEvaluable) return nonEvaluable(lr.reason);
                    return lr.result
                        ? new Verdict(true, rule.DHC_Severity__c, rule.DHC_Message__c, curStr)
                        : notTriggered();
                }
            }

            // ── CHANGED_TO / CHANGED_FROM — both states required ─────────────
            if (operator == 'CHANGED_TO' || operator == 'CHANGED_FROM') {

                if (baselineState == null) {
                    return nonEvaluable(
                        'Non évaluable : aucun état baseline capturé pour ce composant, ' +
                        'l\'opérateur ' + operator + ' nécessite les deux états.');
                }
                if (currentState == null) {
                    return nonEvaluable(
                        'Non évaluable : aucun état current capturé pour ce composant, ' +
                        'l\'opérateur ' + operator + ' nécessite les deux états.');
                }
                if (!baselineState.containsKey(attr)) {
                    return nonEvaluable(
                        'Non évaluable : l\'attribut \'' + attr +
                        '\' est absent de l\'état baseline.');
                }
                if (!currentState.containsKey(attr)) {
                    return nonEvaluable(
                        'Non évaluable : l\'attribut \'' + attr +
                        '\' est absent de l\'état current.');
                }
                if (String.isBlank(expected)) {
                    return nonEvaluable(
                        'Non évaluable : DHC_Expected_Value__c est vide pour l\'opérateur ' +
                        operator + '.');
                }

                Object baseVal = baselineState.get(attr);
                Object curVal  = currentState.get(attr);
                String curStr  = curVal != null ? String.valueOf(curVal) : null;

                MatchResult mrBase = valuesMatch(baseVal, expected);
                MatchResult mrCurr = valuesMatch(curVal,  expected);

                if (operator == 'CHANGED_TO') {
                    // Triggers: baseline != expected AND current == expected
                    if (mrCurr.isNonEvaluable) return nonEvaluable(mrCurr.reason);
                    Boolean baseMatched = !mrBase.isNonEvaluable && mrBase.matched;
                    return (!baseMatched && mrCurr.matched)
                        ? new Verdict(true, rule.DHC_Severity__c, rule.DHC_Message__c, curStr)
                        : notTriggered();
                }

                if (operator == 'CHANGED_FROM') {
                    // Triggers: baseline == expected AND current != expected
                    if (mrBase.isNonEvaluable) return nonEvaluable(mrBase.reason);
                    Boolean curMatched = !mrCurr.isNonEvaluable && mrCurr.matched;
                    return (mrBase.matched && !curMatched)
                        ? new Verdict(true, rule.DHC_Severity__c, rule.DHC_Message__c, curStr)
                        : notTriggered();
                }
            }

        } catch (Exception e) {
            return nonEvaluable(
                'Non évaluable : exception inattendue — ' + e.getMessage());
        }

        return nonEvaluable(
            'Non évaluable : opérateur inconnu \'' + operator + '\'.');
    }

    // ─── Message rendering ────────────────────────────────────────────────────

    /**
     * Substitutes tokens in a message template.
     *   {component} → componentLabel  (removed if blank)
     *   {value}     → evaluatedValue  (removed if blank)
     *   {expected}  → expectedValue   (removed if blank)
     *
     * Tokens with no value are removed rather than replaced with 'null'.
     * Called by the batch — not by evaluate() — so {component} is always available.
     *
     * @TestVisible for unit testing of substitution logic.
     */
    @TestVisible
    public static String renderMessage(
        String template,
        String componentLabel,
        String evaluatedValue,
        String expectedValue
    ) {
        if (String.isBlank(template)) return '';
        String result = template;
        result = result.replace('{component}', String.isNotBlank(componentLabel) ? componentLabel : '');
        result = result.replace('{value}',     String.isNotBlank(evaluatedValue)  ? evaluatedValue  : '');
        result = result.replace('{expected}',  String.isNotBlank(expectedValue)   ? expectedValue   : '');
        return result;
    }

    // ─── Private value comparison helpers ────────────────────────────────────

    private class MatchResult {
        public Boolean isNonEvaluable = false;
        public String  reason;
        public Boolean matched = false;
    }

    private class LessResult {
        public Boolean isNonEvaluable = false;
        public String  reason;
        public Boolean result = false;
    }

    /**
     * Compares an actual value (from JSON.deserializeUntyped) to an expected string.
     *   actual null          → matched=false (null matches nothing, even 'null').
     *   actual Boolean       → expected must be 'true' or 'false' (case-insensitive); else Non évaluable.
     *   actual Integer/Decimal → numeric comparison via Decimal; else Non évaluable.
     *   actual String        → strict case-sensitive equality.
     *   other types          → Non évaluable.
     *
     * Type mismatch always returns Non évaluable, NEVER false.
     *
     * @TestVisible so unit tests can exercise comparison edge cases directly.
     */
    @TestVisible
    private static MatchResult valuesMatch(Object actual, String expected) {
        MatchResult r = new MatchResult();

        if (actual == null) {
            r.matched = false; // null ≠ 'null' — never a match
            return r;
        }

        if (actual instanceof Boolean) {
            String expLower = expected != null ? expected.toLowerCase() : '';
            if (expLower != 'true' && expLower != 'false') {
                r.isNonEvaluable = true;
                r.reason =
                    'Non évaluable : la valeur attendue \'' + expected +
                    '\' n\'est pas un booléen valide (\'true\' ou \'false\').';
                return r;
            }
            r.matched = ((Boolean) actual == Boolean.valueOf(expected));
            return r;
        }

        if (actual instanceof Integer || actual instanceof Decimal) {
            if (String.isBlank(expected)) {
                r.isNonEvaluable = true;
                r.reason = 'Non évaluable : DHC_Expected_Value__c vide pour comparaison numérique.';
                return r;
            }
            try {
                r.matched = (Decimal.valueOf(String.valueOf(actual)) == Decimal.valueOf(expected));
            } catch (Exception e) {
                r.isNonEvaluable = true;
                r.reason =
                    'Non évaluable : impossible de comparer \'' + actual +
                    '\' à \'' + expected + '\' numériquement.';
            }
            return r;
        }

        if (actual instanceof String) {
            r.matched = ((String) actual == expected);
            return r;
        }

        r.isNonEvaluable = true;
        r.reason = 'Non évaluable : type de valeur non supporté pour la comparaison.';
        return r;
    }

    @TestVisible
    private static LessResult lessThan(Object actual, String expected) {
        LessResult r = new LessResult();

        if (actual == null) {
            r.result = false;
            return r;
        }
        if (actual instanceof Boolean) {
            r.isNonEvaluable = true;
            r.reason = 'Non évaluable : l\'opérateur LESS_THAN ne s\'applique pas au type Boolean.';
            return r;
        }
        if (actual instanceof String) {
            r.isNonEvaluable = true;
            r.reason = 'Non évaluable : l\'opérateur LESS_THAN ne s\'applique pas au type String.';
            return r;
        }

        try {
            r.result = (Decimal.valueOf(String.valueOf(actual)) < Decimal.valueOf(expected));
        } catch (Exception e) {
            r.isNonEvaluable = true;
            r.reason =
                'Non évaluable : impossible de comparer numériquement \'' +
                actual + '\' à \'' + expected + '\'.';
        }
        return r;
    }

    // ─── Verdict factories ────────────────────────────────────────────────────

    private static Verdict nonEvaluable(String reason) {
        return new Verdict(true, 'Non évaluable', reason, null);
    }

    private static Verdict notTriggered() {
        return new Verdict(false, null, null, null);
    }
}
