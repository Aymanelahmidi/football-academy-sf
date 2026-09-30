import { LightningElement, wire } from 'lwc';
import getDashboardStats from '@salesforce/apex/FA_DashboardController.getDashboardStats';
import getRecentActivity from '@salesforce/apex/FA_DashboardController.getRecentActivity';
import getUpcomingEvents from '@salesforce/apex/FA_DashboardController.getUpcomingEvents';

export default class FaDashboard extends LightningElement {
    stats;
    recentActivity;
    upcomingEvents;
    error;
    isLoading = true;

    @wire(getDashboardStats)
    wiredStats({ error, data }) {
        this.isLoading = false;
        if (data) {
            this.stats = data;
            this.error = undefined;
        } else if (error) {
            this.error = error.body?.message || 'Erreur de chargement';
        }
    }

    @wire(getRecentActivity)
    wiredActivity({ error, data }) {
        if (data) {
            this.recentActivity = data;
            this.error = undefined;
        } else if (error) {
            this.error = error.body?.message || 'Erreur de chargement';
        }
    }

    @wire(getUpcomingEvents)
    wiredEvents({ error, data }) {
        if (data) {
            this.upcomingEvents = data;
            this.error = undefined;
        } else if (error) {
            this.error = error.body?.message || 'Erreur de chargement';
        }
    }

    get totalPlayers() {
        return this.stats?.playerStats?.totalPlayers || 0;
    }

    get totalCategories() {
        const cats = this.stats?.playerStats?.byCategory;
        return cats ? cats.length : 0;
    }

    get attendanceRate() {
        const rate = this.stats?.attendanceStats?.attendanceRate;
        return rate ? rate + '%' : '0%';
    }

    get totalPresent() {
        return this.stats?.attendanceStats?.presentCount || 0;
    }

    get activeInjuries() {
        return this.stats?.medicalStats?.activeInjuries || 0;
    }

    get injuriesInRehab() {
        const bySev = this.stats?.medicalStats?.injuriesBySeverity;
        return bySev ? Object.values(bySev).reduce((a, b) => a + b, 0) : 0;
    }

    get upcomingMatchCount() {
        return this.stats?.matchStats?.upcomingMatches || 0;
    }

    get matchRecord() {
        const ms = this.stats?.matchStats;
        if (!ms) return '0V 0N 0D';
        return `${ms.wins}V ${ms.draws}N ${ms.losses}D`;
    }

    get wins() { return this.stats?.matchStats?.wins || 0; }
    get draws() { return this.stats?.matchStats?.draws || 0; }
    get losses() { return this.stats?.matchStats?.losses || 0; }
    get goalsFor() { return this.stats?.matchStats?.goalsFor || 0; }
    get goalsAgainst() { return this.stats?.matchStats?.goalsAgainst || 0; }
    get matchesPlayed() { return this.stats?.matchStats?.totalPlayed || 0; }

    get playersByCategory() {
        return this.stats?.playerStats?.byCategory || [];
    }

    get recentMatches() {
        return this.recentActivity?.recentMatches || [];
    }

    get recentInjuries() {
        return this.recentActivity?.recentInjuries || [];
    }

    get balance() {
        const fs = this.stats?.financeStats;
        if (!fs) return '0 MAD';
        return (fs.totalRevenue - fs.totalExpenses).toLocaleString('fr-FR') + ' MAD';
    }

    get todayFormatted() {
        return new Date().toLocaleDateString('fr-FR', {
            weekday: 'long', year: 'numeric', month: 'long', day: 'numeric'
        });
    }
}
