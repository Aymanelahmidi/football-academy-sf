import { LightningElement, wire, track } from 'lwc';
import getCategories from '@salesforce/apex/FA_PlayerController.getCategories';

export default class FaSettings extends LightningElement {
    @track categories = [];
    isLoading = true;
    error;

    @wire(getCategories)
    wiredCats({ error, data }) {
        this.isLoading = false;
        if (data) {
            this.categories = data;
            this.error = undefined;
        } else if (error) {
            this.error = error.body?.message || 'Erreur de chargement';
        }
    }
}
