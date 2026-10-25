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

## JSON storage — two distinct conventions

### State JSON (Baseline_State__c / Current_State__c)

Keys are the **API names of the source fields** (`IsActive`, `IsOutOfDate`, `VersionNumber`…) so that `DHC_Rule__mdt.DHC_Attribute__c` references them directly without any mapping layer.

Do not shorten these keys. Salesforce charges 2 KB per record regardless of content size — compressing key names saves nothing and breaks the direct reference from rules.

### Access JSON (permission set maps)

Permission set accesses are stored as a compact map where keys are permission set names and values encode the access level:

```json
{ "PermSetName": "re", "AnotherPermSet": "e" }
```

`r` = read, `e` = edit. Keys here are data (permission set names), not field attribute names — compact values are appropriate.

Never store one record per permission set / object intersection. The map goes in a LongTextArea field on `DHC_Component__c` or `DHC_Finding__c`.

### Deterministic serialization (both cases)

JSON must be **deterministic**: same state → same string → same hash. Use `JSONGenerator` with a fixed field order. Never serialize a `Map<String, Object>` directly — Apex does not guarantee map iteration order, which would produce different strings for identical states and invalidate hash comparison.

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

## Roles — what Claude Code does and does not do

**Claude Code writes metadata and maintains `manifest/package-dhc.xml`.**
Deployment and Git are exclusively the user's responsibility.

| Action | Owner |
|---|---|
| Write / edit metadata files | Claude Code |
| Update `manifest/package-dhc.xml` | Claude Code (end of each session) |
| `sf project deploy` / `sf project retrieve` | User only |
| `git add` / `git commit` / `git push` | User only |

`manifest/package-dhc.xml` lists only DHC_ prefixed components. It is never mixed with FA_ components.

---

## What this skill does NOT replace

These rules complement `CLAUDE.md`. All FA_ conventions (5-layer architecture, `with sharing`, SOQL in Selector only, no DML in Domain/Controller…) remain in force for DHC classes.
