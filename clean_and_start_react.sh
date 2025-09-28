#!/bin/bash

echo "🧹 Nettoyage complet et démarrage de React..."

# Arrêter tous les processus Flutter
echo "🛑 Arrêt de tous les processus Flutter..."
pkill -f "flutter" 2>/dev/null || true

# Arrêter tous les processus Vite
echo "🛑 Arrêt de tous les processus Vite..."
pkill -f "vite" 2>/dev/null || true

# Arrêter tous les processus npm
echo "🛑 Arrêt de tous les processus npm..."
pkill -f "npm run dev" 2>/dev/null || true

# Libérer le port 8080
echo "🛑 Libération du port 8080..."
lsof -ti:8080 | xargs kill -9 2>/dev/null || true

# Attendre que tout soit arrêté
echo "⏳ Attente de l'arrêt des processus..."
sleep 3

# Vérifier qu'aucun processus ne tourne sur le port 8080
echo "🔍 Vérification du port 8080..."
if lsof -i :8080 >/dev/null 2>&1; then
    echo "❌ Le port 8080 est encore occupé, arrêt forcé..."
    lsof -ti:8080 | xargs kill -9 2>/dev/null || true
    sleep 2
fi

# Naviguer vers le dossier React
cd admin

# Vérifier que c'est bien React
echo "🔍 Vérification du projet React..."
if [ -f "package.json" ] && [ -f "src/main.tsx" ]; then
    echo "✅ Projet React détecté"
else
    echo "❌ Ce n'est pas un projet React !"
    exit 1
fi

# Démarrer React
echo "🚀 Démarrage de React sur le port 8080..."
npm run dev
