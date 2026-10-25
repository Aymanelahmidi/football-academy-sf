import { LightningElement } from 'lwc';
import { loadScript }       from 'lightning/platformResourceLoader';
import DHC_UI               from '@salesforce/resourceUrl/DHC_UI';

// Apex methods — imported by the LWC wrapper, never by React.
import getLatestDeployment from '@salesforce/apex/DHC_AppController.getLatestDeployment';
import getDeployments      from '@salesforce/apex/DHC_AppController.getDeployments';
import getFindings         from '@salesforce/apex/DHC_AppController.getFindings';
import getComponentDetail  from '@salesforce/apex/DHC_AppController.getComponentDetail';
import startCapture          from '@salesforce/apex/DHC_AppController.startCapture';
import runRuleEngine         from '@salesforce/apex/DHC_AppController.runRuleEngine';
import updateFindingStatus   from '@salesforce/apex/DHC_AppController.updateFindingStatus';
import getCaptureScopeConfig from '@salesforce/apex/DHC_AppController.getCaptureScopeConfig';
import getActiveRules        from '@salesforce/apex/DHC_AppController.getActiveRules';

export default class DhcApp extends LightningElement {

    isLoading    = true;
    hasError     = false;
    errorMessage = '';

    /**
     * Guard: renderedCallback() fires on every re-render.
     * loadScript must be called exactly once.
     */
    _scriptLoaded = false;

    renderedCallback() {
        if (this._scriptLoaded) return;
        this._scriptLoaded = true;

        loadScript(this, DHC_UI)
            .then(() => {
                this.isLoading = false;
                const container = this.template.querySelector('.dhc-root');
                window.DHC_UI.mount(container, this._buildApi());
            })
            .catch(error => {
                // Allow retry on the next render cycle.
                this._scriptLoaded = false;
                this.isLoading    = false;
                this.hasError     = true;
                this.errorMessage = (error && error.message)
                    ? error.message
                    : String(error);
            });
    }

    /**
     * Unmount React when the user navigates away from the page.
     * Prevents memory leaks (React roots, event listeners).
     */
    disconnectedCallback() {
        const container = this.template.querySelector('.dhc-root');
        if (container && window.DHC_UI) {
            window.DHC_UI.unmount(container);
        }
    }

    /**
     * Builds the api object injected into React at mount time.
     * React receives async function wrappers — it never imports @salesforce/apex.
     *
     * Apex parameter objects follow the {paramName: value} shape required
     * by LWC imperative Apex calls.
     */
    _buildApi() {
        return {
            getLatestDeployment: () =>
                getLatestDeployment(),

            getDeployments: (limitSize) =>
                getDeployments({ limitSize }),

            getFindings: (params) =>
                getFindings(params),

            getComponentDetail: (componentId) =>
                getComponentDetail({ componentId }),

            startCapture: (mode) =>
                startCapture({ mode }),

            runRuleEngine: (deploymentId) =>
                runRuleEngine({ deploymentId }),

            updateFindingStatus: (findingId, status, justification) =>
                updateFindingStatus({ findingId, status, justification }),

            getCaptureScopeConfig: () =>
                getCaptureScopeConfig(),

            getActiveRules: () =>
                getActiveRules(),
        };
    }
}
