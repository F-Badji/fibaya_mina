#!/bin/bash

echo "🚀 Démarrage de l'interface d'administration FIBAYA..."

# Naviguer vers le dossier de l'interface d'administration
cd admin

# Installer les dépendances (si ce n'est pas déjà fait)
echo "📦 Installation des dépendances npm..."
npm install

# Démarrer l'application React en mode développement sur le port 8080
echo "🌐 Démarrage de l'application React sur http://localhost:8080..."
npm run dev