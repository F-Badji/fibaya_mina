#!/bin/bash

# Script de démarrage pour Fibaya
echo "🚀 Démarrage de Fibaya..."

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fonction pour afficher les messages
print_message() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}================================${NC}"
}

# Vérifier si PostgreSQL est installé et en cours d'exécution
check_postgresql() {
    print_message "Vérification de PostgreSQL..."
    
    if ! command -v psql &> /dev/null; then
        print_error "PostgreSQL n'est pas installé. Veuillez l'installer d'abord."
        exit 1
    fi
    
    # Vérifier si PostgreSQL est en cours d'exécution
    if ! pg_isready -q; then
        print_warning "PostgreSQL n'est pas en cours d'exécution. Tentative de démarrage..."
        # Essayer de démarrer PostgreSQL (selon l'OS)
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS
            brew services start postgresql
        elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
            # Linux
            sudo systemctl start postgresql
        fi
        
        # Attendre que PostgreSQL soit prêt
        sleep 3
        if ! pg_isready -q; then
            print_error "Impossible de démarrer PostgreSQL. Veuillez le démarrer manuellement."
            exit 1
        fi
    fi
    
    print_message "PostgreSQL est prêt ✅"
}

# Vérifier si Java est installé
check_java() {
    print_message "Vérification de Java..."
    
    if ! command -v java &> /dev/null; then
        print_error "Java n'est pas installé. Veuillez installer Java 17+ d'abord."
        exit 1
    fi
    
    # Vérifier la version de Java
    java_version=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2 | cut -d'.' -f1)
    if [ "$java_version" -lt 17 ]; then
        print_error "Java 17+ est requis. Version actuelle: $java_version"
        exit 1
    fi
    
    print_message "Java est prêt ✅"
}

# Vérifier si Maven est installé
check_maven() {
    print_message "Vérification de Maven..."
    
    if ! command -v mvn &> /dev/null; then
        print_error "Maven n'est pas installé. Veuillez l'installer d'abord."
        exit 1
    fi
    
    print_message "Maven est prêt ✅"
}

# Vérifier si Flutter est installé
check_flutter() {
    print_message "Vérification de Flutter..."
    
    if ! command -v flutter &> /dev/null; then
        print_error "Flutter n'est pas installé. Veuillez l'installer d'abord."
        exit 1
    fi
    
    print_message "Flutter est prêt ✅"
}

# Créer la base de données
setup_database() {
    print_header "Configuration de la base de données"
    
    # Vérifier si la base de données existe
    if psql -lqt | cut -d \| -f 1 | grep -qw Fibaya; then
        print_message "Base de données 'Fibaya' existe déjà ✅"
    else
        print_message "Création de la base de données 'Fibaya'..."
        psql -c "CREATE DATABASE \"Fibaya\";"
        print_message "Base de données créée ✅"
    fi
    
    # Exécuter le script de configuration
    print_message "Exécution du script de configuration..."
    if [ -f "database/setup.sql" ]; then
        psql -d "Fibaya" -f database/setup.sql
        print_message "Script de configuration exécuté ✅"
    else
        print_warning "Fichier database/setup.sql non trouvé. Création manuelle des tables..."
        # Les tables seront créées automatiquement par Hibernate
    fi
}

# Démarrer le backend
start_backend() {
    print_header "Démarrage du Backend"
    
    cd backend
    
    print_message "Installation des dépendances Maven..."
    mvn clean install -q
    
    print_message "Démarrage du serveur Spring Boot..."
    mvn spring-boot:run &
    
    BACKEND_PID=$!
    echo $BACKEND_PID > ../backend.pid
    
    # Attendre que le serveur soit prêt
    print_message "Attente du démarrage du serveur..."
    sleep 10
    
    # Vérifier si le serveur répond
    if curl -s http://localhost:8080/api/services > /dev/null; then
        print_message "Backend démarré avec succès ✅"
        print_message "API disponible sur: http://localhost:8080/api"
    else
        print_warning "Le backend semble prendre plus de temps à démarrer..."
        print_message "Vérifiez manuellement: http://localhost:8080/api/services"
    fi
    
    cd ..
}

# Démarrer l'application Flutter
start_flutter() {
    print_header "Démarrage de l'application Flutter"
    
    print_message "Installation des dépendances Flutter..."
    flutter pub get
    
    print_message "Démarrage de l'application client..."
    print_message "L'application Flutter va s'ouvrir dans un nouvel onglet..."
    
    # Démarrer l'app client
    flutter run lib/main_client.dart &
    
    print_message "Application Flutter démarrée ✅"
}

# Fonction principale
main() {
    print_header "FIBAYA - Plateforme de Services"
    print_message "Démarrage de l'environnement de développement..."
    
    # Vérifications préalables
    check_postgresql
    check_java
    check_maven
    check_flutter
    
    # Configuration
    setup_database
    
    # Démarrage des services
    start_backend
    start_flutter
    
    print_header "DÉMARRAGE TERMINÉ"
    print_message "Backend: http://localhost:8080/api"
    print_message "Application Flutter: En cours d'ouverture..."
    print_message ""
    print_message "Pour arrêter les services, exécutez: ./stop.sh"
    print_message "Pour voir les logs du backend: tail -f backend.log"
}

# Gestion des signaux pour arrêter proprement
cleanup() {
    print_message "Arrêt des services..."
    
    if [ -f "backend.pid" ]; then
        BACKEND_PID=$(cat backend.pid)
        kill $BACKEND_PID 2>/dev/null
        rm backend.pid
    fi
    
    # Arrêter les processus Flutter
    pkill -f "flutter run"
    
    print_message "Services arrêtés ✅"
    exit 0
}

# Capturer les signaux d'arrêt
trap cleanup SIGINT SIGTERM

# Exécuter la fonction principale
main "$@"















