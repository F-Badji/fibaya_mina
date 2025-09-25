#!/bin/bash

echo "🔧 Configuration réseau pour Fibaya Mina"
echo "========================================"

# Vérifier si l'émulateur est connecté
echo "📱 Vérification de la connexion émulateur..."
if adb devices | grep -q "emulator"; then
    echo "✅ Émulateur détecté"
    
    # Configurer le port forwarding
    echo "🌐 Configuration du port forwarding..."
    adb reverse tcp:8080 tcp:8080
    
    if [ $? -eq 0 ]; then
        echo "✅ Port forwarding configuré (localhost:8080 -> émulateur:8080)"
    else
        echo "❌ Erreur lors de la configuration du port forwarding"
    fi
    
    # Vérifier la configuration
    echo "🔍 Vérification de la configuration..."
    adb reverse --list
    
else
    echo "❌ Aucun émulateur détecté"
    echo "💡 Veuillez démarrer votre émulateur Android et réessayer"
    echo ""
    echo "Pour démarrer un émulateur :"
    echo "1. Ouvrez Android Studio"
    echo "2. Allez dans Tools > AVD Manager"
    echo "3. Cliquez sur le bouton Play d'un émulateur"
    echo "4. Relancez ce script"
fi

echo ""
echo "📋 Configuration actuelle :"
echo "- Backend URL: http://localhost:8080/api"
echo "- Port forwarding: 8080 -> 8080"
echo "- Configuration dans: lib/common/config.dart"

