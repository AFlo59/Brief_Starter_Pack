#!/bin/bash

echo "🧪 Test de l'environnement PySpark dans le conteneur"
echo ""

docker-compose exec pyspark-jupyter bash -c '
echo "📂 Vérification structure des dossiers:"
ls -la /workspace/data/

echo ""
echo "📊 Vérification données FreshKart:"
ls -la /workspace/data/march-input/ | head -10

echo ""
echo "🐍 Vérification Python:"
python3 --version

echo ""
echo "⚡ Vérification PySpark:"
python3 -c "from pyspark.sql import SparkSession; print(f\"PySpark OK - version disponible\")"

echo ""
echo "📦 Vérification packages:"
pip list | grep -E "pyspark|jupyter|pandas|numpy"

echo ""
echo "✅ Test terminé!"
'
