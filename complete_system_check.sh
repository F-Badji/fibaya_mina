#!/bin/bash

echo "🔍 Vérification complète du système..."

echo "1. Vérification du backend Spring Boot..."
lsof -i :8081

echo ""
echo "2. Vérification de l'application Flutter..."
pgrep -f "flutter"

echo ""
echo "3. Contenu du dossier uploads..."
ls -la backend/uploads/

echo ""
echo "4. Test de l'endpoint de téléchargement..."
curl -I http://localhost:8081/api/files/test_download.txt

echo ""
echo "5. Test de l'endpoint des prestataires..."
curl -I http://localhost:8081/api/prestataires

echo ""
echo "6. Redémarrage de Flutter si nécessaire..."
if ! pgrep -f "flutter" > /dev/null; then
    echo "Flutter n'est pas en cours d'exécution. Redémarrage..."
    flutter clean
    flutter pub get
    flutter run &
    echo "Flutter redémarré en arrière-plan"
else
    echo "Flutter est déjà en cours d'exécution"
fi

echo ""
echo "✅ Vérification terminée!"
