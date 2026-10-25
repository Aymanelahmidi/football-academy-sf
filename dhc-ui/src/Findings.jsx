/**
 * Screen 2 — Constats
 *
 * Matches mockup: findings grouped by rule with collapsible groups,
 * severity/status filter selects, "Nouveaux uniquement" and "Masquer packages
 * managés" checkboxes, bulk accept bar, pagination.
 */
import React, { useState, useEffect, useMemo } from 'react';
import {
  SkeletonTable, ErrorState, EmptyState,
  SeverityBadge, StatusBadge, IconExpand,
  extractError,
} from './shared.jsx';
import { SEVERITY_META, STATUS_OPTIONS, L } from './labels.js';

const PAGE_SIZE = 20;

export default function Findings({ api, onNavigate, params }) {
  const [deploymentId, setDeploymentId] = useState(params?.deploymentId || null);
  const [filters,      setFilters]      = useState({
    severity: params?.filters?.severity || '',
    status:   params?.filters?.status   || '',
    newOnly:  false,
    hideManaged: false,
  });
  const [page,       setPage]       = useState(params?.page || 1);
  const [data,       setData]       = useState(null);
  const [loading,    setLoading]    = useState(true);
  const [error,      setError]      = useState(null);
  const [refreshKey, setRefreshKey] = useState(0);
  const [collapsed,  setCollapsed]  = useState({}); // ruleCode → bool

  // ─── Effect 1: resolve deployment ID ───────────────────────────────────

  useEffect(() => {
    if (deploymentId) return;
    let cancelled = false;
    setLoading(true);

    api.getLatestDeployment()
      .then(dep => { if (!cancelled) setDeploymentId(dep?.id || null); })
      .catch(err => { if (!cancelled) { setError(extractError(err)); setLoading(false); } });

    return () => { cancelled = true; };
  }, [api]); // eslint-disable-line react-hooks/exhaustive-deps

  // ─── Effect 2: fetch findings page ──────────────────────────────────────

  useEffect(() => {
    if (!deploymentId) return;
    let cancelled = false;
    setLoading(true);
    setError(null);

    api.getFindings({
      deploymentId,
      componentId: null,
      severity:    filters.severity || null,
      status:      filters.status   || null,
      pageSize:    PAGE_SIZE,
      pageNumber:  page,
    })
      .then(result => { if (!cancelled) { setData(result); setLoading(false); } })
      .catch(err =>   { if (!cancelled) { setError(extractError(err)); setLoading(false); } });

    return () => { cancelled = true; };
  }, [api, deploymentId, filters.severity, filters.status, page, refreshKey]);

  // ─── Handlers ─────────────────────────────────────────────────────────

  function handleFilterChange(key, value) {
    setFilters(prev => ({ ...prev, [key]: value }));
    setPage(1);
  }

  function handleUpdate(findingId, status, justification) {
    return api.updateFindingStatus(findingId, status, justification)
      .then(() => setRefreshKey(k => k + 1));
  }

  function handleViewComponent(componentId, componentLabel) {
    onNavigate('comparison', {
      componentId,
      componentLabel,
      from: { screen: 'findings', params: { deploymentId, filters, page } },
    });
  }

  function toggleGroup(ruleCode) {
    setCollapsed(prev => ({ ...prev, [ruleCode]: !prev[ruleCode] }));
  }

  // ─── Group findings by rule ──────────────────────────────────────────

  const groups = useMemo(() => {
    if (!data || !data.findings) return [];
    const map = new Map();
    for (const f of data.findings) {
      const key = f.ruleCode || '(sans règle)';
      if (!map.has(key)) {
        map.set(key, { ruleCode: key, severity: f.severity, findings: [] });
      }
      map.get(key).findings.push(f);
    }
    return Array.from(map.values());
  }, [data]);

  // Client-side filters (applied on top of server-side filters)
  const filteredGroups = useMemo(() => {
    let result = groups;
    if (filters.newOnly) {
      result = result.map(g => ({
        ...g,
        findings: g.findings.filter(f => f.isNew),
      })).filter(g => g.findings.length > 0);
    }
    if (filters.hideManaged) {
      result = result.map(g => ({
        ...g,
        findings: g.findings.filter(f => !f.isManaged),
      })).filter(g => g.findings.length > 0);
    }
    return result;
  }, [groups, filters.newOnly, filters.hideManaged]);

  const totalPages = data ? Math.max(1, Math.ceil((data.totalCount || 0) / PAGE_SIZE)) : 1;
  const shownCount = filteredGroups.reduce((acc, g) => acc + g.findings.length, 0);

  // ─── Render ───────────────────────────────────────────────────────────

  if (error && !data) return <ErrorState message={error} onRetry={() => setRefreshKey(k => k + 1)} />;

  return (
    <div className="dhc-screen">
      <div>
        <h1 className="dhc-screen-title">{L.findings.title}</h1>
        <p className="dhc-screen-subtitle">{L.findings.subtitle}</p>
      </div>

      {/* Filter bar */}
      <div className="dhc-filter-bar">
        <select className="dhc-select" value={filters.severity}
          onChange={e => handleFilterChange('severity', e.target.value)}
          aria-label={L.findings.filterSev}>
          <option value="">{L.findings.allSev}</option>
          {SEVERITY_META.map(sm => <option key={sm.key} value={sm.key}>{sm.key}</option>)}
        </select>

        <select className="dhc-select" value={filters.status}
          onChange={e => handleFilterChange('status', e.target.value)}
          aria-label={L.findings.filterStatus}>
          <option value="">{L.findings.allStatus}</option>
          {STATUS_OPTIONS.map(s => <option key={s} value={s}>{s}</option>)}
        </select>

        <div className="dhc-filter-sep" />

        <label className="dhc-checkbox-label">
          <input type="checkbox" className="dhc-checkbox"
            checked={filters.newOnly}
            onChange={e => setFilters(prev => ({ ...prev, newOnly: e.target.checked }))} />
          {L.findings.newOnly}
        </label>

        <label className="dhc-checkbox-label">
          <input type="checkbox" className="dhc-checkbox"
            checked={filters.hideManaged}
            onChange={e => setFilters(prev => ({ ...prev, hideManaged: e.target.checked }))} />
          {L.findings.hideManaged}
        </label>
      </div>

      {/* Error banner */}
      {error && data && (
        <div className="dhc-banner dhc-banner--error" role="alert">
          {L.common.error(error)}
        </div>
      )}

      {/* Loading skeleton */}
      {loading && !data ? (
        <div className="dhc-card">
          <div className="dhc-table-wrap">
            <table className="dhc-table" aria-label={L.findings.title} aria-busy="true">
              <thead><tr>
                <th>{L.findings.colSev}</th>
                <th>{L.findings.colRule}</th>
                <th>{L.findings.colComponent}</th>
                <th>{L.findings.colMessage}</th>
                <th>{L.findings.colStatus}</th>
                <th>{L.findings.colActions}</th>
              </tr></thead>
              <tbody><SkeletonTable cols={6} rows={8} /></tbody>
            </table>
          </div>
        </div>
      ) : !data || filteredGroups.length === 0 ? (
        <EmptyState message={L.findings.noFindings} />
      ) : (
        <>
          {/* Grouped findings */}
          <div style={{ display: 'flex', flexDirection: 'column', gap: 14 }}
               className={loading ? 'dhc-content--refreshing' : undefined}>
            {filteredGroups.map(group => (
              <FindingGroup
                key={group.ruleCode}
                group={group}
                isCollapsed={!!collapsed[group.ruleCode]}
                onToggle={() => toggleGroup(group.ruleCode)}
                onUpdate={handleUpdate}
                onViewComponent={handleViewComponent}
              />
            ))}
          </div>

          {/* Pagination */}
          <div className="dhc-pagination">
            <button className="dhc-btn dhc-btn--secondary" onClick={() => setPage(p => p - 1)}
              disabled={page <= 1 || loading}>
              {L.findings.prev}
            </button>
            <span className="dhc-pagination-info">
              {L.findings.findingCount(shownCount, data.totalCount)}
            </span>
            <button className="dhc-btn dhc-btn--secondary" onClick={() => setPage(p => p + 1)}
              disabled={page >= totalPages || loading}>
              {L.findings.next}
            </button>
          </div>
        </>
      )}
    </div>
  );
}

