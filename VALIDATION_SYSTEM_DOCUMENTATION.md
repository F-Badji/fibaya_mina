# 🔐 Système de Validation des Prestataires

## 📋 Vue d'ensemble

Le système de validation des prestataires permet aux administrateurs de valider automatiquement les prestataires et de stocker leurs numéros de téléphone dans une base de données pour vérification ultérieure lors de la connexion.

## 🏗️ Architecture

### Backend (Spring Boot)
- **Modèle**: `PrestataireValide` - Entité pour stocker les prestataires validés
- **Repository**: `PrestataireValideRepository` - Accès aux données
- **Service**: `PrestataireValideService` - Logique métier
- **Controller**: `PrestataireController` - Endpoints API

### Base de données
- **Table**: `prestataires_valides` - Stockage des numéros validés
- **Index**: Optimisation des recherches par téléphone et statut

### Frontend Admin (React/TypeScript)
- **Page**: `Prestataires.tsx` - Interface de gestion des prestataires
- **Dashboard**: `Dashboard.tsx` - Vue d'ensemble avec validation rapide

### Application Flutter
- **Screen**: `prestataire_auth_screen.dart` - Vérification d'approbation avant SMS

## 🚀 Fonctionnalités

### 1. Validation par l'Administrateur
- **Bouton "Valider"** dans l'interface admin
- **Validation automatique** avec mise à jour du statut
- **Insertion en base** du numéro de téléphone validé
- **Feedback utilisateur** avec messages de succès/erreur

### 2. Vérification d'Approbation
- **API endpoint** pour vérifier si un numéro est validé
- **Intégration Flutter** pour vérifier avant la vérification SMS
- **Redirection conditionnelle** selon le statut d'approbation

### 3. Gestion des Statuts
- **VALIDE**: Prestataire approuvé par l'admin
- **SUSPENDU**: Prestataire suspendu
- **DISPONIBLE**: Statut mis à jour dans la table principale

## 📡 Endpoints API

### Validation d'un prestataire
```http
PATCH /api/prestataires/{id}/valider?validePar=admin
```

**Réponse:**
```json
{
  "success": true,
  "message": "Prestataire validé avec succès et ajouté à la liste des validés",
  "prestataire": { ... },
  "telephone": "+221781234567"
}
```

### Vérification d'approbation
```http
GET /api/prestataires/check-validation/{telephone}
```

**Réponse:**
```json
{
  "telephone": "+221781234567",
  "isValide": true,
  "message": "Numéro validé par l'administrateur"
}
```

## 🗄️ Structure de la Base de Données

### Table `prestataires_valides`
```sql
CREATE TABLE prestataires_valides (
    id BIGSERIAL PRIMARY KEY,
    telephone VARCHAR(20) NOT NULL UNIQUE,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    date_validation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    valide_par VARCHAR(100),
    statut VARCHAR(20) NOT NULL DEFAULT 'VALIDE'
);
```

## 🔄 Flux de Validation

### 1. Côté Administrateur
1. L'admin consulte la liste des prestataires
2. Il clique sur "Valider" pour un prestataire
3. L'API met à jour le statut vers "DISPONIBLE"
4. Le numéro est ajouté à la table `prestataires_valides`
5. Confirmation de validation affichée

### 2. Côté Prestataire (Flutter)
1. Le prestataire saisit son numéro de téléphone
2. L'app vérifie l'approbation via l'API
3. Si validé → Redirection vers vérification SMS
4. Si non validé → Affichage du dialogue "Devenir Prestataire"

## 🛠️ Installation et Configuration

### 1. Créer la table en base
```bash
./run_prestataires_valides_migration.sh
```

### 2. Redémarrer le backend
```bash
cd backend
mvn spring-boot:run
```

### 3. Tester la validation
1. Aller dans l'interface admin
2. Cliquer sur "Valider" pour un prestataire
3. Vérifier que le statut change
4. Tester la connexion avec ce numéro dans l'app Flutter

## 🔍 Tests

### Test de validation
1. **Interface Admin**: Cliquer sur "Valider"
2. **Vérification**: Le prestataire apparaît avec statut "DISPONIBLE"
3. **Base de données**: Le numéro est dans `prestataires_valides`

### Test de vérification
1. **App Flutter**: Saisir le numéro validé
2. **Résultat**: Redirection vers vérification SMS
3. **Numéro non validé**: Affichage du dialogue d'inscription

## 🚨 Gestion des Erreurs

### Erreurs Backend
- **Prestataire non trouvé**: 404 Not Found
- **Erreur de validation**: 500 Internal Server Error
- **Numéro déjà validé**: Mise à jour du statut existant

### Erreurs Frontend
- **Connexion API**: Fallback vers statut non validé
- **Timeout**: Affichage d'erreur utilisateur
- **Données manquantes**: Validation côté client

## 📈 Améliorations Futures

1. **Notifications**: Envoyer un SMS au prestataire validé
2. **Historique**: Log des actions d'administration
3. **Validation en masse**: Sélection multiple de prestataires
4. **Statistiques**: Dashboard des validations
5. **Audit**: Traçabilité des modifications

## 🔒 Sécurité

- **Authentification admin**: Vérifier les permissions
- **Validation des données**: Sanitisation des entrées
- **Rate limiting**: Limiter les appels API
- **Logs**: Enregistrer toutes les actions sensibles
