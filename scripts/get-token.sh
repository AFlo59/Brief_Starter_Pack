#!/bin/bash
# Script de récupération du token Jupyter

cd "$(dirname "$0")/.." || exit 1

CONTAINER_NAME="freshkart-pyspark"

# Vérifier que le container tourne
if ! docker ps --filter "name=$CONTAINER_NAME" --format "{{.Names}}" | grep -q "$CONTAINER_NAME"; then
    echo "❌ Container '$CONTAINER_NAME' non démarré !"
    echo "   Lancez: ./scripts/docker-start.sh"
    exit 1
fi

echo "🔑 Récupération du token Jupyter..."
echo ""

TOKEN=$(docker exec $CONTAINER_NAME jupyter server list 2>/dev/null | grep -oP 'token=\K[a-f0-9]+')

if [ -z "$TOKEN" ]; then
    echo "⏳ Jupyter en cours de démarrage, nouvel essai..."
    sleep 3
    TOKEN=$(docker exec $CONTAINER_NAME jupyter server list 2>/dev/null | grep -oP 'token=\K[a-f0-9]+')
fi

if [ -z "$TOKEN" ]; then
    echo "❌ Impossible de récupérer le token !"
    echo "   Vérifiez les logs: docker-compose logs"
    exit 1
fi

echo "✅ Token: $TOKEN"
echo ""
echo "🌐 Lien direct Jupyter Lab:"
echo "http://localhost:8888/?token=$TOKEN"
echo ""
echo "📝 VS Code (pas de token nécessaire):"
echo "http://localhost:8080"
