#!/bin/bash
# Script de test complet pour valider l'environnement Docker

cd "$(dirname "$0")/.." || exit 1

echo "🧪 Tests de l'environnement FreshKart Migration"
echo "================================================"
echo ""

# Vérifier Python
echo "✓ Python version:"
python3 --version
echo ""

# Vérifier PySpark
echo "✓ PySpark installation:"
python3 -c "import pyspark; print(f'PySpark {pyspark.__version__}')"
echo ""

# Vérifier Pandas
echo "✓ Pandas installation:"
python3 -c "import pandas as pd; print(f'Pandas {pd.__version__}')"
echo ""

# Vérifier pytest
echo "✓ Pytest installation:"
pytest --version
echo ""

# Vérifier les données
echo "✓ Vérification données FreshKart:"
DATA_PATH="/workspace/Brief_Starter_Pack/data/march-input"
if [ -d "$DATA_PATH" ]; then
    echo "  ✓ Dossier data trouvé: $DATA_PATH"
    echo "  ✓ Fichiers CSV: $(ls $DATA_PATH/*.csv 2>/dev/null | wc -l)"
    echo "  ✓ Fichiers JSON: $(ls $DATA_PATH/*.json 2>/dev/null | wc -l)"
else
    echo "  ✗ ERREUR: Dossier data non trouvé!"
    exit 1
fi
echo ""

# Vérifier la structure du projet
echo "✓ Structure projet migration:"
PROJECT_PATH="/workspace/Brief_Starter_Pack/projects/freshkart_migration"
if [ -d "$PROJECT_PATH" ]; then
    echo "  ✓ Projet trouvé: $PROJECT_PATH"
    [ -f "$PROJECT_PATH/src/pandas/pipeline.py" ] && echo "  ✓ Pipeline Pandas présent"
    [ -f "$PROJECT_PATH/src/pyspark/pipeline.py" ] && echo "  ✓ Pipeline PySpark présent"
    [ -f "$PROJECT_PATH/tests/test_migration.py" ] && echo "  ✓ Tests unitaires présents"
    [ -f "$PROJECT_PATH/.pre-commit-config.yaml" ] && echo "  ✓ Pre-commit hooks configurés"
else
    echo "  ✗ ERREUR: Projet non trouvé!"
    exit 1
fi
echo ""

# Test rapide import pipelines
echo "✓ Test imports Python:"
cd "$PROJECT_PATH"
python3 -c "
import sys
sys.path.insert(0, 'src')
from pandas.pipeline import FreshKartPandasPipeline
from pyspark.pipeline import FreshKartPySparkPipeline
print('  ✓ Imports Pandas/PySpark OK')
" || echo "  ✗ ERREUR lors des imports!"
echo ""

# Lancer les tests
echo "✓ Lancement des tests unitaires:"
echo "  (Ceci peut prendre quelques secondes...)"
cd "$PROJECT_PATH"
pytest tests/ -v --tb=short -x 2>&1 | head -n 50
echo ""

echo "================================================"
echo "✅ Tests terminés!"
echo ""
echo "📝 Services disponibles:"
echo "  - Jupyter Lab: http://localhost:8888"
echo "  - VS Code: http://localhost:8080"
echo ""
echo "🚀 Pour lancer le pipeline:"
echo "  cd /workspace/Brief_Starter_Pack/projects/freshkart_migration"
echo "  python3 -m pytest tests/ -v"
