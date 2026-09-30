Review the code quality of a given Apex class or LWC component in the Football Academy SF project.

Usage: /review [filename or path]
Example: /review FA_PlayerService.cls  OR  /review faPlayerList

Check for:
1. **Governor Limits**: SOQL in loops, DML in loops, missing bulkification
2. **Security**: with sharing declaration, SOQL injection risks, FLS enforcement
3. **Best Practices**: FA_ naming conventions, service/controller separation, @AuraEnabled usage
4. **Test Coverage**: is there a corresponding test class? Coverage >= 85%?
5. **Performance**: unnecessary queries, missing indexes, large data risks

Output a prioritized list of issues: Critical / Warning / Suggestion.
