#!/bin/bash

echo "🚀 Démarrage du backend Spring Boot en mode debug..."

# Aller dans le dossier backend
cd backend

# Compiler d'abord pour voir les erreurs
echo "🔨 Compilation du projet..."
./mvnw compile

echo ""
echo "🌐 Démarrage du serveur Spring Boot..."
./mvnw spring-boot:run
