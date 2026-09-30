import { LightningElement, wire, track } from 'lwc';
import getInjuries from '@salesforce/apex/FA_MedicalController.getInjuries';
import getMedicalStats from '@salesforce/apex/FA_MedicalController.getMedicalStats';

export default class FaMedicalTracking extends LightningElement {
    @track injuries = [];
    stats;
    selectedStatus = '';
    isLoading = true;
    error;

    statusOptions = [
        { label: 'Tous', value: '' },
        { label: 'En Traitement', value: 'In Treatment' },
        { label: 'En Rééducation', value: 'Rehabilitation' },
        { label: 'Guéri', value: 'Recovered' }
    ];

    columns = [
        { label: 'Joueur', fieldName: 'playerName', type: 'text' },
        { label: 'Catégorie', fieldName: 'categoryName', type: 'text' },
        { label: 'Type', fieldName: 'Type__c', type: 'text' },
        { label: 'Localisation', fieldName: 'Body_Part__c', type: 'text' },
        { label: 'Sévérité', fieldName: 'Severity__c', type: 'text' },
        { label: 'Date Blessure', fieldName: 'Injury_Date__c', type: 'date' },
        { label: 'Retour Prévu', fieldName: 'Expected_Return_Date__c', type: 'date' },
        { label: 'Statut', fieldName: 'Status__c', type: 'text' }
    ];

    @wire(getMedicalStats)
    wiredStats({ error, data }) {
        if (data) { this.stats = data; this.error = undefined; }
        else if (error) { this.error = error.body?.message || 'Erreur de chargement'; }
    }

    @wire(getInjuries, { playerId: null, status: '$statusFilter' })
    wiredInjuries({ error, data }) {
        this.isLoading = false;
        if (data) {
            this.injuries = data.map(i => ({
                ...i,
                playerName: i.Player__r?.First_Name__c + ' ' + i.Player__r?.Last_Name__c,
                categoryName: i.Player__r?.Category__r?.Short_Name__c || ''
            }));
            this.error = undefined;
        } else if (error) {
            this.error = error.body?.message || 'Erreur de chargement';
        }
    }

    get statusFilter() { return this.selectedStatus || null; }
    get activeInjuries() { return this.stats?.activeInjuries || 0; }

    handleStatusChange(e) { this.selectedStatus = e.detail.value; }
}
