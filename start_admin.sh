#!/bin/bash

echo "🚀 Démarrage de l'interface d'administration FIBAYA..."

# Naviguer vers le dossier de l'interface d'administration
cd admin

# Installer les dépendances manquantes
echo "📦 Installation des dépendances manquantes..."
npm install @radix-ui/react-tooltip@^1.0.6

# Installer toutes les dépendances
echo "📦 Installation de toutes les dépendances..."
npm install

# Démarrer l'application React en mode développement sur le port 8080
echo "🌐 Démarrage de l'application React sur http://localhost:8080..."
npm run dev