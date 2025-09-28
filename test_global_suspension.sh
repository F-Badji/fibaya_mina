#!/bin/bash

echo "🧪 Test du système de suspension GLOBALE"
echo "========================================"

# Variables
BASE_URL="http://localhost:8081"
API_BASE="$BASE_URL/api/prestataires"

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Fonction pour afficher les résultats
log_result() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✅ SUCCÈS: $2${NC}"
    else
        echo -e "${RED}❌ ÉCHEC: $2${NC}"
        echo "Détails de l'erreur:"
        echo "$3"
        exit 1
    fi
}

# --- Étape 1: Créer un prestataire pour le test ---
echo -e "\n${YELLOW}--- Étape 1: Création d'un prestataire de test ---${NC}"
TEST_PHONE="+221780000000"
TEST_NOM="TestNom"
TEST_PRENOM="TestPrenom"

# Supprimer le prestataire s'il existe déjà pour un test propre
echo "Tentative de suppression d'un prestataire existant avec le téléphone $TEST_PHONE..."
DELETE_RESPONSE=$(curl -s -X DELETE "$API_BASE/delete-by-telephone/$TEST_PHONE")
echo "Réponse suppression (si existant): $DELETE_RESPONSE"

CREATE_PAYLOAD='{
    "nom": "'"$TEST_NOM"'",
    "prenom": "'"$TEST_PRENOM"'",
    "telephone": "'"$TEST_PHONE"'",
    "serviceType": "Plomberie",
    "experience": "5",
    "statut": "EN_ATTENTE",
    "typeService": "A_DOMICILE",
    "description": "Prestataire de test pour la suspension globale",
    "ville": "Dakar",
    "codePostal": "10000",
    "adresse": "Rue Test"
}'

CREATE_RESPONSE=$(curl -s -X POST -H "Content-Type: application/json" -d "$CREATE_PAYLOAD" "$API_BASE")
CREATE_STATUS=$?
log_result $CREATE_STATUS "Création du prestataire de test" "$CREATE_RESPONSE"

if [ $CREATE_STATUS -ne 0 ]; then
    echo "Impossible de créer le prestataire de test. Arrêt des tests."
    exit 1
fi

# Extraire l'ID du prestataire créé
PRESTATAIRE_ID=$(echo "$CREATE_RESPONSE" | grep -o '"id":[0-9]*' | grep -o '[0-9]*')
if [ -z "$PRESTATAIRE_ID" ]; then
    echo -e "${RED}❌ ÉCHEC: Impossible d'extraire l'ID du prestataire créé.${NC}"
    exit 1
fi
echo -e "${GREEN}Prestataire de test créé avec ID: $PRESTATAIRE_ID${NC}"

# --- Étape 2: Valider le prestataire ---
echo -e "\n${YELLOW}--- Étape 2: Validation du prestataire ---${NC}"
VALIDATE_RESPONSE=$(curl -s -X PATCH "$API_BASE/$PRESTATAIRE_ID/valider?validePar=test_script")
VALIDATE_STATUS=$?
log_result $VALIDATE_STATUS "Validation du prestataire" "$VALIDATE_RESPONSE"

if echo "$VALIDATE_RESPONSE" | grep -q '"success":true'; then
    echo -e "${GREEN}✅ SUCCÈS: Le prestataire a été validé avec succès.${NC}"
else
    echo -e "${RED}❌ ÉCHEC: La validation du prestataire a échoué.${NC}"
    echo "Réponse: $VALIDATE_RESPONSE"
    exit 1
fi

# --- Étape 3: Vérifier que le prestataire EST validé ---
echo -e "\n${YELLOW}--- Étape 3: Vérification de la validation ---${NC}"
CHECK_VALIDATION_RESPONSE=$(curl -s "$API_BASE/check-validation/$TEST_PHONE")
CHECK_VALIDATION_STATUS=$?
log_result $CHECK_VALIDATION_STATUS "Vérification de la validation" "$CHECK_VALIDATION_RESPONSE"

if echo "$CHECK_VALIDATION_RESPONSE" | grep -q '"isValide":true'; then
    echo -e "${GREEN}✅ SUCCÈS: Le prestataire est validé (attendu).${NC}"
else
    echo -e "${RED}❌ ÉCHEC: Le prestataire n'est pas validé après validation.${NC}"
    echo "Réponse: $CHECK_VALIDATION_RESPONSE"
    exit 1
fi

echo -e "\n${GREEN}🎉 Test de validation terminé avec succès!${NC}"

echo -e "\n${YELLOW}📱 Instructions pour tester la suspension GLOBALE:${NC}"
echo "1. Ouvrez l'app Flutter"
echo "2. Connectez-vous avec le numéro: $TEST_PHONE"
echo "3. Naviguez entre les différents écrans (Accueil, Commandes, Carte, Portefeuille, Profil)"
echo "4. Dans l'interface admin, suspendez le prestataire"
echo "5. L'app devrait IMMÉDIATEMENT rediriger vers l'écran d'authentification"
echo "6. Peu importe l'écran où vous étiez, la redirection doit être instantanée"
echo "7. L'utilisateur sera traité comme un nouveau utilisateur"

echo -e "\n${YELLOW}⏱️  Détection rapide:${NC}"
echo "- Vérification toutes les 10 secondes"
echo "- Redirection immédiate sans dialog"
echo "- Suppression de toutes les routes précédentes"

echo -e "\n${YELLOW}🧹 Nettoyage:${NC}"
echo "Pour nettoyer après le test, exécutez:"
echo "curl -X DELETE '$API_BASE/delete-by-telephone/$TEST_PHONE'"
echo "PGPASSWORD=5334 psql -h localhost -p 5432 -U postgres -d Fibaya -c \"DELETE FROM prestataires_valides WHERE telephone = '$TEST_PHONE';\""
