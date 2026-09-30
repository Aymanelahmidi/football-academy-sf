import { LightningElement, wire, track } from 'lwc';
import getPlayers from '@salesforce/apex/FA_PlayerController.getPlayers';
import getCategories from '@salesforce/apex/FA_PlayerController.getCategories';
import deactivatePlayer from '@salesforce/apex/FA_PlayerController.deactivatePlayer';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

const COLUMNS = [
    { label: 'N°', fieldName: 'Jersey_Number__c', type: 'number', initialWidth: 60 },
    { label: 'Nom', fieldName: 'playerUrl', type: 'url',
      typeAttributes: { label: { fieldName: 'fullName' }, target: '_self' }},
    { label: 'Catégorie', fieldName: 'categoryName', type: 'text' },
    { label: 'Position', fieldName: 'Position__c', type: 'text' },
    { label: 'Nationalité', fieldName: 'Nationality__c', type: 'text' },
    { label: 'Statut', fieldName: 'Status__c', type: 'text',
      cellAttributes: {
          class: { fieldName: 'statusClass' }
      }
    },
    { label: 'Date Naissance', fieldName: 'Date_of_Birth__c', type: 'date' },
    { type: 'action', typeAttributes: { rowActions: [
        { label: 'Voir Profil', name: 'view' },
        { label: 'Modifier', name: 'edit' },
        { label: 'Désactiver', name: 'deactivate' }
    ]}}
];

export default class FaPlayerList extends NavigationMixin(LightningElement) {
    columns = COLUMNS;
    @track players = [];
    @track categories = [];
    selectedCategory = '';
    selectedStatus = '';
    searchTerm = '';
    isLoading = true;
    error;
    wiredPlayersResult;

    statusOptions = [
        { label: 'Tous', value: '' },
        { label: 'Actif', value: 'Actif' },
        { label: 'Blessé', value: 'Blessé' },
        { label: 'Suspendu', value: 'Suspendu' },
        { label: 'En Essai', value: 'En Essai' }
    ];

    @wire(getCategories)
    wiredCategories({ error, data }) {
        if (data) {
            this.categories = [
                { label: 'Toutes les catégories', value: '' },
                ...data.map(c => ({ label: c.Short_Name__c + ' - ' + c.Name, value: c.Id }))
            ];
            this.error = undefined;
        } else if (error) {
            this.error = error.body?.message || 'Erreur de chargement';
        }
    }

    @wire(getPlayers, { categoryId: '$selectedCategoryId', status: '$selectedStatusValue', searchTerm: '$searchTermValue' })
    wiredPlayers(result) {
        this.wiredPlayersResult = result;
        if (result.data) {
            this.players = result.data.map(p => ({
                ...p,
                fullName: p.First_Name__c + ' ' + p.Last_Name__c,
                categoryName: p.Category__r?.Short_Name__c || '',
                playerUrl: '/lightning/r/FA_Player__c/' + p.Id + '/view',
                statusClass: p.Status__c === 'Blessé' ? 'slds-text-color_error' :
                             p.Status__c === 'Actif' ? 'slds-text-color_success' : ''
            }));
            this.isLoading = false;
            this.error = undefined;
        } else if (result.error) {
            this.error = result.error.body?.message || 'Erreur de chargement';
            this.isLoading = false;
        }
    }

    get selectedCategoryId() {
        return this.selectedCategory || null;
    }

    get selectedStatusValue() {
        return this.selectedStatus || null;
    }

    get searchTermValue() {
        return this.searchTerm || null;
    }

    get totalPlayers() {
        return this.players.length;
    }

    handleCategoryChange(event) {
        this.selectedCategory = event.detail.value;
    }

    handleStatusChange(event) {
        this.selectedStatus = event.detail.value;
    }

    handleSearch(event) {
        this.searchTerm = event.target.value;
    }

    handleRowAction(event) {
        const action = event.detail.action;
        const row = event.detail.row;

        switch (action.name) {
            case 'view':
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: row.Id,
                        objectApiName: 'FA_Player__c',
                        actionName: 'view'
                    }
                });
                break;
            case 'edit':
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: row.Id,
                        objectApiName: 'FA_Player__c',
                        actionName: 'edit'
                    }
                });
                break;
            case 'deactivate':
                this.handleDeactivate(row.Id);
                break;
        }
    }

    async handleDeactivate(playerId) {
        try {
            await deactivatePlayer({ playerId });
            this.dispatchEvent(new ShowToastEvent({
                title: 'Succès',
                message: 'Joueur désactivé',
                variant: 'success'
            }));
            return refreshApex(this.wiredPlayersResult);
        } catch (error) {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Erreur',
                message: error.body?.message || 'Erreur lors de la désactivation',
                variant: 'error'
            }));
        }
    }

    handleNewPlayer() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'FA_Player__c',
                actionName: 'new'
            }
        });
    }
}
