# Architecture Decision Log — DHC

One entry per decision. Format: choice made / alternative discarded / reason.

---

## ADR-001 — State table instead of snapshots

**Date**: 2026-10-17

**Choice**: Store component state in two LongTextArea fields on `DHC_Component__c` (`Baseline_State__c`, `Current_State__c`). A formula field `Has_Changed__c` derives drift.

**Alternative discarded**: `DHC_Snapshot__c` / `DHC_Snapshot_Item__c` — a separate snapshot object per audit run, with one child record per component per snapshot.

**Reason**: Snapshots multiply records with every run (unbounded growth), make diff queries complex, and require joining three objects to answer "has this component changed?". A single-row-per-component model answers the same question with a formula, keeps storage flat, and makes upsert on External ID trivially idempotent.

---

## ADR-002 — Access stored as JSON map, not as rows

**Date**: 2026-10-17

**Choice**: Serialize permission set accesses as a JSON map `{ "PermSetName": "re" }` in a LongTextArea on the component or finding record.

**Alternative discarded**: One `DHC_Access__c` record per (component × permission set) intersection — a relational child table.

**Reason**: A field typically has 2–10 relevant permission sets. A relational table would generate tens of thousands of records for a medium org, hit DML row limits during upsert, and require an extra SOQL join on every read. The JSON map keeps all access data co-located with the component, one upsert, one read.

---

## ADR-004 — Real deployment closes each session

**Date**: 2026-10-17

**Choice**: Every session ends with a real deployment to the org. The deployment result is the authoritative validity check for metadata files.

**Alternative discarded**: Relying on file review and XML well-formedness as a sufficient pre-deploy check.

**Reason**: The Metadata API enforces constraints that are invisible at file level — e.g. `TextArea` rejecting `<length>`, formula syntax errors, missing required sub-elements. A well-formed XML file can be refused at deploy time. Only a live deployment surfaces these errors. Code review catches logic issues; deployment catches API contract violations.

---

## ADR-005 — Désactivation de Flow_F4 et PermSet_P2

**Date**: 2026-10-22

**Choice**: `Flow_F4` (CHANGED_TO sur `VersionNumber`, Expected `+1`) et `PermSet_P2` (CHANGED_FROM sur `AssignmentCount`, Expected `null`) sont mis à `DHC_Is_Active__c = false`. Ils restent dans le catalogue pour traçabilité.

**Reason**:

*Flow_F4* — L'opérateur `CHANGED_TO` compare la valeur courante à la valeur attendue littérale. La chaîne `+1` n'est pas interprétée comme un delta mais comparée verbatim à la valeur de `VersionNumber` (entier). Cette règle ne peut jamais se déclencher. Par ailleurs, tout incrément de version est un comportement normal lors d'un déploiement ; la traçabilité est fournie par Git, pas par DHC.

*PermSet_P2* — L'opérateur `CHANGED_FROM` nécessite une valeur attendue non-null (valeur *de départ* à détecter). Avec `Expected_Value = null`, la règle est systématiquement Non évaluable et ne produit aucun signal utile. La détection d'une diminution d'assignations est couverte indirectement par `PermSet_P1` (LESS_THAN 1, détecte un permission set sans aucune assignation).

**Alternative discarded**: Ajouter un septième opérateur `DELTA_GT` ou `DECREASED_BY` pour exprimer les intentions de ces deux règles.

**Reason for rejection**: Le jeu de six opérateurs (`EQUALS`, `NOT_EQUALS`, `CHANGED_TO`, `CHANGED_FROM`, `GREATER_THAN`, `LESS_THAN`) est une décision d'architecture (ADR-003). L'ajouter pour deux règles mal formées introduit de la complexité dans le moteur générique sans valeur proportionnelle. La règle correcte sera réécrite si le besoin est confirmé.

---

## ADR-003 — No business logic in Apex, all rules in Custom Metadata

**Date**: 2026-10-17

**Choice**: Every compliance rule (what to check, expected value, severity) is a Custom Metadata record. Apex evaluators are generic dispatchers that read rule configuration at runtime.

**Alternative discarded**: Hard-coded rule logic in Apex classes — one class (or one method) per rule.

**Reason**: Adding or modifying a rule would require a code change, a test update, and a deployment. Custom Metadata records can be deployed independently, are visible to admins, can be toggled without touching Apex, and make the rule catalogue introspectable via SOQL. The Apex layer stays thin and rule-agnostic.
