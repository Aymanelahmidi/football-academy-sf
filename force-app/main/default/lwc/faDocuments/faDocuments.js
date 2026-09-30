import { LightningElement, wire, track } from 'lwc';
import getDocuments from '@salesforce/apex/FA_MedicalController.getDocuments';

export default class FaDocuments extends LightningElement {
    @track documents = [];
    isLoading = true;
    error;

    columns = [
        { label: 'Nom', fieldName: 'Name', type: 'text' },
        { label: 'Type', fieldName: 'Type__c', type: 'text' },
        { label: 'Joueur', fieldName: 'playerName', type: 'text' },
        { label: 'Statut', fieldName: 'Status__c', type: 'text' },
        { label: 'Expiration', fieldName: 'Expiry_Date__c', type: 'date' },
        { label: 'Créé le', fieldName: 'CreatedDate', type: 'date' }
    ];

    @wire(getDocuments, { playerId: null, docType: null, status: null })
    wiredDocs({ error, data }) {
        this.isLoading = false;
        if (data) {
            this.documents = data.map(d => ({
                ...d,
                playerName: d.Player__r ? d.Player__r.First_Name__c + ' ' + d.Player__r.Last_Name__c : ''
            }));
            this.error = undefined;
        } else if (error) {
            this.error = error.body?.message || 'Erreur de chargement';
        }
    }
}
