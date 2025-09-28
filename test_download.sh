#!/bin/bash

echo "🧪 Test du système de téléchargement..."

# Attendre que le backend démarre
echo "⏳ Attente du démarrage du backend..."
sleep 20

# Tester le téléchargement du fichier de test
echo "📥 Test de téléchargement du fichier test..."
curl -I http://localhost:8081/api/files/test_download.txt

echo ""
echo "📋 Contenu du dossier uploads:"
ls -la backend/uploads/

echo ""
echo "🌐 Test de l'endpoint des prestataires:"
curl -I http://localhost:8081/api/prestataires

echo ""
echo "✅ Test terminé!"
