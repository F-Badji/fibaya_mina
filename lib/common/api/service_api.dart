import 'api_service.dart';
import '../models/service.dart';

class ServiceApi {
  // Récupérer tous les services
  static Future<List<Service>> getAllServices() async {
    try {
      final response = await ApiService.get('/services');
      final List<dynamic> servicesData = response['data'] ?? [];

      return servicesData.map((json) => Service.fromJson(json)).toList();
    } catch (e) {
      // En cas d'erreur, retourner les services par défaut
      return _getDefaultServices();
    }
  }

  // Récupérer un service par ID
  static Future<Service?> getServiceById(int id) async {
    try {
      final response = await ApiService.get('/services/$id');
      return Service.fromJson(response['data']);
    } catch (e) {
      return null;
    }
  }

  // Services par défaut (fallback)
  static List<Service> _getDefaultServices() {
    return [
      Service(
        id: 1,
        name: 'Plombier',
        description: 'Installation et réparation de plomberie',
        icon: '🔧',
        category: 'Réparation',
      ),
      Service(
        id: 2,
        name: 'Électricien',
        description: 'Installation et maintenance électrique',
        icon: '⚡',
        category: 'Électricité',
      ),
      Service(
        id: 3,
        name: 'Mécanicien',
        description: 'Réparation et maintenance automobile',
        icon: '🔧',
        category: 'Automobile',
      ),
      Service(
        id: 4,
        name: 'Nettoyage',
        description: 'Services de nettoyage et ménage',
        icon: '🧹',
        category: 'Ménage',
      ),
      Service(
        id: 5,
        name: 'Cuisine',
        description: 'Services culinaires et restauration',
        icon: '👨‍🍳',
        category: 'Culinaire',
      ),
      Service(
        id: 6,
        name: 'Beauté',
        description: 'Services de beauté et coiffure',
        icon: '💄',
        category: 'Beauté',
      ),
      Service(
        id: 7,
        name: 'Jardinage',
        description: 'Entretien et aménagement de jardins',
        icon: '🌱',
        category: 'Jardin',
      ),
      Service(
        id: 8,
        name: 'Peinture',
        description: 'Peinture et décoration intérieure',
        icon: '🎨',
        category: 'Décoration',
      ),
      Service(
        id: 9,
        name: 'Maçonnerie',
        description: 'Travaux de maçonnerie et construction',
        icon: '🧱',
        category: 'Construction',
      ),
      Service(
        id: 10,
        name: 'Climatisation',
        description: 'Installation et maintenance de climatisation',
        icon: '❄️',
        category: 'Climatisation',
      ),
    ];
  }
}
