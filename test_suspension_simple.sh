#!/bin/bash

echo "🧪 Test simple de suspension"
echo "============================"

# Variables
BASE_URL="http://localhost:8081"
API_BASE="$BASE_URL/api/prestataires"
TEST_PHONE="+221701234568"

echo "📱 Numéro de test: $TEST_PHONE"

# Vérifier le statut actuel
echo -e "\n🔍 Vérification du statut actuel..."
STATUS_RESPONSE=$(curl -s "$API_BASE/check-validation/$TEST_PHONE")
echo "Réponse: $STATUS_RESPONSE"

# Extraire le statut
IS_VALID=$(echo "$STATUS_RESPONSE" | grep -o '"isValide":[^,]*' | cut -d':' -f2)

if [ "$IS_VALID" = "true" ]; then
    echo "✅ Le prestataire est actuellement VALIDÉ"
    echo "📱 Dans l'app Flutter, vous devriez voir les logs de vérification toutes les 10 secondes"
    echo "🔄 Maintenant, suspendez le prestataire dans l'interface admin"
    echo "⏱️  L'app devrait se déconnecter automatiquement dans les 10 secondes"
else
    echo "❌ Le prestataire est actuellement SUSPENDU"
    echo "📱 Dans l'app Flutter, vous devriez être redirigé vers l'écran d'authentification"
fi

echo -e "\n📋 Instructions:"
echo "1. Ouvrez l'app Flutter"
echo "2. Regardez les logs dans la console"
echo "3. Si le prestataire est validé, suspendez-le dans l'interface admin"
echo "4. L'app devrait se déconnecter automatiquement"
