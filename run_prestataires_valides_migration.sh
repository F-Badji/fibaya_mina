#!/bin/bash

# Script pour créer la table des prestataires validés
# Ce script doit être exécuté depuis le répertoire racine du projet

echo "🚀 Création de la table prestataires_valides..."

# Vérifier si PostgreSQL est installé
if ! command -v psql &> /dev/null; then
    echo "❌ PostgreSQL n'est pas installé ou psql n'est pas dans le PATH"
    exit 1
fi

# Variables de connexion (à adapter selon votre configuration)
DB_HOST="localhost"
DB_PORT="5432"
DB_NAME="Fibaya"
DB_USER="postgres"
DB_PASSWORD="5334"

# Exécuter le script SQL
echo "📝 Exécution du script SQL..."
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f create_prestataires_valides_table.sql

if [ $? -eq 0 ]; then
    echo "✅ Table prestataires_valides créée avec succès!"
    echo "📊 Vérification de la table..."
    psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "\d prestataires_valides"
else
    echo "❌ Erreur lors de la création de la table"
    exit 1
fi

echo "🎉 Migration terminée avec succès!"
echo ""
echo "📋 Prochaines étapes:"
echo "1. Redémarrer le backend Spring Boot"
echo "2. Tester la validation dans l'interface admin"
echo "3. Tester la vérification d'approbation dans l'app Flutter"
