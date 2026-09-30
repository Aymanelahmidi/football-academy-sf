import { LightningElement, wire, track } from 'lwc';
import getSessions from '@salesforce/apex/FA_TrainingController.getSessions';
import getMatches from '@salesforce/apex/FA_MatchController.getMatches';

export default class FaCalendarView extends LightningElement {
    @track events = [];
    isLoading = true;
    error;

    @wire(getSessions, { categoryId: null, startDate: null, endDate: null })
    wiredSessions({ error, data }) {
        this.isLoading = false;
        if (data) {
            const sessionEvents = data.map(s => ({
                id: s.Id,
                title: s.Type__c + ' - ' + (s.Category__r?.Short_Name__c || ''),
                date: s.Session_Date__c,
                time: s.Start_Time__c,
                type: 'training',
                location: s.Location__c,
                status: s.Status__c
            }));
            this.events = [...this.events.filter(e => e.type !== 'training'), ...sessionEvents];
            this.error = undefined;
        } else if (error) {
            this.error = error.body?.message || 'Erreur de chargement';
        }
    }

    @wire(getMatches, { categoryId: null, status: null, startDate: null, endDate: null })
    wiredMatches({ error, data }) {
        if (data) {
            const matchEvents = data.map(m => ({
                id: m.Id,
                title: (m.Is_Home__c ? 'vs ' : '@ ') + m.Opponent__c + ' (' + (m.Category__r?.Short_Name__c || '') + ')',
                date: m.Match_Date__c,
                time: m.Kickoff_Time__c,
                type: 'match',
                location: m.Location__c,
                status: m.Status__c,
                score: m.Status__c === 'Terminé' ? m.Goals_For__c + '-' + m.Goals_Against__c : ''
            }));
            this.events = [...this.events.filter(e => e.type !== 'match'), ...matchEvents];
            this.error = undefined;
        } else if (error) {
            this.error = error.body?.message || 'Erreur de chargement';
        }
    }

    get sortedEvents() {
        return [...this.events].sort((a, b) => new Date(b.date) - new Date(a.date));
    }

    get totalEvents() { return this.events.length; }
}
