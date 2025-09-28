#!/bin/bash

echo "🚀 Redémarrage complet du système avec validation du numéro de téléphone..."

echo "1. Arrêt de tous les processus..."
pkill -f "java"
pkill -f "flutter"
pkill -f "vite"
pkill -f "npm"

# Attendre un peu
sleep 3

echo "2. Redémarrage du backend avec validation..."
./restart_backend_with_validation.sh

if [ $? -ne 0 ]; then
    echo "❌ Échec du redémarrage du backend"
    exit 1
fi

echo "3. Redémarrage de Flutter avec validation..."
./restart_flutter_with_validation.sh

if [ $? -ne 0 ]; then
    echo "❌ Échec du redémarrage de Flutter"
    exit 1
fi

echo "4. Test de validation du numéro de téléphone..."
./test_phone_validation.sh

echo ""
echo "✅ Système complet redémarré avec succès!"
echo "📱 Flutter: Prêt pour les tests"
echo "🔧 Backend: Prêt avec validation du numéro de téléphone"
echo "📋 Test: Vérifiez que les numéros de téléphone sont uniques"
