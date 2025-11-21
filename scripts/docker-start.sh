#!/bin/bash
# Script de démarrage des services Docker

cd "$(dirname "$0")/.." || exit 1

echo "🚀 Démarrage des services Docker..."
echo ""

docker-compose up -d

if [ $? -eq 0 ]; then
    echo ""
    echo "⏳ Attente du démarrage des services (10s)..."
    sleep 10
    
    echo ""
    echo "✅ Services démarrés !"
    echo ""
    echo "🌐 Accès aux services:"
    echo "  - Jupyter Lab: http://localhost:8888"
    echo "  - VS Code: http://localhost:8080"
    echo ""
    echo "🔑 Token Jupyter:"
    ./scripts/get-token.sh
    echo ""
    echo "📝 Commandes utiles:"
    echo "  - Tests: ./run-tests.ps1"
    echo "  - Logs: docker-compose logs -f"
    echo "  - Shell: docker exec -it brief_starter_pack bash"
else
    echo ""
    echo "❌ Erreur lors du démarrage !"
    exit 1
fi
