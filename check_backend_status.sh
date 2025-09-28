#!/bin/bash

echo "🔍 Vérification du statut du backend..."

# Vérifier si le port 8081 est utilisé
echo "📡 Vérification du port 8081..."
lsof -i :8081

echo ""
echo "🌐 Test de l'endpoint des prestataires..."
curl -I http://localhost:8081/api/prestataires

echo ""
echo "📁 Contenu du dossier uploads:"
ls -la backend/uploads/

echo ""
echo "🧪 Test de téléchargement du fichier de test..."
curl -I http://localhost:8081/api/files/test_download.txt
