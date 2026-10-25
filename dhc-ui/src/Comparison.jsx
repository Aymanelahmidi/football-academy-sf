/**
 * Screen 3 — Comparaison
 *
 * Matches mockup: identity card, 3-column diff grid (Attribute | Baseline | Current),
 * collapsible identical attributes, related findings verdict section, fingerprint bar.
 */
import React, { useState, useEffect, useMemo } from 'react';
import {
  LoadingState, ErrorState, EmptyState,
  SeverityBadge, StatusBadge, StateBadge,
  IconArrowLeft, IconChevronLeft, IconChevronRight,
  extractError, formatDate, safeParseJson, decodeAccess,
} from './shared.jsx';
import { L } from './labels.js';

// ─── Diff helpers ──────────────────────────────────────────────────────────

function getDiff(baseObj, currObj, key) {
  const hasBase = baseObj !== null && Object.prototype.hasOwnProperty.call(baseObj, key);
  const hasCurr = currObj !== null && Object.prototype.hasOwnProperty.call(currObj, key);
  if (!hasBase && hasCurr)  return 'added';
  if (hasBase  && !hasCurr) return 'removed';
  if (JSON.stringify(baseObj[key]) === JSON.stringify(currObj[key])) return 'same';
  return 'changed';
}

function renderStateValue(val) {
  if (val === null || val === undefined) return <span className="dhc-text-muted" style={{ fontStyle: 'italic' }}>null</span>;
  if (typeof val === 'boolean') return <span className="dhc-diff-val">{val ? 'vrai' : 'faux'}</span>;

  if (typeof val === 'object') {
    const entries = Object.entries(val).sort(([a], [b]) => a.localeCompare(b));
    if (entries.length === 0) return <span className="dhc-text-muted">{'{ }'}</span>;
    return (
      <div>
        {entries.map(([perm, code]) => (
          <div key={perm} className="dhc-access-block">
            <div className="dhc-access-perm-name">{perm}</div>
            <div className="dhc-access-pills">
              {renderPermPills(String(code))}
            </div>
          </div>
        ))}
      </div>
    );
  }

  return <span className="dhc-diff-val">{String(val)}</span>;
}

function renderPermPills(code) {
  if (!code) return null;
  const PILL_MAP = { r: 'Lecture', c: 'Création', e: 'Modification', d: 'Suppression' };
  return code.split('').map((ch, i) => (
    <span key={i} className="dhc-access-pill">{PILL_MAP[ch] || ch.toUpperCase()}</span>
  ));
}

// ─── Main component ────────────────────────────────────────────────────────

