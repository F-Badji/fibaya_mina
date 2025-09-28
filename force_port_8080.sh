#!/bin/bash

echo "🚀 Force le port 8080 pour l'interface React..."

# Arrêter tous les processus
echo "🛑 Arrêt de tous les processus..."
pkill -f "vite" 2>/dev/null || true
pkill -f "npm run dev" 2>/dev/null || true

# Libérer le port 8080
echo "🛑 Libération du port 8080..."
lsof -ti:8080 | xargs kill -9 2>/dev/null || true

# Attendre
sleep 2

# Naviguer vers le dossier admin
cd admin

# Démarrer sur le port 8080
echo "🌐 Démarrage sur le port 8080..."
npx vite --port 8080 --host 0.0.0.0
