# DHC Conventions

**Trigger**: activate on any work touching DHC objects, DHC Apex classes, DHC metadata, or DHC deployment logic.

---

## Data Model (frozen)

| Object | Key fields |
|---|---|
| `DHC_Component__c` | `DHC_API_Name__c` (External ID, unique), `Baseline_State__c` (LongTextArea), `Current_State__c` (LongTextArea), `Has_Changed__c` (Formula, compares the two) |
| `DHC_Deployment__c` | deployment envelope, references components |
| `DHC_Finding__c` | one finding per non-compliant rule per component |

**Prohibited objects** — `DHC_Snapshot__c` and `DHC_Snapshot_Item__c` are permanently discarded. Never create them, never reference them, never suggest them.

---

## Upsert rule

Always upsert `DHC_Component__c` on External ID `DHC_API_Name__c`. Never attempt manual ID reconciliation (SOQL lookup → conditional insert/update). The External ID upsert is the only acceptable pattern.

---

## Access storage

Permission set accesses are stored as a single JSON map on the component record:

```json
{ "PermSetName": "re", "AnotherPermSet": "rw" }
```

Never store one record per permission set / object intersection. The map goes in a LongTextArea field on `DHC_Component__c` or `DHC_Finding__c`.

---

## Async execution strategy

| Scope | Pattern |
|---|---|
| FLS (FieldPermissions) | `Batchable` with `QueryLocator` — large volume, must be chunked |
| All other scopes (CRUD, sharing, validation rules…) | `Queueable` |

Never use `@future` for DHC jobs. Never use `Schedulable` directly — schedule via `System.enqueueJob`.

---

## Rule evaluation semantics

| Outcome | Label |
|---|---|
| Rule evaluated and component is compliant | `conforme` |
| Rule evaluated and component is not compliant | `non conforme` |
| Rule cannot be evaluated (missing metadata, unsupported type…) | `non évaluable` |

A result of `non évaluable` is never downgraded to `non conforme`. It must be surfaced as-is.

---

## FieldPermissions absence semantics

A `FieldPermissions` record absent from the org means the permission set grants **no access** to that field. It is not an unknown or uncaptured state — it is "no access" and must be recorded as such.

---

## What this skill does NOT replace

These rules complement `CLAUDE.md`. All FA_ conventions (5-layer architecture, `with sharing`, SOQL in Selector only, no DML in Domain/Controller…) remain in force for DHC classes.
