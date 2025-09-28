#!/bin/bash

echo "🚀 Mise à jour du projet Fibaya sur GitHub..."

# Vérifier si nous sommes dans un repository git
if [ ! -d ".git" ]; then
    echo "❌ Ce répertoire n'est pas un repository git. Initialisation..."
    git init
    git remote add origin https://github.com/F-Badji/fibaya_mina.git
fi

# Vérifier la configuration git
echo "📋 Configuration git actuelle:"
git config --list | grep -E "(user\.name|user\.email|remote\.origin\.url)" || echo "Configuration git non trouvée"

# Ajouter tous les fichiers modifiés
echo "📁 Ajout des fichiers modifiés..."
git add .

# Vérifier les fichiers ajoutés
echo "📋 Fichiers à commiter:"
git status --porcelain

# Créer un commit avec toutes les améliorations
echo "💾 Création du commit..."
git commit -m "feat: Améliorations complètes du système Fibaya

✅ Fonctionnalités ajoutées:
- Validation des numéros de téléphone uniques
- Stockage physique automatique des fichiers
- Téléchargement de fichiers fonctionnel
- Interface admin React complète
- Gestion des erreurs améliorée

🔧 Corrections techniques:
- Résolution de l'erreur 413 (Payload Too Large)
- Configuration des limites de fichiers (50MB/200MB)
- Correction des warnings Java obsolètes
- Scripts de démarrage automatisés

📱 Applications:
- Flutter: Enregistrement prestataires avec fichiers
- React Admin: Interface d'administration complète
- Backend: API REST avec validation et stockage

🛠️ Scripts créés:
- Scripts de diagnostic et redémarrage
- Scripts de test et validation
- Configuration automatique des environnements

📊 Statistiques:
- Backend: Spring Boot 3.2.0 avec PostgreSQL
- Frontend: Flutter + React avec Tailwind CSS
- Validation: Numéros de téléphone uniques
- Stockage: Fichiers physiques avec UUID"

# Pousser vers GitHub
echo "🌐 Push vers GitHub..."
git push -u origin main

if [ $? -eq 0 ]; then
    echo "✅ Mise à jour GitHub réussie!"
    echo "🔗 Repository: https://github.com/F-Badji/fibaya_mina.git"
    echo ""
    echo "📋 Résumé des améliorations poussées:"
    echo "   - Validation numéros de téléphone uniques"
    echo "   - Stockage physique des fichiers"
    echo "   - Interface admin React complète"
    echo "   - Correction erreur 413"
    echo "   - Scripts de diagnostic et test"
    echo "   - Configuration Java 17"
    echo "   - Gestion d'erreurs améliorée"
else
    echo "❌ Erreur lors du push vers GitHub"
    echo "💡 Vérifiez votre authentification GitHub"
    exit 1
fi

echo ""
echo "🎉 Projet Fibaya mis à jour avec succès sur GitHub!"
