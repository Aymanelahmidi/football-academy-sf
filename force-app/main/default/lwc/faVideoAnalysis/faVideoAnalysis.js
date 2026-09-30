import { LightningElement, wire, track } from 'lwc';
import getVideoAnalyses from '@salesforce/apex/FA_VideoController.getVideoAnalyses';
import { NavigationMixin } from 'lightning/navigation';

export default class FaVideoAnalysis extends NavigationMixin(LightningElement) {
    @track videos = [];
    selectedType = '';
    selectedStatus = '';
    isLoading = true;
    error;

    typeOptions = [
        { label: 'Tous', value: '' },
        { label: 'Match Complet', value: 'Match Complet' },
        { label: 'Séquence Tactique', value: 'Séquence Tactique' },
        { label: 'Actions Individuelles', value: 'Actions Individuelles' },
        { label: 'Coups de Pied Arrêtés', value: 'Coups de Pied Arrêtés' },
        { label: 'Analyse Adversaire', value: 'Analyse Adversaire' }
    ];

    statusOptions = [
        { label: 'Tous', value: '' },
        { label: 'En Cours', value: 'En Cours' },
        { label: 'Terminé', value: 'Terminé' },
        { label: 'En Attente', value: 'En Attente' }
    ];

    @wire(getVideoAnalyses, { matchId: null, analysisType: '$typeFilter', status: '$statusFilter' })
    wiredVideos({ error, data }) {
        this.isLoading = false;
        if (data) {
            this.videos = data.map(v => ({
                ...v,
                matchName: v.Match__r?.Opponent__c || v.Training_Session__r?.Name || 'N/A',
                analystName: v.Analyst__r?.Display_Name__c || '',
                annotationCount: v.Annotations__r ? v.Annotations__r.length : 0,
                durationFormatted: v.Duration__c ? Math.floor(v.Duration__c / 60) + ':' + String(v.Duration__c % 60).padStart(2, '0') : ''
            }));
            this.error = undefined;
        } else if (error) {
            this.error = error.body?.message || 'Erreur de chargement';
        }
    }

    get typeFilter() { return this.selectedType || null; }
    get statusFilter() { return this.selectedStatus || null; }
    get totalVideos() { return this.videos.length; }

    handleTypeChange(e) { this.selectedType = e.detail.value; }
    handleStatusChange(e) { this.selectedStatus = e.detail.value; }

    handleViewVideo(event) {
        const videoId = event.currentTarget.dataset.id;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: { recordId: videoId, objectApiName: 'FA_Video_Analysis__c', actionName: 'view' }
        });
    }
}
