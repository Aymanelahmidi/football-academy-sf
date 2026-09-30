Generate technical and functional documentation for a given module or object of the Football Academy SF project.

Usage: /doc [object or module name]
Example: /doc FA_Player__c  OR  /doc medical  OR  /doc training

Steps:
1. Read all relevant metadata files (object-meta.xml, field files, Apex classes, LWC components)
2. Generate:
   - **Technical doc**: object schema, fields, relationships, Apex service methods, LWC components
   - **Functional doc**: business description, use cases, user flows (non-technical language)
3. Format output as clean Markdown ready to share with a client or team

Follow Football Academy SF conventions from CLAUDE.md.
