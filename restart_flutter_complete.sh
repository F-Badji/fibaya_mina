#!/bin/bash

echo "🔄 Redémarrage complet de l'application Flutter..."

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
flutter run
