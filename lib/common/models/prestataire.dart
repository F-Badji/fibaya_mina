import 'dart:math';

class Prestataire {
  final int id;
  final String nom;
  final String prenom;
  final String telephone;
  final String email;
  final String adresse;
  final double latitude;
  final double longitude;
  final String serviceType;
  final double rating;
  final int nombreEvaluations;
  final String prixParHeure;
  final String experience;
  final int jobsCompletes;
  final String statut; // DISPONIBLE, OCCUPE, HORS_LIGNE
  final String typeService; // A_DOMICILE, EN_PRESENCE, LES_DEUX
  final String description;
  final String imageProfil;
  final DateTime dateCreation;
  final DateTime dateModification;

  Prestataire({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.telephone,
    required this.email,
    required this.adresse,
    required this.latitude,
    required this.longitude,
    required this.serviceType,
    required this.rating,
    required this.nombreEvaluations,
    required this.prixParHeure,
    required this.experience,
    required this.jobsCompletes,
    required this.statut,
    required this.typeService,
    required this.description,
    required this.imageProfil,
    required this.dateCreation,
    required this.dateModification,
  });

  // Calculer la distance en km entre ce prestataire et une position donnée
  double calculerDistance(double clientLatitude, double clientLongitude) {
    const double earthRadius = 6371; // Rayon de la Terre en km
    
    double dLat = _deg2rad(latitude - clientLatitude);
    double dLon = _deg2rad(longitude - clientLongitude);
    
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_deg2rad(clientLatitude)) * cos(_deg2rad(latitude)) *
        sin(dLon / 2) * sin(dLon / 2);
    
    double c = 2 * asin(sqrt(a));
    double distance = earthRadius * c;
    
    return distance;
  }

  double _deg2rad(double deg) {
    return deg * (3.14159265359 / 180);
  }

  // Obtenir le nom complet
  String get nomComplet => '$prenom $nom';

  // Obtenir le statut formaté
  String get statutFormate {
    switch (statut) {
      case 'DISPONIBLE':
        return 'Disponible';
      case 'OCCUPE':
        return 'Occupé';
      case 'HORS_LIGNE':
        return 'Hors ligne';
      default:
        return 'Inconnu';
    }
  }

  // Obtenir le type de service formaté
  String get typeServiceFormate {
    switch (typeService) {
      case 'A_DOMICILE':
        return 'À domicile';
      case 'EN_PRESENCE':
        return 'En présence';
      case 'LES_DEUX':
        return 'À domicile & En présence';
      default:
        return 'Non spécifié';
    }
  }

  // Vérifier si le prestataire est disponible pour un type de service
  bool estDisponiblePour(String typeServiceDemande) {
    if (statut != 'DISPONIBLE') return false;
    
    switch (typeServiceDemande) {
      case 'À domicile':
        return typeService == 'A_DOMICILE' || typeService == 'LES_DEUX';
      case 'En présence':
        return typeService == 'EN_PRESENCE' || typeService == 'LES_DEUX';
      default:
        return false;
    }
  }

  factory Prestataire.fromJson(Map<String, dynamic> json) {
    return Prestataire(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      telephone: json['telephone'],
      email: json['email'],
      adresse: json['adresse'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      serviceType: json['service_type'],
      rating: json['rating'].toDouble(),
      nombreEvaluations: json['nombre_evaluations'],
      prixParHeure: json['prix_par_heure'],
      experience: json['experience'],
      jobsCompletes: json['jobs_completes'],
      statut: json['statut'],
      typeService: json['type_service'],
      description: json['description'],
      imageProfil: json['image_profil'],
      dateCreation: DateTime.parse(json['date_creation']),
      dateModification: DateTime.parse(json['date_modification']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'telephone': telephone,
      'email': email,
      'adresse': adresse,
      'latitude': latitude,
      'longitude': longitude,
      'service_type': serviceType,
      'rating': rating,
      'nombre_evaluations': nombreEvaluations,
      'prix_par_heure': prixParHeure,
      'experience': experience,
      'jobs_completes': jobsCompletes,
      'statut': statut,
      'type_service': typeService,
      'description': description,
      'image_profil': imageProfil,
      'date_creation': dateCreation.toIso8601String(),
      'date_modification': dateModification.toIso8601String(),
    };
  }
}
