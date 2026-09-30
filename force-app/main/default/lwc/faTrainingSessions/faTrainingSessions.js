import { LightningElement, wire, track } from 'lwc';
import getSessions from '@salesforce/apex/FA_TrainingController.getSessions';
import getCategories from '@salesforce/apex/FA_PlayerController.getCategories';
import { NavigationMixin } from 'lightning/navigation';

export default class FaTrainingSessions extends NavigationMixin(LightningElement) {
    @track sessions = [];
    categories = [];
    selectedCategory = '';
    isLoading = true;
    error;

    columns = [
        { label: 'Date', fieldName: 'Session_Date__c', type: 'date', sortable: true },
        { label: 'Catégorie', fieldName: 'categoryName', type: 'text' },
        { label: 'Type', fieldName: 'Type__c', type: 'text' },
        { label: 'Horaire', fieldName: 'timeRange', type: 'text' },
        { label: 'Lieu', fieldName: 'Location__c', type: 'text' },
        { label: 'Coach', fieldName: 'coachName', type: 'text' },
        { label: 'Statut', fieldName: 'Status__c', type: 'text' },
        { type: 'action', typeAttributes: { rowActions: [
            { label: 'Voir Détails', name: 'view' },
            { label: 'Prendre Présences', name: 'attendance' }
        ]}}
    ];

    @wire(getCategories)
    wiredCategories({ error, data }) {
        if (data) {
            this.categories = [
                { label: 'Toutes', value: '' },
                ...data.map(c => ({ label: c.Short_Name__c, value: c.Id }))
            ];
            this.error = undefined;
        } else if (error) {
            this.error = error.body?.message || 'Erreur de chargement';
        }
    }

    @wire(getSessions, { categoryId: '$categoryFilter', startDate: null, endDate: null })
    wiredSessions({ error, data }) {
        this.isLoading = false;
        if (data) {
            this.sessions = data.map(s => ({
                ...s,
                categoryName: s.Category__r?.Short_Name__c || '',
                coachName: s.Coach__r?.Display_Name__c || '',
                timeRange: (s.Start_Time__c || '') + ' - ' + (s.End_Time__c || '')
            }));
            this.error = undefined;
        } else if (error) {
            this.error = error.body?.message || 'Erreur de chargement';
        }
    }

    get categoryFilter() { return this.selectedCategory || null; }

    handleCategoryChange(event) { this.selectedCategory = event.detail.value; }

    handleRowAction(event) {
        const row = event.detail.row;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: { recordId: row.Id, objectApiName: 'FA_Training_Session__c', actionName: 'view' }
        });
    }

    handleNewSession() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: { objectApiName: 'FA_Training_Session__c', actionName: 'new' }
        });
    }
}
