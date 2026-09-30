import { LightningElement, wire, track } from 'lwc';
import getGpsData from '@salesforce/apex/FA_PerformanceController.getGpsData';
import getCategories from '@salesforce/apex/FA_PlayerController.getCategories';
import getPlayers from '@salesforce/apex/FA_PlayerController.getPlayers';

export default class FaGpsData extends LightningElement {
    @track gpsRecords = [];
    categories = [];
    players = [];
    selectedPlayer = '';
    isLoading = true;
    error;

    columns = [
        { label: 'Date', fieldName: 'Record_Date__c', type: 'date', sortable: true },
        { label: 'Joueur', fieldName: 'playerName', type: 'text' },
        { label: 'Catégorie', fieldName: 'categoryName', type: 'text' },
        { label: 'Contexte', fieldName: 'Context__c', type: 'text' },
        { label: 'Distance (km)', fieldName: 'Total_Distance_Km__c', type: 'number', typeAttributes: { maximumFractionDigits: 1 } },
        { label: 'Vit. Max (km/h)', fieldName: 'Max_Speed_Kmh__c', type: 'number', typeAttributes: { maximumFractionDigits: 1 } },
        { label: 'Sprints', fieldName: 'Sprint_Count__c', type: 'number' },
        { label: 'FC Moy', fieldName: 'Avg_Heart_Rate__c', type: 'number' },
        { label: 'FC Max', fieldName: 'Max_Heart_Rate__c', type: 'number' },
        { label: 'ACWR', fieldName: 'ACWR_Ratio__c', type: 'number', typeAttributes: { maximumFractionDigits: 2 },
          cellAttributes: { class: { fieldName: 'acwrClass' } } },
        { label: 'Calories', fieldName: 'Calories_Burned__c', type: 'number' }
    ];

    @wire(getPlayers, { categoryId: null, status: null, searchTerm: null })
    wiredPlayers({ error, data }) {
        if (data) {
            this.players = [
                { label: 'Tous les joueurs', value: '' },
                ...data.map(p => ({ label: p.First_Name__c + ' ' + p.Last_Name__c, value: p.Id }))
            ];
            this.error = undefined;
        } else if (error) {
            this.error = error.body?.message || 'Erreur de chargement';
        }
    }

    @wire(getGpsData, { playerId: '$playerFilter', sessionId: null, startDate: null, endDate: null })
    wiredGps({ error, data }) {
        this.isLoading = false;
        if (data) {
            this.gpsRecords = data.map(g => ({
                ...g,
                playerName: g.Player__r?.First_Name__c + ' ' + g.Player__r?.Last_Name__c,
                categoryName: g.Player__r?.Category__r?.Short_Name__c || '',
                acwrClass: g.ACWR_Ratio__c > 1.5 ? 'slds-text-color_error' :
                           g.ACWR_Ratio__c < 0.8 ? 'slds-text-color_weak' : 'slds-text-color_success'
            }));
            this.error = undefined;
        } else if (error) {
            this.error = error.body?.message || 'Erreur de chargement';
        }
    }

    get playerFilter() { return this.selectedPlayer || null; }
    get totalRecords() { return this.gpsRecords.length; }

    get avgDistance() {
        if (!this.gpsRecords.length) return 0;
        return (this.gpsRecords.reduce((s, g) => s + (g.Total_Distance_Km__c || 0), 0) / this.gpsRecords.length).toFixed(1);
    }

    get avgMaxSpeed() {
        if (!this.gpsRecords.length) return 0;
        return (this.gpsRecords.reduce((s, g) => s + (g.Max_Speed_Kmh__c || 0), 0) / this.gpsRecords.length).toFixed(1);
    }

    get avgSprints() {
        if (!this.gpsRecords.length) return 0;
        return Math.round(this.gpsRecords.reduce((s, g) => s + (g.Sprint_Count__c || 0), 0) / this.gpsRecords.length);
    }

    handlePlayerChange(e) { this.selectedPlayer = e.detail.value; }
}