// ─── Finding Group ──────────────────────────────────────────────────────

function FindingGroup({ group, isCollapsed, onToggle, onUpdate, onViewComponent }) {
  return (
    <div className="dhc-group">
      {/* Group header */}
      <div className="dhc-group-header" onClick={onToggle} role="button" tabIndex={0}
        aria-expanded={!isCollapsed}
        onKeyDown={e => { if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); onToggle(); } }}>
        <IconExpand open={!isCollapsed} />
        <SeverityBadge severity={group.severity} />
        <span className="dhc-group-rule">{group.ruleCode}</span>
        <span className="dhc-group-count">
          {group.findings.length} constat{group.findings.length > 1 ? 's' : ''}
        </span>
      </div>

      {/* Group items */}
      {!isCollapsed && group.findings.map(f => (
        <FindingItem key={f.id} finding={f} onUpdate={onUpdate} onViewComponent={onViewComponent} />
      ))}
    </div>
  );
}

// ─── Finding Item ───────────────────────────────────────────────────────

function FindingItem({ finding, onUpdate, onViewComponent }) {
  const [selectedStatus, setSelectedStatus] = useState(finding.status);
  const [justification,  setJustification]  = useState(finding.justification || '');
  const [saving,         setSaving]         = useState(false);
  const [saveError,      setSaveError]      = useState(null);

  const isEditing          = selectedStatus !== finding.status;
  const needsJustification = isEditing && selectedStatus !== 'Ouvert';
  const canSave            = isEditing && (!needsJustification || justification.trim().length > 0);

  function handleSave() {
    setSaving(true);
    setSaveError(null);
    onUpdate(finding.id, selectedStatus, justification.trim() || null)
      .catch(err => { setSaveError(extractError(err)); setSaving(false); });
  }

  function handleCancel() {
    setSelectedStatus(finding.status);
    setJustification(finding.justification || '');
    setSaveError(null);
  }

  return (
    <div className="dhc-group-item" style={{ flexDirection: 'column', alignItems: 'stretch' }}>
      <div style={{ display: 'flex', flexWrap: 'wrap', gap: 14, alignItems: 'center' }}>
        {finding.componentType && <span className="dhc-type-badge">{finding.componentType}</span>}
        <div className="dhc-group-item-body">
          <div style={{ fontSize: 14, fontWeight: 500, marginBottom: 4 }}>
            {finding.componentLabel || finding.componentId || '—'}
          </div>
          {finding.componentId && (
            <span className="dhc-api-name">{finding.componentId}</span>
          )}
        </div>

        {/* Status select */}
        <label htmlFor={`status-${finding.id}`} className="dhc-sr-only">{L.findings.editStatus}</label>
        <select id={`status-${finding.id}`} className="dhc-select" value={selectedStatus}
          onChange={e => setSelectedStatus(e.target.value)} disabled={saving}
          style={{ minWidth: 120 }}>
          {STATUS_OPTIONS.map(s => <option key={s} value={s}>{s}</option>)}
        </select>

        {/* Actions */}
        {isEditing ? (
          <div className="dhc-inline-actions">
            <button className="dhc-btn dhc-btn--primary" onClick={handleSave} disabled={!canSave || saving}
              style={{ minHeight: 36 }}>
              {saving ? '...' : L.findings.save}
            </button>
            <button className="dhc-btn dhc-btn--secondary" onClick={handleCancel} disabled={saving}
              style={{ minHeight: 36 }}>
              {L.findings.cancel}
            </button>
          </div>
        ) : (
          <StatusBadge status={finding.status} />
        )}

        {finding.componentId && (
          <button className="dhc-btn dhc-btn--link"
            onClick={() => onViewComponent(finding.componentId, finding.componentLabel || finding.componentId)}>
            {L.findings.detail}
          </button>
        )}
      </div>

      {/* Justification area */}
      {isEditing && needsJustification && (
        <div className="dhc-expand-inner" style={{ marginTop: 10, borderRadius: 8 }}>
          <span className="dhc-expand-title">{L.findings.justLabel}</span>
          <textarea className="dhc-textarea" rows={3} placeholder={L.findings.justLabel}
            value={justification} onChange={e => setJustification(e.target.value)}
            disabled={saving} autoFocus />
          <span className="dhc-field-hint">{L.findings.justHint}</span>
          {saveError && (
            <span style={{ color: 'var(--crit)', fontSize: 12 }} role="alert">{saveError}</span>
          )}
        </div>
      )}

      {isEditing && !needsJustification && saveError && (
        <span style={{ color: 'var(--crit)', fontSize: 12, marginTop: 8 }} role="alert">{saveError}</span>
      )}
    </div>
  );
}
