#!/bin/bash

echo "🔧 Correction des warnings Java..."

echo "1. Vérification des versions Java installées..."
/usr/libexec/java_home -V

echo ""
echo "2. Configuration de Java 17 pour Gradle..."
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
echo "JAVA_HOME: $JAVA_HOME"

echo ""
echo "3. Nettoyage du cache Gradle..."
cd android
./gradlew clean

echo ""
echo "4. Recompilation avec Java 17..."
./gradlew build

echo ""
echo "5. Retour au répertoire principal..."
cd ..

echo ""
echo "6. Nettoyage du cache Flutter..."
flutter clean

echo ""
echo "7. Récupération des dépendances Flutter..."
flutter pub get

echo ""
echo "✅ Correction des warnings terminée!"
echo "Maintenant, relancez Flutter avec: flutter run"
