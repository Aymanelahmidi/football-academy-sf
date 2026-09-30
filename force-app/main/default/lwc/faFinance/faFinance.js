import { LightningElement, wire, track } from 'lwc';
import getTransactions from '@salesforce/apex/FA_MedicalController.getTransactions';
import getFinanceStats from '@salesforce/apex/FA_MedicalController.getFinanceStats';

export default class FaFinance extends LightningElement {
    @track transactions = [];
    stats;
    selectedType = '';
    isLoading = true;
    error;

    typeOptions = [
        { label: 'Tous', value: '' },
        { label: 'Revenu', value: 'Revenue' },
        { label: 'Dépense', value: 'Expense' }
    ];

    columns = [
        { label: 'Date', fieldName: 'Transaction_Date__c', type: 'date', sortable: true },
        { label: 'Type', fieldName: 'Type__c', type: 'text' },
        { label: 'Catégorie', fieldName: 'Category__c', type: 'text' },
        { label: 'Description', fieldName: 'Description__c', type: 'text' },
        { label: 'Montant (MAD)', fieldName: 'Amount__c', type: 'currency', typeAttributes: { currencyCode: 'MAD' } },
        { label: 'Joueur', fieldName: 'playerName', type: 'text' },
        { label: 'Statut', fieldName: 'Status__c', type: 'text' },
        { label: 'Mode', fieldName: 'Payment_Method__c', type: 'text' }
    ];

    @wire(getFinanceStats)
    wiredStats({ error, data }) {
        if (data) { this.stats = data; this.error = undefined; }
        else if (error) { this.error = error.body?.message || 'Erreur de chargement'; }
    }

    @wire(getTransactions, { transType: '$typeFilter', status: null, startDate: null, endDate: null })
    wiredTrans({ error, data }) {
        this.isLoading = false;
        if (data) {
            this.transactions = data.map(t => ({
                ...t,
                playerName: t.Player__r ? t.Player__r.First_Name__c + ' ' + t.Player__r.Last_Name__c : ''
            }));
            this.error = undefined;
        } else if (error) {
            this.error = error.body?.message || 'Erreur de chargement';
        }
    }

    get typeFilter() { return this.selectedType || null; }
    get totalRevenue() { return this.stats?.totalRevenue?.toLocaleString('fr-FR') || '0'; }
    get totalExpenses() { return this.stats?.totalExpenses?.toLocaleString('fr-FR') || '0'; }
    get balance() { return this.stats?.balance?.toLocaleString('fr-FR') || '0'; }

    handleTypeChange(e) { this.selectedType = e.detail.value; }
}
