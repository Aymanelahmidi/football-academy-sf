/**
 * Screen 4 — Composants
 *
 * Matches mockup: 4 state counters (Inchangés, Modifiés, Sans baseline, Disparus),
 * search input, type/state filters, sortable table of all monitored components.
 */
import React, { useState, useEffect, useMemo } from 'react';
import {
  LoadingState, ErrorState, EmptyState, StateBadge,
  extractError, formatDate,
} from './shared.jsx';
import { L } from './labels.js';

export default function Components({ api, onNavigate }) {
  const [components, setComponents] = useState([]);
  const [loading,    setLoading]    = useState(true);
  const [error,      setError]      = useState(null);
  const [search,     setSearch]     = useState('');
  const [filterType, setFilterType] = useState('');
  const [filterState, setFilterState] = useState('');

  useEffect(() => {
    let cancelled = false;
    setLoading(true);

    const run = async () => {
      try {
        // Try getComponents if available, otherwise fallback
        let comps = [];
        if (api.getComponents) {
          comps = await api.getComponents() || [];
        } else {
          // Fallback: get latest deployment and use component data from it
          const dep = await api.getLatestDeployment();
          if (dep && api.getDeploymentComponents) {
            comps = await api.getDeploymentComponents(dep.id) || [];
          }
        }
        if (!cancelled) { setComponents(comps); setLoading(false); }
      } catch (err) {
        if (!cancelled) { setError(extractError(err)); setLoading(false); }
      }
    };

    run();
    return () => { cancelled = true; };
  }, [api]);

  // ─── Derived data ────────────────────────────────────────────────────

  function getState(c) {
    if (c.isAbsent || c.isMissing) return 'Disparu';
    if (!c.hasBaseline && !c.baselineState) return 'Sans baseline';
    if (c.hasChanged) return 'Modifié';
    return 'Inchangé';
  }

  const enriched = useMemo(() =>
    components.map(c => ({ ...c, state: getState(c) })),
    [components]
  );

  const types = useMemo(() => {
    const set = new Set(enriched.map(c => c.componentType).filter(Boolean));
    return Array.from(set).sort();
  }, [enriched]);

  const filtered = useMemo(() => {
    let result = enriched;
    if (search) {
      const q = search.toLowerCase();
      result = result.filter(c =>
        (c.label || '').toLowerCase().includes(q) ||
        (c.apiName || '').toLowerCase().includes(q)
      );
    }
    if (filterType) result = result.filter(c => c.componentType === filterType);
    if (filterState) result = result.filter(c => c.state === filterState);
    return result;
  }, [enriched, search, filterType, filterState]);

  const counts = useMemo(() => ({
    unchanged:   enriched.filter(c => c.state === 'Inchangé').length,
    modified:    enriched.filter(c => c.state === 'Modifié').length,
    noBaseline:  enriched.filter(c => c.state === 'Sans baseline').length,
    missing:     enriched.filter(c => c.state === 'Disparu').length,
  }), [enriched]);

  function handleViewDetail(comp) {
    onNavigate('comparison', {
      componentId: comp.id,
      componentLabel: comp.label || comp.apiName,
      from: { screen: 'components', params: {} },
    });
  }

  // ─── Render ───────────────────────────────────────────────────────────

  if (loading) return <LoadingState />;
  if (error)   return <ErrorState message={error} onRetry={() => window.location.reload()} />;

  return (
    <div className="dhc-screen">
      <div>
        <h1 className="dhc-screen-title">{L.components.title}</h1>
        <p className="dhc-screen-subtitle">{L.components.subtitle}</p>
      </div>

      {/* Counters */}
      <div className="dhc-comp-counters">
        <CounterCard value={counts.unchanged}  label={L.components.unchangedCount}  color="var(--txt3)" />
        <CounterCard value={counts.modified}   label={L.components.modifiedCount}   color="var(--warn)" />
        <CounterCard value={counts.noBaseline} label={L.components.noBaselineCount} color="var(--mut)" />
        <CounterCard value={counts.missing}    label={L.components.missingCount}    color="var(--crit)" />
      </div>

      {/* Filter bar */}
      <div className="dhc-filter-bar">
        <input type="text" className="dhc-search-input" placeholder={L.components.search}
          value={search} onChange={e => setSearch(e.target.value)} aria-label={L.components.search} />

        <select className="dhc-select" value={filterType}
          onChange={e => setFilterType(e.target.value)} aria-label={L.components.filterType}>
          <option value="">{L.components.allTypes}</option>
          {types.map(t => <option key={t} value={t}>{t}</option>)}
        </select>

        <select className="dhc-select" value={filterState}
          onChange={e => setFilterState(e.target.value)} aria-label={L.components.filterState}>
          <option value="">{L.components.allStates}</option>
          <option value="Inchangé">{L.components.stateUnchanged}</option>
          <option value="Modifié">{L.components.stateModified}</option>
          <option value="Sans baseline">{L.components.stateNoBaseline}</option>
          <option value="Disparu">{L.components.stateMissing}</option>
        </select>
      </div>

      {/* Table */}
      {filtered.length === 0 ? (
        <EmptyState message={L.components.noComponents} />
      ) : (
        <div className="dhc-card">
          <table className="dhc-table" aria-label={L.components.title}>
            <thead>
              <tr>
                <th>{L.components.colName}</th>
                <th>{L.components.colType}</th>
                <th>{L.components.colState}</th>
                <th>{L.components.colFindings}</th>
                <th>{L.components.colActions}</th>
              </tr>
            </thead>
            <tbody>
              {filtered.map(c => (
                <tr key={c.id} className={c.state === 'Modifié' ? 'dhc-table-highlight' : undefined}>
                  <td>
                    <div className="dhc-table-name">
                      {c.label || c.apiName}
                    </div>
                    <span className="dhc-api-name">{c.apiName}</span>
                  </td>
                  <td><span className="dhc-type-badge">{c.componentType || '—'}</span></td>
                  <td><StateBadge state={c.state} /></td>
                  <td style={{ fontVariantNumeric: 'tabular-nums' }}>
                    {c.findingCount ?? 0}
                  </td>
                  <td>
                    <button className="dhc-btn dhc-btn--link" onClick={() => handleViewDetail(c)}>
                      {L.components.viewDetail}
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}

function CounterCard({ value, label, color }) {
  return (
    <div className="dhc-comp-counter">
      <div className="dhc-comp-counter-value" style={{ color }}>{value}</div>
      <div className="dhc-comp-counter-label">{label}</div>
    </div>
  );
}
