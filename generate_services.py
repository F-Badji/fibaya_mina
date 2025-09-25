#!/usr/bin/env python3
"""
Script pour générer automatiquement le code Flutter avec les vrais services de la base de données.
"""

import subprocess
import re

def get_database_services_with_details():
    """Récupère tous les services avec leurs détails depuis la base de données PostgreSQL"""
    try:
        result = subprocess.run([
            'psql', '-h', 'localhost', '-U', 'postgres', '-d', 'Fibaya', 
            '-c', "SELECT id, name, description, icon, category FROM services ORDER BY id;", '-t'
        ], capture_output=True, text=True, check=True)
        
        services = []
        lines = result.stdout.strip().split('\n')
        for line in lines:
            line = line.strip()
            if line and not line.startswith('(') and not line.startswith('-') and '|' in line:
                parts = [part.strip() for part in line.split('|')]
                if len(parts) >= 5:
                    service = {
                        'id': int(parts[0]),
                        'name': parts[1],
                        'description': parts[2] if parts[2] else '',
                        'icon': parts[3] if parts[3] else 'work',
                        'category': parts[4] if parts[4] else 'Autre'
                    }
                    services.append(service)
        
        return services
    except Exception as e:
        print(f"Erreur lors de la récupération des services: {e}")
        return []

def generate_flutter_code(services):
    """Génère le code Flutter pour les services"""
    now = "DateTime.now()"
    
    code = """  // Liste par défaut des services (basée sur la vraie base de données PostgreSQL)
  static List<Service> _getDefaultServices() {
    final now = DateTime.now();
    return ["""
    
    for service in services:
        # Échapper les apostrophes dans les noms
        name = service['name'].replace("'", "\\'")
        description = service['description'].replace("'", "\\'") if service['description'] else ''
        icon = service['icon']
        category = service['category'].replace("'", "\\'")
        
        code += f"""
      Service(
        id: {service['id']},
        name: '{name}',
        description: '{description}',
        icon: '{icon}',
        category: '{category}',
        isActive: true,
        createdAt: now,
      ),"""
    
    code += """
    ];
  }"""
    
    return code

def main():
    print("🔧 Génération du code Flutter pour les services...")
    
    # Récupérer les services de la base de données
    services = get_database_services_with_details()
    print(f"📊 {len(services)} services récupérés de la base de données")
    
    if not services:
        print("❌ Aucun service récupéré. Vérifiez la connexion à la base de données.")
        return
    
    # Générer le code Flutter
    flutter_code = generate_flutter_code(services)
    
    # Lire le fichier existant
    try:
        with open('/Users/macbook/Desktop/fibaya_mina/lib/prestataire_app/services/service_service.dart', 'r', encoding='utf-8') as f:
            content = f.read()
    except Exception as e:
        print(f"Erreur lors de la lecture du fichier: {e}")
        return
    
    # Remplacer la méthode _getDefaultServices
    pattern = r'static List<Service> _getDefaultServices\(\) \{[^}]+\};'
    new_content = re.sub(pattern, flutter_code, content, flags=re.DOTALL)
    
    # Sauvegarder le fichier modifié
    try:
        with open('/Users/macbook/Desktop/fibaya_mina/lib/prestataire_app/services/service_service.dart', 'w', encoding='utf-8') as f:
            f.write(new_content)
        print("✅ Fichier service_service.dart mis à jour avec succès!")
    except Exception as e:
        print(f"Erreur lors de l'écriture du fichier: {e}")
        return
    
    print(f"🎉 {len(services)} services synchronisés avec la base de données!")

if __name__ == "__main__":
    main()
