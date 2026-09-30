import { LightningElement, wire, track } from 'lwc';
import getPlayersWithInjuryStatus from '@salesforce/apex/FA_PlayerController.getPlayersWithInjuryStatus';
import getCategories from '@salesforce/apex/FA_PlayerController.getCategories';

export default class FaTeamComposition extends LightningElement {
    @track players = [];
    categories = [];
    selectedCategory = '';
    isLoading = true;
    error;

    @wire(getCategories)
    wiredCats({ error, data }) {
        if (data) {
            this.categories = data.map(c => ({ label: c.Short_Name__c + ' - ' + c.Name, value: c.Id }));
            if (data.length > 0 && !this.selectedCategory) {
                this.selectedCategory = data[0].Id;
            }
            this.error = undefined;
        } else if (error) {
            this.error = error.body?.message || 'Erreur de chargement';
            this.isLoading = false;
        }
    }

    @wire(getPlayersWithInjuryStatus, { categoryId: '$selectedCategory' })
    wiredPlayers({ error, data }) {
        this.isLoading = false;
        if (data) {
            this.players = data;
            this.error = undefined;
        } else if (error) {
            this.error = error.body?.message || 'Erreur de chargement';
        }
    }

    get goalkeepers() { return this.players.filter(p => p.position === 'Gardien'); }
    get defenders() { return this.players.filter(p => p.position === 'Défenseur'); }
    get midfielders() { return this.players.filter(p => p.position === 'Milieu'); }
    get forwards() { return this.players.filter(p => p.position === 'Attaquant'); }
    get totalPlayers() { return this.players.length; }

    handleCategoryChange(e) { this.selectedCategory = e.detail.value; }
}
