# Football Academy SF — Roadmap & Guide d'Évolution

> **Date :** 30 septembre 2026
> **Org :** FA DEMO | API v66.0 | Architecture 5 couches
> **Tests :** 155 classes, 100% pass, 91% coverage

---

## Table des matières

1. [Vue d'ensemble du projet](#1-vue-densemble)
2. [Carte des modules et objets](#2-carte-des-modules)
3. [Architecture Apex — inventaire complet](#3-architecture-apex)
4. [Composants LWC — état et évolutions](#4-composants-lwc)
5. [Layouts par objet](#5-layouts)
6. [Status / Picklists / Chemins de statut](#6-statuts-et-chemins)
7. [KPIs par module](#7-kpis-par-module)
8. [Design & UX — recommandations](#8-design--ux)
9. [Cloud Salesforce — recommandation](#9-salesforce-cloud)
10. [Features suggérées (faible coût)](#10-features-suggérées)
11. [Bugs connus à corriger](#11-bugs-connus)
12. [Ordre de priorité](#12-priorités)

---

## 1. Vue d'ensemble

Football Academy SF est une application Salesforce complète pour la gestion d'une académie de football. Elle couvre 9 domaines métier :

| Module | Objet(s) principal(aux) | LWC | Statut actuel |
|--------|------------------------|-----|---------------|
| **Joueurs** | FA_Player__c | faPlayerList, faPlayerProfile, faTeamComposition | ✅ Fonctionnel |
| **Entraînements** | FA_Training_Session__c, FA_Attendance__c | faTrainingSessions, faAttendance | ✅ Fonctionnel |
| **Matchs** | FA_Match__c, FA_Match_Event__c | faMatchList | ✅ Fonctionnel |
| **Médical** | FA_Injury__c, FA_Medical_Record__c | faMedicalTracking | ⚠️ Bug filtre statut |
| **Performance** | FA_GPS_Data__c, FA_Fitness_Test__c, FA_Morphological_Measure__c | faGpsData, faPhysicalPrep | ✅ Fonctionnel |
| **Évaluations** | FA_Evaluation__c | faEvaluations | ✅ Fonctionnel |
| **Vidéo** | FA_Video_Analysis__c, FA_Video_Annotation__c | faVideoAnalysis | ⚠️ Annotations toujours 0 |
| **Finance** | FA_Transaction__c | faFinance | ⚠️ Bug valeurs type |
| **Documents** | FA_Document__c, FA_Contract__c | faDocuments | ✅ Fonctionnel |
| **Dashboard** | (agrégat) | faDashboard | ✅ Fonctionnel |
| **Calendrier** | (agrégat) | faCalendarView | ✅ Fonctionnel |
| **Paramètres** | FA_Academy_Setting__c | faSettings | ✅ Fonctionnel |

---

## 2. Carte des modules

### 2.1 Module Joueurs

```
FA_Category__c
  ├─ Name (text)
  ├─ Short_Name__c (U7, U9, U11... SEN)
  ├─ Age_Min__c / Age_Max__c
  ├─ Max_Players__c
  ├─ Color__c
  └─ Is_Active__c

FA_Player__c  ← Objet central
  ├─ First_Name__c / Last_Name__c → Name auto via trigger
  ├─ Date_of_Birth__c
  ├─ Nationality__c
  ├─ Position__c (Gardien / Défenseur / Milieu / Attaquant)
  ├─ Jersey_Number__c
  ├─ Category__c (→ FA_Category__c)
  ├─ Status__c [Active | Injured | Suspended | Inactive]
  ├─ Height__c / Weight__c
  ├─ Email__c / Phone__c
  └─ Photo_URL__c

FA_Legal_Guardian__c (tuteurs pour mineurs)
  ├─ First_Name__c / Last_Name__c → Name
  ├─ Phone__c / Email__c / Address__c
  ├─ Player__c (→ FA_Player__c)
  ├─ Is_Primary__c / Is_Primary_Contact__c
  └─ Is_Emergency_Contact__c

FA_Staff_Profile__c
  ├─ Display_Name__c
  ├─ Role__c (Coach / Médecin / Préparateur...)
  ├─ Category__c (→ FA_Category__c)
  └─ User__c (→ User standard Salesforce)
```

### 2.2 Module Entraînements

```
FA_Training_Session__c
  ├─ Session_Date__c
  ├─ Start_Time__c / End_Time__c
  ├─ Type__c (Technique / Physique / Tactique...)
  ├─ Location__c
  ├─ Category__c (→ FA_Category__c)
  ├─ Coach__c (→ FA_Staff_Profile__c)
  ├─ Status__c
  └─ Notes__c

FA_Attendance__c
  ├─ Name → "Presence A. Chaoui 2026-09-08"
  ├─ Player__c (→ FA_Player__c)
  ├─ Training_Session__c (→ FA_Training_Session__c)
  ├─ Match__c (→ FA_Match__c, optionnel)
  ├─ Attendance_Date__c
  ├─ Status__c [Present | Absent | Late | Excused | Injured]
  └─ Notes__c

FA_Session_Exercise__c
  ├─ Training_Session__c (→ FA_Training_Session__c)
  ├─ Exercise_Name__c
  ├─ Duration_Minutes__c
  ├─ Intensity__c
  └─ Description__c
```

### 2.3 Module Matchs & Compétitions

```
FA_Competition__c
  ├─ Type__c (Championnat / Coupe / Tournoi / Amical)
  ├─ Season__c (ex: 2026-2027)
  ├─ Category__c (→ FA_Category__c)
  ├─ Start_Date__c / End_Date__c
  └─ Is_Active__c

FA_Match__c
  ├─ Opponent__c
  ├─ Match_Date__c
  ├─ Location__c
  ├─ Category__c (→ FA_Category__c)
  ├─ Competition__c (→ FA_Competition__c)
  ├─ Status__c [Scheduled | In Progress | Completed | Cancelled | Postponed]
  ├─ Goals_For__c / Goals_Against__c
  └─ Notes__c

FA_Match_Event__c
  ├─ Name → "Goal - J1 SEN vs Raja #1"
  ├─ Match__c (→ FA_Match__c)
  ├─ Player__c (→ FA_Player__c)
  ├─ Event_Type__c (Goal / Yellow Card / Red Card / Substitution...)
  ├─ Minute__c
  └─ Description__c
```

### 2.4 Module Médical

```
FA_Medical_Record__c
  ├─ Name → "Dossier Adam Chaoui"
  ├─ Player__c (→ FA_Player__c)
  ├─ Blood_Type__c
  ├─ Allergies__c
  └─ Medical_Notes__c

FA_Injury__c
  ├─ Name → "Entorse cheville - Ferhat 2026-09-05"
  ├─ Player__c (→ FA_Player__c)
  ├─ Type__c (Entorse / Fracture / Muscle / Contusion...)
  ├─ Body_Part__c
  ├─ Severity__c (Minor / Moderate / Severe)
  ├─ Status__c [In Treatment | Rehabilitation | Recovered]
  ├─ Injury_Date__c
  ├─ Expected_Return_Date__c / Actual_Return_Date__c
  ├─ Doctor__c (→ FA_Staff_Profile__c)
  └─ Notes__c

FA_Medical_Access_Log__c
  ├─ Player__c (→ FA_Player__c)
  ├─ Accessed_By__c (→ User)
  ├─ Access_Date__c
  └─ Reason__c
```

### 2.5 Module Performance GPS & Physique

```
FA_GPS_Data__c  ← Données wearables
  ├─ Name → "GPS A. Zerrouk 2026-09-14"
  ├─ Player__c (→ FA_Player__c)
  ├─ Training_Session__c / Match__c
  ├─ Record_Date__c
  ├─ Context__c (Training / Match)
  ├─ Total_Distance_Km__c
  ├─ Avg_Speed_Kmh__c / Max_Speed_Kmh__c
  ├─ High_Intensity_Distance__c
  ├─ Sprint_Count__c
  ├─ Avg_Heart_Rate__c / Max_Heart_Rate__c
  ├─ Calories_Burned__c
  ├─ Zone1_Minutes__c...Zone5_Minutes__c (zones FC)
  ├─ Acute_Load__c / Chronic_Load__c / ACWR_Ratio__c
  └─ Preparateur__c (→ FA_Staff_Profile__c)

FA_Fitness_Test__c
  ├─ Name → "VAMEVAL Mansouri 2026-09-10"
  ├─ Player__c (→ FA_Player__c)
  ├─ Test_Type__c (VAMEVAL / Cooper / VO2max / Détente...)
  ├─ Test_Date__c
  ├─ Result__c / Unit__c
  ├─ Percentile__c
  ├─ Evaluator__c (→ FA_Staff_Profile__c)
  └─ Notes__c

FA_Morphological_Measure__c
  ├─ Player__c (→ FA_Player__c)
  ├─ Measure_Date__c
  ├─ Height_Cm__c / Weight_Kg__c
  ├─ BMI__c
  ├─ Fat_Percentage__c
  └─ Muscle_Mass__c

FA_Physical_Program__c
  ├─ Category__c (→ FA_Category__c)
  ├─ Staff__c (→ FA_Staff_Profile__c)
  ├─ Start_Date__c / End_Date__c
  ├─ Type__c (Pré-saison / En-saison / Récupération...)
  └─ Description__c
```

### 2.6 Module Évaluations Sportives

```
FA_Evaluation__c
  ├─ Name → "Eval S. Mansouri 2026-09-15"
  ├─ Player__c (→ FA_Player__c)
  ├─ Evaluator__c (→ FA_Staff_Profile__c)
  ├─ Evaluation_Date__c
  ├─ Type__c (Mensuelle / Trimestrielle / Annuelle...)
  ├─ Technical_Score__c (1-10)
  ├─ Physical_Score__c (1-10)
  ├─ Tactical_Score__c (1-10)
  ├─ Mental_Score__c (1-10)
  ├─ Speed_Score__c (1-10)
  ├─ Endurance_Score__c (1-10)
  ├─ Overall_Score__c (calculé)
  ├─ Strengths__c / Weaknesses__c
  └─ Recommendations__c
```

### 2.7 Module Vidéo

```
FA_Video_Analysis__c
  ├─ Match__c (→ FA_Match__c)
  ├─ Analyst__c (→ FA_Staff_Profile__c)
  ├─ Video_URL__c
  ├─ Analysis_Date__c
  ├─ Type__c (Match / Training / Opponent...)
  └─ Notes__c

FA_Video_Annotation__c
  ├─ Name
  ├─ Video_Analysis__c (→ FA_Video_Analysis__c)
  ├─ Player__c (→ FA_Player__c)
  ├─ Type__c (Positif / Négatif / Tactique...)
  ├─ Label__c
  ├─ Timestamp__c / End_Timestamp__c (secondes)
  └─ Description__c
```

### 2.8 Module Finance

```
FA_Transaction__c
  ├─ Name → "Cotisation 4200 MAD 2026-09-05"
  ├─ Type__c [Revenue | Expense]
  ├─ Category__c (Cotisation / Salaire / Équipement / Transport...)
  ├─ Amount__c
  ├─ Transaction_Date__c
  ├─ Player__c (→ FA_Player__c, optionnel)
  └─ Notes__c
```

### 2.9 Module Documents & Contrats

```
FA_Contract__c
  ├─ Name → "Contrat Adam Chaoui 2026-2027"
  ├─ Player__c (→ FA_Player__c)
  ├─ Type__c (Formation / Pro / Prêt...)
  ├─ Start_Date__c / End_Date__c
  ├─ Monthly_Fee__c
  ├─ Status__c [Active | Expired | Terminated]
  └─ Notes__c

FA_Document__c
  ├─ Player__c (→ FA_Player__c)
  ├─ Type__c (Licence / Passeport / Certificat médical / Photo...)
  ├─ File_URL__c / File_Size__c
  ├─ Expiry_Date__c
  ├─ Status__c [Valide | Expired | En Attente]
  └─ Notes__c

FA_Academy_Setting__c (configuration)
  ├─ Setting_Key__c
  ├─ Setting_Value__c
  └─ Value__c
```

---

## 3. Architecture Apex

### 3.1 Structure 5 couches par domaine

| Domaine | [EM] Selector | [DM] Domain | [SM] Service | [TH] Handler | [LC] Controller |
|---------|--------------|-------------|--------------|--------------|-----------------|
| **Player** | FA_PlayerSelector | FA_PlayerDomain | FA_PlayerService | FA_PlayerTriggerHandler | FA_PlayerController |
| **Training** | FA_TrainingSelector | FA_TrainingDomain | FA_TrainingService | FA_TrainingTriggerHandler | FA_TrainingController |
| **Match** | FA_MatchSelector | FA_MatchDomain | FA_MatchService | FA_MatchTriggerHandler | FA_MatchController |
| **Medical** | FA_MedicalSelector | FA_MedicalDomain | FA_MedicalService | FA_InjuryTriggerHandler | FA_MedicalController |
| **Evaluation** | FA_EvaluationSelector | FA_EvaluationDomain | FA_EvaluationService | FA_EvaluationTriggerHandler | FA_EvaluationController |
| **Performance** | FA_PerformanceSelector | FA_PerformanceDomain | FA_PerformanceService | FA_PerformanceTriggerHandler | FA_PerformanceController |
| **Video** | FA_VideoSelector | FA_VideoDomain | FA_VideoService | FA_VideoTriggerHandler | FA_VideoController |
| **Dashboard** | FA_DashboardSelector | — | — | — | FA_DashboardController |

### 3.2 Classes d'intégration

| Classe | Rôle |
|--------|------|
| `FA_GpsIntegration` | Import GPS (Catapult, STATSports, CSV) |
| `FA_GpsRestApi` | Endpoint REST entrant pour GPS (@RestResource) |
| `FA_VideoIntegration` | Import vidéo (Hudl, Wyscout), Schedulable |
| `FA_ExternalIntegration` | Comptabilité Sage, licences FRMF, fédération |
| `FA_IntegrationSelector` | SOQL pour intégrations |
| `FA_MockHttpCallout` | Mock HTTP pour tests |
| `FA_TestDataFactory` | Factory de données de test |
| `FA_ServiceTest` | Tests callouts HTTP mockés |

### 3.3 Nombre de classes par type

- Selectors : 8 classes
- Domains : 7 classes
- Services : 7 classes
- TriggerHandlers : 7 classes
- Controllers : 8 classes
- Intégrations : 4 classes
- Tests : ~35 classes
- Utilitaires : 3 classes

---

## 4. Composants LWC

### 4.1 Inventaire complet

| Composant | Module | Apex appelé | Fonctionnalités |
|-----------|--------|-------------|----------------|
| `faDashboard` | Dashboard | FA_DashboardController (3 méthodes) | Stats globales, matchs récents, blessures récentes, balance financière |
| `faPlayerList` | Joueurs | FA_PlayerController (getPlayers, getCategories, deactivatePlayer) | Tableau filtrable, navigation, désactivation |
| `faPlayerProfile` | Joueurs | FA_PlayerController + FA_MedicalController + FA_PerformanceController | Profil 360° avec onglets (info, évals, blessures, GPS, morpho) |
| `faTeamComposition` | Joueurs | FA_PlayerController.getPlayersWithInjuryStatus | Composition 4-4-2 / 4-3-3 par position |
| `faTrainingSessions` | Entraînements | FA_TrainingController (getSessions, getCategories) | Liste des séances par catégorie, navigation |
| `faAttendance` | Entraînements | FA_TrainingController (getAttendanceForSession, upsertAttendance) | Saisie présences par séance |
| `faMatchList` | Matchs | FA_MatchController (getMatches, getCategories) | Liste matchs avec score, résultat, filtres |
| `faMedicalTracking` | Médical | FA_MedicalController (getInjuries, getMedicalStats) | Suivi blessures actives par statut |
| `faEvaluations` | Évaluations | FA_MedicalController (getEvaluations) | Liste évaluations avec scores |
| `faGpsData` | Performance | FA_PerformanceController (getGpsData, getPlayerGpsAverages) | Données GPS, moyennes joueur |
| `faPhysicalPrep` | Performance | FA_PerformanceController (getPhysicalPrograms, getFitnessTests) | Programmes physiques + tests |
| `faVideoAnalysis` | Vidéo | FA_VideoController (getVideoAnalyses, addAnnotation) | Analyses vidéo + annotations |
| `faFinance` | Finance | FA_MedicalController (getTransactions, getFinanceStats) | Tableau transactions, balance |
| `faDocuments` | Documents | FA_MedicalController (getDocuments) | Liste documents avec statut expiration |
| `faCalendarView` | Calendrier | FA_TrainingController + FA_MatchController | Vue calendrier séances + matchs |
| `faSettings` | Paramètres | (Academy Settings) | Configuration académie |

### 4.2 Bugs critiques identifiés

| # | Composant | Fichier | Problème | Correction |
|---|-----------|---------|---------|------------|
| 1 | faTeamComposition | faTeamComposition.js | Getter `p.position` → doit être `p.Position__c` | Renommer le champ |
| 2 | faMedicalTracking | faMedicalTracking.js | Filtre statut en français vs valeurs API anglaises | Aligner avec `In Treatment`, `Rehabilitation`, `Recovered` |
| 3 | faPlayerList | faPlayerList.js | Status options `'Actif'`, `'Blessé'` vs valeurs API `'Active'`, `'Injured'` | Aligner avec les vraies valeurs picklist |
| 4 | faFinance | faFinance.js | typeOptions `'Revenu'`/`'Dépense'` vs valeurs API `'Revenue'`/`'Expense'` | Aligner avec field-meta.xml |
| 5 | faVideoAnalysis | JS + FA_VideoSelector | Annotations count toujours 0 — sous-requête manquante dans selector | Ajouter `(SELECT Id FROM FA_Video_Annotation__c) Annotations__r` |

### 4.3 Évolutions suggérées par composant

**faDashboard :**
- Ajouter un graphique en courbes (taux de présence sur 12 semaines)
- Ajouter alertes : documents expirés, contrats qui se terminent dans 30 jours
- Ajouter top 5 joueurs par note d'évaluation

**faPlayerList :**
- Ajouter export CSV (lightning-button + Apex)
- Ajouter badge coloré pour le statut (au lieu de texte brut)
- Ajouter filtre par position

**faPlayerProfile :**
- Onglet "Contrats" déjà wired mais non affiché dans le HTML → à activer
- Ajouter graphique radar pour les scores d'évaluation
- Afficher alerte si blessure active en cours

**faTrainingSessions :**
- Ajouter bouton "Dupliquer séance"
- Ajouter indicateur de taux de présence par séance

**faMatchList :**
- Ajouter indicateur victoire/défaite coloré (vert/rouge/gris)
- Ajouter navigation vers les événements match

**faMedicalTracking :**
- Après correction bug statut : ajouter timeline de récupération
- Ajouter alerte retour prévu cette semaine

**faGpsData :**
- Ajouter graphique linéaire distance/semaine
- Alerter si ACWR_Ratio > 1.5 (risque blessure)

**faVideoAnalysis :**
- Après correction bug annotations : afficher compteur par analyse

---

## 5. Layouts

### 5.1 Layouts existants (24 objets)

| Objet | Layout | Recommandation |
|-------|--------|----------------|
| FA_Player__c | FA Player Layout | ✅ Bon — ajouter section "Contrats actifs" |
| FA_Category__c | FA Category Layout | ✅ Simple et suffisant |
| FA_Competition__c | FA Competition Layout | ✅ OK |
| FA_Training_Session__c | FA Training Session Layout | Ajouter related list FA_Attendance__c |
| FA_Match__c | FA Match Layout | Ajouter related list FA_Match_Event__c |
| FA_Attendance__c | FA Attendance Layout | ✅ Simple |
| FA_Evaluation__c | FA Evaluation Layout | Ajouter section scores visuels |
| FA_GPS_Data__c | FA GPS Data Layout | Ajouter section zones FC en groupe |
| FA_Injury__c | FA Injury Layout | ✅ Complet avec dates retour |
| FA_Medical_Record__c | FA Medical Record Layout | Ajouter related list FA_Injury__c |
| FA_Fitness_Test__c | FA Fitness Test Layout | ✅ OK |
| FA_Morphological_Measure__c | FA Morphological Measure Layout | ✅ OK |
| FA_Contract__c | FA Contract Layout | Ajouter section financière |
| FA_Document__c | FA Document Layout | Ajouter date expiration en haut |
| FA_Transaction__c | FA Transaction Layout | ✅ OK |
| FA_Video_Analysis__c | FA Video Analysis Layout | Ajouter related list annotations |
| FA_Video_Annotation__c | FA Video Annotation Layout | ✅ OK |
| FA_Staff_Profile__c | FA Staff Profile Layout | ✅ OK |
| FA_Legal_Guardian__c | FA Legal Guardian Layout | ✅ OK |
| FA_Match_Event__c | FA Match Event Layout | ✅ OK |
| FA_Medical_Access_Log__c | FA Medical Access Log Layout | ✅ Audit only |
| FA_Physical_Program__c | FA Physical Program Layout | ✅ OK |
| FA_Session_Exercise__c | FA Session Exercise Layout | ✅ OK |
| FA_Academy_Setting__c | FA Academy Setting Layout | ✅ Config only |

### 5.2 Flexipage

- **FA_Dashboard_Page** — Page App Builder avec le composant `faDashboard`

### 5.3 Layouts manquants (à créer)

Actuellement pas de layouts dédiés pour les objets suivants qui apparaissent seulement en related list :
- `FA_Legal_Guardian__c` → layout basique existant, suffisant

---

## 6. Statuts et Chemins

### 6.1 Objets avec Path Salesforce recommandé

Un **Path** (chemin visuel) est utile pour les objets avec un cycle de vie séquentiel clair.

#### FA_Player__c — Status__c
```
Active → Injured → Active (guérison)
Active → Suspended → Active (levée suspension)
Active → Inactive
```
Valeurs API : `Active` | `Injured` | `Suspended` | `Inactive`
**→ Path recommandé ✅** (progression logique du joueur)

#### FA_Injury__c — Status__c
```
In Treatment → Rehabilitation → Recovered
```
Valeurs API : `In Treatment` | `Rehabilitation` | `Recovered`
**→ Path fortement recommandé ✅** (parcours médical séquentiel)

#### FA_Match__c — Status__c
```
Scheduled → In Progress → Completed
              ↓
           Postponed → Scheduled
           Cancelled
```
Valeurs API : `Scheduled` | `In Progress` | `Completed` | `Cancelled` | `Postponed`
**→ Path recommandé ✅**

#### FA_Contract__c — Status__c
```
Active → Expired (auto à la date de fin)
Active → Terminated
```
Valeurs API : `Active` | `Expired` | `Terminated`
**→ Path utile ✅**

#### FA_Document__c — Status__c
```
En Attente → Valide → Expired
```
Valeurs API : `Valide` | `Expired` | `En Attente`
**→ Path utile ✅** (à réordonner : En Attente → Valide → Expired)

#### FA_Attendance__c — Status__c
Pas de chemin séquentiel — c'est un choix unique.
Valeurs API : `Present` | `Absent` | `Late` | `Excused` | `Injured`
**→ Pas de Path, picklist suffisante**

#### FA_Transaction__c — Type__c
Valeurs API : `Revenue` | `Expense` — choix binaire, pas de path.

### 6.2 Création des Paths (comment faire)

Dans Setup → Path Settings → New Path :
1. Objet : FA_Injury__c
2. Champ Picklist : Status__c
3. Étapes : In Treatment → Rehabilitation → Recovered
4. Ajouter des Key Fields et Guidance par étape (ex: "Expected_Return_Date__c" sur Rehabilitation)

---

## 7. KPIs par module

### 7.1 Dashboard principal — KPIs actuels

| KPI | Source | Valeur affichée |
|-----|--------|-----------------|
| Total joueurs | FA_PlayerController.getDashboardStats | Count FA_Player__c actifs |
| Taux présence | FA_DashboardController | Present/(Present+Absent) % |
| Blessures actives | FA_MedicalService | Count In Treatment + Rehabilitation |
| Bilan matchs | FA_MatchService | V/N/D + buts |
| Balance financière | FA_EvaluationService | Revenue - Expense (MAD) |

### 7.2 KPIs à ajouter par module

**Module Joueurs**
- Nombre de joueurs par catégorie (barres colorées)
- Âge moyen par catégorie
- % joueurs avec document expiré
- Top 3 postes les plus représentés

**Module Entraînements**
- Taux de présence moyen (objectif : >85%)
- Nombre de séances ce mois
- Joueurs en retard fréquent (>2 fois)
- Heures d'entraînement par catégorie

**Module Matchs**
- % victoires sur les 10 derniers matchs
- Buts marqués vs encaissés (par catégorie)
- Série en cours (3V consécutives, etc.)
- Joueur le plus décisif (goals + assists)

**Module Médical**
- Temps moyen de récupération (jours)
- Blessures par zone corporelle (treemap)
- ACWR moyen de l'équipe (alerte si >1.5)
- Ratio blessures / 1000h d'entraînement

**Module Performance GPS**
- Distance moyenne par session (objectif : 8-10 km)
- Vitesse max moyenne
- Joueurs à risque surmenage (ACWR > 1.5)
- Progression mensuelle (Δ distance)

**Module Finance**
- Revenu total vs dépenses ce mois (gauge)
- Top 3 catégories de dépenses
- % cotisations payées / attendues
- Prévision clôture d'exercice

**Module Évaluations**
- Score moyen global (radar 6 axes)
- Progression vs dernière évaluation (%)
- Top 5 joueurs par score global
- Joueurs en dessous de 5/10 (alerte)

---

## 8. Design & UX

### 8.1 Principes généraux recommandés

**Couleurs (SLDS)**
```
Actif / Succès    → slds-text-color_success  (#2e7d32)
Blessé / Erreur   → slds-text-color_error    (#c62828)
En attente        → slds-text-color_weak     (#706e6b)
Info              → slds-text-color_default  (#032d60)
Alerte            → slds-badge / warning     (#f59e0b)
```

**Badges de statut** (à ajouter dans faPlayerList, faMatchList)
```html
<lightning-badge label={record.Status__c}
    class={statusBadgeClass}>
</lightning-badge>
```
Plutôt que du texte brut dans les colonnes de datatable.

**Loading states** — Tous les composants ont `isLoading` mais peu affichent un spinner cohérent. Pattern recommandé :
```html
<template if:true={isLoading}>
    <lightning-spinner alternative-text="Chargement..." size="medium">
    </lightning-spinner>
</template>
```

**Error states** — Ajouter un composant d'erreur réutilisable plutôt que du texte brut :
```html
<template if:true={error}>
    <div class="slds-notify slds-notify_alert slds-theme_error">
        <span>{error}</span>
    </div>
</template>
```

### 8.2 Améliorations UX par module

| Module | Amélioration | Complexité |
|--------|-------------|-----------|
| Joueurs | Photo du joueur dans le profil (Salesforce Files / ContentVersion) | Moyenne |
| Joueurs | Carte joueur style "Football card" dans faPlayerProfile | Faible |
| Matchs | Badge coloré Victoire (vert) / Défaite (rouge) / Nul (gris) | Très faible |
| Médical | Timeline horizontale de blessure (dates clés) | Faible |
| GPS | Graphique courbe distance/vitesse sur 4 semaines | Moyenne (lightning-chart ou Chart.js) |
| Évaluations | Graphique radar 6 axes (technique, physique, tactique, mental, vitesse, endurance) | Moyenne |
| Finance | Graphique donut revenus vs dépenses | Faible |
| Calendrier | Améliorer la vue mensuelle avec couleurs par type d'événement | Faible |
| Dashboard | Cards avec icône + tendance (↑↓) vs période précédente | Faible |

### 8.3 Responsive & Accessibilité

- Tous les composants doivent utiliser `slds-grid` + `slds-wrap` pour le responsive
- Les formulaires doivent avoir des labels explicites (`<label>`)
- Les actions destructives (désactiver joueur) doivent avoir une confirmation (`lightning-confirm`)
- Les toast notifications sont déjà bien implémentées via `ShowToastEvent`

### 8.4 Quick Wins Design (< 1h chacun)

1. Ajouter `slds-page-header` à tous les composants (titre + breadcrumb)
2. Utiliser `lightning-badge` pour les statuts avec couleurs
3. Ajouter un compteur total dans l'en-tête de chaque liste (`{totalPlayers} joueurs`)
4. Ajouter icône `utility:warning` sur les documents expirés
5. Highlighter en rouge les lignes Attendance avec status `Absent` (via cellAttributes)

---

## 9. Salesforce Cloud

### 9.1 Situation actuelle

L'application utilise la **Salesforce Platform** (Developer Edition / Scratch Org) sans activation de clouds spécifiques. Elle est basée sur des custom objects FA_* sans utiliser les objets standard (Account, Contact, Opportunity, Case...).

### 9.2 Recommandation : Platform Edition

**Vous n'avez PAS besoin de Sales Cloud ni Service Cloud.**

Raisons :
- Pas de processus de vente (pas d'Opportunity, Pipeline, Forecast)
- Pas de service client ticketing (pas de Cases, Entitlements)
- Les joueurs sont des custom objects, pas des Contacts/Accounts
- L'architecture custom est plus adaptée au domaine sportif

**Ce qu'il faut :** `Salesforce Platform` (ou `Enterprise Edition` pour les fonctionnalités avancées)

### 9.3 Fonctionnalités natives Salesforce à activer

| Fonctionnalité | Utilité | Coût |
|----------------|---------|------|
| **Salesforce Files** | Stocker photos joueurs, documents PDF | Inclus Platform |
| **Chatter** | Communication interne staff/coaches | Inclus |
| **Path (Chemins)** | Visualisation cycle de vie (blessures, matchs) | Inclus |
| **Approval Processes** | Validation contrats ou transferts | Inclus Enterprise |
| **Flows (Screen Flows)** | Saisie guidée des présences, création joueur | Inclus |
| **Reports & Dashboards** | Tableaux de bord natifs Salesforce | Inclus |
| **Einstein Analytics (CRM Analytics)** | Dashboards avancés avec prédictions | Licence supplémentaire |
| **Scheduled Flows** | Expiration auto des contrats/documents | Inclus |
| **Email Alerts** | Notifications coach si ACWR > 1.5 | Inclus |

### 9.4 Ce qu'il faut ÉVITER

- Ne pas activer **Experience Cloud** (portail joueurs) sans besoin réel — coûteux
- Ne pas activer **Marketing Cloud** — hors scope académie de foot
- Ne pas migrer vers des objets standard (Account = Joueur) — l'architecture FA_* est bien conçue

---

## 10. Features Suggérées

### 10.1 Catégorie A — Très faible coût (1-3 jours)

**A1 — Path sur FA_Injury__c**
- Activer le Path visuel In Treatment → Rehabilitation → Recovered
- Ajouter Guidance text par étape (ex: "Vérifier avec le médecin avant de passer en Récupération")
- Impact : UX médecin/staff nettement améliorée

**A2 — Scheduled Flow : expiration contrats/documents**
- Flow planifié quotidien : si `End_Date__c < TODAY()` → passer Status à `Expired`
- Impact : données toujours à jour sans intervention manuelle

**A3 — Report & Dashboard Salesforce natif**
- 5 rapports standards : Joueurs par catégorie, Blessures actives, Présences par séance, Transactions ce mois, Matchs par résultat
- Dashboard Salesforce (en complément du LWC faDashboard)
- Impact : directeurs/responsables peuvent voir les données sans besoin de l'app custom

**A4 — Email Alert : ACWR > 1.5**
- Flow ou Process Builder : si ACWR_Ratio__c > 1.5 → envoyer email au préparateur physique
- Impact : prévention blessures, valeur ajoutée immédiate

**A5 — Quick Action "Nouveau joueur" sur FA_Category__c**
- Depuis la page d'une catégorie, bouton "Ajouter Joueur" prérempli avec la catégorie
- Impact : saisie plus rapide, moins d'erreurs

### 10.2 Catégorie B — Faible coût (3-7 jours)

**B1 — Screen Flow "Prise de présences guidée"**
- Flow écran : choisir séance → afficher liste joueurs → cocher présent/absent → sauvegarder
- Remplace le LWC faAttendance complexe par un flow simple
- Impact : usage mobile, accessible aux coaches non techniques

**B2 — faPlayerProfile : onglet "Contrats & Documents"**
- Activer l'affichage des contrats et documents dans le profil joueur (données déjà wired)
- Impact : vue 360° complète du joueur depuis une seule page

**B3 — Composant LWC "faPlayerCard"**
- Mini-carte joueur réutilisable (photo, nom, catégorie, statut, position)
- Utilisé dans faTeamComposition et faPlayerProfile
- Impact : cohérence visuelle + réutilisabilité

**B4 — Alerte contrats expirant dans 30 jours**
- Dans faDashboard : ajouter une section "Alertes" qui liste les contrats/documents à renouveler
- Apex : query `WHERE End_Date__c <= NEXT_N_DAYS:30 AND Status__c = 'Active'`
- Impact : gestion proactive, évite les oublis de renouvellement

**B5 — Export CSV joueurs**
- Dans faPlayerList : bouton "Exporter" → génère un CSV des joueurs filtrés
- Apex : méthode `@AuraEnabled` retournant une String CSV encodée en base64
- Impact : besoin fréquent pour les rapports fédération

### 10.3 Catégorie C — Coût moyen (1-2 semaines)

**C1 — Graphiques dans faEvaluations et faGpsData**
- Utiliser `lightning-chart` (natif SLDS) ou intégrer Chart.js via static resource
- Radar chart pour évaluations (6 axes)
- Courbe linéaire pour GPS (distance/vitesse sur 30 jours)
- Impact : visualisation puissante, démo impressionnante

**C2 — Module Calendrier amélioré (faCalendarView)**
- Vue mensuelle avec événements colorés par type (séance = bleu, match = vert, blessure = rouge)
- Click sur événement → détail en modal
- Impact : planning staff / direction

**C3 — Gestion des transferts (nouveau module)**
- Objet FA_Transfer__c : joueur, date, club départ/arrivée, type (prêt/transfert/libre)
- Status path : En négociation → Approuvé → Finalisé
- Impact : traçabilité des mouvements de joueurs

**C4 — Module Nutrition (nouveau)**
- FA_Nutrition_Plan__c (lié à FA_Player__c)
- Champs : calories/jour, protéines, glucides, lipides, régime spécial
- Impact : complète le volet performance physique

**C5 — Notifications push (Salesforce Custom Notifications)**
- Notification si ACWR > 1.5, blessure critique, document expiré
- Via `CustomNotificationType` + Apex `Messaging.CustomNotification`
- Impact : alertes temps réel sur mobile Salesforce

### 10.4 Catégorie D — Hors scope (trop coûteux / hors périmètre)

- ❌ Portail joueurs/parents (Experience Cloud — licence supplémentaire)
- ❌ Intégration temps réel GPS live (nécessite streaming)
- ❌ Application mobile dédiée (hors Salesforce Mobile)
- ❌ Module de recrutement complet (trop large)

---

## 11. Bugs Connus

### Bugs Apex

| # | Classe | Description | Priorité |
|---|--------|-------------|----------|
| B1 | FA_VideoSelector | `getVideoAnalyses` ne retourne pas `Annotations__r` → annotations count = 0 | Haute |
| B2 | FA_PlayerService | `getPlayersWithInjuryStatus` retourne `Position__c`, pas `position` | Haute |

### Bugs LWC

| # | Composant | Description | Priorité |
|---|-----------|-------------|----------|
| L1 | faTeamComposition.js | `p.position` → doit être `p.Position__c` (groupes position toujours vides) | Critique |
| L2 | faMedicalTracking.js | statusOptions en français vs valeurs API anglaises | Critique |
| L3 | faPlayerList.js | statusOptions `'Actif'`/`'Blessé'` vs valeurs API `'Active'`/`'Injured'` | Haute |
| L4 | faFinance.js | typeOptions `'Revenu'`/`'Dépense'` vs valeurs API `'Revenue'`/`'Expense'` | Haute |
| L5 | faMatchList.js | statusOptions en français vs valeurs API anglaises (Scheduled/Completed) | Haute |

### Données

| # | Description | Résolution |
|---|-------------|-----------|
| D1 | Scripts demo 04-10 ne définissent pas le champ Name → IDs affichés | ✅ Corrigé par fix_names.apex |
| D2 | Scripts demo devront être mis à jour pour les futurs rechargements | À faire |

---

## 12. Priorités

### Phase 1 — Corrections immédiates (sprint 1)

- [ ] Corriger L1 (faTeamComposition : `Position__c`)
- [ ] Corriger L2 (faMedicalTracking : valeurs statut)
- [ ] Corriger L3 (faPlayerList : valeurs statut)
- [ ] Corriger L4 (faFinance : valeurs type)
- [ ] Corriger L5 (faMatchList : valeurs statut)
- [ ] Corriger B1 (FA_VideoSelector : ajouter Annotations__r)
- [ ] Mettre à jour les scripts demo pour inclure le champ Name

### Phase 2 — UX & Paths (sprint 2)

- [ ] Créer Path sur FA_Injury__c (In Treatment → Rehabilitation → Recovered)
- [ ] Créer Path sur FA_Match__c (Scheduled → In Progress → Completed)
- [ ] Créer Path sur FA_Contract__c
- [ ] Ajouter Related Lists manquantes dans les layouts
- [ ] Ajouter badges colorés pour les statuts (faPlayerList, faMatchList)
- [ ] Scheduled Flow pour expiration auto contrats/documents

### Phase 3 — Features à valeur ajoutée (sprint 3)

- [ ] Feature A4 : Email Alert ACWR > 1.5
- [ ] Feature B2 : onglet Contrats & Documents dans faPlayerProfile
- [ ] Feature B4 : Section alertes dans faDashboard
- [ ] Feature B5 : Export CSV joueurs
- [ ] 5 Reports & Dashboard Salesforce natifs

### Phase 4 — Graphiques et modules avancés (sprint 4+)

- [ ] Feature C1 : Graphiques évaluations + GPS
- [ ] Feature C2 : Calendrier amélioré
- [ ] Feature C3 : Module Transferts
- [ ] Feature C5 : Notifications push

---

*Ce document est maintenu dans le dépôt Football Academy SF. Dernière mise à jour : 30 septembre 2026.*
