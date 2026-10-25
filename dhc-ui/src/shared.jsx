/**
 * Shared components and utility functions for the DHC UI.
 * Import from here — never duplicate these across screens.
 */
import React from 'react';
import { L } from './labels.js';

// ─── SVG Icons ────────────────────────────────────────────────────────────

export function IconShield() {
  return (
    <svg width="16" height="16" viewBox="0 0 16 16" fill="none" aria-hidden="true">
      <path d="M8 1L2 3.5V7.5C2 11.09 4.56 14.41 8 15.5C11.44 14.41 14 11.09 14 7.5V3.5L8 1Z" fill="currentColor" opacity="0.9"/>
      <path d="M7 10.5L4.5 8L5.41 7.09L7 8.67L10.59 5.09L11.5 6L7 10.5Z" fill="white"/>
    </svg>
  );
}

export function IconSun() {
  return (
    <svg width="14" height="14" viewBox="0 0 14 14" fill="none" aria-hidden="true">
      <circle cx="7" cy="7" r="3" stroke="currentColor" strokeWidth="1.5"/>
      <path d="M7 1V2.5M7 11.5V13M1 7H2.5M11.5 7H13M2.76 2.76L3.82 3.82M10.18 10.18L11.24 11.24M11.24 2.76L10.18 3.82M3.82 10.18L2.76 11.24" stroke="currentColor" strokeWidth="1.2" strokeLinecap="round"/>
    </svg>
  );
}

export function IconMoon() {
  return (
    <svg width="14" height="14" viewBox="0 0 14 14" fill="none" aria-hidden="true">
      <path d="M12.5 8.5A5.5 5.5 0 015.5 1.5 5.5 5.5 0 107.5 12.5a5.48 5.48 0 005-4z" stroke="currentColor" strokeWidth="1.2" strokeLinecap="round" strokeLinejoin="round"/>
    </svg>
  );
}

export function IconChevronLeft() {
  return (
    <svg width="16" height="16" viewBox="0 0 16 16" fill="none" aria-hidden="true">
      <path d="M10 12L6 8L10 4" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round"/>
    </svg>
  );
}

export function IconChevronRight() {
  return (
    <svg width="16" height="16" viewBox="0 0 16 16" fill="none" aria-hidden="true">
      <path d="M6 4L10 8L6 12" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round"/>
    </svg>
  );
}

export function IconArrowLeft() {
  return (
    <svg width="14" height="14" viewBox="0 0 14 14" fill="none" aria-hidden="true">
      <path d="M11 7H3M3 7L6.5 3.5M3 7L6.5 10.5" stroke="currentColor" strokeWidth="1.3" strokeLinecap="round" strokeLinejoin="round"/>
    </svg>
  );
}

export function IconCritical() {
  return (
    <svg width="16" height="16" viewBox="0 0 16 16" fill="none" aria-hidden="true">
      <circle cx="8" cy="8" r="6" stroke="currentColor" strokeWidth="1.5"/>
      <path d="M8 5V9M8 11V11.01" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round"/>
    </svg>
  );
}

export function IconWarning() {
  return (
    <svg width="16" height="16" viewBox="0 0 16 16" fill="none" aria-hidden="true">
      <path d="M7.13 2.5L1.5 12.5H14.5L8.87 2.5C8.49 1.83 7.51 1.83 7.13 2.5Z" stroke="currentColor" strokeWidth="1.3" strokeLinejoin="round"/>
      <path d="M8 6.5V9M8 11V11.01" stroke="currentColor" strokeWidth="1.3" strokeLinecap="round"/>
    </svg>
  );
}

export function IconInfo() {
  return (
    <svg width="16" height="16" viewBox="0 0 16 16" fill="none" aria-hidden="true">
      <circle cx="8" cy="8" r="6" stroke="currentColor" strokeWidth="1.5"/>
      <path d="M8 7V11M8 5V5.01" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round"/>
    </svg>
  );
}

export function IconUnknown() {
  return (
    <svg width="16" height="16" viewBox="0 0 16 16" fill="none" aria-hidden="true">
      <circle cx="8" cy="8" r="6" stroke="currentColor" strokeWidth="1.5"/>
      <path d="M6 6C6 4.9 6.9 4 8 4C9.1 4 10 4.9 10 6C10 7.5 8 7.5 8 9M8 11V11.01" stroke="currentColor" strokeWidth="1.2" strokeLinecap="round"/>
    </svg>
  );
}

