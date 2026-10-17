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

## ADR-003 — No business logic in Apex, all rules in Custom Metadata

**Date**: 2026-10-17

**Choice**: Every compliance rule (what to check, expected value, severity) is a Custom Metadata record. Apex evaluators are generic dispatchers that read rule configuration at runtime.

**Alternative discarded**: Hard-coded rule logic in Apex classes — one class (or one method) per rule.

**Reason**: Adding or modifying a rule would require a code change, a test update, and a deployment. Custom Metadata records can be deployed independently, are visible to admins, can be toggled without touching Apex, and make the rule catalogue introspectable via SOQL. The Apex layer stays thin and rule-agnostic.
