#!/bin/bash

# Script de test pour le système de validation des prestataires
# Ce script teste les endpoints API et vérifie le fonctionnement

echo "🧪 Test du système de validation des prestataires"
echo "=================================================="

# Variables
BASE_URL="http://localhost:8081"
API_BASE="$BASE_URL/api/prestataires"

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Fonction pour tester un endpoint
test_endpoint() {
    local method=$1
    local url=$2
    local expected_status=$3
    local description=$4
    
    echo -n "🔍 $description... "
    
    if [ "$method" = "GET" ]; then
        response=$(curl -s -w "%{http_code}" -o /tmp/response.json "$url")
    elif [ "$method" = "PATCH" ]; then
        response=$(curl -s -w "%{http_code}" -o /tmp/response.json -X PATCH "$url")
    fi
    
    if [ "$response" = "$expected_status" ]; then
        echo -e "${GREEN}✅ OK${NC}"
        if [ -f /tmp/response.json ]; then
            echo "   📄 Réponse: $(cat /tmp/response.json)"
        fi
    else
        echo -e "${RED}❌ ÉCHEC${NC} (Status: $response, Attendu: $expected_status)"
        if [ -f /tmp/response.json ]; then
            echo "   📄 Réponse: $(cat /tmp/response.json)"
        fi
    fi
    echo ""
}

# Vérifier que le backend est démarré
echo "🔌 Vérification de la connexion au backend..."
if curl -s "$BASE_URL/actuator/health" > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Backend accessible${NC}"
else
    echo -e "${RED}❌ Backend non accessible. Veuillez démarrer le backend Spring Boot.${NC}"
    exit 1
fi
echo ""

# Test 1: Récupérer la liste des prestataires
echo "📋 Test 1: Récupération des prestataires"
test_endpoint "GET" "$API_BASE/disponibles" "200" "Liste des prestataires disponibles"

# Test 2: Vérifier la validation d'un numéro (numéro de test)
echo "📱 Test 2: Vérification de validation"
test_endpoint "GET" "$API_BASE/check-validation/+221781234567" "200" "Vérification numéro de test"

# Test 3: Valider un prestataire (ID 1 - si il existe)
echo "✅ Test 3: Validation d'un prestataire"
test_endpoint "PATCH" "$API_BASE/1/valider?validePar=test-admin" "200" "Validation prestataire ID 1"

# Test 4: Vérifier à nouveau la validation du numéro
echo "🔄 Test 4: Vérification après validation"
test_endpoint "GET" "$API_BASE/check-validation/+221781234567" "200" "Vérification après validation"

echo "🎯 Tests terminés!"
echo ""
echo "📋 Prochaines étapes:"
echo "1. Vérifier l'interface admin: http://localhost:3000"
echo "2. Tester la validation via l'interface web"
echo "3. Tester l'app Flutter avec un numéro validé"
echo ""
echo "💡 Pour tester avec un vrai prestataire:"
echo "   1. Créer un prestataire via l'API ou l'interface"
echo "   2. Noter son ID"
echo "   3. Utiliser cet ID dans le test de validation"
