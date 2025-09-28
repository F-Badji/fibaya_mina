#!/bin/bash

echo "🚀 Démarrage de l'interface d'administration FIBAYA..."

# Naviguer vers le dossier de l'interface d'administration
cd admin

# Supprimer node_modules et package-lock.json pour forcer une réinstallation propre
echo "🧹 Nettoyage des dépendances existantes..."
rm -rf node_modules package-lock.json

# Installer toutes les dépendances
echo "📦 Installation de toutes les dépendances..."
npm install

# Installer spécifiquement les dépendances Radix UI manquantes
echo "📦 Installation des dépendances Radix UI..."
npm install @radix-ui/react-progress@^1.0.3

# Démarrer l'application React en mode développement sur le port 8080
echo "🌐 Démarrage de l'application React sur http://localhost:8080..."
npm run dev