export default function Comparison({ api, onNavigate, params }) {
  const { componentId, componentLabel, from } = params || {};

  const [component, setComponent] = useState(null);
  const [findings,  setFindings]  = useState([]);
  const [loading,   setLoading]   = useState(true);
  const [error,     setError]     = useState(null);
  const [showIdentical, setShowIdentical] = useState(false);

  useEffect(() => {
    if (!componentId) { setLoading(false); return; }
    let cancelled = false;

    const run = async () => {
      try {
        const [comp, dep] = await Promise.all([
          api.getComponentDetail(componentId),
          api.getLatestDeployment(),
        ]);
        if (cancelled) return;
        setComponent(comp);
        if (!comp || !dep) { setLoading(false); return; }

        const page = await api.getFindings({
          deploymentId: dep.id,
          componentId,
          severity: null,
          status: null,
          pageSize: 50,
          pageNumber: 1,
        });
        if (cancelled) return;
        setFindings(page ? (page.findings || []) : []);
        setLoading(false);
      } catch (err) {
        if (!cancelled) { setError(extractError(err)); setLoading(false); }
      }
    };

    run();
    return () => { cancelled = true; };
  }, [api, componentId]);

  function handleBack() {
    if (from) onNavigate(from.screen, from.params);
    else      onNavigate('dashboard', {});
  }

  if (loading) return <LoadingState />;
  if (error)   return <ErrorState message={error} onRetry={() => onNavigate('comparison', params)} />;
  if (!componentId || !component) {
    return (
      <div className="dhc-screen">
        <button className="dhc-back-link" onClick={handleBack}>
          <IconArrowLeft /> {L.comparison.back}
        </button>
        <EmptyState message={L.comparison.noComponent} />
      </div>
    );
  }

  const baseObj = safeParseJson(component.baselineState);
  const currObj = safeParseJson(component.currentState);
  const allKeys = Array.from(new Set([
    ...Object.keys(baseObj || {}),
    ...Object.keys(currObj || {}),
  ])).sort();

  const changedKeys = allKeys.filter(k => getDiff(baseObj, currObj, k) !== 'same');
  const identicalKeys = allKeys.filter(k => getDiff(baseObj, currObj, k) === 'same');

  const componentState = component.hasChanged ? 'Modifié'
    : component.isAbsent ? 'Sans baseline'
    : 'Inchangé';

  return (
    <div className="dhc-screen">
      {/* Navigation bar */}
      <div className="dhc-comp-nav">
        <button className="dhc-back-link" onClick={handleBack}>
          <IconArrowLeft /> {L.comparison.back}
        </button>
      </div>

      {/* Identity card */}
      <div className="dhc-card">
        <div className="dhc-identity">
          <div className="dhc-identity-badges">
            {component.componentType && <span className="dhc-type-badge">{component.componentType}</span>}
            <StateBadge state={componentState} />
            {component.hasChanged && <span className="dhc-badge dhc-badge--new">NEW</span>}
          </div>
          <h1 className="dhc-identity-title">
            {componentLabel || component.label || component.apiName}
          </h1>
          <div className="dhc-identity-meta">
            <span className="dhc-api-name">{component.apiName || '—'}</span>
            <span className="dhc-identity-desc">
              {component.changeCount ?? 0} changement{(component.changeCount ?? 0) > 1 ? 's' : ''} détecté{(component.changeCount ?? 0) > 1 ? 's' : ''}
            </span>
          </div>
        </div>
      </div>

      {/* Diff section */}
      {allKeys.length === 0 ? (
        <EmptyState message={L.comparison.noState} />
      ) : (
        <div className="dhc-card">
          {/* Diff header */}
          <div className="dhc-diff-head">
            <div className="dhc-diff-head-cell">
              <div className="dhc-diff-head-label">{L.comparison.colAttr}</div>
            </div>
            <div className="dhc-diff-head-cell">
              <div className="dhc-diff-head-label">{L.comparison.baselineDate}</div>
              {component.baselineDate && <div className="dhc-diff-head-date">{formatDate(component.baselineDate)}</div>}
            </div>
            <div className="dhc-diff-head-cell">
              <div className="dhc-diff-head-label">{L.comparison.currentDate}</div>
              {component.currentDate && <div className="dhc-diff-head-date">{formatDate(component.currentDate)}</div>}
            </div>
          </div>

          {/* Changed rows */}
          {changedKeys.map(key => {
            const diff    = getDiff(baseObj, currObj, key);
            const baseVal = baseObj ? baseObj[key] : undefined;
            const currVal = currObj ? currObj[key] : undefined;
            return (
              <div key={key} className="dhc-diff-row">
                <div className="dhc-diff-attr">
                  <div className="dhc-diff-attr-name">{key}</div>
                  <span className={`dhc-badge dhc-badge--${diff === 'added' ? 'ok' : diff === 'removed' ? 'crit' : 'warn'}`}
                    style={{ fontSize: 10, padding: '2px 7px' }}>
                    {diff === 'added' ? 'Ajouté' : diff === 'removed' ? 'Supprimé' : 'Modifié'}
                  </span>
                </div>
                <div className={`dhc-diff-cell dhc-diff-cell--baseline`}>
                  {diff === 'added'
                    ? <span className="dhc-text-muted" style={{ fontStyle: 'italic' }}>{L.comparison.absent}</span>
                    : renderStateValue(baseVal)}
                </div>
                <div className={`dhc-diff-cell dhc-diff-cell--current`}>
                  {diff === 'removed'
                    ? <span className="dhc-text-muted" style={{ fontStyle: 'italic' }}>{L.comparison.absent}</span>
                    : renderStateValue(currVal)}
                </div>
              </div>
            );
          })}

          {/* Collapsed identical attributes */}
          {identicalKeys.length > 0 && (
            <div className="dhc-diff-collapsed">
              <span className="dhc-diff-collapsed-info">
                {L.comparison.identicalCount(identicalKeys.length)}
              </span>
              <button className="dhc-btn dhc-btn--link"
                onClick={() => setShowIdentical(prev => !prev)}>
                {showIdentical ? L.comparison.hideIdentical : L.comparison.showIdentical}
              </button>
            </div>
          )}

          {showIdentical && identicalKeys.map(key => {
            const val = baseObj ? baseObj[key] : currObj ? currObj[key] : undefined;
            return (
              <div key={key} className="dhc-diff-row" style={{ opacity: 0.6 }}>
                <div className="dhc-diff-attr">
                  <div className="dhc-diff-attr-name">{key}</div>
                  <span className="dhc-badge dhc-badge--ne" style={{ fontSize: 10, padding: '2px 7px' }}>Identique</span>
                </div>
                <div className="dhc-diff-cell dhc-diff-cell--baseline">{renderStateValue(val)}</div>
                <div className="dhc-diff-cell dhc-diff-cell--current">{renderStateValue(val)}</div>
              </div>
            );
          })}
        </div>
      )}

      {/* Related findings */}
      <div className="dhc-card">
        <div className="dhc-verdict-section-head">
          <span className="dhc-overline">{L.comparison.findingsTitle}</span>
        </div>
        {findings.length === 0 ? (
          <EmptyState message={L.comparison.noFindings} />
        ) : (
          <div>
            {findings.map(f => (
              <div key={f.id} className="dhc-verdict-row">
                <SeverityBadge severity={f.severity} />
                <span className="dhc-verdict-msg">{f.message}</span>
                <span className="dhc-verdict-rule">{f.ruleCode || '—'}</span>
                <StatusBadge status={f.status} />
              </div>
            ))}
          </div>
        )}
      </div>

      {/* Fingerprints */}
      {(component.baselineHash || component.currentHash) && (
        <div className="dhc-fingerprint">
          <span className="dhc-overline" style={{ flexShrink: 0 }}>{L.comparison.fingerprint}</span>
          <span className="dhc-fingerprint-hash">
            {component.baselineHash && `Baseline: ${component.baselineHash}`}
            {component.baselineHash && component.currentHash && ' | '}
            {component.currentHash && `Current: ${component.currentHash}`}
          </span>
        </div>
      )}
    </div>
  );
}
