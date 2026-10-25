/**
 * DHC UI — entry point.
 *
 * Exposes window.DHC_UI = { mount, unmount } for the LWC wrapper.
 * Manages a Map of React roots so multiple instances can coexist.
 *
 * Navigation is purely state-based (no react-router, which would
 * interfere with Lightning's own navigation).
 */
import React, { useState, useCallback } from 'react';
import { createRoot } from 'react-dom/client';
import { injectStyles } from './styles.js';
import Dashboard  from './Dashboard.jsx';
import Findings   from './Findings.jsx';
import Comparison from './Comparison.jsx';
import Components from './Components.jsx';
import Config     from './Config.jsx';
import { L }      from './labels.js';
import { IconShield, IconSun, IconMoon } from './shared.jsx';

// ─── Root registry ─────────────────────────────────────────────────────────
const roots = new Map();

// ─── Navigation items shown in the nav bar ─────────────────────────────────
const NAV_ITEMS = [
  { key: 'dashboard',  label: L.nav.dashboard  },
  { key: 'findings',   label: L.nav.findings   },
  { key: 'comparison', label: L.nav.comparison },
  { key: 'components', label: L.nav.components },
  { key: 'config',     label: L.nav.config     },
];

// ─── Theme toggle ──────────────────────────────────────────────────────────

function ThemeToggle({ theme, setTheme }) {
  return (
    <div className="dhc-theme-group" role="radiogroup" aria-label="Thème">
      <button
        className={`dhc-theme-btn${theme === 'light' ? ' dhc-theme-btn--active' : ''}`}
        onClick={() => setTheme('light')}
        role="radio"
        aria-checked={theme === 'light'}
      >
        <IconSun /> Clair
      </button>
      <button
        className={`dhc-theme-btn${theme === 'dark' ? ' dhc-theme-btn--active' : ''}`}
        onClick={() => setTheme('dark')}
        role="radio"
        aria-checked={theme === 'dark'}
      >
        <IconMoon /> Sombre
      </button>
    </div>
  );
}

// ─── Nav component ─────────────────────────────────────────────────────────

function Nav({ current, onNavigate }) {
  return (
    <nav className="dhc-nav" aria-label="Navigation DHC">
      {NAV_ITEMS.map(item => (
        <button
          key={item.key}
          className={`dhc-nav-btn${current === item.key ? ' dhc-nav-btn--active' : ''}`}
          onClick={() => onNavigate(item.key, {})}
          aria-current={current === item.key ? 'page' : undefined}
        >
          {item.label}
        </button>
      ))}
    </nav>
  );
}

// ─── Root app component ────────────────────────────────────────────────────

function DhcApp({ api }) {
  const [nav, setNav]     = useState({ screen: 'dashboard', params: {} });
  const [theme, setTheme] = useState('light');
  const [announcement, setAnnouncement] = useState('');

  const navigate = useCallback((screen, params = {}) => {
    setNav({ screen, params });
    const labels = {
      dashboard:  L.nav.dashboard,
      findings:   L.nav.findings,
      comparison: L.nav.comparison,
      components: L.nav.components,
      config:     L.nav.config,
    };
    setAnnouncement(`Écran : ${labels[screen] || screen}`);
  }, []);

  return (
    <div className="dhc" data-theme={theme}>
      {/* Screen-reader live region */}
      <div aria-live="polite" aria-atomic="true" className="dhc-sr-only">
        {announcement}
      </div>

      {/* App header */}
      <header className="dhc-header" role="banner">
        <div className="dhc-header-left">
          <div className="dhc-header-logo">
            <IconShield />
          </div>
          <h1 className="dhc-header-title">Deployment Health Check</h1>
        </div>
        <div className="dhc-header-right">
          <ThemeToggle theme={theme} setTheme={setTheme} />
        </div>
      </header>

      <Nav current={nav.screen} onNavigate={navigate} />

      {nav.screen === 'dashboard'  && (
        <Dashboard api={api} onNavigate={navigate} />
      )}
      {nav.screen === 'findings'   && (
        <Findings api={api} onNavigate={navigate} params={nav.params} />
      )}
      {nav.screen === 'comparison' && (
        <Comparison api={api} onNavigate={navigate} params={nav.params} />
      )}
      {nav.screen === 'components' && (
        <Components api={api} onNavigate={navigate} />
      )}
      {nav.screen === 'config'     && (
        <Config api={api} />
      )}
    </div>
  );
}

// ─── Public API ────────────────────────────────────────────────────────────

function mount(element, api) {
  if (roots.has(element)) return;
  injectStyles();
  const root = createRoot(element);
  root.render(React.createElement(DhcApp, { api }));
  roots.set(element, root);
}

function unmount(element) {
  const root = roots.get(element);
  if (root) {
    root.unmount();
    roots.delete(element);
  }
}

window.DHC_UI = { mount, unmount };
