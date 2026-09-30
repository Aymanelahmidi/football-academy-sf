import { LightningElement, wire, track } from 'lwc';
import getMatches from '@salesforce/apex/FA_MatchController.getMatches';
import getCategories from '@salesforce/apex/FA_PlayerController.getCategories';
import { NavigationMixin } from 'lightning/navigation';

export default class FaMatchList extends NavigationMixin(LightningElement) {
    @track matches = [];
    categories = [];
    selectedCategory = '';
    selectedStatus = '';
    isLoading = true;
    error;

    statusOptions = [
        { label: 'Tous', value: '' },
        { label: 'Planifié', value: 'Planifié' },
        { label: 'Terminé', value: 'Terminé' },
        { label: 'Annulé', value: 'Annulé' }
    ];

    columns = [
        { label: 'Date', fieldName: 'Match_Date__c', type: 'date', sortable: true },
        { label: 'Adversaire', fieldName: 'Opponent__c', type: 'text' },
        { label: 'Catégorie', fieldName: 'categoryName', type: 'text' },
        { label: 'Compétition', fieldName: 'competitionName', type: 'text' },
        { label: 'Lieu', fieldName: 'Location__c', type: 'text' },
        { label: 'Score', fieldName: 'score', type: 'text' },
        { label: 'Résultat', fieldName: 'result', type: 'text' },
        { label: 'Statut', fieldName: 'Status__c', type: 'text' }
    ];

    @wire(getCategories)
    wiredCats({ error, data }) {
        if (data) {
            this.categories = [{ label: 'Toutes', value: '' }, ...data.map(c => ({ label: c.Short_Name__c, value: c.Id }))];
            this.error = undefined;
        } else if (error) {
            this.error = error.body?.message || 'Erreur de chargement';
        }
    }

    @wire(getMatches, { categoryId: '$catFilter', status: '$statusFilter', startDate: null, endDate: null })
    wiredMatches({ error, data }) {
        this.isLoading = false;
        if (data) {
            this.matches = data.map(m => ({
                ...m,
                categoryName: m.Category__r?.Short_Name__c || '',
                competitionName: m.Competition__r?.Name || '',
                score: m.Status__c === 'Terminé' ? m.Goals_For__c + ' - ' + m.Goals_Against__c : '-',
                result: m.Status__c === 'Terminé' ? (m.Goals_For__c > m.Goals_Against__c ? 'Victoire' : m.Goals_For__c < m.Goals_Against__c ? 'Défaite' : 'Nul') : ''
            }));
            this.error = undefined;
        } else if (error) {
            this.error = error.body?.message || 'Erreur de chargement';
        }
    }

    get catFilter() { return this.selectedCategory || null; }
    get statusFilter() { return this.selectedStatus || null; }

    handleCategoryChange(e) { this.selectedCategory = e.detail.value; }
    handleStatusChange(e) { this.selectedStatus = e.detail.value; }

    handleNewMatch() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: { objectApiName: 'FA_Match__c', actionName: 'new' }
        });
    }
}
