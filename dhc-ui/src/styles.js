/**
 * CSS for the DHC UI — complete design system.
 * Injected as a <style> tag at mount time so the IIFE bundle stays a single file.
 * Design tokens extracted from the high-fidelity mockups (Inter + JetBrains Mono).
 */

const CSS = `
/* ─── Design Tokens ─────────────────────────────────────────────────────── */

.dhc {
  --bg:#F6F8FB; --surface:#FFFFFF; --subtle:#F1F4F9; --well:#F8FAFC;
  --line:#DDE3EC; --line2:#C7D0DC; --hair:#EDF0F5;
  --txt:#0B1623; --txt2:#54657A; --txt3:#6E7E94;
  --brand:#0B6EEF; --brand-on:#FFFFFF; --brand-soft:#EEF4FE; --brand-line:#CBDDF9;
  --crit:#C8232C; --crit-bg:#FDF0F0; --crit-line:#F3C9CB;
  --warn:#B35309; --warn-bg:#FDF5EA; --warn-line:#F0DCBF;
  --ok:#1B7A43; --ok-bg:#EDF7F1; --ok-line:#C5E3D1;
  --mut:#5C6B7F; --mut-bg:#F2F4F7;
  --diff-a:#FDF9F3; --diff-b:#F5F9FE;
  --shadow:0 1px 2px rgba(11,22,35,.05);
  font-family: Inter, system-ui, -apple-system, sans-serif;
  -webkit-font-smoothing: antialiased;
  background: var(--bg);
  color: var(--txt);
  min-height: 100%;
}

.dhc[data-theme="dark"] {
  --bg:#0B1017; --surface:#141A23; --subtle:#1B2230; --well:#10161E;
  --line:#273243; --line2:#36445A; --hair:#1F2838;
  --txt:#E9EEF5; --txt2:#A2B1C4; --txt3:#7C8CA1;
  --brand:#4A93FF; --brand-on:#07101C; --brand-soft:#132236; --brand-line:#23456E;
  --crit:#FF7B72; --crit-bg:#2A1517; --crit-line:#5A2529;
  --warn:#F2B443; --warn-bg:#2A2012; --warn-line:#59431C;
  --ok:#4ED68E; --ok-bg:#122520; --ok-line:#1F4D38;
  --mut:#9AA7B8; --mut-bg:#1B2230;
  --diff-a:#241D10; --diff-b:#111E30;
  --shadow:0 1px 2px rgba(0,0,0,.4);
}

.dhc * { box-sizing: border-box; }
.dhc a { color: var(--brand); }
.dhc :focus-visible { outline: 2px solid var(--brand); outline-offset: 2px; border-radius: 4px; }

/* ─── App header ─────────────────────────────────────────────────────────── */

.dhc-header {
  display: flex;
  flex-wrap: wrap;
  gap: 16px;
  align-items: center;
  justify-content: space-between;
  padding: 14px 32px;
  background: var(--surface);
  border-bottom: 1px solid var(--line);
}

.dhc-header-left {
  display: flex;
  align-items: center;
  gap: 11px;
}

.dhc-header-logo {
  width: 28px;
  height: 28px;
  border-radius: 7px;
  background: var(--brand);
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.dhc-header-title {
  font-size: 15px;
  font-weight: 600;
  letter-spacing: -0.012em;
  margin: 0;
}

.dhc-header-right {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 18px;
}

/* ─── Theme toggle ───────────────────────────────────────────────────────── */

.dhc-theme-group {
  display: inline-flex;
  align-items: center;
  gap: 3px;
  padding: 3px;
  background: var(--subtle);
  border: 1px solid var(--line);
  border-radius: 9px;
}

.dhc-theme-btn {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  min-height: 34px;
  padding: 0 12px;
  font-size: 12px;
  font-weight: 600;
  font-family: inherit;
  border-radius: 7px;
  cursor: pointer;
  border: 1px solid transparent;
  background: transparent;
  color: var(--txt3);
  transition: all 150ms ease;
}

.dhc-theme-btn--active {
  color: var(--txt);
  background: var(--surface);
  border-color: var(--line2);
}

/* ─── Navigation ──────────────────────────────────────────────────────────── */

.dhc-nav {
  display: flex;
  flex-wrap: wrap;
  gap: 2px;
  padding: 0 32px;
  background: var(--surface);
  border-bottom: 1px solid var(--line);
}

.dhc-nav-btn {
  padding: 13px 15px;
  font-size: 13px;
  font-weight: 500;
  font-family: inherit;
  color: var(--txt2);
  text-decoration: none;
  border: none;
  background: none;
  cursor: pointer;
  border-bottom: 2px solid transparent;
  transition: color 150ms ease;
  white-space: nowrap;
}

.dhc-nav-btn:hover { color: var(--txt); }

.dhc-nav-btn--active {
  font-weight: 600;
  color: var(--txt);
  border-bottom-color: var(--brand);
}

.dhc-nav-btn:focus-visible {
  outline: 2px solid var(--brand);
  outline-offset: -2px;
  border-radius: 4px 4px 0 0;
}

/* ─── Screen ──────────────────────────────────────────────────────────────── */

.dhc-screen {
  max-width: 1060px;
  margin: 0 auto;
  padding: 32px;
  display: flex;
  flex-direction: column;
  gap: 22px;
}

.dhc-screen-title {
  margin: 0 0 7px;
  font-size: 24px;
  font-weight: 700;
  letter-spacing: -0.025em;
}

.dhc-screen-subtitle {
  margin: 0;
  font-size: 14px;
  color: var(--txt2);
}

.dhc-section-title {
  margin: 0 0 14px;
  font-size: 18px;
  font-weight: 600;
  letter-spacing: -0.015em;
}

.dhc-overline {
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 0.09em;
  color: var(--txt3);
  text-transform: uppercase;
}

/* ─── Cards ───────────────────────────────────────────────────────────────── */

.dhc-card {
  background: var(--surface);
  border: 1px solid var(--line);
  border-radius: 12px;
  box-shadow: var(--shadow);
  overflow: hidden;
}

.dhc-card-body { padding: 30px 32px; }

/* ─── Buttons ─────────────────────────────────────────────────────────────── */

.dhc-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 7px;
  min-height: 44px;
  padding: 0 17px;
  font-size: 13px;
  font-weight: 600;
  font-family: inherit;
  border-radius: 8px;
  cursor: pointer;
  border: 1px solid;
  white-space: nowrap;
  transition: background 150ms ease, transform 150ms ease, box-shadow 150ms ease;
}

.dhc-btn:focus-visible { outline: 2px solid var(--brand); outline-offset: 2px; }
.dhc-btn:disabled { opacity: 0.45; cursor: not-allowed; }

.dhc-btn--primary {
  color: var(--brand-on);
  background: var(--brand);
  border-color: var(--brand);
}
.dhc-btn--primary:hover:not(:disabled) { filter: brightness(1.1); }

.dhc-btn--secondary {
  font-weight: 500;
  color: var(--txt);
  background: var(--surface);
  border-color: var(--line2);
}
.dhc-btn--secondary:hover:not(:disabled) { background: var(--subtle); }

.dhc-btn--danger {
  color: #fff;
  background: var(--crit);
  border-color: var(--crit);
}

.dhc-btn--ghost {
  font-weight: 500;
  color: var(--txt2);
  background: transparent;
  border-color: var(--line);
}
.dhc-btn--ghost:hover:not(:disabled) { background: var(--subtle); }

.dhc-btn--link {
  background: none;
  border: none;
  color: var(--brand);
  padding: 0;
  min-height: unset;
  font-size: inherit;
  font-weight: 500;
  cursor: pointer;
  text-decoration: none;
}
.dhc-btn--link:hover { text-decoration: underline; }

/* ─── Badges ──────────────────────────────────────────────────────────────── */

.dhc-badge {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  font-size: 11px;
  font-weight: 600;
  border-radius: 6px;
  padding: 4px 10px;
  border: 1px solid;
  white-space: nowrap;
  flex-shrink: 0;
}

.dhc-badge--crit   { color: var(--crit); background: var(--crit-bg); border-color: var(--crit-line); }
.dhc-badge--warn   { color: var(--warn); background: var(--warn-bg); border-color: var(--warn-line); }
.dhc-badge--info   { color: var(--brand); background: var(--brand-soft); border-color: var(--brand-line); }
.dhc-badge--ne     { color: var(--mut); background: var(--mut-bg); border-color: var(--line); }
.dhc-badge--ok     { color: var(--ok); background: var(--ok-bg); border-color: var(--ok-line); }

.dhc-badge--modif  { color: var(--warn); background: var(--warn-bg); border-color: var(--warn-line); }
.dhc-badge--absent { color: var(--mut); background: var(--mut-bg); border-color: var(--line); }
.dhc-badge--inchange { color: var(--txt3); background: var(--well); border-color: transparent; font-weight: 500; }
.dhc-badge--new    { font-size: 10px; font-weight: 700; letter-spacing: 0.05em; color: var(--ok); background: var(--ok-bg); border-color: var(--ok-line); border-radius: 5px; padding: 3px 7px; }
.dhc-badge--disabled { font-size: 10px; font-weight: 700; letter-spacing: 0.05em; color: var(--mut); background: var(--mut-bg); border-color: var(--line); border-radius: 5px; padding: 3px 7px; }

/* Type badges (component types) */
.dhc-type-badge {
  font-size: 11px;
  font-weight: 600;
  color: var(--txt2);
  background: var(--subtle);
  border: 1px solid var(--line);
  border-radius: 6px;
  padding: 3px 8px;
  white-space: nowrap;
}

/* API name badge */
.dhc-api-name {
  font-family: 'JetBrains Mono', monospace;
  font-size: 11px;
  color: var(--txt3);
  background: var(--well);
  border: 1px solid var(--line);
  border-radius: 6px;
  padding: 3px 8px;
}

/* Copy button for API name */
.dhc-copy-btn {
  display: inline-flex;
  align-items: center;
  gap: 7px;
  min-height: 32px;
  padding: 0 10px;
  font-family: 'JetBrains Mono', monospace;
  font-size: 11px;
  color: var(--txt2);
  background: var(--well);
  border: 1px solid var(--line);
  border-radius: 6px;
  cursor: pointer;
}
.dhc-copy-btn:hover { background: var(--subtle); }

/* ─── Severity Counters (Dashboard) ──────────────────────────────────────── */

.dhc-counters {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 14px;
}

@media (max-width: 800px) {
  .dhc-counters { grid-template-columns: repeat(2, minmax(0, 1fr)); }
}

.dhc-counter {
  background: var(--surface);
  border: 1px solid var(--line);
  border-radius: 12px;
  padding: 18px 20px;
  box-shadow: var(--shadow);
}

.dhc-counter-header {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 14px;
}

.dhc-counter-label {
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 0.08em;
  color: var(--txt2);
  text-transform: uppercase;
}

.dhc-counter-row {
  display: flex;
  align-items: baseline;
  gap: 9px;
}

.dhc-counter-value {
  font-size: 34px;
  font-weight: 700;
  font-variant-numeric: tabular-nums;
  line-height: 1;
  letter-spacing: -0.025em;
}

.dhc-counter-delta {
  font-size: 12px;
  font-weight: 600;
  font-variant-numeric: tabular-nums;
}

/* ─── Component counters (Composants screen) ─────────────────────────────── */

.dhc-comp-counters {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 14px;
}

@media (max-width: 800px) {
  .dhc-comp-counters { grid-template-columns: repeat(2, minmax(0, 1fr)); }
}

.dhc-comp-counter {
  background: var(--surface);
  border: 1px solid var(--line);
  border-radius: 12px;
  padding: 16px 18px;
  box-shadow: var(--shadow);
}

.dhc-comp-counter-value {
  font-size: 26px;
  font-weight: 700;
  font-variant-numeric: tabular-nums;
  line-height: 1;
  margin-bottom: 8px;
  letter-spacing: -0.02em;
}

.dhc-comp-counter-label {
  font-size: 12px;
  color: var(--txt2);
}

/* ─── Release bar (Dashboard) ────────────────────────────────────────────── */

.dhc-release-bar {
  display: flex;
  flex-wrap: wrap;
  gap: 18px;
  align-items: center;
  justify-content: space-between;
}

.dhc-release-info {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 12px;
}

.dhc-release-label {
  font-size: 14px;
  font-weight: 600;
}

.dhc-release-time {
  font-size: 13px;
  color: var(--txt2);
  font-variant-numeric: tabular-nums;
}

.dhc-release-actions {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

/* ─── Verdict card (Dashboard) ───────────────────────────────────────────── */

.dhc-verdict {
  display: flex;
  flex-wrap: wrap;
  gap: 28px;
  align-items: flex-start;
  justify-content: space-between;
}

.dhc-verdict-text {
  flex: 999 1 440px;
  min-width: 0;
}

.dhc-verdict-headline {
  margin: 0 0 12px;
  font-size: 28px;
  font-weight: 700;
  line-height: 1.2;
  letter-spacing: -0.025em;
}

.dhc-verdict-desc {
  margin: 0;
  font-size: 15px;
  line-height: 1.6;
  color: var(--txt2);
  max-width: 58ch;
}

/* ─── Finding list items (Dashboard + Constats) ──────────────────────────── */

.dhc-finding-card {
  display: flex;
  flex-wrap: wrap;
  gap: 18px;
  align-items: center;
  padding: 18px 22px;
}

.dhc-finding-card + .dhc-finding-card { border-top: 1px solid var(--hair); }
.dhc-finding-card:last-child { border-bottom: none; }

.dhc-finding-body {
  flex: 999 1 340px;
  min-width: 0;
}

.dhc-finding-message {
  font-size: 14px;
  line-height: 1.5;
  margin-bottom: 8px;
}

.dhc-finding-meta {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 8px;
}

.dhc-finding-label {
  font-size: 13px;
  font-weight: 500;
}

.dhc-finding-sub {
  font-size: 12px;
  color: var(--txt3);
  font-variant-numeric: tabular-nums;
}

/* ─── Footer bar (Dashboard) ─────────────────────────────────────────────── */

.dhc-footer-bar {
  display: flex;
  flex-wrap: wrap;
  gap: 14px;
  align-items: center;
  justify-content: space-between;
  margin-top: 16px;
}

.dhc-footer-stat {
  font-size: 13px;
  color: var(--txt2);
  font-variant-numeric: tabular-nums;
}

/* ─── Filter bar (Constats + Composants) ─────────────────────────────────── */

.dhc-filter-bar {
  background: var(--surface);
  border: 1px solid var(--line);
  border-radius: 12px;
  padding: 16px 20px;
  display: flex;
  flex-wrap: wrap;
  gap: 14px;
  align-items: center;
  box-shadow: var(--shadow);
}

.dhc-select {
  background: var(--surface);
  color: var(--txt);
  border: 1px solid var(--line2);
  border-radius: 8px;
  padding: 10px 12px;
  font-size: 13px;
  font-family: inherit;
  min-height: 44px;
  cursor: pointer;
}
.dhc-select:hover { border-color: var(--brand); }
.dhc-select:focus-visible { outline: 2px solid var(--brand); outline-offset: 2px; border-color: var(--brand); }

.dhc-filter-sep {
  width: 1px;
  height: 26px;
  background: var(--line);
  flex-shrink: 0;
}

.dhc-checkbox-label {
  display: inline-flex;
  align-items: center;
  gap: 9px;
  font-size: 13px;
  cursor: pointer;
  min-height: 44px;
}

.dhc-checkbox {
  width: 17px;
  height: 17px;
  accent-color: #0B6EEF;
  cursor: pointer;
}

.dhc-search-input {
  flex: 999 1 260px;
  min-width: 0;
  background: var(--surface);
  color: var(--txt);
  border: 1px solid var(--line2);
  border-radius: 8px;
  padding: 11px 14px;
  font-size: 13px;
  font-family: inherit;
  min-height: 44px;
}
.dhc-search-input:hover { border-color: var(--brand); }
.dhc-search-input:focus-visible { outline: 2px solid var(--brand); outline-offset: 2px; border-color: var(--brand); }

/* ─── Findings groups (Constats screen) ──────────────────────────────────── */

.dhc-group {
  background: var(--surface);
  border: 1px solid var(--line);
  border-radius: 12px;
  overflow: hidden;
  box-shadow: var(--shadow);
}

.dhc-group-header {
  display: flex;
  flex-wrap: wrap;
  gap: 14px;
  align-items: center;
  padding: 15px 20px;
  background: var(--subtle);
  border-bottom: 1px solid var(--line);
  cursor: pointer;
}
.dhc-group-header:hover { background: var(--well); }

.dhc-group-rule {
  flex: 999 1 240px;
  min-width: 0;
  font-size: 13px;
  font-weight: 500;
}

.dhc-group-info {
  font-size: 12px;
  color: var(--txt3);
  flex-shrink: 0;
  font-variant-numeric: tabular-nums;
}

.dhc-group-count {
  font-size: 13px;
  font-weight: 600;
  flex-shrink: 0;
  font-variant-numeric: tabular-nums;
}

.dhc-group-item {
  display: flex;
  flex-wrap: wrap;
  gap: 14px;
  align-items: center;
  padding: 18px 20px;
}

.dhc-group-item + .dhc-group-item { border-top: 1px solid var(--hair); }

.dhc-group-item-body {
  flex: 999 1 320px;
  min-width: 0;
}

/* Bulk accept bar */
.dhc-bulk-bar {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  align-items: center;
  padding: 16px 20px;
  background: var(--well);
}

.dhc-bulk-label {
  font-size: 12px;
  color: var(--txt2);
  flex-shrink: 0;
}

.dhc-bulk-input {
  flex: 999 1 300px;
  min-width: 0;
  background: var(--surface);
  color: var(--txt);
  border: 1px solid var(--line2);
  border-radius: 8px;
  padding: 11px 13px;
  font-size: 13px;
  font-family: inherit;
  min-height: 44px;
}

/* ─── Pagination ──────────────────────────────────────────────────────────── */

.dhc-pagination {
  display: flex;
  flex-wrap: wrap;
  gap: 14px;
  align-items: center;
  justify-content: center;
}

.dhc-pagination-info {
  font-size: 13px;
  color: var(--txt2);
  font-variant-numeric: tabular-nums;
}

/* ─── Comparison screen ──────────────────────────────────────────────────── */

.dhc-comp-nav {
  display: flex;
  flex-wrap: wrap;
  gap: 16px;
  align-items: center;
  justify-content: space-between;
}

.dhc-back-link {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  font-size: 13px;
  font-weight: 500;
  text-decoration: none;
  color: var(--txt2);
  background: none;
  border: none;
  cursor: pointer;
  padding: 0;
  font-family: inherit;
}
.dhc-back-link:hover { color: var(--brand); }

.dhc-comp-pager {
  display: flex;
  align-items: center;
  gap: 10px;
}

.dhc-comp-pager-info {
  font-size: 12px;
  color: var(--txt3);
  font-variant-numeric: tabular-nums;
}

.dhc-pager-btn {
  width: 44px;
  height: 44px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--txt);
  background: var(--surface);
  border: 1px solid var(--line2);
  border-radius: 8px;
  cursor: pointer;
}
.dhc-pager-btn:hover { background: var(--subtle); }
.dhc-pager-btn:disabled {
  color: var(--txt3);
  background: var(--subtle);
  border-color: var(--line);
  cursor: not-allowed;
}

/* Identity card */
.dhc-identity { padding: 24px 28px; }

.dhc-identity-badges {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 9px;
  margin-bottom: 12px;
}

.dhc-identity-title {
  margin: 0 0 10px;
  font-size: 24px;
  font-weight: 700;
  letter-spacing: -0.025em;
}

.dhc-identity-meta {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 12px;
}

.dhc-identity-desc {
  font-size: 13px;
  color: var(--txt2);
}

/* Diff toggle */
.dhc-diff-toggle {
  display: flex;
  flex-wrap: wrap;
  gap: 20px;
  align-items: center;
  justify-content: space-between;
}

/* Diff table — 3-column grid */
.dhc-diff-head {
  display: grid;
  grid-template-columns: 220px minmax(0, 1fr) minmax(0, 1fr);
  background: var(--subtle);
  border-bottom: 1px solid var(--line);
}

.dhc-diff-head-cell {
  padding: 13px 20px;
}

.dhc-diff-head-cell + .dhc-diff-head-cell {
  border-left: 1px solid var(--line);
}

.dhc-diff-head-label {
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 0.09em;
  text-transform: uppercase;
  margin-bottom: 3px;
}

.dhc-diff-head-date {
  font-size: 11px;
  color: var(--txt3);
  font-variant-numeric: tabular-nums;
}

.dhc-diff-row {
  display: grid;
  grid-template-columns: 220px minmax(0, 1fr) minmax(0, 1fr);
  border-bottom: 1px solid var(--hair);
}

.dhc-diff-attr {
  padding: 18px 20px;
}

.dhc-diff-attr-name {
  font-size: 13px;
  font-weight: 500;
  margin-bottom: 6px;
}

.dhc-diff-attr-key {
  font-family: 'JetBrains Mono', monospace;
  font-size: 11px;
  color: var(--txt3);
  margin-bottom: 9px;
}

.dhc-diff-cell {
  padding: 18px 20px;
  border-left: 1px solid var(--hair);
}

.dhc-diff-cell--baseline { background: var(--diff-a); }
.dhc-diff-cell--current  { background: var(--diff-b); }

.dhc-diff-val {
  font-size: 15px;
  font-weight: 600;
  margin-bottom: 7px;
}

.dhc-diff-desc {
  font-size: 12px;
  color: var(--txt2);
  line-height: 1.5;
}

/* Collapsed identical row */
.dhc-diff-collapsed {
  display: flex;
  flex-wrap: wrap;
  gap: 14px;
  align-items: center;
  padding: 15px 20px;
  background: var(--well);
}

.dhc-diff-collapsed-info {
  font-size: 13px;
  color: var(--txt2);
  flex: 999 1 200px;
  min-width: 0;
  font-variant-numeric: tabular-nums;
}

/* Access map in diff cells */
.dhc-access-block { margin-bottom: 14px; }
.dhc-access-block:last-child { margin-bottom: 0; }

.dhc-access-perm-name {
  font-size: 12px;
  font-weight: 500;
  margin-bottom: 8px;
}

.dhc-access-pills {
  display: flex;
  flex-wrap: wrap;
  gap: 5px;
}

.dhc-access-pill {
  font-size: 11px;
  color: var(--txt);
  background: var(--surface);
  border: 1px solid var(--line);
  border-radius: 5px;
  padding: 4px 9px;
}

.dhc-access-pill--new {
  display: inline-flex;
  align-items: center;
  gap: 5px;
  font-weight: 600;
  color: var(--brand-on);
  background: var(--brand);
  border-color: var(--brand);
}

/* Verdict section (comparison) */
.dhc-verdict-section-head {
  padding: 14px 22px;
  background: var(--subtle);
  border-bottom: 1px solid var(--line);
}

.dhc-verdict-row {
  display: flex;
  flex-wrap: wrap;
  gap: 16px;
  align-items: center;
  padding: 18px 22px;
}

.dhc-verdict-row + .dhc-verdict-row { border-top: 1px solid var(--hair); }

.dhc-verdict-msg {
  flex: 999 1 300px;
  min-width: 0;
  font-size: 14px;
  line-height: 1.5;
}

.dhc-verdict-rule {
  font-size: 12px;
  color: var(--txt3);
  flex-shrink: 0;
}

/* Fingerprint bar */
.dhc-fingerprint {
  display: flex;
  flex-wrap: wrap;
  gap: 16px;
  align-items: center;
  padding: 14px 18px;
  background: var(--surface);
  border: 1px solid var(--line);
  border-radius: 10px;
}

.dhc-fingerprint-hash {
  font-family: 'JetBrains Mono', monospace;
  font-size: 11px;
  color: var(--txt2);
  flex: 999 1 180px;
  min-width: 0;
  word-break: break-all;
}

.dhc-fingerprint-note {
  font-size: 12px;
  color: var(--txt3);
  flex-shrink: 0;
}

/* ─── Tables (Composants screen) ─────────────────────────────────────────── */

.dhc-table {
  width: 100%;
  border-collapse: collapse;
}

.dhc-table th,
.dhc-table td {
  text-align: left;
  font-variant-numeric: tabular-nums;
}

.dhc-table thead tr {
  background: var(--subtle);
  border-bottom: 1px solid var(--line);
}

.dhc-table th {
  padding: 13px 20px;
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 0.09em;
  color: var(--txt3);
  text-transform: uppercase;
}

.dhc-table td {
  padding: 16px 20px;
}

.dhc-table tbody tr { border-bottom: 1px solid var(--hair); }
.dhc-table tbody tr:last-child { border-bottom: none; }
.dhc-table tbody tr:hover { background: var(--subtle); }

.dhc-table-highlight { background: var(--brand-soft); }
.dhc-table-highlight:hover { background: var(--brand-soft) !important; }

.dhc-table-name {
  font-size: 14px;
  font-weight: 500;
  margin-bottom: 6px;
}

.dhc-table-name-suffix {
  font-weight: 400;
  color: var(--txt3);
}

/* ─── Configuration screen ───────────────────────────────────────────────── */

.dhc-config-head {
  display: flex;
  flex-wrap: wrap;
  gap: 20px;
  align-items: flex-start;
  justify-content: space-between;
}

.dhc-config-head-text {
  flex: 999 1 460px;
  min-width: 0;
}

.dhc-config-desc {
  margin: 0;
  font-size: 14px;
  color: var(--txt2);
  max-width: 70ch;
}

/* Scope rows */
.dhc-scope-row {
  display: flex;
  flex-wrap: wrap;
  gap: 18px;
  align-items: center;
  padding: 16px 20px;
}

.dhc-scope-row + .dhc-scope-row { border-top: 1px solid var(--hair); }

.dhc-scope-type {
  font-size: 13px;
  font-weight: 600;
  width: 130px;
  flex-shrink: 0;
}

.dhc-scope-desc {
  flex: 999 1 280px;
  min-width: 0;
  font-size: 13px;
  color: var(--txt2);
}

.dhc-scope-count {
  font-size: 12px;
  color: var(--txt3);
  flex-shrink: 0;
  font-variant-numeric: tabular-nums;
}

/* Scope target objects */
.dhc-scope-targets {
  padding-left: 148px;
}

.dhc-chips {
  display: flex;
  flex-wrap: wrap;
  gap: 7px;
  margin-bottom: 11px;
}

.dhc-chip {
  font-family: 'JetBrains Mono', monospace;
  font-size: 11px;
  color: var(--txt2);
  background: var(--well);
  border: 1px solid var(--line);
  border-radius: 6px;
  padding: 5px 10px;
}

.dhc-scope-note {
  margin: 0;
  font-size: 12px;
  color: var(--txt3);
  line-height: 1.6;
  max-width: 76ch;
}

/* Rule rows */
.dhc-rule-type-header {
  padding: 12px 20px;
  background: var(--subtle);
  border-bottom: 1px solid var(--line);
  border-top: 1px solid var(--line);
}

.dhc-rule-type-header:first-child { border-top: none; }

.dhc-rule-row {
  display: flex;
  flex-wrap: wrap;
  gap: 16px;
  align-items: center;
  padding: 15px 20px;
}

.dhc-rule-row + .dhc-rule-row { border-top: 1px solid var(--hair); }

.dhc-rule-dot {
  width: 8px;
  height: 8px;
  border-radius: 2px;
  flex-shrink: 0;
}
.dhc-rule-dot--crit { background: var(--crit); }
.dhc-rule-dot--warn { background: var(--warn); }
.dhc-rule-dot--info { background: var(--brand); }

.dhc-rule-dot--disabled {
  background: transparent;
  border: 1.5px solid var(--txt3);
}

.dhc-rule-msg {
  flex: 999 1 320px;
  min-width: 0;
  font-size: 13px;
}

.dhc-rule-expr {
  font-family: 'JetBrains Mono', monospace;
  font-size: 11px;
  color: var(--txt3);
  background: var(--well);
  border: 1px solid var(--line);
  border-radius: 6px;
  padding: 5px 9px;
  flex-shrink: 0;
}

/* Disabled rule row */
.dhc-rule-row--disabled {
  background: var(--well);
}

.dhc-rule-msg--disabled {
  color: var(--txt3);
  text-decoration: line-through;
}

.dhc-rule-explain {
  font-size: 12px;
  color: var(--txt3);
  line-height: 1.6;
  max-width: 76ch;
}

.dhc-rules-footer {
  display: flex;
  flex-wrap: wrap;
  gap: 14px;
  align-items: center;
  justify-content: center;
  margin-top: 16px;
}

.dhc-rules-footer-info {
  font-size: 13px;
  color: var(--txt2);
  font-variant-numeric: tabular-nums;
}

/* ─── Info banner ─────────────────────────────────────────────────────────── */

.dhc-info-banner {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  align-items: flex-start;
  background: var(--brand-soft);
  border: 1px solid var(--brand-line);
  border-radius: 10px;
  padding: 15px 18px;
}

.dhc-info-banner-text {
  flex: 999 1 420px;
  min-width: 0;
  font-size: 13px;
  line-height: 1.6;
  color: var(--txt);
}

/* ─── Banners (success/error) ────────────────────────────────────────────── */

.dhc-banner {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 14px 20px;
  border-radius: 10px;
  font-size: 14px;
  border: 1px solid;
}

.dhc-banner--success {
  color: var(--ok);
  background: var(--ok-bg);
  border-color: var(--ok-line);
}

.dhc-banner--error {
  color: var(--crit);
  background: var(--crit-bg);
  border-color: var(--crit-line);
}

.dhc-banner-dismiss {
  margin-left: auto;
  background: none;
  border: none;
  color: inherit;
  cursor: pointer;
  font-size: 18px;
  line-height: 1;
  opacity: 0.6;
  padding: 4px;
  flex-shrink: 0;
}
.dhc-banner-dismiss:hover { opacity: 1; }

/* ─── Dialog ──────────────────────────────────────────────────────────────── */

.dhc-dialog-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0,0,0,0.45);
  backdrop-filter: blur(4px);
  -webkit-backdrop-filter: blur(4px);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  animation: dhc-fade-in 150ms ease;
}

@keyframes dhc-fade-in {
  from { opacity: 0; }
  to   { opacity: 1; }
}

.dhc-dialog {
  background: var(--surface);
  border-radius: 12px;
  padding: 28px;
  max-width: 480px;
  width: 90%;
  box-shadow: 0 10px 30px rgba(0,0,0,.2);
  animation: dhc-slide-up 250ms ease;
}

@keyframes dhc-slide-up {
  from { transform: translateY(10px); opacity: 0; }
  to   { transform: translateY(0);    opacity: 1; }
}

.dhc-dialog-title {
  font-size: 16px;
  font-weight: 600;
  margin: 0 0 16px;
}

.dhc-dialog-body {
  font-size: 14px;
  color: var(--txt2);
  line-height: 1.6;
  margin-bottom: 24px;
}

.dhc-dialog-actions {
  display: flex;
  gap: 8px;
  justify-content: flex-end;
}

/* ─── States ──────────────────────────────────────────────────────────────── */

.dhc-loading {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 12px;
  padding: 60px 32px;
  color: var(--txt2);
  font-size: 14px;
}

.dhc-spinner {
  width: 20px;
  height: 20px;
  border: 2.5px solid var(--line);
  border-top-color: var(--brand);
  border-radius: 50%;
  animation: dhc-spin 0.7s linear infinite;
  flex-shrink: 0;
}

.dhc-spinner--sm { width: 14px; height: 14px; border-width: 2px; }

@keyframes dhc-spin { to { transform: rotate(360deg); } }

.dhc-error {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  gap: 12px;
  padding: 32px;
  font-size: 14px;
  color: var(--crit);
}

.dhc-empty {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 40px 20px;
  font-size: 14px;
  color: var(--txt3);
}

/* Skeleton */
@keyframes dhc-shimmer {
  0%   { background-position: -400px 0; }
  100% { background-position:  400px 0; }
}

.dhc-skel-cell {
  display: block;
  height: 14px;
  border-radius: 6px;
  background: linear-gradient(90deg, var(--line) 25%, var(--subtle) 50%, var(--line) 75%);
  background-size: 800px 100%;
  animation: dhc-shimmer 1.4s ease infinite;
}

.dhc-skel-row td { padding: 14px 20px; }

/* ─── Dimmed refresh ──────────────────────────────────────────────────────── */

.dhc-content--refreshing {
  opacity: 0.5;
  pointer-events: none;
  transition: opacity 250ms ease;
}

.dhc-refreshing-hint {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  font-size: 12px;
  color: var(--txt2);
}

/* ─── Utilities ───────────────────────────────────────────────────────────── */

.dhc-sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0,0,0,0);
  white-space: nowrap;
  border: 0;
}

.dhc-text-muted { color: var(--txt2); }
.dhc-text-mono { font-family: 'JetBrains Mono', monospace; font-size: 11px; color: var(--txt3); }

.dhc-inline-actions { display: flex; gap: 6px; flex-wrap: wrap; }

/* Textarea */
.dhc-textarea {
  width: 100%;
  max-width: 520px;
  padding: 10px 13px;
  border: 1px solid var(--line2);
  border-radius: 8px;
  font-size: 13px;
  font-family: inherit;
  background: var(--surface);
  color: var(--txt);
  resize: vertical;
  box-sizing: border-box;
  min-height: 64px;
}
.dhc-textarea:hover { border-color: var(--brand); }
.dhc-textarea:focus-visible { outline: 2px solid var(--brand); outline-offset: 2px; }

/* Expand row */
.dhc-expand-row td { padding: 0; border-bottom: 2px solid var(--brand); }
.dhc-expand-inner {
  padding: 16px 20px;
  background: var(--brand-soft);
  display: flex;
  flex-direction: column;
  gap: 10px;
}
.dhc-expand-title {
  font-size: 12px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: var(--brand);
}
.dhc-field-hint { font-size: 11px; color: var(--txt3); }

/* Notice (read-only info) */
.dhc-notice {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 14px 18px;
  background: var(--brand-soft);
  border: 1px solid var(--brand-line);
  border-radius: 10px;
  font-size: 13px;
  line-height: 1.6;
  color: var(--txt);
}

/* Loading overlay */
.dhc-loading-overlay-wrap { position: relative; }
.dhc-loading-overlay {
  position: absolute;
  inset: 0;
  background: rgba(255,255,255,0.65);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 5;
  border-radius: 12px;
}
.dhc[data-theme="dark"] .dhc-loading-overlay { background: rgba(11,16,23,0.65); }
`;

/**
 * Injects the DHC stylesheet into <head> exactly once.
 * Safe to call multiple times — guarded by id check.
 */
export function injectStyles() {
  if (typeof document === 'undefined') return;
  if (document.querySelector('#dhc-ui-styles')) return;
  const el = document.createElement('style');
  el.id = 'dhc-ui-styles';
  el.textContent = CSS;
  document.head.appendChild(el);
}
