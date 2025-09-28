#!/bin/bash

echo "🚀 Démarrage simple de l'interface React..."

# Aller dans le dossier admin
cd admin

# Démarrer l'interface
echo "🌐 Démarrage sur le port 8080..."
npx vite --port 8080 --host 0.0.0.0
