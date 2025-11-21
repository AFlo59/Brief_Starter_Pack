#!/bin/bash
# Script de nettoyage complet des containers Docker

cd "$(dirname "$0")/.." || exit 1

echo "🧹 Nettoyage des containers Docker..."
echo ""

# 1. Arrêter tous les containers liés au projet
echo "1️⃣  Arrêt des containers..."
CONTAINERS=$(docker ps -a --filter "name=freshkart" --filter "name=brief_starter_pack" --format "{{.Names}}" 2>/dev/null)

if [ -n "$CONTAINERS" ]; then
    echo "$CONTAINERS" | while read -r container; do
        echo "   🛑 Arrêt de $container"
        docker stop "$container" 2>/dev/null >/dev/null
        docker rm -f "$container" 2>/dev/null >/dev/null
    done
    echo "   ✅ Containers arrêtés et supprimés"
else
    echo "   ℹ️  Aucun container à arrêter"
fi

# 2. Nettoyer avec docker-compose
echo ""
echo "2️⃣  Nettoyage docker-compose..."
docker-compose down -v 2>/dev/null >/dev/null
echo "   ✅ docker-compose nettoyé"

# 3. Supprimer les réseaux orphelins
echo ""
echo "3️⃣  Nettoyage des réseaux..."
docker network prune -f 2>/dev/null >/dev/null
echo "   ✅ Réseaux nettoyés"

# 4. Supprimer les volumes non utilisés (optionnel)
echo ""
echo "4️⃣  Nettoyage des volumes..."
read -p "   Supprimer aussi les volumes ? (o/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Oo]$ ]]; then
    docker volume prune -f 2>/dev/null >/dev/null
    echo "   ✅ Volumes nettoyés"
else
    echo "   ⏭️  Volumes conservés"
fi

# 5. Nettoyer les images intermédiaires
echo ""
echo "5️⃣  Nettoyage des images intermédiaires..."
docker image prune -f 2>/dev/null >/dev/null
echo "   ✅ Images intermédiaires nettoyées"

# 6. Nettoyage système global (optionnel)
echo ""
echo "6️⃣  Nettoyage système Docker..."
docker system prune -f 2>/dev/null >/dev/null
echo "   ✅ Système nettoyé"

echo ""
echo "============================================================"
echo "✅ NETTOYAGE TERMINÉ !"
echo "============================================================"
echo ""
echo "📝 Prochaines étapes:"
echo "   1. Rebuild: bash scripts/docker-build.sh"
echo "   2. Start: bash scripts/docker-start.sh"
echo ""
