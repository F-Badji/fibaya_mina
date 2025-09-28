#!/bin/bash

echo "🔍 Test de validation du numéro de téléphone unique..."

echo "1. Vérification du backend Spring Boot..."
lsof -i :8081

echo ""
echo "2. Test de l'endpoint des prestataires..."
curl -X GET http://localhost:8081/api/prestataires

echo ""
echo "3. Test d'enregistrement avec un numéro de téléphone existant..."
curl -X POST http://localhost:8081/api/prestataires/with-files \
  -F "nom=Test" \
  -F "prenom=Duplicate" \
  -F "telephone=+221771234567" \
  -F "serviceType=Danseur(e)" \
  -F "typeService=LES_DEUX" \
  -F "experience=5" \
  -F "description=Test duplicate phone"

echo ""
echo "4. Test d'enregistrement avec un nouveau numéro de téléphone..."
curl -X POST http://localhost:8081/api/prestataires/with-files \
  -F "nom=Test" \
  -F "prenom=New" \
  -F "telephone=+221771234568" \
  -F "serviceType=Danseur(e)" \
  -F "typeService=LES_DEUX" \
  -F "experience=5" \
  -F "description=Test new phone"

echo ""
echo "✅ Test de validation terminé!"