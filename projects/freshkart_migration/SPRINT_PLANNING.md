# 📋 Organisation Agile - Migration FreshKart

## 🎯 Vue d'ensemble du projet

**Durée** : 3 jours (24h productives)
**Équipe** : 1 Data Engineer
**Méthodologie** : Agile Scrum (sprints courts)
**Objectif** : Migration Pandas → PySpark avec garantie d'équivalence

---

## 📅 Planification des Sprints

### **SPRINT 1 : Découverte & Fondations** (Jour 1 - 8h)

#### 🎯 Objectifs du Sprint
- Comprendre le dataset FreshKart
- Mettre en place l'environnement de développement
- Implémenter le pipeline Pandas (référence)
- Créer la structure projet avec tests

#### 📋 Backlog Sprint 1

| ID | Tâche | Statut | Temps | Priorité |
|----|-------|--------|-------|----------|
| S1-1 | Analyser dataset FreshKart (CSV + JSON) | ✅ DONE | 1h | P0 |
| S1-2 | Setup Docker (Ubuntu + Python + PySpark) | ✅ DONE | 2h | P0 |
| S1-3 | Installer Jupyter Lab + VS Code (code-server) | ✅ DONE | 1h | P0 |
| S1-4 | Implémenter FreshKartPandasPipeline complet | ✅ DONE | 3h | P0 |
| S1-5 | Créer structure projet (src/pandas, src/pyspark, tests) | ✅ DONE | 0.5h | P0 |
| S1-6 | Setup requirements.txt avec dépendances | ✅ DONE | 0.5h | P0 |

#### ✅ Résultats Sprint 1
- [x] Dataset analysé : 802 clients, 31 fichiers JSON commandes, 1,124 refunds
- [x] Docker fonctionnel : Ubuntu 22.04 + Python 3.10 + PySpark 3.5.0
- [x] Pipeline Pandas : 287 lignes, 9 méthodes, pipeline complet
- [x] Jupyter accessible : http://localhost:8888
- [x] VS Code accessible : http://localhost:8080

---

### **SPRINT 2 : Migration PySpark** (Jour 2 - 8h)

#### 🎯 Objectifs du Sprint
- Migrer le pipeline Pandas vers PySpark
- Garantir l'équivalence stricte des résultats
- Créer tests unitaires complets
- Corriger erreurs notebooks

#### 📋 Backlog Sprint 2

| ID | Tâche | Statut | Temps | Priorité |
|----|-------|--------|-------|----------|
| S2-1 | Migrer load_data() vers PySpark | ✅ DONE | 1h | P0 |
| S2-2 | Migrer filter_paid_orders() vers PySpark | ✅ DONE | 0.5h | P0 |
| S2-3 | Migrer explode_items() vers PySpark | ✅ DONE | 1h | P0 |
| S2-4 | Migrer calculate_revenue() vers PySpark | ✅ DONE | 1h | P0 |
| S2-5 | Migrer join_with_customers() vers PySpark | ✅ DONE | 0.5h | P0 |
| S2-6 | Migrer add_refunds() vers PySpark | ✅ DONE | 1h | P0 |
| S2-7 | Migrer aggregate_daily_stats() vers PySpark | ✅ DONE | 1h | P0 |
| S2-8 | Créer test_migration.py (tests équivalence) | ✅ DONE | 1.5h | P0 |
| S2-9 | Valider résultats Pandas ≡ PySpark | ⏳ TODO | 0.5h | P0 |
| S2-10 | Corriger erreurs chemins notebooks | ⏳ TODO | 1h | P1 |

#### 📊 Métriques Sprint 2
- **Taux de couverture tests** : Objectif 90%
- **Différence revenue** : Tolérance ±1€
- **Différence nb lignes** : Tolérance ±5 lignes

---

### **SPRINT 3 : Production & Industrialisation** (Jour 3 - 8h)

#### 🎯 Objectifs du Sprint
- Mettre en place pre-commit hooks
- Créer CI/CD GitHub Actions
- Documenter le projet complet
- Préparer la présentation

#### 📋 Backlog Sprint 3

| ID | Tâche | Statut | Temps | Priorité |
|----|-------|--------|-------|----------|
| S3-1 | Configurer pre-commit (black, flake8, isort) | ✅ DONE | 1h | P0 |
| S3-2 | Tester pre-commit sur tout le code | ⏳ TODO | 0.5h | P0 |
| S3-3 | Créer GitHub Actions workflow (.github/workflows) | ✅ DONE | 1h | P0 |
| S3-4 | Tester CI/CD sur push | ⏳ TODO | 0.5h | P0 |
| S3-5 | Rédiger README.md projet complet | ✅ DONE | 1h | P0 |
| S3-6 | Créer documentation Sprint/Trello | ✅ DONE | 0.5h | P1 |
| S3-7 | Ajouter coverage badge au README | ⏳ TODO | 0.5h | P2 |
| S3-8 | Créer Makefile pour commandes courantes | ✅ DONE | 0.5h | P1 |
| S3-9 | Nettoyer code et notebooks | ⏳ TODO | 1h | P1 |
| S3-10 | Préparer présentation résultats | ⏳ TODO | 2h | P0 |

