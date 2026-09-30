---
name: lwc-patterns
description: Apply when creating or reviewing Lightning Web Components. Use when the user asks about @wire, data loading, navigation, event communication, component architecture, or UI patterns for the Football Academy app.
---

# Skill: LWC Patterns — Football Academy SF

## Pattern #1 — Wire Standard (lectures)

```javascript
import { LightningElement, wire, track } from 'lwc';
import getPlayers from '@salesforce/apex/FA_PlayerController.getPlayers';

export default class FaPlayerList extends LightningElement {
    @track selectedCategory;

    // Wire réactif — se recharge quand selectedCategory change
    @wire(getPlayers, { categoryId: '$selectedCategory' })
    wiredPlayers({ error, data }) {
        if (data) {
            this.players = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.players = [];
        }
    }
}
```

## Pattern #2 — Imperative Call (mutations)

```javascript
import createPlayer from '@salesforce/apex/FA_PlayerController.createPlayer';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

// Dans le handler
handleSave() {
    this.isLoading = true;
    createPlayer({ player: this.playerData })
        .then(result => {
            this.showToast('Succès', `Joueur ${result.Name} créé.`, 'success');
            return refreshApex(this.wiredPlayersResult); // Rafraîchir la liste
        })
        .catch(error => {
            this.showToast('Erreur', error.body.message, 'error');
        })
        .finally(() => {
            this.isLoading = false;
        });
}

showToast(title, message, variant) {
    this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
}
```

## Pattern #3 — Communication Parent → Enfant (propriété)

```html
<!-- parent.html -->
<template>
    <c-fa-player-profile player-id={selectedPlayerId}></c-fa-player-profile>
</template>
```

```javascript
// faPlayerProfile.js — enfant reçoit la prop
import { LightningElement, api, wire } from 'lwc';
import getPlayerById from '@salesforce/apex/FA_PlayerController.getPlayerById';

export default class FaPlayerProfile extends LightningElement {
    @api playerId; // Propriété publique reçue du parent

    @wire(getPlayerById, { playerId: '$playerId' })
    player;
}
```

## Pattern #4 — Communication Enfant → Parent (événement custom)

```javascript
// Enfant émet un événement
handlePlayerSelected(event) {
    const playerId = event.currentTarget.dataset.id;
    this.dispatchEvent(new CustomEvent('playerselect', {
        detail: { playerId },
        bubbles: true
    }));
}
```

```html
<!-- Parent écoute l'événement -->
<template>
    <c-fa-player-list onplayerselect={handlePlayerSelect}></c-fa-player-list>
</template>
```

```javascript
// Parent reçoit
handlePlayerSelect(event) {
    this.selectedPlayerId = event.detail.playerId;
}
```

## Pattern #5 — Navigation

```javascript
import { NavigationMixin } from 'lightning/navigation';

export default class FaPlayerList extends NavigationMixin(LightningElement) {

    // Vers la page record
    navigateToPlayer(playerId) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: { recordId: playerId, actionName: 'view' }
        });
    }

    // Vers une App Page
    navigateToDashboard() {
        this[NavigationMixin.Navigate]({
            type: 'standard__navItemPage',
            attributes: { apiName: 'Football_Academy' }
        });
    }

    // Vers formulaire de création
    navigateToCreate() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'FA_Player__c',
                actionName: 'new'
            }
        });
    }
}
```

## Pattern #6 — Getters Calculés (éviter la logique dans HTML)

```javascript
// ✅ CORRECT — Logic dans JS via getters
get hasPlayers() {
    return this.players && this.players.length > 0;
}

get playerCount() {
    return this.players ? this.players.length : 0;
}

get statusBadgeClass() {
    const base = 'slds-badge ';
    switch(this.player.Status__c) {
        case 'Actif': return base + 'slds-badge_success';
        case 'Blessé': return base + 'slds-badge_error';
        case 'Suspendu': return base + 'slds-badge_warning';
        default: return base;
    }
}
```

```html
<!-- ✅ HTML simple sans logique -->
<template if:true={hasPlayers}>
    <p>Total : {playerCount} joueurs</p>
    <span class={statusBadgeClass}>{player.Status__c}</span>
</template>
```

## Pattern #7 — Loading State

```html
<template>
    <template if:true={isLoading}>
        <lightning-spinner alternative-text="Chargement..." size="medium"></lightning-spinner>
    </template>
    <template if:false={isLoading}>
        <!-- Contenu principal -->
    </template>
</template>
```

## Pattern #8 — Colonnes Datatable Football Academy

```javascript
const PLAYER_COLUMNS = [
    {
        label: '#',
        fieldName: 'Jersey_Number__c',
        type: 'number',
        cellAttributes: { alignment: 'center' },
        initialWidth: 60
    },
    { label: 'Nom', fieldName: 'Last_Name__c', type: 'text', sortable: true },
    { label: 'Prénom', fieldName: 'First_Name__c', type: 'text', sortable: true },
    { label: 'Poste', fieldName: 'Position__c', type: 'text' },
    { label: 'Statut', fieldName: 'Status__c', type: 'text' },
    {
        type: 'action',
        typeAttributes: {
            rowActions: [
                { label: 'Profil', name: 'view' },
                { label: 'Modifier', name: 'edit' },
                { label: 'Blessure', name: 'injury' }
            ]
        }
    }
];
```

## Anti-Patterns à Éviter

```javascript
// ❌ Appel Apex dans connectedCallback (pas de wire)
connectedCallback() {
    getPlayers().then(data => { this.players = data; }); // ❌
}

// ✅ Utiliser @wire systématiquement pour les lectures

// ❌ Modification directe des données wire
this.players.push(newPlayer); // ❌ — les wire data sont readonly

// ✅ Créer une copie
this.players = [...this.players, newPlayer];

// ❌ Logique métier dans le HTML
<template if:true={player.Status__c == 'Actif'}> // ❌ — impossible en LWC

// ✅ Getter JS
get isActive() { return this.player.Status__c === 'Actif'; }
<template if:true={isActive}>
```
