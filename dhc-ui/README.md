# DHC UI — React source

This directory contains the React source for the DHC front-end.
It lives at the repo root and is **never deployed to Salesforce directly**.

## Prerequisites

Node.js 18+ and npm.

## Build

```bash
npm install
npm run build
```

The build writes a single IIFE bundle to:

```
../force-app/main/default/staticresources/DHC_UI.js
```

Deploy it afterwards:

```bash
sf project deploy start --manifest manifest/package-dhc.xml
```

## Architecture

| File | Role |
|---|---|
| `src/main.jsx` | Root component + `mount` / `unmount` exported on `window.DHC_UI` |
| `vite.config.js` | IIFE lib build, single file, bundled React, no CDN |

### Key constraints (Lightning Web Security)

- **IIFE format** — `loadScript` does not support ES modules or dynamic imports.
- **No eval / new Function** — forbidden by LWS at runtime.
- **Self-contained bundle** — React is bundled inline; no CDN dependency.
- **API injection** — React never imports `@salesforce/apex`.
  The LWC wrapper (`dhcApp`) imports Apex methods and passes an `api` object
  to `window.DHC_UI.mount(container, api)` at mount time.
- **unmount on disconnect** — The LWC wrapper calls `window.DHC_UI.unmount(container)`
  in `disconnectedCallback()` to prevent memory leaks.
