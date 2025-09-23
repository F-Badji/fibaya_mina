class Service {
  final int id;
  final String name;
  final String category;
  final String icon;
  final String? image;
  final String description;

  Service({
    required this.id,
    required this.name,
    required this.category,
    required this.icon,
    this.image,
    required this.description,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      icon: json['icon'],
      image: json['image'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'icon': icon,
      'image': image,
      'description': description,
    };
  }
}

class ServiceCategory {
  // MÉTIERS TECHNIQUES ET MANUELS
  static const String BUILDING = "🛠️ Bâtiment & Construction";
  static const String HVAC = "❄️ Froid, Climatisation, Chauffage";
  static const String MECHANICS = "⚙️ Mécanique & Maintenance";
  static const String CLEANING = "🧹 Entretien & Propreté";

  // HÔTELLERIE, RESTAURATION & ALIMENTAIRE
  static const String COOKING = "🧑‍🍳 Cuisine & restauration";
  static const String SERVICE = "☕ Service & hôtellerie";

  // AUTRES CATÉGORIES EXISTANTES
  static const String BEAUTY = "Beauté & Bien-être";
  static const String HOME = "Maison & Jardin";
  static const String TECH = "Technologie & Réparation";
  static const String CREATIVE = "Créatif & Formation";
  static const String HEALTH = "Santé & Couture";
  static const String SECURITY = "Sécurité & Surveillance";
  static const String AGRICULTURE = "Agriculture & Élevage";
  static const String EVENTS = "Événements & Animation";
  static const String OTHER = "Autre";

  static Map<String, String> get categories => {
    'BUILDING': BUILDING,
    'HVAC': HVAC,
    'MECHANICS': MECHANICS,
    'CLEANING': CLEANING,
    'COOKING': COOKING,
    'SERVICE': SERVICE,
    'BEAUTY': BEAUTY,
    'HOME': HOME,
    'TECH': TECH,
    'CREATIVE': CREATIVE,
    'HEALTH': HEALTH,
    'SECURITY': SECURITY,
    'AGRICULTURE': AGRICULTURE,
    'EVENTS': EVENTS,
    'OTHER': OTHER,
  };
}
