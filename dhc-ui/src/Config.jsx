/**
 * Screen 5 — Configuration
 *
 * Matches mockup: scopes as rows within a card, rules grouped by type with
 * colored dot indicators, disabled rules with strikethrough, "Ouvrir Setup" link.
 */
import React, { useState, useEffect, useMemo } from 'react';
import { LoadingState, ErrorState, EmptyState, SeverityBadge, extractError } from './shared.jsx';
import { L } from './labels.js';

const INITIAL_RULES_SHOWN = 10;

export default function Config({ api }) {
  const [scopes,  setScopes]  = useState([]);
  const [rules,   setRules]   = useState([]);
  const [loading, setLoading] = useState(true);
  const [error,   setError]   = useState(null);
  const [showAll, setShowAll] = useState(false);

  useEffect(() => {
    let cancelled = false;

    Promise.all([api.getCaptureScopeConfig(), api.getActiveRules()])
      .then(([scopeData, ruleData]) => {
        if (!cancelled) {
          setScopes(scopeData || []);
          setRules(ruleData  || []);
          setLoading(false);
        }
      })
      .catch(err => {
        if (!cancelled) { setError(extractError(err)); setLoading(false); }
      });

    return () => { cancelled = true; };
  }, [api]);

  // Group rules by component type
  const rulesByType = useMemo(() => {
    const map = {};
    for (const r of rules) {
      const type = r.componentType || '(sans type)';
      if (!map[type]) map[type] = [];
      map[type].push(r);
    }
    return map;
  }, [rules]);

  const sortedTypes = useMemo(() => Object.keys(rulesByType).sort(), [rulesByType]);

  // Flat rule list for pagination
  const allRuleRows = useMemo(() => {
    const rows = [];
    for (const type of sortedTypes) {
      rows.push({ isHeader: true, type });
      for (const r of rulesByType[type]) {
        rows.push({ isHeader: false, rule: r });
      }
    }
    return rows;
  }, [sortedTypes, rulesByType]);

  const visibleRows = showAll ? allRuleRows : allRuleRows.slice(0, INITIAL_RULES_SHOWN);
  const hiddenCount = allRuleRows.length - visibleRows.length;

  if (loading) return <LoadingState />;
  if (error)   return <ErrorState message={error} onRetry={() => window.location.reload()} />;

  return (
    <div className="dhc-screen">
      {/* Header */}
      <div className="dhc-config-head">
        <div className="dhc-config-head-text">
          <h1 className="dhc-screen-title">{L.config.title}</h1>
          <p className="dhc-config-desc">{L.config.subtitle}</p>
        </div>
      </div>

      {/* Info banner */}
      <div className="dhc-notice" role="note">
        <span>{L.config.readOnly}</span>
      </div>

      {/* Capture scopes */}
      <section>
        <h2 className="dhc-section-title">{L.config.scopesTitle}</h2>
        {scopes.length === 0 ? (
          <EmptyState message={L.config.noScopes} />
        ) : (
          <div className="dhc-card">
            {scopes.map((s, i) => (
              <div key={i}>
                <div className="dhc-scope-row">
                  <span className="dhc-scope-type">{s.componentType || '—'}</span>
                  <span className="dhc-scope-desc">{s.label || ''}</span>
                  <span className={`dhc-badge ${s.isActive ? 'dhc-badge--ok' : 'dhc-badge--ne'}`}>
                    {s.isActive ? L.config.yes : L.config.no}
                  </span>
                  {s.targetObjects && (
                    <span className="dhc-scope-count">
                      {L.config.scopeNote(s.targetObjects.split(',').filter(Boolean).length)}
                    </span>
                  )}
                </div>
                {s.targetObjects && (
                  <div className="dhc-scope-row" style={{ paddingTop: 0 }}>
                    <div className="dhc-chips" style={{ marginLeft: 148 }}>
                      {s.targetObjects.split(',').map(obj => obj.trim()).filter(Boolean).map((obj, j) => (
                        <span key={j} className="dhc-chip">{obj}</span>
                      ))}
                    </div>
                  </div>
                )}
              </div>
            ))}
          </div>
        )}
      </section>

      {/* Rules */}
      <section>
        <h2 className="dhc-section-title">{L.config.rulesTitle}</h2>
        {rules.length === 0 ? (
          <EmptyState message={L.config.noRules} />
        ) : (
          <div className="dhc-card">
            {visibleRows.map((row, i) => {
              if (row.isHeader) {
                return (
                  <div key={`h-${row.type}`} className="dhc-rule-type-header">
                    <span className="dhc-overline">{row.type}</span>
                  </div>
                );
              }
              const r = row.rule;
              const isDisabled = r.isActive === false;
              const dotClass = isDisabled ? 'dhc-rule-dot--disabled'
                : r.severity === 'Critique' ? 'dhc-rule-dot--crit'
                : r.severity === 'Avertissement' ? 'dhc-rule-dot--warn'
                : 'dhc-rule-dot--info';
              return (
                <div key={`r-${i}`} className={`dhc-rule-row${isDisabled ? ' dhc-rule-row--disabled' : ''}`}>
                  <div className={`dhc-rule-dot ${dotClass}`} />
                  <span className={`dhc-rule-msg${isDisabled ? ' dhc-rule-msg--disabled' : ''}`}>
                    {r.message || r.code || '—'}
                  </span>
                  {r.attribute && (
                    <span className="dhc-rule-expr">
                      {r.attribute}{r.operator ? ` ${r.operator}` : ''}{r.expectedValue ? ` "${r.expectedValue}"` : ''}
                    </span>
                  )}
                  {r.code && <span className="dhc-rule-expr">{r.code}</span>}
                  {isDisabled && <span className="dhc-badge dhc-badge--disabled">DÉSACTIVÉE</span>}
                </div>
              );
            })}
          </div>
        )}

        {/* Show more / less */}
        {hiddenCount > 0 && (
          <div className="dhc-rules-footer">
            <span className="dhc-rules-footer-info">{L.config.moreRules(hiddenCount)}</span>
            <button className="dhc-btn dhc-btn--link" onClick={() => setShowAll(true)}>
              {L.config.showAll}
            </button>
          </div>
        )}
        {showAll && allRuleRows.length > INITIAL_RULES_SHOWN && (
          <div className="dhc-rules-footer">
            <button className="dhc-btn dhc-btn--link" onClick={() => setShowAll(false)}>
              Réduire
            </button>
          </div>
        )}
      </section>
    </div>
  );
}
