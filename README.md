# Fibaya - Plateforme de Services

## 📱 Description
Fibaya est une plateforme mobile qui connecte les clients avec des prestataires de services locaux. L'application permet de réserver des services à domicile ou en présence, avec géolocalisation et suivi en temps réel.

## 🏗️ Architecture

### Frontend (Flutter)
- **Client App** : Application mobile pour les clients
- **Prestataire App** : Application mobile pour les prestataires
- **Admin App** : Interface web d'administration

### Backend (Java/Spring Boot)
- **API REST** : Endpoints pour toutes les applications
- **Base de données** : PostgreSQL
- **Géolocalisation** : Intégration Google Maps

## 🚀 Structure du Projet

```
fibaya_mina/
│
├── lib/                         # Flutter (Frontend)
│   ├── common/                  # Code partagé
│   │   ├── api/                 # Services API
│   │   ├── models/              # Modèles de données
│   │   ├── widgets/             # Widgets réutilisables
│   │   ├── utils/               # Helpers
│   │   └── theme.dart           # Styles globaux
│   │
│   ├── client_app/              # App Client
│   │   ├── screens/             # UI Client
│   │   └── controllers/         
│   │
│   ├── prestataire_app/         # App Prestataire
│   │   ├── screens/             
│   │   └── controllers/         
│   │
│   ├── admin_app/               # App Admin (Web)
│   │   ├── screens/             
│   │   └── controllers/         
│   │
│   ├── main_client.dart         # Entrée Client
│   ├── main_prestataire.dart    # Entrée Prestataire
│   └── main_admin.dart          # Entrée Admin
│
├── backend/                     # Java / Spring Boot
│   ├── src/main/java/com/fibaya/backend/
│   │   ├── controllers/         # Endpoints REST
│   │   ├── services/            # Logique métier
│   │   ├── repositories/        # DAO
│   │   ├── models/              # Entités
│   │   └── FibayaBackendApplication.java
│   │
│   ├── src/main/resources/
│   │   ├── application.properties
│   │   └── data.sql
│   │
│   └── pom.xml
│
└── README.md
```

## 🛠️ Technologies

### Frontend
- **Flutter** : Framework mobile cross-platform
- **Google Maps** : Cartographie et géolocalisation
- **Material Design** : Interface utilisateur

### Backend
- **Java 17** : Langage de programmation
- **Spring Boot 3.2.0** : Framework backend
- **Spring Data JPA** : Persistance des données
- **PostgreSQL** : Base de données
- **Maven** : Gestion des dépendances

## 📋 Prérequis

### Flutter
- Flutter SDK 3.0+
- Dart SDK 3.0+
- Android Studio / VS Code
- Android SDK / Xcode

### Backend
- Java 17+
- Maven 3.6+
- PostgreSQL 13+
- IDE (IntelliJ IDEA / Eclipse)

## 🚀 Installation

### 1. Cloner le projet
```bash
git clone <repository-url>
cd fibaya_mina
```

### 2. Configuration Flutter
```bash
# Installer les dépendances
flutter pub get

# Lancer l'app client
flutter run lib/main_client.dart

# Lancer l'app prestataire
flutter run lib/main_prestataire.dart

# Lancer l'app admin (Web)
flutter run -d chrome lib/main_admin.dart
```

### 3. Configuration Backend
```bash
cd backend

# Installer les dépendances
mvn clean install

# Lancer l'application
mvn spring-boot:run
```

### 4. Configuration Base de données
```sql
-- Créer la base de données
CREATE DATABASE Fibaya;

-- L'application créera automatiquement les tables
-- Les données initiales seront insérées via data.sql
```

## 🔧 Configuration

### Flutter
- **Google Maps API Key** : Configuré dans `android/app/src/main/AndroidManifest.xml`
- **API Base URL** : `http://localhost:8080/api` (configuré dans `common/api/api_service.dart`)

### Backend
- **Port** : 8080 (configuré dans `application.properties`)
- **Base de données** : PostgreSQL sur localhost:5432
- **CORS** : Activé pour toutes les origines

## 📱 Fonctionnalités

### Client App
- ✅ Écran d'accueil avec services
- ✅ Sélection de service (À domicile / En présence)
- ✅ Liste des prestataires
- ✅ Carte avec géolocalisation
- ✅ Réservation de services
- ✅ Suivi en temps réel

### Prestataire App
- 🔄 À développer

### Admin App
- 🔄 À développer

## 🗄️ Base de données

### Tables principales
- **users** : Utilisateurs (clients, prestataires, admins)
- **services** : Services disponibles
- **provider_services** : Services proposés par les prestataires
- **bookings** : Réservations
- **provider_reviews** : Avis sur les prestataires

## 🔌 API Endpoints

### Services
- `GET /api/services` - Liste des services
- `GET /api/services/{id}` - Service par ID
- `GET /api/services/category/{category}` - Services par catégorie

### Prestataires
- `GET /api/providers` - Liste des prestataires
- `GET /api/providers/service/{serviceId}` - Prestataires par service
- `GET /api/providers/nearby` - Prestataires proches

### Utilisateurs
- `GET /api/users` - Liste des utilisateurs
- `POST /api/users` - Créer un utilisateur
- `PUT /api/users/{id}` - Modifier un utilisateur

## 🚀 Déploiement

### Flutter
```bash
# Build Android
flutter build apk --release

# Build iOS
flutter build ios --release

# Build Web
flutter build web --release
```

### Backend
```bash
# Build JAR
mvn clean package

# Lancer le JAR
java -jar target/fibaya-backend-1.0.0.jar
```

## 📝 Développement

### VS Code Configuration
Le fichier `.vscode/launch.json` permet de lancer facilement chaque application :
- **Client App** : Lance l'app client
- **Prestataire App** : Lance l'app prestataire
- **Admin App (Web)** : Lance l'app admin sur Chrome

### Structure des commits
```
feat: nouvelle fonctionnalité
fix: correction de bug
docs: documentation
style: formatage
refactor: refactoring
test: tests
chore: tâches de maintenance
```

## 🤝 Contribution

1. Fork le projet
2. Créer une branche feature (`git checkout -b feature/nouvelle-fonctionnalite`)
3. Commit les changements (`git commit -m 'feat: ajouter nouvelle fonctionnalité'`)
4. Push vers la branche (`git push origin feature/nouvelle-fonctionnalite`)
5. Ouvrir une Pull Request

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.

## 📞 Support

Pour toute question ou problème, contactez l'équipe de développement.

---

**Fibaya** - Connecter les services, simplifier la vie 🚀