import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/prestataire.dart';

class PrestataireService {
  static const String baseUrl = 'http://localhost:8080/api';

  // Utiliser les vraies données de la base de données PostgreSQL

  // Méthode pour faire correspondre les services de manière flexible
  static bool _isServiceMatching(
    String prestataireService,
    String clientService,
  ) {
    String prestataire = prestataireService.toLowerCase();
    String client = clientService.toLowerCase();

    // Correspondances exactes pour tous les 50 services
    Map<String, List<String>> correspondances = {
      // BÂTIMENT & CONSTRUCTION
      'plombier': ['plombier'],
      'électricien': ['électricien'],
      'maçon': ['maçon'],
      'peintre en bâtiment': ['peintre en bâtiment', 'peintre'],
      'carreleur': ['carreleur'],
      'couvreur': ['couvreur'],
      'charpentier': ['charpentier'],
      'serrurier': ['serrurier'],
      'vitrier': ['vitrier'],

      // HVAC
      'chauffagiste': ['chauffagiste'],
      'climatiseur': ['climatiseur', 'climatisation'],
      'frigoriste': ['frigoriste'],

      // MÉCANIQUE
      'mécanicien auto': ['mécanicien auto', 'mécanicien'],
      'mécanicien moto': ['mécanicien moto', 'mécanicien'],
      'réparateur électroménager': ['réparateur électroménager'],
      'réparateur informatique': ['réparateur informatique'],
      'réparateur téléphone': ['réparateur téléphone'],

      // NETTOYAGE
      'nettoyeur': ['nettoyeur', 'nettoyage'],
      'laveur de vitres': ['laveur de vitres'],
      'désinsectiseur': ['désinsectiseur'],

      // CUISINE
      'chef cuisinier': ['chef cuisinier', 'chef'],
      'pâtissier': ['pâtissier'],

      // SERVICE
      'serveur': ['serveur'],
      'barman': ['barman'],

      // BEAUTÉ
      'coiffeur': ['coiffeur', 'coiffure'],
      'esthéticienne': ['esthéticienne'],
      'manucure': ['manucure'],
      'massage': ['massage'],

      // MAISON
      'jardinier': ['jardinier', 'jardinage'],
      'paysagiste': ['paysagiste'],
      'ébéniste': ['ébéniste'],
      'décorateur': ['décorateur'],

      // TECH
      'technicien informatique': ['technicien informatique'],
      'développeur': ['développeur'],

      // CRÉATIF
      'graphiste': ['graphiste'],
      'photographe': ['photographe'],
      'formateur': ['formateur'],

      // SANTÉ
      'infirmier': ['infirmier'],
      'couturier': ['couturier'],

      // SÉCURITÉ
      'agent de sécurité': ['agent de sécurité'],
      'garde du corps': ['garde du corps'],

      // AGRICULTURE
      'agriculteur': ['agriculteur'],
      'éleveur': ['éleveur'],

      // ÉVÉNEMENTS
      'animateur': ['animateur'],
      'dj': ['dj'],

      // AUTRES
      'traducteur': ['traducteur'],
      'comptable': ['comptable'],
      'avocat': ['avocat'],
      'architecte': ['architecte'],
      'géomètre': ['géomètre'],
    };

    // Vérifier les correspondances
    for (String key in correspondances.keys) {
      if (prestataire.contains(key)) {
        for (String match in correspondances[key]!) {
          if (client.contains(match)) {
            return true;
          }
        }
      }
    }

    // Correspondance simple
    return prestataire.contains(client) || client.contains(prestataire);
  }

