#!/bin/bash

echo "🧪 Test du système de téléchargement de fichiers..."

# Attendre que le backend démarre
echo "⏳ Attente du démarrage du backend..."
sleep 15

# Tester le téléchargement
echo "📥 Test de téléchargement du fichier test..."
curl -I http://localhost:8081/api/files/test_download.txt

echo ""
echo "📋 Vérification du dossier uploads..."
ls -la backend/uploads/

echo ""
echo "🌐 Test de l'endpoint des prestataires..."
curl -I http://localhost:8081/api/prestataires
