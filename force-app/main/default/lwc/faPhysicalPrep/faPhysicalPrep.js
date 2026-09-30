import { LightningElement, wire, track } from 'lwc';
import getPhysicalPrograms from '@salesforce/apex/FA_PerformanceController.getPhysicalPrograms';
import getFitnessTests from '@salesforce/apex/FA_PerformanceController.getFitnessTests';
import getCategories from '@salesforce/apex/FA_PlayerController.getCategories';

export default class FaPhysicalPrep extends LightningElement {
    @track programs = [];
    @track fitnessTests = [];
    categories = [];
    selectedCategory = '';
    activeTab = 'programs';
    isLoading = true;
    error;

    testColumns = [
        { label: 'Date', fieldName: 'Test_Date__c', type: 'date' },
        { label: 'Joueur', fieldName: 'playerName', type: 'text' },
        { label: 'Type', fieldName: 'Test_Type__c', type: 'text' },
        { label: 'Résultat', fieldName: 'Result__c', type: 'number', typeAttributes: { maximumFractionDigits: 2 } },
        { label: 'Unité', fieldName: 'Unit__c', type: 'text' },
        { label: 'Percentile', fieldName: 'Percentile__c', type: 'number' }
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

    @wire(getPhysicalPrograms, { categoryId: '$catFilter', status: null })
    wiredPrograms({ error, data }) {
        this.isLoading = false;
        if (data) {
            this.programs = data;
            this.error = undefined;
        } else if (error) {
            this.error = error.body?.message || 'Erreur de chargement';
        }
    }

    @wire(getFitnessTests, { playerId: null, testType: null })
    wiredTests({ error, data }) {
        if (data) {
            this.fitnessTests = data.map(t => ({
                ...t,
                playerName: t.Player__r?.First_Name__c + ' ' + t.Player__r?.Last_Name__c
            }));
            this.error = undefined;
        } else if (error) {
            this.error = error.body?.message || 'Erreur de chargement';
        }
    }

    get catFilter() { return this.selectedCategory || null; }
    get isProgramsTab() { return this.activeTab === 'programs'; }
    get isTestsTab() { return this.activeTab === 'tests'; }

    handleCategoryChange(e) { this.selectedCategory = e.detail.value; }
    handleTabChange(e) { this.activeTab = e.target.value; }
}
