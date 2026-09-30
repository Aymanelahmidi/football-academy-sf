import { LightningElement, wire, track } from 'lwc';
import getEvaluations from '@salesforce/apex/FA_MedicalController.getEvaluations';

export default class FaEvaluations extends LightningElement {
    @track evaluations = [];
    isLoading = true;
    error;

    columns = [
        { label: 'Date', fieldName: 'Evaluation_Date__c', type: 'date', sortable: true },
        { label: 'Joueur', fieldName: 'playerName', type: 'text' },
        { label: 'Catégorie', fieldName: 'categoryName', type: 'text' },
        { label: 'Type', fieldName: 'Type__c', type: 'text' },
        { label: 'Technique', fieldName: 'Technical_Score__c', type: 'number' },
        { label: 'Tactique', fieldName: 'Tactical_Score__c', type: 'number' },
        { label: 'Physique', fieldName: 'Physical_Score__c', type: 'number' },
        { label: 'Mental', fieldName: 'Mental_Score__c', type: 'number' },
        { label: 'Note Globale', fieldName: 'Overall_Score__c', type: 'number' }
    ];

    @wire(getEvaluations, { playerId: null, evalType: null })
    wiredEvals({ error, data }) {
        this.isLoading = false;
        if (data) {
            this.evaluations = data.map(e => ({
                ...e,
                playerName: e.Player__r?.First_Name__c + ' ' + e.Player__r?.Last_Name__c,
                categoryName: e.Player__r?.Category__r?.Short_Name__c || ''
            }));
            this.error = undefined;
        } else if (error) {
            this.error = error.body?.message || 'Erreur de chargement';
        }
    }
}
