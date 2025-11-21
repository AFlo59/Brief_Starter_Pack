# 🚀 Brief Starter Pack - Migration Pandas → PySpark

Migration complète Pandas → PySpark avec méthodologie Agile, tests unitaires et environnement Docker professionnel.

## 📌 Quick Start

```powershell
# Windows PowerShell
.\docker-build.ps1       # Build image
.\docker-start.ps1       # Start services  
.\get-token.ps1          # Get Jupyter token
.\run-tests.ps1          # Run tests

# Ou via bash (WSL/Git Bash)
bash scripts/docker-build.sh
bash scripts/docker-start.sh
bash scripts/get-token.sh
```

**Services** :
- Jupyter Lab : http://localhost:8888
- VS Code Web : http://localhost:8080

## 📂 Structure du Projet

```
Brief_Starter_Pack/
├── projects/
│   └── freshkart_migration/          ⭐ PROJET PRINCIPAL
│       ├── src/pandas/               # Pipeline Pandas (référence)
│       ├── src/pyspark/              # Pipeline PySpark (migration)
│       ├── tests/                    # Tests unitaires
│       └── SPRINT_PLANNING.md        # Organisation Agile
├── notebooks/                        # Jupyter formation
├── data/march-input/                 # Dataset FreshKart
├── Dockerfile + docker-compose.yml   # Docker
└── .github/workflows/                # CI/CD
```

## 📊 Dataset FreshKart

- **802 clients** (customers.csv)
- **31 fichiers JSON** commandes (orders_2025-03-*.json)
- **1,124 remboursements** (refunds.csv)

## 🧪 Tests & Qualité

```powershell
# Tests unitaires
.\run-tests.ps1

# Tests avec coverage
.\run-tests.ps1 --coverage

# Pre-commit hooks
make pre-commit  # ou docker exec
```

**Tests implémentés** :
- ✅ Chargement données identique
- ✅ Étapes pipeline équivalentes
- ✅ Résultats finaux (colonnes, revenue, échantillon)
- ✅ Performance comparée

## 📈 Méthodologie Agile (3 jours)

Voir `projects/freshkart_migration/SPRINT_PLANNING.md`

- **Jour 1** : Découverte & Setup ✅
- **Jour 2** : Migration PySpark ⏳
- **Jour 3** : Industrialisation ⏳

## 🔧 Technologies

- Python 3.10+ | PySpark 3.5.0 | Pandas 2.1.4
- Docker | Jupyter Lab | VS Code (code-server)
- pytest | black | flake8 | pre-commit

## 📝 Commandes Docker

```powershell
# Windows PowerShell
.\docker-build.ps1      # Build image
.\docker-start.ps1      # Start services
.\get-token.ps1         # Get token
docker-compose down     # Stop services

# Bash (WSL/Git Bash)
bash scripts/docker-build.sh
bash scripts/docker-start.sh
bash scripts/docker-rebuild.sh  # Rebuild complet
bash scripts/get-token.sh

# Logs et debug
docker-compose logs -f
docker exec -it brief_starter_pack bash
```

## 📚 Documentation

- **README projet** : `projects/freshkart_migration/README.md`
- **Sprint Planning** : `projects/freshkart_migration/SPRINT_PLANNING.md`
- **Guide migration** : `Migration_Pandas_PySpark_Guide/README.md`

## ✅ Statut

- [x] Docker environment
- [x] Pipeline Pandas (287 lignes)
- [x] Pipeline PySpark (286 lignes)
- [x] Tests unitaires
- [x] Pre-commit hooks
- [x] CI/CD GitHub Actions
- [ ] Validation résultats (en cours)

**Projet Brief : Migration Pandas → PySpark & Industrialisation**
