#!/bin/bash

echo "🚀 Redémarrage de Flutter sans warnings Java..."

# Arrêter Flutter
echo "⏹️ Arrêt de Flutter..."
pkill -f "flutter"

# Attendre
sleep 2

# Configurer Java 17
echo "☕ Configuration de Java 17..."
export JAVA_HOME=$(/usr/libexec/java_home -v 17 2>/dev/null || /usr/libexec/java_home -v 11 2>/dev/null || /usr/libexec/java_home)
echo "JAVA_HOME: $JAVA_HOME"

# Nettoyer Flutter
echo "🧹 Nettoyage de Flutter..."
flutter clean

# Récupérer les dépendances
echo "📦 Récupération des dépendances..."
flutter pub get

# Lancer Flutter avec suppression des warnings
echo "🚀 Lancement de Flutter..."
flutter run --no-sound-null-safety 2>/dev/null || flutter run

echo "✅ Flutter redémarré!"
