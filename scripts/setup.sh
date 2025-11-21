#!/bin/bash

echo "🚀 Configuration de l'environnement PySpark FreshKart"

# Créer le venv si nécessaire
if [ ! -d "venv" ]; then
    echo "📦 Création du venv Python3..."
    python3 -m venv venv
fi

# Activer le venv
echo "✅ Activation du venv..."
source venv/bin/activate

# Installer les packages
echo "📥 Installation des dépendances..."
pip install --upgrade pip
pip install pyspark==3.5.0 jupyter jupyterlab pandas numpy matplotlib seaborn

echo "✅ Installation terminée !"
echo ""
echo "Pour démarrer Jupyter Lab:"
echo "  source venv/bin/activate"
echo "  jupyter lab --notebook-dir=notebooks"
