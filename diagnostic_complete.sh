#!/bin/bash

echo "🔍 Diagnostic complet du système..."

echo "1. Vérification de Java..."
java -version

echo ""
echo "2. Vérification de Maven..."
mvn -version

echo ""
echo "3. Vérification du dossier backend..."
ls -la backend/

echo ""
echo "4. Vérification du fichier mvnw..."
ls -la backend/mvnw

echo ""
echo "5. Tentative de compilation..."
cd backend
./mvnw compile

echo ""
echo "6. Tentative de démarrage..."
./mvnw spring-boot:run
