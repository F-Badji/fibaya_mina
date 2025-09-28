#!/bin/bash

echo "🔄 Redémarrage de Flutter avec validation du numéro de téléphone..."

# Arrêter tous les processus Flutter
echo "⏹️ Arrêt des processus Flutter..."
pkill -f "flutter"

# Attendre un peu
sleep 2

# Nettoyer le cache Flutter
echo "🧹 Nettoyage du cache Flutter..."
flutter clean

# Récupérer les dépendances
echo "📦 Récupération des dépendances..."
flutter pub get

# Recompiler et lancer l'application
echo "🚀 Lancement de l'application Flutter avec les nouvelles modifications..."
flutter run > flutter_startup.log 2>&1 &
FLUTTER_PID=$!

echo "Flutter démarré avec PID: $FLUTTER_PID"
echo "Vérification des logs dans flutter_startup.log..."

# Attendre que Flutter démarre
sleep 30

# Vérifier si Flutter a démarré correctement
if grep -q "Connected to the VM Service" flutter_startup.log; then
    echo "✅ Flutter démarré avec succès"
else
    echo "❌ Flutter n'a pas démarré correctement. Vérifiez flutter_startup.log"
    kill $FLUTTER_PID
    exit 1
fi

echo "✅ Redémarrage Flutter terminé!"
