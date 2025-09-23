#!/bin/bash

# Script d'arrêt pour Fibaya
echo "🛑 Arrêt de Fibaya..."

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

# Arrêter le backend
stop_backend() {
    print_header "Arrêt du Backend"
    
    if [ -f "backend.pid" ]; then
        BACKEND_PID=$(cat backend.pid)
        print_message "Arrêt du processus backend (PID: $BACKEND_PID)..."
        
        if kill $BACKEND_PID 2>/dev/null; then
            print_message "Backend arrêté ✅"
        else
            print_warning "Le processus backend n'était pas en cours d'exécution"
        fi
        
        rm backend.pid
    else
        print_warning "Fichier PID du backend non trouvé"
    fi
    
    # Arrêter tous les processus Java liés à Spring Boot
    print_message "Arrêt des processus Java Spring Boot..."
    pkill -f "spring-boot:run" 2>/dev/null
    pkill -f "fibaya-backend" 2>/dev/null
    
    print_message "Backend complètement arrêté ✅"
}

# Arrêter l'application Flutter
stop_flutter() {
    print_header "Arrêt de l'application Flutter"
    
    print_message "Arrêt des processus Flutter..."
    pkill -f "flutter run" 2>/dev/null
    pkill -f "dart" 2>/dev/null
    
    print_message "Application Flutter arrêtée ✅"
}

# Arrêter PostgreSQL (optionnel)
stop_postgresql() {
    print_header "Arrêt de PostgreSQL (optionnel)"
    
    read -p "Voulez-vous arrêter PostgreSQL? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_message "Arrêt de PostgreSQL..."
        
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS
            brew services stop postgresql
        elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
            # Linux
            sudo systemctl stop postgresql
        fi
        
        print_message "PostgreSQL arrêté ✅"
    else
        print_message "PostgreSQL laissé en cours d'exécution"
    fi
}

# Nettoyer les fichiers temporaires
cleanup() {
    print_header "Nettoyage"
    
    print_message "Suppression des fichiers temporaires..."
    
    # Supprimer les fichiers de log
    rm -f backend.log
    rm -f flutter.log
    
    # Supprimer les fichiers PID
    rm -f backend.pid
    rm -f flutter.pid
    
    # Nettoyer les builds Maven
    if [ -d "backend/target" ]; then
        print_message "Nettoyage des builds Maven..."
        rm -rf backend/target
    fi
    
    print_message "Nettoyage terminé ✅"
}

# Fonction principale
main() {
    print_header "ARRÊT DE FIBAYA"
    
    # Arrêter les services
    stop_backend
    stop_flutter
    
    # Nettoyage optionnel
    cleanup
    
    # Arrêt optionnel de PostgreSQL
    stop_postgresql
    
    print_header "ARRÊT TERMINÉ"
    print_message "Tous les services ont été arrêtés ✅"
    print_message "Pour redémarrer, exécutez: ./start.sh"
}

# Exécuter la fonction principale
main "$@"



