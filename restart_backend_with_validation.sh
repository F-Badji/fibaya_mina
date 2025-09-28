#!/bin/bash

echo "🔄 Redémarrage du backend avec validation du numéro de téléphone..."

# Arrêter tous les processus Java
echo "⏹️ Arrêt des processus Java..."
pkill -f "java"

# Attendre un peu
sleep 3

# Vérifier que le port 8081 est libre
echo "🔍 Vérification du port 8081..."
lsof -i :8081

# Compiler et démarrer le backend
echo "🚀 Compilation et démarrage du backend..."
cd backend
mvn clean compile
mvn spring-boot:run > ../backend_startup.log 2>&1 &
BACKEND_PID=$!

echo "Backend démarré avec PID: $BACKEND_PID"
echo "Vérification des logs dans backend_startup.log..."

# Attendre que le backend démarre
sleep 15

# Vérifier si le backend a démarré correctement
if grep -q "Tomcat started on port 8081" ../backend_startup.log; then
    echo "✅ Backend Spring Boot démarré avec succès sur le port 8081"
    echo "🔍 Test de l'endpoint de validation..."
    curl -I http://localhost:8081/api/prestataires
else
    echo "❌ Le backend n'a pas démarré correctement. Vérifiez backend_startup.log"
    kill $BACKEND_PID
    exit 1
fi

cd ..
echo "✅ Redémarrage terminé!"
