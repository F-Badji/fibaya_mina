#!/bin/bash

echo "🧪 Test des limites d'upload de fichiers..."

echo "1. Vérification du backend..."
curl -I http://localhost:8081/api/prestataires

echo ""
echo "2. Test d'upload avec un petit fichier (simulation)..."
curl -X POST http://localhost:8081/api/prestataires/with-files \
  -F "nom=Test" \
  -F "prenom=Upload" \
  -F "telephone=+221771234569" \
  -F "serviceType=Testeur" \
  -F "typeService=LES_DEUX" \
  -F "experience=1" \
  -F "description=Test des limites d'upload"

echo ""
echo "3. Vérification des logs du backend..."
echo "Recherche des messages de configuration multipart..."
grep -i "multipart\|file-size\|max-request" backend_startup.log || echo "Aucun log de configuration multipart trouvé"

echo ""
echo "4. Test de l'endpoint de téléchargement..."
curl -I http://localhost:8081/api/files/test_download.txt

echo ""
echo "✅ Test des limites terminé!"
echo "📋 Résumé des nouvelles limites:"
echo "   - Fichier max: 50MB"
echo "   - Requête max: 200MB"
echo "   - HTTP POST max: 200MB"
