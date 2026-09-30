import { LightningElement, wire, track } from 'lwc';
import getSessions from '@salesforce/apex/FA_TrainingController.getSessions';
import getAttendanceForSession from '@salesforce/apex/FA_TrainingController.getAttendanceForSession';
import getAttendanceStats from '@salesforce/apex/FA_TrainingController.getAttendanceStats';

export default class FaAttendance extends LightningElement {
    @track sessions = [];
    @track attendance = [];
    stats;
    selectedSession = '';
    isLoading = true;
    error;

    columns = [
        { label: 'N°', fieldName: 'jerseyNumber', type: 'number', initialWidth: 60 },
        { label: 'Joueur', fieldName: 'playerName', type: 'text' },
        { label: 'Position', fieldName: 'position', type: 'text' },
        { label: 'Statut', fieldName: 'Status__c', type: 'text' },
        { label: 'Notes', fieldName: 'Notes__c', type: 'text' }
    ];

    @wire(getAttendanceStats)
    wiredStats({ error, data }) {
        if (data) { this.stats = data; this.error = undefined; }
        else if (error) { this.error = error.body?.message || 'Erreur de chargement'; }
    }

    @wire(getSessions, { categoryId: null, startDate: null, endDate: null })
    wiredSessions({ error, data }) {
        this.isLoading = false;
        if (data) {
            this.sessions = data.map(s => ({
                label: s.Session_Date__c + ' - ' + (s.Category__r?.Short_Name__c || '') + ' - ' + s.Type__c,
                value: s.Id
            }));
            this.error = undefined;
        } else if (error) {
            this.error = error.body?.message || 'Erreur de chargement';
        }
    }

    @wire(getAttendanceForSession, { sessionId: '$sessionFilter' })
    wiredAttendance({ error, data }) {
        if (data) {
            this.attendance = data.map(a => ({
                ...a,
                playerName: a.Player__r?.First_Name__c + ' ' + a.Player__r?.Last_Name__c,
                jerseyNumber: a.Player__r?.Jersey_Number__c,
                position: a.Player__r?.Position__c
            }));
            this.error = undefined;
        } else if (error) {
            this.error = error.body?.message || 'Erreur de chargement';
        }
    }

    get sessionFilter() { return this.selectedSession || null; }
    get attendanceRate() { return this.stats?.attendanceRate || 0; }
    get totalPresent() { return this.stats?.presentCount || 0; }

    handleSessionChange(e) { this.selectedSession = e.detail.value; }
}
