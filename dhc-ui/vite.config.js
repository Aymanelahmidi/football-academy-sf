import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

// Vite build config for DHC UI — React IIFE bundle loaded by dhcApp LWC.
//
// Constraints (Lightning Web Security):
//   - IIFE format: loadScript does not support ES modules or dynamic imports.
//   - Single file: inlineDynamicImports must be true.
//   - No eval / new Function: enforced by LWS at runtime.
//   - React bundled inline: no CDN; the static resource must be self-contained.
//
// Output: force-app/main/default/staticresources/DHC_UI.js

export default defineConfig({
  plugins: [react()],
  build: {
    lib: {
      entry: 'src/main.jsx',
      name: 'DHC_UI',
      formats: ['iife'],
      fileName: () => 'DHC_UI.js',
    },
    outDir: '../force-app/main/default/staticresources',
    emptyOutDir: false,
    rollupOptions: {
      output: {
        inlineDynamicImports: true,
      },
    },
    cssCodeSplit: false,
    minify: 'esbuild',
    target: 'es2020',
  },
  define: {
    'process.env.NODE_ENV': '"production"',
  },
});
