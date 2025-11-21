# FreshKart Migration: Pandas → PySpark

## 🎯 Objectif du Projet

Migration complète du pipeline de données FreshKart de **Pandas** vers **PySpark**, en garantissant l'équivalence stricte des résultats et en suivant une méthodologie Agile sur **3 jours**.

## 📊 Dataset FreshKart

- **Clients** : 802 clients (CSV)
- **Commandes** : 31 fichiers JSON (mars 2025)
- **Remboursements** : 1,124 remboursements (CSV)

## 🏗️ Architecture du Projet

```
projects/freshkart_migration/
├── src/
│   ├── pandas/
│   │   ├── __init__.py
│   │   └── pipeline.py          # Pipeline original Pandas
│   └── pyspark/
│       ├── __init__.py
│       └── pipeline.py          # Pipeline migré PySpark
├── tests/
│   ├── __init__.py
│   └── test_migration.py        # Tests unitaires d'équivalence
├── .pre-commit-config.yaml      # Hooks qualité code
├── conftest.py                   # Configuration pytest
└── README.md                     # Ce fichier
```

## 🧪 Tests Unitaires

Les tests garantissent que **Pandas ≡ PySpark** :

```bash
# Lancer les tests dans le container
pytest tests/ -v

# Avec coverage
pytest tests/ --cov=src --cov-report=html
```

### Tests Implémentés

1. **TestDataLoading** : Chargement identique (clients, commandes, refunds)
2. **TestPipelineSteps** : Étapes intermédiaires (filtre, explosion items)
3. **TestFullPipeline** : Résultat final (colonnes, revenue, échantillon)
4. **TestPerformance** : Comparaison temps d'exécution

## 🔧 Pre-commit Hooks

Activation des hooks :

```bash
# Dans le container
pre-commit install
pre-commit run --all-files
```

Hooks configurés :
- **black** : Formatage code (100 caractères/ligne)
- **flake8** : Linting Python
- **isort** : Tri des imports
- **pytest** : Tests automatiques avant commit

## 📈 Méthodologie Agile - 3 Jours

### **Jour 1 : Découverte & Setup**
- ✅ Analyse du dataset FreshKart
- ✅ Création environnement Docker (Ubuntu + PySpark + Jupyter)
- ✅ Implémentation pipeline Pandas (référence)
- ✅ Structure projet avec tests

### **Jour 2 : Migration PySpark**
- ✅ Migration pipeline vers PySpark
- ✅ Tests unitaires d'équivalence
- ⏳ Correction notebooks (erreurs chemins)
- ⏳ Validation complète des résultats

### **Jour 3 : Industrialisation**
- ⏳ Pre-commit hooks finalisés
- ⏳ Documentation technique
- ⏳ CI/CD GitHub Actions
- ⏳ Présentation résultats

## 🚀 Quickstart

### 1. Build & Start Docker

```bash
# Windows PowerShell
.\docker-build.sh
.\docker-start.sh
```

### 2. Accès Services

- **Jupyter Lab** : http://localhost:8888 (token: `.\get-token.sh`)
- **VS Code Web** : http://localhost:8080

### 3. Lancer le Pipeline

```python
# Pandas
from src.pandas.pipeline import FreshKartPandasPipeline
pipeline = FreshKartPandasPipeline("/workspace/Brief_Starter_Pack/data/march-input")
result = pipeline.run_full_pipeline()
print(f"Revenu total: {result['net_revenue_eur'].sum():.2f}€")

# PySpark
from src.pyspark.pipeline import FreshKartPySparkPipeline
from pyspark.sql import SparkSession
spark = SparkSession.builder.appName("FreshKart").getOrCreate()
pipeline = FreshKartPySparkPipeline("/workspace/Brief_Starter_Pack/data/march-input", spark)
result = pipeline.run_full_pipeline()
result.agg({"net_revenue_eur": "sum"}).show()
```

## 📋 Trello / Suivi Sprint

### Sprint 1 : Découverte (Jour 1)
- [x] Analyse données FreshKart
- [x] Setup Docker + PySpark
- [x] Pipeline Pandas complet
- [x] Structure projet tests

### Sprint 2 : Migration (Jour 2)
- [x] Pipeline PySpark
- [x] Tests unitaires
- [ ] Fix erreurs notebooks
- [ ] Validation résultats

### Sprint 3 : Production (Jour 3)
- [x] Pre-commit hooks
- [ ] CI/CD GitHub Actions
- [ ] Documentation complète
- [ ] Review & présentation

## 🔍 Résultats Attendus

| Métrique | Pandas | PySpark | Tolérance |
|----------|--------|---------|-----------|
| Nb clients | 802 | 802 | 0 |
| Nb commandes | ~X | ~X | 0 |
| Nb items explosés | ~Y | ~Y | ±5 |
| Revenu total | Z€ | Z€ | ±1€ |

## 🛠️ Technologies

- **Python** : 3.10+
- **PySpark** : 3.5.0
- **Pandas** : 2.x
- **Pytest** : 7.x
- **Docker** : Ubuntu 22.04
- **Jupyter Lab** : Dernière version

## 📝 Notes Techniques

### Différences Pandas/PySpark
- **API** : `df.sum()` vs `df.agg({"col": "sum"})`
- **Lazy Evaluation** : PySpark exécute au `.show()` ou `.collect()`
- **Typage** : PySpark nécessite schéma explicite pour JSON
- **Performance** : PySpark parallélise (meilleur sur gros volumes)

### Problèmes Résolus
- ✅ Chemins données : `/workspace/Brief_Starter_Pack/data/march-input/`
- ✅ Montage Docker : Volume complet au lieu de sous-dossiers
- ✅ Token Jupyter : Récupération via `docker exec`

## 🤝 Contribution

1. Créer branche : `git checkout -b feature/ma-feature`
2. Commits : Les hooks pre-commit valident automatiquement
3. Tests : `pytest tests/ -v` doit passer
4. PR : Vers `main` avec description

## 📞 Support

- **Erreurs notebooks** : Vérifier chemins `/workspace/Brief_Starter_Pack/data/march-input/`
- **Tests échouent** : Vérifier Spark session (mémoire suffisante ?)
- **Docker** : `docker-compose down -v` puis rebuild

---

**Projet réalisé dans le cadre du Brief : Migration Pandas → PySpark & Industrialisation**
