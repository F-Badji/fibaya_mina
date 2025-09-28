#!/bin/bash

echo "🧪 Test simple du backend..."

# Aller dans le dossier backend
cd backend

# Tester la compilation
echo "🔨 Test de compilation..."
./mvnw compile

# Si la compilation réussit, démarrer le serveur
if [ $? -eq 0 ]; then
    echo "✅ Compilation réussie"
    echo "🚀 Démarrage du serveur..."
    ./mvnw spring-boot:run
else
    echo "❌ Erreur de compilation"
fi
