#!/bin/bash
# Script de build de l'image Docker

cd "$(dirname "$0")/.." || exit 1

echo "🐳 Construction de l'image Docker PySpark..."
echo ""

# Build sans cache pour s'assurer que requirements.txt est pris en compte
docker-compose build --no-cache

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Image construite avec succès !"
    echo ""
    echo "📝 Prochaines étapes:"
    echo "  1. Démarrer: ./scripts/docker-start.sh"
    echo "  2. Token Jupyter: ./scripts/get-token.sh"
    echo "  3. Tests: ./run-tests.ps1"
    echo ""
    echo "🌐 Services (après démarrage):"
    echo "  - Jupyter Lab: http://localhost:8888"
    echo "  - VS Code: http://localhost:8080"
else
    echo ""
    echo "❌ Erreur lors de la construction de l'image !"
    exit 1
fi
