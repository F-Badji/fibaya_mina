#!/bin/bash

echo "🐘 Vérification de PostgreSQL..."

# Vérifier si PostgreSQL est en cours d'exécution
echo "1. Vérification du statut de PostgreSQL..."
brew services list | grep postgresql

echo ""
echo "2. Tentative de connexion à PostgreSQL..."
psql -h localhost -U postgres -d Fibaya -c "SELECT version();"

echo ""
echo "3. Si PostgreSQL n'est pas démarré, le démarrer..."
brew services start postgresql

echo ""
echo "4. Vérification finale..."
psql -h localhost -U postgres -d Fibaya -c "SELECT 'PostgreSQL is running' as status;"
