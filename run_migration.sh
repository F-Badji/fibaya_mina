#!/bin/bash

# Script pour exécuter la migration de validation des numéros de téléphone
# Assurez-vous que PostgreSQL est démarré et que la base de données Fibaya existe

echo "🚀 Démarrage de la migration de validation des numéros de téléphone..."

# Vérifier si PostgreSQL est en cours d'exécution
if ! pg_isready -q; then
    echo "❌ PostgreSQL n'est pas en cours d'exécution. Veuillez démarrer PostgreSQL d'abord."
    exit 1
fi

# Vérifier si la base de données Fibaya existe
if ! psql -lqt | cut -d \| -f 1 | grep -qw "Fibaya"; then
    echo "❌ La base de données 'Fibaya' n'existe pas. Veuillez la créer d'abord."
    echo "💡 Vous pouvez utiliser le script database/setup.sql"
    exit 1
fi

echo "✅ PostgreSQL est en cours d'exécution"
echo "✅ Base de données 'Fibaya' trouvée"

# Exécuter la migration
echo "📝 Exécution de la migration..."
psql -d "Fibaya" -f database/migration_phone_validation.sql

if [ $? -eq 0 ]; then
    echo "🎉 Migration terminée avec succès!"
    echo ""
    echo "📊 Résumé de la migration:"
    echo "   - Table 'phone_formats' créée avec 100+ pays"
    echo "   - Fonction 'validate_phone_number' créée"
    echo "   - Fonction 'get_phone_format' créée"
    echo "   - Contrainte de validation ajoutée à la table 'users'"
    echo "   - Données des pays insérées dans 'country_codes'"
    echo ""
    echo "🔧 Prochaines étapes:"
    echo "   1. Redémarrer le backend Spring Boot"
    echo "   2. Tester les nouveaux endpoints de validation"
    echo "   3. Vérifier que la validation fonctionne côté serveur"
else
    echo "❌ Erreur lors de l'exécution de la migration"
    exit 1
fi
