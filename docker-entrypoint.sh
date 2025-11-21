#!/bin/bash
# Script d'initialisation du conteneur

# Installer le projet freshkart_migration en mode développement si présent
if [ -d "/workspace/projects/freshkart_migration" ] && [ -f "/workspace/projects/freshkart_migration/pyproject.toml" ]; then
    echo "📦 Installation du projet freshkart_migration en mode développement..."
    cd /workspace/projects/freshkart_migration
    /workspace/venv/bin/pip install -e . > /dev/null 2>&1
    echo "✅ Projet installé"
    cd /workspace
fi

# Lancer code-server en arrière-plan
code-server --bind-addr 0.0.0.0:8080 --auth none /workspace &

# Lancer Jupyter Lab
/workspace/venv/bin/jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --notebook-dir=/workspace
