import { LightningElement, api, wire } from 'lwc';
import getPlayerById from '@salesforce/apex/FA_PlayerController.getPlayerById';
import getPlayerContracts from '@salesforce/apex/FA_PlayerController.getPlayerContracts';
import getPlayerGuardians from '@salesforce/apex/FA_PlayerController.getPlayerGuardians';
import getEvaluations from '@salesforce/apex/FA_MedicalController.getEvaluations';
import getInjuries from '@salesforce/apex/FA_MedicalController.getInjuries';
import getGpsData from '@salesforce/apex/FA_PerformanceController.getGpsData';
import getMorphologicalMeasures from '@salesforce/apex/FA_PerformanceController.getMorphologicalMeasures';

export default class FaPlayerProfile extends LightningElement {
    @api recordId;
    player;
    contracts = [];
    guardians = [];
    evaluations = [];
    injuries = [];
    gpsData = [];
    morphology = [];
    activeTab = 'info';
    isLoading = true;
    error;

    @wire(getPlayerById, { playerId: '$recordId' })
    wiredPlayer({ error, data }) {
        this.isLoading = false;
        if (data) { this.player = data; this.error = undefined; }
        else if (error) { this.error = error.body?.message || 'Erreur de chargement'; }
    }

    @wire(getPlayerContracts, { playerId: '$recordId' })
    wiredContracts({ error, data }) {
        if (data) { this.contracts = data; this.error = undefined; }
        else if (error) { this.error = error.body?.message || 'Erreur de chargement'; }
    }

    @wire(getPlayerGuardians, { playerId: '$recordId' })
    wiredGuardians({ error, data }) {
        if (data) { this.guardians = data; this.error = undefined; }
        else if (error) { this.error = error.body?.message || 'Erreur de chargement'; }
    }

    @wire(getEvaluations, { playerId: '$recordId', evalType: null })
    wiredEvals({ error, data }) {
        if (data) { this.evaluations = data; this.error = undefined; }
        else if (error) { this.error = error.body?.message || 'Erreur de chargement'; }
    }

    @wire(getInjuries, { playerId: '$recordId', status: null })
    wiredInjuries({ error, data }) {
        if (data) { this.injuries = data; this.error = undefined; }
        else if (error) { this.error = error.body?.message || 'Erreur de chargement'; }
    }

    @wire(getGpsData, { playerId: '$recordId', sessionId: null, startDate: null, endDate: null })
    wiredGps({ error, data }) {
        if (data) { this.gpsData = data.slice(0, 20); this.error = undefined; }
        else if (error) { this.error = error.body?.message || 'Erreur de chargement'; }
    }

    @wire(getMorphologicalMeasures, { playerId: '$recordId' })
    wiredMorpho({ error, data }) {
        if (data) { this.morphology = data; this.error = undefined; }
        else if (error) { this.error = error.body?.message || 'Erreur de chargement'; }
    }

    get fullName() { return this.player ? this.player.First_Name__c + ' ' + this.player.Last_Name__c : ''; }
    get categoryName() { return this.player?.Category__r?.Short_Name__c || ''; }
    get age() {
        if (!this.player?.Date_of_Birth__c) return '';
        const birth = new Date(this.player.Date_of_Birth__c);
        return Math.floor((Date.now() - birth.getTime()) / 31557600000) + ' ans';
    }

    get isInfoTab() { return this.activeTab === 'info'; }
    get isEvalsTab() { return this.activeTab === 'evals'; }
    get isInjuriesTab() { return this.activeTab === 'injuries'; }
    get isGpsTab() { return this.activeTab === 'gps'; }
    get isMorphoTab() { return this.activeTab === 'morpho'; }

    handleTabChange(event) { this.activeTab = event.target.value; }
}
