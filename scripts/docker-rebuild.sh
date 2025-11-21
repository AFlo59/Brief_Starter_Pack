#!/bin/bash
# Script de rebuild complet (down + build + up)

cd "$(dirname "$0")/.." || exit 1

echo "🔄 Reconstruction complète de l'environnement Docker"
echo ""

# Arrêter le conteneur actuel
echo "🛑 Arrêt et suppression des conteneurs + volumes..."
docker-compose down -v

# Nettoyage
echo ""
echo "🧹 Nettoyage des images intermédiaires..."
docker image prune -f

# Reconstruire l'image (sans cache pour forcer la mise à jour)
echo ""
echo "🔨 Reconstruction de l'image (sans cache)..."
docker-compose build --no-cache

if [ $? -ne 0 ]; then
    echo ""
    echo "❌ Erreur lors de la construction !"
    exit 1
fi

# Relancer
echo ""
echo "🚀 Démarrage des services..."
docker-compose up -d

echo ""
echo "⏳ Attente du démarrage (10s)..."
sleep 10

echo ""
echo "✅ Environnement reconstruit !"
echo ""
echo "🔑 Token Jupyter:"
./scripts/get-token.sh
echo ""
echo "🌐 Services:"
echo "  - Jupyter Lab: http://localhost:8888"
echo "  - VS Code:     http://localhost:8080"
