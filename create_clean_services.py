#!/usr/bin/env python3
"""
Script pour créer un fichier service_service.dart propre avec tous les services de la base de données.
"""

import subprocess

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

def create_clean_service_file(services):
    """Crée un fichier service_service.dart propre"""
    
    # En-tête du fichier
    header = '''import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../common/config.dart';

class ServiceService {
  static String get baseUrl => AppConfig.baseApiUrl;

  // Headers communs
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Obtenir tous les services
  static Future<List<Service>> getAllServices() async {
    try {
      print('🌐 Tentative de connexion à: \$baseUrl/services');
      print('📡 Headers: \$headers');

      final response = await http.get(
        Uri.parse('\$baseUrl/services'),
        headers: headers,
      );

      print('📊 Status Code: \${response.statusCode}');
      print('📄 Response Headers: \${response.headers}');
      print(
        '📝 Response Body (first 200 chars): \${response.body.length > 200 ? response.body.substring(0, 200) + "..." : response.body}',
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        List<Service> services = jsonData
            .map((json) => Service.fromJson(json))
            .toList();
        print('✅ \${services.length} services chargés avec succès');
        return services;
      } else {
        print('❌ Erreur API: \${response.statusCode} - \${response.body}');
        // Retourner une liste par défaut en cas d'erreur
        return _getDefaultServices();
      }
    } catch (e) {
      print('Erreur API getAllServices: \$e');
      // Retourner une liste par défaut en cas d'erreur
      return _getDefaultServices();
    }
  }

  // Liste par défaut des services (basée sur la vraie base de données PostgreSQL)
  static List<Service> _getDefaultServices() {
    final now = DateTime.now();
    return ['''

    # Générer les services
    services_code = ""
    for service in services:
        # Échapper les apostrophes et guillemets
        name = service['name'].replace("'", "\\'").replace('"', '\\"')
        description = service['description'].replace("'", "\\'").replace('"', '\\"') if service['description'] else ''
        icon = service['icon']
        category = service['category'].replace("'", "\\'").replace('"', '\\"')
        
        services_code += f'''
      Service(
        id: {service['id']},
        name: '{name}',
        description: '{description}',
        icon: '{icon}',
        category: '{category}',
        isActive: true,
        createdAt: now,
      ),'''

    # Fin du fichier
    footer = '''
    ];
  }
}

// Modèle Service
class Service {
  final int id;
  final String name;
  final String description;
  final String icon;
  final String category;
  final String? imageUrl;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.category,
    this.imageUrl,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      icon: json['icon'] ?? '🔧',
      category: json['category'] ?? 'Autre',
      imageUrl: json['imageUrl'],
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }
}'''

    return header + services_code + footer

def main():
    print("🔧 Création d'un fichier service_service.dart propre...")
    
    # Récupérer les services de la base de données
    services = get_database_services_with_details()
    print(f"📊 {len(services)} services récupérés de la base de données")
    
    if not services:
        print("❌ Aucun service récupéré. Vérifiez la connexion à la base de données.")
        return
    
    # Créer le contenu du fichier
    file_content = create_clean_service_file(services)
    
    # Sauvegarder le fichier
    try:
        with open('/Users/macbook/Desktop/fibaya_mina/lib/prestataire_app/services/service_service.dart', 'w', encoding='utf-8') as f:
            f.write(file_content)
        print("✅ Fichier service_service.dart créé avec succès!")
    except Exception as e:
        print(f"Erreur lors de l'écriture du fichier: {e}")
        return
    
    print(f"🎉 {len(services)} services synchronisés avec la base de données!")

if __name__ == "__main__":
    main()
