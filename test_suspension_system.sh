#!/bin/bash

echo "🧪 Test du système de suspension automatique"
echo "=============================================="

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
TEST_PHONE="+221771234567"
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
    "description": "Prestataire de test pour la suspension",
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

# --- Étape 4: Suspendre le prestataire ---
echo -e "\n${YELLOW}--- Étape 4: Suspension du prestataire ---${NC}"
SUSPEND_RESPONSE=$(curl -s -X PATCH "$API_BASE/$PRESTATAIRE_ID/suspendre?validePar=test_script")
SUSPEND_STATUS=$?
log_result $SUSPEND_STATUS "Suspension du prestataire" "$SUSPEND_RESPONSE"

if echo "$SUSPEND_RESPONSE" | grep -q '"success":true'; then
    echo -e "${GREEN}✅ SUCCÈS: Le prestataire a été suspendu avec succès.${NC}"
else
    echo -e "${RED}❌ ÉCHEC: La suspension du prestataire a échoué.${NC}"
    echo "Réponse: $SUSPEND_RESPONSE"
    exit 1
fi

# --- Étape 5: Vérifier que le prestataire N'EST PLUS validé ---
echo -e "\n${YELLOW}--- Étape 5: Vérification après suspension ---${NC}"
CHECK_SUSPENDED_RESPONSE=$(curl -s "$API_BASE/check-validation/$TEST_PHONE")
CHECK_SUSPENDED_STATUS=$?
log_result $CHECK_SUSPENDED_STATUS "Vérification après suspension" "$CHECK_SUSPENDED_RESPONSE"

if echo "$CHECK_SUSPENDED_RESPONSE" | grep -q '"isValide":false'; then
    echo -e "${GREEN}✅ SUCCÈS: Le prestataire n'est plus validé après suspension (attendu).${NC}"
else
    echo -e "${RED}❌ ÉCHEC: Le prestataire est encore validé après suspension.${NC}"
    echo "Réponse: $CHECK_SUSPENDED_RESPONSE"
    exit 1
fi

# --- Étape 6: Nettoyage ---
echo -e "\n${YELLOW}--- Étape 6: Nettoyage ---${NC}"
DELETE_RESPONSE_FINAL=$(curl -s -X DELETE "$API_BASE/delete-by-telephone/$TEST_PHONE")
DELETE_STATUS_FINAL=$?
log_result $DELETE_STATUS_FINAL "Suppression du prestataire de test" "$DELETE_RESPONSE_FINAL"

DB_DELETE_RESPONSE=$(PGPASSWORD=5334 psql -h localhost -p 5432 -U postgres -d Fibaya -c "DELETE FROM prestataires_valides WHERE telephone = '$TEST_PHONE';")
DB_DELETE_STATUS=$?
log_result $DB_DELETE_STATUS "Suppression de l'entrée dans prestataires_valides" "$DB_DELETE_RESPONSE"

echo -e "\n${GREEN}🎉 Test du système de suspension terminé avec succès!${NC}"
echo -e "\n${YELLOW}📱 Instructions pour tester dans l'app Flutter:${NC}"
echo "1. Ouvrez l'app Flutter"
echo "2. Connectez-vous avec le numéro: $TEST_PHONE"
echo "3. L'app devrait vérifier le statut toutes les 30 secondes"
echo "4. Dans l'interface admin, suspendez le prestataire"
echo "5. L'app devrait automatiquement rediriger vers l'écran d'authentification"
echo "6. L'alerte 'Compte Suspendu' devrait s'afficher"