  // Méthode pour convertir les données JSON en objet Prestataire
  static Prestataire _fromJson(Map<String, dynamic> json) {
    return Prestataire(
      id: json['id'],
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      telephone: json['telephone'] ?? '',
      email: json['email'] ?? '',
      adresse: json['adresse'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      serviceType: json['service_type'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      nombreEvaluations: json['nombre_evaluations'] ?? 0,
      prixParHeure: json['prix_par_heure'] ?? '',
      experience: json['experience'] ?? '',
      jobsCompletes: json['jobs_completes'] ?? 0,
      statut: json['statut'] ?? 'DISPONIBLE',
      typeService: json['type_service'] ?? 'LES_DEUX',
      description: json['description'] ?? '',
      imageProfil: json['image_profil'] ?? 'assets/images/default_profile.png',
      dateCreation: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      dateModification: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  // Obtenir tous les prestataires disponibles pour un service donné
  static Future<List<Prestataire>> getPrestatairesDisponibles({
    required String serviceType,
    required String typeService, // 'À domicile' ou 'En présence'
    required double clientLatitude,
    required double clientLongitude,
    double rayonKm = 10.0, // Rayon de recherche par défaut
  }) async {
    try {
      // Appel à l'API backend pour récupérer les prestataires
      final response = await http.get(
        Uri.parse('$baseUrl/prestataires/disponibles'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        List<Prestataire> prestataires = jsonData
            .map((json) => _fromJson(json))
            .toList();

        // Filtrer les prestataires selon le service et le type
        List<Prestataire> prestatairesFiltres = prestataires.where((
          prestataire,
        ) {
          // Vérifier le type de service avec correspondance flexible
          bool serviceMatch = _isServiceMatching(
            prestataire.serviceType,
            serviceType,
          );

          // Vérifier la disponibilité pour le type de service demandé
          bool typeServiceMatch = prestataire.estDisponiblePour(typeService);

          // Vérifier le statut
          bool statutMatch = prestataire.statut == 'DISPONIBLE';

          return serviceMatch && typeServiceMatch && statutMatch;
        }).toList();

        // Calculer les distances et filtrer par rayon
        List<Map<String, dynamic>> prestatairesAvecDistance =
            prestatairesFiltres
                .map((prestataire) {
                  double distance = prestataire.calculerDistance(
                    clientLatitude,
                    clientLongitude,
                  );
                  return {'prestataire': prestataire, 'distance': distance};
                })
                .where((item) => (item['distance'] as double) <= rayonKm)
                .toList();

        // Trier par distance
        prestatairesAvecDistance.sort(
          (a, b) =>
              (a['distance'] as double).compareTo(b['distance'] as double),
        );

        print(
          '✅ ${prestatairesAvecDistance.length} prestataires trouvés pour $serviceType ($typeService)',
        );
        return prestatairesAvecDistance
            .map((item) => item['prestataire'] as Prestataire)
            .toList();
      } else {
        print('❌ Erreur API: ${response.statusCode} - ${response.body}');
        return [];
      }
    } catch (e) {
      print('❌ Erreur dans getPrestatairesDisponibles: $e');
      return [];
    }
  }

  // Obtenir un prestataire par ID
  static Future<Prestataire?> getPrestataireById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/prestataires/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        return _fromJson(jsonData);
      } else {
        print('❌ Erreur API: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération du prestataire: $e');
      return null;
    }
  }

  // Rechercher des prestataires par nom ou description
  static Future<List<Prestataire>> searchPrestataires({
    required String query,
    required String typeService, // "À domicile" ou "En présence"
    required double clientLatitude,
    required double clientLongitude,
    double rayonKm = 10.0,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/prestataires/search?q=${Uri.encodeComponent(query)}',
        ),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        List<Prestataire> prestataires = jsonData
            .map((json) => _fromJson(json))
            .toList();

        String queryLower = query.toLowerCase();

        List<Prestataire> prestatairesFiltres = prestataires.where((
          prestataire,
        ) {
          bool nomMatch = prestataire.nomComplet.toLowerCase().contains(
            queryLower,
          );
          bool serviceMatch = _isServiceMatching(
            prestataire.serviceType,
            queryLower,
          );
          bool descriptionMatch = prestataire.description
              .toLowerCase()
              .contains(queryLower);
          bool statutMatch = prestataire.statut == 'DISPONIBLE';

          // Vérifier la disponibilité pour le type de service demandé
          bool typeServiceMatch = prestataire.estDisponiblePour(typeService);

          return (nomMatch || serviceMatch || descriptionMatch) &&
              statutMatch &&
              typeServiceMatch;
        }).toList();

        // Calculer les distances et filtrer par rayon
        List<Map<String, dynamic>> prestatairesAvecDistance =
            prestatairesFiltres
                .map((prestataire) {
                  double distance = prestataire.calculerDistance(
                    clientLatitude,
                    clientLongitude,
                  );
                  return {'prestataire': prestataire, 'distance': distance};
                })
                .where((item) => (item['distance'] as double) <= rayonKm)
                .toList();

        // Trier par distance
        prestatairesAvecDistance.sort(
          (a, b) =>
              (a['distance'] as double).compareTo(b['distance'] as double),
        );

        return prestatairesAvecDistance
            .map((item) => item['prestataire'] as Prestataire)
            .toList();
      } else {
        print('❌ Erreur API: ${response.statusCode} - ${response.body}');
        return [];
      }
    } catch (e) {
      print('❌ Erreur dans searchPrestataires: $e');
      return [];
    }
  }

  // Obtenir les statistiques des prestataires
  static Future<Map<String, dynamic>> getStatistiquesPrestataires() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/prestataires/statistiques'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('❌ Erreur API: ${response.statusCode} - ${response.body}');
        return {};
      }
    } catch (e) {
      print('❌ Erreur lors de la récupération des statistiques: $e');
      return {};
    }
  }
}
