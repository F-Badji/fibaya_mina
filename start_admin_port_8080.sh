#!/bin/bash

echo "🚀 Démarrage de l'interface d'administration FIBAYA sur le port 8080..."

# Arrêter tous les processus qui utilisent le port 8080
echo "🛑 Libération du port 8080..."
lsof -ti:8080 | xargs kill -9 2>/dev/null || true

# Attendre un peu pour que le port soit libéré
sleep 2

# Naviguer vers le dossier de l'interface d'administration
cd admin

# Démarrer l'application React en mode développement sur le port 8080
echo "🌐 Démarrage de l'application React sur http://localhost:8080..."
npm run dev
