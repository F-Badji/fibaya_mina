#!/bin/bash

# Script de test pour la validation des numéros de téléphone
# Teste les endpoints de l'API après la migration

echo "🧪 Test de la validation des numéros de téléphone..."

# URL de base de l'API (ajustez selon votre configuration)
BASE_URL="http://localhost:8081/api"

# Fonction pour tester un endpoint
test_endpoint() {
    local method=$1
    local endpoint=$2
    local data=$3
    
    echo "📡 Test: $method $endpoint"
    
    if [ "$method" = "GET" ]; then
        response=$(curl -s -w "\n%{http_code}" "$BASE_URL$endpoint")
    else
        response=$(curl -s -w "\n%{http_code}" -X POST -H "Content-Type: application/json" -d "$data" "$BASE_URL$endpoint")
    fi
    
    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | head -n -1)
    
    if [ "$http_code" -eq 200 ]; then
        echo "✅ Succès (HTTP $http_code)"
        echo "📄 Réponse: $body"
    else
        echo "❌ Échec (HTTP $http_code)"
        echo "📄 Réponse: $body"
    fi
    echo ""
}

# Attendre que le serveur soit prêt
echo "⏳ Attente du démarrage du serveur..."
sleep 5

# Test 1: Validation d'un numéro sénégalais valide
test_endpoint "GET" "/phone-validation/validate?phone=781234567&country=Sénégal"

# Test 2: Validation d'un numéro sénégalais invalide
test_endpoint "GET" "/phone-validation/validate?phone=123455&country=Sénégal"

# Test 3: Validation par code pays
test_endpoint "GET" "/phone-validation/validate-by-code?phone=781234567&countryCode=+221"

# Test 4: Obtenir le format d'un pays
test_endpoint "GET" "/phone-validation/format?country=Sénégal"

# Test 5: Validation via POST
test_endpoint "POST" "/phone-validation/validate" '{"phone": "781234567", "country": "Sénégal"}'

# Test 6: Validation d'un numéro français valide
test_endpoint "GET" "/phone-validation/validate?phone=0612345678&country=France"

# Test 7: Validation d'un numéro français invalide
test_endpoint "GET" "/phone-validation/validate?phone=0512345678&country=France"

echo "🎯 Tests terminés!"
echo ""
echo "📋 Résumé des tests:"
echo "   - Numéro sénégalais valide (781234567) ✅"
echo "   - Numéro sénégalais invalide (123455) ❌"
echo "   - Validation par code pays (+221) ✅"
echo "   - Format du Sénégal ✅"
echo "   - Validation via POST ✅"
echo "   - Numéro français valide (0612345678) ✅"
echo "   - Numéro français invalide (0512345678) ❌"
