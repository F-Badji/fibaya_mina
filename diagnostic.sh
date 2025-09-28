#!/bin/bash

echo "🔍 Diagnostic de l'interface React..."

# Vérifier si le dossier admin existe
if [ -d "admin" ]; then
    echo "✅ Dossier admin existe"
else
    echo "❌ Dossier admin n'existe pas"
    exit 1
fi

# Vérifier si package.json existe
if [ -f "admin/package.json" ]; then
    echo "✅ package.json existe"
else
    echo "❌ package.json n'existe pas"
    exit 1
fi

# Vérifier si node_modules existe
if [ -d "admin/node_modules" ]; then
    echo "✅ node_modules existe"
else
    echo "❌ node_modules n'existe pas - installation nécessaire"
    cd admin && npm install
fi

# Vérifier les processus sur le port 8080
echo "🔍 Vérification du port 8080..."
if lsof -i :8080 >/dev/null 2>&1; then
    echo "⚠️  Port 8080 est occupé"
    lsof -i :8080
else
    echo "✅ Port 8080 est libre"
fi

echo "🚀 Tentative de démarrage..."
cd admin && npm run dev
