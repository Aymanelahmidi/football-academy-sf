/**
 * @description [EM] Selector for DHC_Capture_Scope__mdt.
 *
 * Custom Metadata Types do NOT support WITH USER_MODE, AccessLevel.USER_MODE,
 * nor Security.stripInaccessible — they are platform data, not user records.
 * All queries use AccessLevel.SYSTEM_MODE.
 *
 * No DML, no business logic.
 */
public with sharing class DHC_CaptureScopeSelector {

    /**
     * @return  Comma-separated DHC_Target_Objects__c for the active FieldAccess scope,
     *          split and trimmed into individual object API names.
     *          Returns an empty list if no active FieldAccess scope exists or
     *          if DHC_Target_Objects__c is blank.
     */
    public static List<String> getFieldAccessTargetObjects() {
        Map<String, Object> binds = new Map<String, Object>{
            'isActive'      => true,
            'componentType' => 'FieldAccess'
        };
        List<DHC_Capture_Scope__mdt> scopes = Database.queryWithBinds(
            'SELECT DHC_Target_Objects__c ' +
            'FROM DHC_Capture_Scope__mdt ' +
            'WHERE DHC_Is_Active__c = :isActive ' +
            'AND DHC_Component_Type__c = :componentType ' +
            'LIMIT 1',
            binds,
            AccessLevel.SYSTEM_MODE
        );
        if (scopes.isEmpty() || String.isBlank(scopes[0].DHC_Target_Objects__c)) {
            return new List<String>();
        }
        return parseTargetObjects(scopes[0].DHC_Target_Objects__c);
    }

    /**
     * @description Splits and trims a comma-separated list of object API names.
     * Exposed for unit testing only.
     */
    @TestVisible
    private static List<String> parseTargetObjects(String raw) {
        if (String.isBlank(raw)) { return new List<String>(); }
        List<String> result = new List<String>();
        for (String s : raw.split(',')) {
            String trimmed = s.trim();
            if (String.isNotBlank(trimmed)) {
                result.add(trimmed);
            }
        }
        return result;
    }

    /**
     * @return  Ordered list of DHC_Component_Type__c values for all active scopes,
     *          sorted ascending by DHC_Sequence__c.
     */
    public static List<String> getActiveScopeTypes() {
        Map<String, Object> binds = new Map<String, Object>{ 'isActive' => true };
        List<DHC_Capture_Scope__mdt> scopes = Database.queryWithBinds(
            'SELECT DHC_Component_Type__c ' +
            'FROM DHC_Capture_Scope__mdt ' +
            'WHERE DHC_Is_Active__c = :isActive ' +
            'ORDER BY DHC_Sequence__c ASC',
            binds,
            AccessLevel.SYSTEM_MODE
        );
        List<String> types = new List<String>();
        for (DHC_Capture_Scope__mdt s : scopes) {
            types.add(s.DHC_Component_Type__c);
        }
        return types;
    }
}
