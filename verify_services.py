#!/usr/bin/env python3
"""
Script pour vérifier que tous les services de la base de données PostgreSQL
sont correctement récupérés et affichés dans l'interface Flutter.
"""

import psycopg2
import re

def get_database_services():
    """Récupère tous les services depuis la base de données PostgreSQL"""
    try:
        conn = psycopg2.connect(
            host="localhost",
            database="Fibaya",
            user="postgres",
            password="5334"
        )
        cur = conn.cursor()
        cur.execute("SELECT name FROM services ORDER BY name;")
        services = [row[0] for row in cur.fetchall()]
        cur.close()
        conn.close()
        return services
    except Exception as e:
        print(f"Erreur lors de la connexion à la base de données: {e}")
        return []

def get_flutter_services():
    """Extrait les services du fichier service_service.dart"""
    try:
        with open('/Users/macbook/Desktop/fibaya_mina/lib/prestataire_app/services/service_service.dart', 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Extraire les noms des services depuis le code
        services = []
        # Chercher les patterns "name: 'Service Name'"
        pattern = r"name:\s*'([^']+)'"
        matches = re.findall(pattern, content)
        services.extend(matches)
        
        return services
    except Exception as e:
        print(f"Erreur lors de la lecture du fichier Flutter: {e}")
        return []

def main():
    print("🔍 Vérification des services...")
    print("=" * 50)
    
    # Récupérer les services de la base de données
    db_services = get_database_services()
    print(f"📊 Services dans la base de données: {len(db_services)}")
    
    # Récupérer les services du code Flutter
    flutter_services = get_flutter_services()
    print(f"📱 Services dans le code Flutter: {len(flutter_services)}")
    
    print("\n🔍 Comparaison des services:")
    print("-" * 30)
    
    # Convertir en sets pour faciliter la comparaison
    db_set = set(db_services)
    flutter_set = set(flutter_services)
    
    # Services manquants dans Flutter
    missing_in_flutter = db_set - flutter_set
    if missing_in_flutter:
        print(f"❌ Services manquants dans Flutter ({len(missing_in_flutter)}):")
        for service in sorted(missing_in_flutter):
            print(f"   - {service}")
    else:
        print("✅ Tous les services de la base de données sont présents dans Flutter")
    
    # Services supplémentaires dans Flutter
    extra_in_flutter = flutter_set - db_set
    if extra_in_flutter:
        print(f"⚠️  Services supplémentaires dans Flutter ({len(extra_in_flutter)}):")
        for service in sorted(extra_in_flutter):
            print(f"   - {service}")
    else:
        print("✅ Aucun service supplémentaire dans Flutter")
    
    # Services communs
    common_services = db_set & flutter_set
    print(f"✅ Services communs: {len(common_services)}")
    
    print("\n📋 Résumé:")
    print(f"   Base de données: {len(db_services)} services")
    print(f"   Code Flutter: {len(flutter_services)} services")
    print(f"   Correspondance: {len(common_services)}/{len(db_services)} ({len(common_services)/len(db_services)*100:.1f}%)")
    
    if len(common_services) == len(db_services) and len(extra_in_flutter) == 0:
        print("\n🎉 SUCCÈS: Tous les services sont correctement synchronisés!")
    else:
        print("\n⚠️  ATTENTION: Il y a des différences entre la base de données et le code Flutter")

if __name__ == "__main__":
    main()