#### 📈 KPIs Sprint 3
- **Qualité code** : Black + Flake8 = 0 erreurs
- **Tests automatisés** : CI/CD passe sur main
- **Documentation** : README complet avec quickstart

---

## 📊 Tableau Kanban (Style Trello)

### 📥 BACKLOG
- [ ] S3-2 : Tester pre-commit sur tout le code
- [ ] S3-4 : Tester CI/CD sur push
- [ ] S3-7 : Ajouter coverage badge
- [ ] S3-9 : Nettoyer code et notebooks

### 🚧 IN PROGRESS
- [ ] S2-9 : Valider résultats Pandas ≡ PySpark
- [ ] S2-10 : Corriger erreurs notebooks

### ✅ DONE
- [x] S1-1 : Analyser dataset FreshKart
- [x] S1-2 : Setup Docker
- [x] S1-3 : Installer Jupyter + VS Code
- [x] S1-4 : Pipeline Pandas complet
- [x] S1-5 : Structure projet
- [x] S1-6 : Requirements.txt
- [x] S2-1 à S2-8 : Migration PySpark + Tests
- [x] S3-1 : Pre-commit hooks
- [x] S3-3 : GitHub Actions
- [x] S3-5 : README projet
- [x] S3-6 : Doc Sprint/Trello
- [x] S3-8 : Makefile

### 🚀 TO REVIEW
- [ ] S3-10 : Présentation résultats

---

## 🎯 Définition of Done (DoD)

Une tâche est considérée "DONE" si :

1. ✅ **Code écrit** : Fonctionnalité implémentée et testée
2. ✅ **Tests passent** : `pytest tests/ -v` = 100% réussite
3. ✅ **Pre-commit OK** : Black, Flake8, Isort = 0 erreurs
4. ✅ **Documenté** : Docstrings + README mis à jour
5. ✅ **Reviewé** : Code revu et validé
6. ✅ **Intégré** : Merge dans main sans conflit

---

## 📈 Burndown Chart (Estimation)

```
Tâches restantes
     25 |●
     20 |  ●●
     15 |     ●●
     10 |        ●●●
      5 |            ●●
      0 |_______________●
         J1  J2  J3  Fin
```

---

## 🏆 Rétrospective Sprint

### Sprint 1 ✅
**Ce qui a bien fonctionné** :
- Docker simplifie le setup (vs pyenv local)
- Pipeline Pandas clair et testé manuellement
- Jupyter + VS Code = excellent workflow

**Ce qui pourrait être amélioré** :
- Chemins data cassés initialement (résolu avec montage complet)
- Token Jupyter pas évident à récupérer (script get-token.sh créé)

**Actions** :
- [x] Créer scripts utilitaires (docker-start.sh, get-token.sh)
- [x] Documenter chemins data dans README

### Sprint 2 ⏳ (en cours)
**Ce qui a bien fonctionné** :
- Migration PySpark fluide grâce à API similaire
- Tests unitaires détectent les différences

**Ce qui pourrait être amélioré** :
- Notebooks ont encore des erreurs de chemins
- Tests lents (Spark session startup)

**Actions prévues** :
- [ ] Fixture Spark session partagée pour accélérer tests
- [ ] Corriger notebooks avec chemins absolus

---

## 📞 Daily Standup (Format Agile)

### Jour 1 (Fin)
**Hier** : Setup projet
**Aujourd'hui** : Pipeline Pandas complet ✅
**Blocages** : Aucun

### Jour 2 (Matin)
**Hier** : Pipeline Pandas
**Aujourd'hui** : Migration PySpark + Tests
**Blocages** : Aucun

### Jour 2 (Fin)
**Hier** : Migration PySpark
**Aujourd'hui** : Tests passent, validation résultats
**Blocages** : Notebooks à corriger

### Jour 3 (Matin)
**Hier** : Tests + validation
**Aujourd'hui** : Pre-commit + CI/CD + Doc
**Blocages** : Aucun

### Jour 3 (Fin)
**Hier** : Industrialisation
**Aujourd'hui** : Présentation
**Blocages** : Aucun

---

## 🎓 Livrables Attendus

1. ✅ **Code Source**
   - [x] Pipeline Pandas (src/pandas/pipeline.py)
   - [x] Pipeline PySpark (src/pyspark/pipeline.py)
   - [x] Tests unitaires (tests/test_migration.py)

2. ✅ **Infrastructure**
   - [x] Docker (Dockerfile + docker-compose.yml)
   - [x] Pre-commit hooks (.pre-commit-config.yaml)
   - [x] GitHub Actions (.github/workflows/tests.yml)

3. ⏳ **Documentation**
   - [x] README principal
   - [x] README projet migration
   - [x] Doc Sprint/Trello (ce fichier)
   - [ ] Présentation résultats

4. ⏳ **Validation**
   - [ ] Tests 100% OK
   - [ ] CI/CD passe
   - [ ] Résultats Pandas ≡ PySpark validés

---

**Dernière mise à jour** : Jour 2, 18h00
**Statut global** : 🟢 On track
**Risques** : 🟡 Notebooks à corriger (mineur)
