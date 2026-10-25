/**
 * Screen 1 — Dashboard (Tableau de bord)
 *
 * Matches mockup: release bar, verdict card with new-problem count,
 * 4 severity counters with delta indicators, "Nouveau sur cette livraison"
 * findings list, footer with component count.
 */
import React, { useState, useEffect, useCallback } from 'react';
import {
  LoadingState, ErrorState, EmptyState,
  SeverityBadge, StatusBadge,
  IconCritical, IconWarning, IconInfo, IconUnknown,
  extractError, formatDate,
} from './shared.jsx';
import { SEVERITY_META, L } from './labels.js';

const SEVERITY_ICONS = {
  crit: IconCritical,
  warn: IconWarning,
  info: IconInfo,
  ne:   IconUnknown,
};

export default function Dashboard({ api, onNavigate }) {
  const [deployment,        setDeployment]        = useState(null);
  const [critFindings,      setCritFindings]      = useState([]);
  const [loading,           setLoading]           = useState(true);
  const [refreshing,        setRefreshing]        = useState(false);
  const [error,             setError]             = useState(null);
  const [captureLaunched,   setCaptureLaunched]   = useState(false);
  const [launchedMessage,   setLaunchedMessage]   = useState('');
  const [captureError,      setCaptureError]      = useState(null);
  const [confirming,        setConfirming]        = useState(false);
  const [submitting,        setSubmitting]        = useState(false);

  // ─── Data loading ────────────────────────────────────────────────────────

  const load = useCallback((isRefresh = false) => {
    let cancelled = false;
    if (isRefresh) {
      setRefreshing(true);
    } else {
      setLoading(true);
    }
    setError(null);

    const run = async () => {
      try {
        const dep = await api.getLatestDeployment();
        if (cancelled) return;
        setDeployment(dep);
        if (!dep) { setLoading(false); setRefreshing(false); return; }

        const page = await api.getFindings({
          deploymentId: dep.id,
          componentId:  null,
          severity:     'Critique',
          status:       null,
          pageSize:     5,
          pageNumber:   1,
        });
        if (cancelled) return;
        setCritFindings(page ? (page.findings || []) : []);
        setLoading(false);
        setRefreshing(false);
      } catch (err) {
        if (!cancelled) {
          setError(extractError(err));
          setLoading(false);
          setRefreshing(false);
        }
      }
    };

    run();
    return () => { cancelled = true; };
  }, [api]);

  useEffect(() => load(false), [load]);

  // ─── Capture actions ─────────────────────────────────────────────────────

  function handleCapture(mode) {
    if (mode === 'BASELINE') { setConfirming(true); return; }
    doCapture(mode);
  }

  function doCapture(mode) {
    setConfirming(false);
    setSubmitting(true);
    setCaptureError(null);
    setCaptureLaunched(false);

    api.startCapture(mode)
      .then(() => {
        setLaunchedMessage(L.dashboard.launched);
        setCaptureLaunched(true);
        setSubmitting(false);
      })
      .catch(err => { setCaptureError(extractError(err)); setSubmitting(false); });
  }

  function handleReevaluate() {
    if (!deployment) return;
    setSubmitting(true);
    setCaptureError(null);
    setCaptureLaunched(false);

    api.runRuleEngine(deployment.id)
      .then(() => {
        setLaunchedMessage(L.dashboard.reevLaunched);
        setCaptureLaunched(true);
        setSubmitting(false);
      })
      .catch(err => { setCaptureError(extractError(err)); setSubmitting(false); });
  }

  // ─── Derived values ────────────────────────────────────────────────────

  const newProblemCount = deployment
    ? (deployment.criticalDelta || 0) + (deployment.warningDelta || 0) + (deployment.informationDelta || 0)
    : 0;

  const componentCount = deployment ? (deployment.componentCount || 0) : 0;

  // ─── Render ───────────────────────────────────────────────────────────────

  if (loading) return <LoadingState />;
  if (error && !deployment) return <ErrorState message={error} onRetry={() => load(false)} />;

  return (
    <div className="dhc-screen">
      {/* Banners */}
      {captureLaunched && (
        <div className="dhc-banner dhc-banner--success" role="status">
          {launchedMessage}
          <button className="dhc-banner-dismiss" aria-label="Fermer" onClick={() => { setCaptureLaunched(false); setLaunchedMessage(''); }}>
            &times;
          </button>
        </div>
      )}
      {captureError && (
        <div className="dhc-banner dhc-banner--error" role="alert">
          {L.common.error(captureError)}
          <button className="dhc-banner-dismiss" aria-label="Fermer" onClick={() => setCaptureError(null)}>
            &times;
          </button>
        </div>
      )}
      {error && deployment && (
        <div className="dhc-banner dhc-banner--error" role="alert">
          {L.common.error(error)}
        </div>
      )}

      {/* BASELINE confirmation dialog */}
      {confirming && (
        <div className="dhc-dialog-overlay" role="dialog" aria-modal="true" aria-labelledby="dlg-baseline-title">
          <div className="dhc-dialog">
            <p id="dlg-baseline-title" className="dhc-dialog-title">{L.dashboard.captureBaseline}</p>
            <p className="dhc-dialog-body">{L.dashboard.baselineWarning}</p>
            <div className="dhc-dialog-actions">
              <button className="dhc-btn dhc-btn--secondary" onClick={() => setConfirming(false)}>
                {L.dashboard.cancel}
              </button>
              <button className="dhc-btn dhc-btn--danger" onClick={() => doCapture('BASELINE')} autoFocus>
                {L.dashboard.baselineConfirm}
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Empty state */}
      {!deployment ? (
        <>
          <EmptyState message={L.dashboard.noDeployment} />
          <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
            <button className="dhc-btn dhc-btn--primary" onClick={() => handleCapture('CURRENT')} disabled={submitting}>
              {L.dashboard.captureCurrent}
            </button>
            <button className="dhc-btn dhc-btn--secondary" onClick={() => handleCapture('BASELINE')} disabled={submitting}>
              {L.dashboard.captureBaseline}
            </button>
          </div>
        </>
      ) : (
        <div className={refreshing ? 'dhc-content--refreshing' : undefined}>
          {/* Release bar */}
          <div className="dhc-card">
            <div className="dhc-card-body">
              <div className="dhc-release-bar">
                <div className="dhc-release-info">
                  <span className="dhc-release-label">{deployment.releaseLabel || 'Déploiement'}</span>
                  <span className="dhc-release-time">{formatDate(deployment.runDate)}</span>
                  <StatusBadge status={deployment.status} />
                </div>
                <div className="dhc-release-actions">
                  <button className="dhc-btn dhc-btn--primary" onClick={() => handleCapture('CURRENT')} disabled={submitting}>
                    {L.dashboard.captureCurrent}
                  </button>
                  <button className="dhc-btn dhc-btn--secondary" onClick={() => handleCapture('BASELINE')} disabled={submitting}>
                    {L.dashboard.captureBaseline}
                  </button>
                  <button className="dhc-btn dhc-btn--ghost" onClick={handleReevaluate} disabled={submitting || !deployment}
                    title="Applique les règles actives sans relancer la capture">
                    {L.dashboard.reevaluate}
                  </button>
                  {captureLaunched && (
                    <>
                      <button className="dhc-btn dhc-btn--ghost" onClick={() => load(true)} disabled={submitting || refreshing}>
                        {L.dashboard.refresh}
                      </button>
                      {refreshing && (
                        <span className="dhc-refreshing-hint">
                          <div className="dhc-spinner dhc-spinner--sm" aria-hidden="true" />
                        </span>
                      )}
                    </>
                  )}
                </div>
              </div>
            </div>
          </div>

          {/* Verdict card */}
          {newProblemCount > 0 && (
            <div className="dhc-card">
              <div className="dhc-card-body">
                <div className="dhc-verdict">
                  <div className="dhc-verdict-text">
                    <h2 className="dhc-verdict-headline">{L.dashboard.verdictNew(newProblemCount)}</h2>
                    <p className="dhc-verdict-desc">{L.dashboard.verdictDesc}</p>
                  </div>
                  <button className="dhc-btn dhc-btn--primary"
                    onClick={() => onNavigate('findings', { deploymentId: deployment.id })}>
                    {L.dashboard.viewNewFindings(newProblemCount)}
                  </button>
                </div>
              </div>
            </div>
          )}

          {/* 4 severity counters */}
          <div className="dhc-counters">
            {SEVERITY_META.map(sm => {
              const Icon = SEVERITY_ICONS[sm.cssClass] || IconUnknown;
              const count = deployment[sm.countField] ?? 0;
              const delta = deployment[sm.deltaField] ?? null;
              return (
                <div key={sm.key} className="dhc-counter">
                  <div className="dhc-counter-header">
                    <span style={{ color: `var(--${sm.cssClass === 'ne' ? 'mut' : sm.cssClass})` }}>
                      <Icon />
                    </span>
                    <span className="dhc-counter-label">{sm.key}</span>
                  </div>
                  <div className="dhc-counter-row">
                    <span className="dhc-counter-value" style={{ color: `var(--${sm.cssClass === 'ne' ? 'mut' : sm.cssClass})` }}>
                      {count}
                    </span>
                    {delta !== null && delta !== 0 && (
                      <span className="dhc-counter-delta" style={{ color: delta > 0 ? 'var(--crit)' : 'var(--ok)' }}>
                        {delta > 0 ? `+${delta}` : delta}
                      </span>
                    )}
                  </div>
                </div>
              );
            })}
          </div>

          {/* New findings on this release */}
          <div className="dhc-card">
            <div className="dhc-card-body" style={{ paddingBottom: 0 }}>
              <div className="dhc-overline" style={{ marginBottom: 18 }}>{L.dashboard.topCritical}</div>
            </div>
            {critFindings.length === 0 ? (
              <EmptyState message="Aucun constat critique." />
            ) : (
              <div>
                {critFindings.map(f => (
                  <div key={f.id} className="dhc-finding-card">
                    <SeverityBadge severity={f.severity} />
                    <div className="dhc-finding-body">
                      <div className="dhc-finding-message">{f.message}</div>
                      <div className="dhc-finding-meta">
                        {f.componentType && <span className="dhc-type-badge">{f.componentType}</span>}
                        {f.componentLabel && <span className="dhc-finding-label">{f.componentLabel}</span>}
                      </div>
                    </div>
                    {f.componentId && (
                      <button className="dhc-btn dhc-btn--link"
                        onClick={() => onNavigate('comparison', {
                          componentId: f.componentId,
                          componentLabel: f.componentLabel || f.componentType || f.componentId,
                          from: { screen: 'dashboard', params: {} },
                        })}>
                        {L.dashboard.viewComponent}
                      </button>
                    )}
                  </div>
                ))}
              </div>
            )}
            {/* Footer */}
            <div className="dhc-card-body" style={{ paddingTop: 14 }}>
              <div className="dhc-footer-bar">
                <span className="dhc-footer-stat">
                  {L.dashboard.componentCount(componentCount)}
                </span>
                <button className="dhc-btn dhc-btn--link"
                  onClick={() => onNavigate('findings', { deploymentId: deployment.id })}>
                  {L.dashboard.viewAll}
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
