#!/bin/bash

echo "🚀 Démarrage complet du système Fibaya..."

# 1. Démarrer PostgreSQL
echo "1. 🐘 Démarrage de PostgreSQL..."
brew services start postgresql
sleep 5

# 2. Vérifier la connexion à la base de données
echo "2. 🔍 Vérification de la base de données..."
psql -h localhost -U postgres -d Fibaya -c "SELECT 'Database connected' as status;" || echo "❌ Erreur de connexion à la base de données"

# 3. Démarrer le backend Spring Boot
echo "3. 🌐 Démarrage du backend Spring Boot..."
cd backend
./mvnw spring-boot:run &
BACKEND_PID=$!

# Attendre que le backend démarre
echo "⏳ Attente du démarrage du backend..."
sleep 30

# 4. Vérifier que le backend fonctionne
echo "4. 🧪 Test du backend..."
curl -I http://localhost:8081/api/prestataires || echo "❌ Backend non accessible"

echo ""
echo "✅ Système démarré !"
echo "🌐 Backend: http://localhost:8081"
echo "📱 Flutter: Prêt à être lancé"
echo "🖥️ React Admin: http://localhost:8080"
