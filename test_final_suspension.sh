#!/bin/bash

echo "🎯 Test final du système de suspension automatique"
echo "================================================="

# Variables
BASE_URL="http://localhost:8081"
API_BASE="$BASE_URL/api/prestataires"
TEST_PHONE="+221780000000"

echo "📱 Numéro de test: $TEST_PHONE"

# Vérifier le statut actuel
echo -e "\n🔍 Vérification du statut actuel..."
STATUS_RESPONSE=$(curl -s "$API_BASE/check-validation/$TEST_PHONE")
echo "Réponse: $STATUS_RESPONSE"

# Extraire le statut
IS_VALID=$(echo "$STATUS_RESPONSE" | grep -o '"isValide":[^,]*' | cut -d':' -f2)

if [ "$IS_VALID" = "true" ]; then
    echo "✅ Le prestataire est actuellement VALIDÉ"
    echo ""
    echo "📱 Instructions pour tester la déconnexion automatique:"
    echo "1. Ouvrez l'application Flutter"
    echo "2. Regardez les logs dans la console - vous devriez voir:"
    echo "   🔍 Vérification globale du statut démarrée pour tous les écrans"
    echo "   🔍 Vérification du statut pour: +221780000000"
    echo "   📡 Réponse du serveur: 200"
    echo "   🔍 Statut vérifié: Éligible"
    echo ""
    echo "3. Dans l'interface admin (http://localhost:8080), suspendez le prestataire"
    echo "4. L'app devrait automatiquement (dans les 10 secondes):"
    echo "   - Détecter la suspension"
    echo "   - Afficher: ⚠️ Utilisateur suspendu détecté - Déconnexion automatique"
    echo "   - Rediriger vers l'écran d'authentification (SplashScreen)"
    echo ""
    echo "5. L'utilisateur sera traité comme un nouveau utilisateur"
    echo ""
    echo "🔄 Pour tester la suspension, exécutez:"
    echo "curl -X PATCH \"$API_BASE/2/suspendre?validePar=test\""
    
else
    echo "❌ Le prestataire est actuellement SUSPENDU"
    echo "📱 Dans l'app Flutter, vous devriez être redirigé vers l'écran d'authentification"
    echo ""
    echo "🔄 Pour revalider le prestataire, exécutez:"
    echo "curl -X PATCH \"$API_BASE/2/valider?validePar=test\""
fi

echo ""
echo "📋 Logs à surveiller dans l'app Flutter:"
echo "- 🔍 Vérification du statut démarrée pour: +221780000000"
echo "- 📡 Réponse du serveur: 200"
echo "- 🔍 Statut vérifié: Éligible/Non éligible"
echo "- ⚠️ Utilisateur suspendu détecté - Déconnexion automatique"
echo "- 🚨 handleUserSuspended appelé !"
echo "- ✅ Widget monté, procédure de déconnexion..."
echo "- 🎯 Redirection vers SplashScreen effectuée"
