---
name: new-lwc
description: Use when creating a new Lightning Web Component for the Football Academy project. Generates a complete LWC template with best practices (wire, error handling, toast, loading state). Replace fa-my-component / faMyComponent with actual component name.
---

# Plugin: Nouveau Composant LWC Football Academy

## Usage
Remplacer : `faMyComponent` (JS/CSS) / `fa-my-component` (HTML) / `MY_DOMAIN` / `myMethod`

---

## 1. HTML — `faMyComponent.html`

```html
<template>
    <!-- Loading Spinner -->
    <template if:true={isLoading}>
        <lightning-spinner alternative-text="Chargement..." size="medium"></lightning-spinner>
    </template>

    <!-- Error Display -->
    <template if:true={error}>
        <div class="slds-notify slds-notify_alert slds-alert_error" role="alert">
            <span class="slds-assistive-text">Erreur</span>
            <h2>{errorMessage}</h2>
        </div>
    </template>

    <!-- Main Content -->
    <template if:false={isLoading}>
        <lightning-card title="MY COMPONENT TITLE" icon-name="standard:account">
            <div class="slds-p-around_medium">

                <!-- Filters -->
                <div class="slds-grid slds-gutters slds-m-bottom_medium">
                    <div class="slds-col">
                        <lightning-combobox
                            name="category"
                            label="Catégorie"
                            value={selectedCategory}
                            placeholder="Toutes les catégories"
                            options={categoryOptions}
                            onchange={handleCategoryChange}>
                        </lightning-combobox>
                    </div>
                    <div class="slds-col slds-align-bottom">
                        <lightning-button
                            label="Nouveau"
                            variant="brand"
                            icon-name="utility:add"
                            onclick={handleNew}>
                        </lightning-button>
                    </div>
                </div>

                <!-- Data Table -->
                <template if:true={hasData}>
                    <lightning-datatable
                        key-field="Id"
                        data={records}
                        columns={columns}
                        onrowaction={handleRowAction}
                        hide-checkbox-column>
                    </lightning-datatable>
                </template>

                <!-- Empty State -->
                <template if:false={hasData}>
                    <div class="slds-illustration slds-illustration_small slds-p-around_large slds-text-align_center">
                        <p class="slds-text-color_weak">Aucun enregistrement trouvé.</p>
                    </div>
                </template>
            </div>
        </lightning-card>
    </template>
</template>
```

---

## 2. JavaScript — `faMyComponent.js`

```javascript
import { LightningElement, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import { refreshApex } from '@salesforce/apex';

// Imports Apex
import getRecords from '@salesforce/apex/FA_MY_DOMAINController.getRecords';
import deleteRecord from '@salesforce/apex/FA_MY_DOMAINController.deactivateRecord';

const COLUMNS = [
    { label: 'Nom', fieldName: 'Name', type: 'text', sortable: true },
    { label: 'Catégorie', fieldName: 'categoryName', type: 'text' },
    { label: 'Statut', fieldName: 'Status__c', type: 'text' },
    {
        type: 'action',
        typeAttributes: {
            rowActions: [
                { label: 'Voir', name: 'view' },
                { label: 'Modifier', name: 'edit' },
                { label: 'Désactiver', name: 'deactivate' }
            ]
        }
    }
];

export default class FaMyComponent extends NavigationMixin(LightningElement) {
    @track selectedCategory;
    @track records = [];
    @track error;
    @track isLoading = false;

    columns = COLUMNS;
    wiredRecordsResult;

    // Wire — chargement automatique des données
    @wire(getRecords, { categoryId: '$selectedCategory' })
    wiredRecords(result) {
        this.wiredRecordsResult = result;
        if (result.data) {
            this.records = result.data.map(r => ({
                ...r,
                categoryName: r.Category__r ? r.Category__r.Name : ''
            }));
            this.error = undefined;
        } else if (result.error) {
            this.error = result.error;
            this.records = [];
        }
        this.isLoading = false;
    }

    // Getters calculés
    get hasData() {
        return this.records && this.records.length > 0;
    }

    get errorMessage() {
        if (this.error) {
            return this.error.body ? this.error.body.message : 'Erreur inconnue';
        }
        return '';
    }

    get categoryOptions() {
        return [
            { label: 'U9', value: 'u9-id' },
            { label: 'U11', value: 'u11-id' },
            // Charger dynamiquement depuis Apex si besoin
        ];
    }

    // Handlers
    handleCategoryChange(event) {
        this.selectedCategory = event.detail.value;
    }

    handleNew() {
        // Navigation vers un formulaire de création
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'FA_MY_OBJECT__c',
                actionName: 'new'
            }
        });
    }

    handleRowAction(event) {
        const action = event.detail.action.name;
        const row = event.detail.row;

        switch (action) {
            case 'view':
                this.navigateToRecord(row.Id);
                break;
            case 'edit':
                this.navigateToEdit(row.Id);
                break;
            case 'deactivate':
                this.handleDeactivate(row.Id);
                break;
            default:
                break;
        }
    }

    handleDeactivate(recordId) {
        this.isLoading = true;
        deleteRecord({ recordId })
            .then(() => {
                this.showToast('Succès', 'Enregistrement désactivé.', 'success');
                return refreshApex(this.wiredRecordsResult);
            })
            .catch(error => {
                this.showToast('Erreur', error.body.message, 'error');
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    navigateToRecord(recordId) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: { recordId, actionName: 'view' }
        });
    }

    navigateToEdit(recordId) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: { recordId, actionName: 'edit' }
        });
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }
}
```

---

## 3. CSS — `faMyComponent.css`

```css
:host {
    display: block;
}

.card-header {
    background-color: #1B5E20;
    color: white;
    padding: 12px 16px;
    border-radius: 4px 4px 0 0;
}

.stat-card {
    background: #f8f9fa;
    border-radius: 8px;
    padding: 16px;
    text-align: center;
    border-left: 4px solid #1B5E20;
}

.stat-value {
    font-size: 2rem;
    font-weight: 700;
    color: #1B5E20;
}

.stat-label {
    font-size: 0.875rem;
    color: #6c757d;
    margin-top: 4px;
}
```

---

## 4. Meta — `faMyComponent.js-meta.xml`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<LightningComponentBundle xmlns="http://soap.sforce.com/2006/04/metadata">
    <apiVersion>66.0</apiVersion>
    <isExposed>true</isExposed>
    <targets>
        <target>lightning__AppPage</target>
        <target>lightning__RecordPage</target>
        <target>lightning__HomePage</target>
    </targets>
    <targetConfigs>
        <targetConfig targets="lightning__AppPage">
            <property name="title" type="String" label="Titre" default="Mon Composant"/>
        </targetConfig>
    </targetConfigs>
</LightningComponentBundle>
```
