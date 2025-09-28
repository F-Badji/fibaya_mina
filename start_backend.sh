#!/bin/bash

echo "🚀 Démarrage du backend Spring Boot..."

# Aller dans le dossier backend
cd backend

# Démarrer le backend
echo "🌐 Démarrage sur le port 8081..."
./mvnw spring-boot:run