export function IconExpand({ open }) {
  return (
    <svg width="12" height="12" viewBox="0 0 12 12" fill="none" aria-hidden="true"
         style={{ transition: 'transform 150ms ease', transform: open ? 'rotate(90deg)' : 'rotate(0)' }}>
      <path d="M4.5 2.5L8 6L4.5 9.5" stroke="currentColor" strokeWidth="1.3" strokeLinecap="round" strokeLinejoin="round"/>
    </svg>
  );
}

// ─── State components ──────────────────────────────────────────────────────

export function LoadingState() {
  return (
    <div className="dhc-loading" role="status" aria-live="polite">
      <div className="dhc-spinner" aria-hidden="true" />
      <span>{L.common.loading}</span>
    </div>
  );
}

export function ErrorState({ message, onRetry }) {
  return (
    <div className="dhc-error" role="alert">
      <span>{L.common.error(message)}</span>
      {onRetry && (
        <button className="dhc-btn dhc-btn--secondary" onClick={onRetry}>
          {L.common.retry}
        </button>
      )}
    </div>
  );
}

export function EmptyState({ message }) {
  return (
    <div className="dhc-empty">
      <span>{message}</span>
    </div>
  );
}

// ─── Skeleton table ─────────────────────────────────────────────────────────

export function SkeletonTable({ cols = 4, rows = 6 }) {
  const WIDTHS = ['60%', '40%', '75%', '50%', '65%', '45%'];
  return (
    <>
      {Array.from({ length: rows }).map((_, ri) => (
        <tr key={ri} className="dhc-skel-row" aria-hidden="true">
          {Array.from({ length: cols }).map((_, ci) => (
            <td key={ci}>
              <span
                className="dhc-skel-cell"
                style={{ width: WIDTHS[(ri * cols + ci) % WIDTHS.length] }}
              />
            </td>
          ))}
        </tr>
      ))}
    </>
  );
}

// ─── Badge components ──────────────────────────────────────────────────────

const SEVERITY_ICON_MAP = {
  'Critique':      IconCritical,
  'Avertissement': IconWarning,
  'Information':   IconInfo,
  'Non évaluable': IconUnknown,
};

const SEVERITY_CLASS_MAP = {
  'Critique':      'crit',
  'Avertissement': 'warn',
  'Information':   'info',
  'Non évaluable': 'ne',
};

export function SeverityBadge({ severity }) {
  const cls = SEVERITY_CLASS_MAP[severity] || 'ne';
  const Icon = SEVERITY_ICON_MAP[severity] || IconUnknown;
  return (
    <span className={`dhc-badge dhc-badge--${cls}`}>
      <Icon />
      {severity}
    </span>
  );
}

export function StatusBadge({ status }) {
  const CLASS_MAP = {
    'Ouvert':    'info',
    'Corrigé':   'ok',
    'Accepté':   'ne',
    'En cours':  'info',
    'Terminé':   'ok',
    'Échoué':    'crit',
  };
  const cls = CLASS_MAP[status] || 'ne';
  return (
    <span className={`dhc-badge dhc-badge--${cls}`}>
      {status}
    </span>
  );
}

// ─── Component State Badge ─────────────────────────────────────────────────

export function StateBadge({ state }) {
  const MAP = {
    'Modifié':        'modif',
    'Sans baseline':  'absent',
    'Inchangé':       'inchange',
    'Disparu':        'absent',
  };
  const cls = MAP[state] || 'ne';
  return <span className={`dhc-badge dhc-badge--${cls}`}>{state}</span>;
}

// ─── Utility functions ─────────────────────────────────────────────────────

export function extractError(err) {
  if (!err) return 'Erreur inconnue';
  if (err.body && err.body.message) return err.body.message;
  if (err.message) return err.message;
  return String(err);
}

export function formatDate(dateStr) {
  if (!dateStr) return '—';
  try {
    return new Intl.DateTimeFormat('fr-FR', {
      day: '2-digit', month: '2-digit', year: 'numeric',
      hour: '2-digit', minute: '2-digit',
    }).format(new Date(dateStr));
  } catch {
    return String(dateStr);
  }
}

export function safeParseJson(str) {
  if (!str) return null;
  try { return JSON.parse(str); } catch { return null; }
}

export function decodeAccess(code) {
  if (!code) return '';
  const MAP = { r: 'Lecture', c: 'Création', e: 'Modification', d: 'Suppression' };
  return code.split('').map(ch => MAP[ch] || ch).join(', ');
}
