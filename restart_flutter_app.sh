#!/bin/bash

echo "🔄 Redémarrage de l'application Flutter avec les nouvelles modifications..."

# Arrêter tous les processus Flutter
echo "⏹️ Arrêt des processus Flutter existants..."
pkill -f "flutter"

# Nettoyer le cache Flutter
echo "🧹 Nettoyage du cache Flutter..."
flutter clean

# Récupérer les dépendances
echo "📦 Récupération des dépendances..."
flutter pub get

# Recompiler et lancer l'application
echo "🚀 Lancement de l'application Flutter..."
flutter run
