import '../models/service.dart';

class ServicesData {
  static final List<Service> services = [
    // 🛠️ BÂTIMENT & CONSTRUCTION
    Service(
      id: 1,
      name: "Plombier",
      category: ServiceCategory.BUILDING,
      icon: "🔧",
      description: "Installation et réparation plomberie",
    ),
    Service(
      id: 2,
      name: "Électricien",
      category: ServiceCategory.BUILDING,
      icon: "⚡",
      description: "Installation et réparation électrique",
    ),
    Service(
      id: 3,
      name: "Maçon",
      category: ServiceCategory.BUILDING,
      icon: "🧱",
      description: "Maçonnerie et construction",
    ),
    Service(
      id: 4,
      name: "Peintre en bâtiment",
      category: ServiceCategory.BUILDING,
      icon: "🎨",
      description: "Peinture intérieure et extérieure",
    ),
    Service(
      id: 5,
      name: "Carreleur",
      category: ServiceCategory.BUILDING,
      icon: "🔲",
      description: "Pose de carrelage et faïence",
    ),
    Service(
      id: 6,
      name: "Couvreur",
      category: ServiceCategory.BUILDING,
      icon: "🏠",
      description: "Couvreur et toiture",
    ),
    Service(
      id: 7,
      name: "Charpentier",
      category: ServiceCategory.BUILDING,
      icon: "🪚",
      description: "Charpenterie et menuiserie",
    ),
    Service(
      id: 8,
      name: "Serrurier",
      category: ServiceCategory.BUILDING,
      icon: "🔐",
      description: "Serrurerie et métallerie",
    ),
    Service(
      id: 9,
      name: "Vitrier",
      category: ServiceCategory.BUILDING,
      icon: "🪟",
      description: "Vitrerie et miroiterie",
    ),
    Service(
      id: 10,
      name: "Chauffagiste",
      category: ServiceCategory.HVAC,
      icon: "🔥",
      description: "Chauffage et plomberie",
    ),
    Service(
      id: 11,
      name: "Climatiseur",
      category: ServiceCategory.HVAC,
      icon: "❄️",
      description: "Climatisation et ventilation",
    ),
    Service(
      id: 12,
      name: "Frigoriste",
      category: ServiceCategory.HVAC,
      icon: "🧊",
      description: "Froid et climatisation",
    ),
    Service(
      id: 13,
      name: "Mécanicien auto",
      category: ServiceCategory.MECHANICS,
      icon: "🚗",
      description: "Mécanique automobile",
    ),
    Service(
      id: 14,
      name: "Mécanicien moto",
      category: ServiceCategory.MECHANICS,
      icon: "🏍️",
      description: "Mécanique motocycle",
    ),
    Service(
      id: 15,
      name: "Réparateur électroménager",
      category: ServiceCategory.MECHANICS,
      icon: "🔧",
      description: "Réparation électroménager",
    ),
    Service(
      id: 16,
      name: "Réparateur informatique",
      category: ServiceCategory.MECHANICS,
      icon: "💻",
      description: "Réparation informatique",
    ),
    Service(
      id: 17,
      name: "Réparateur téléphone",
      category: ServiceCategory.MECHANICS,
      icon: "📱",
      description: "Réparation téléphone",
    ),
    Service(
      id: 18,
      name: "Nettoyeur",
      category: ServiceCategory.CLEANING,
      icon: "🧹",
      description: "Nettoyage et ménage",
    ),
    Service(
      id: 19,
      name: "Laveur de vitres",
      category: ServiceCategory.CLEANING,
      icon: "🪟",
      description: "Lavage de vitres",
    ),
    Service(
      id: 20,
      name: "Désinsectiseur",
      category: ServiceCategory.CLEANING,
      icon: "🐛",
      description: "Désinsectisation",
    ),
    Service(
      id: 21,
      name: "Chef cuisinier",
      category: ServiceCategory.COOKING,
      icon: "👨‍🍳",
      description: "Cuisine et restauration",
    ),
    Service(
      id: 22,
      name: "Pâtissier",
      category: ServiceCategory.COOKING,
      icon: "🧁",
      description: "Pâtisserie et boulangerie",
    ),
    Service(
      id: 23,
      name: "Serveur",
      category: ServiceCategory.SERVICE,
      icon: "🍽️",
      description: "Service en restauration",
    ),
    Service(
      id: 24,
      name: "Barman",
      category: ServiceCategory.SERVICE,
      icon: "🍸",
      description: "Bar et mixologie",
    ),
    Service(
      id: 25,
      name: "Coiffeur",
      category: ServiceCategory.BEAUTY,
      icon: "💇‍♂️",
      description: "Coiffure et esthétique",
    ),
    Service(
      id: 26,
      name: "Esthéticienne",
      category: ServiceCategory.BEAUTY,
      icon: "💄",
      description: "Esthétique et beauté",
    ),
    Service(
      id: 27,
      name: "Manucure",
      category: ServiceCategory.BEAUTY,
      icon: "💅",
      description: "Manucure et pédicure",
    ),
    Service(
      id: 28,
      name: "Massage",
      category: ServiceCategory.BEAUTY,
      icon: "💆‍♀️",
      description: "Massage et bien-être",
    ),
    Service(
      id: 29,
      name: "Jardinier",
      category: ServiceCategory.HOME,
      icon: "🌱",
      description: "Jardinage et paysagisme",
    ),
    Service(
      id: 30,
      name: "Paysagiste",
      category: ServiceCategory.HOME,
      icon: "🌳",
      description: "Paysagisme et aménagement",
    ),
    Service(
      id: 31,
      name: "Ébéniste",
      category: ServiceCategory.HOME,
      icon: "🪑",
      description: "Ébénisterie et menuiserie",
    ),
    Service(
      id: 32,
      name: "Décorateur",
      category: ServiceCategory.HOME,
      icon: "🏠",
      description: "Décoration intérieure",
    ),
    Service(
      id: 33,
      name: "Technicien informatique",
      category: ServiceCategory.TECH,
      icon: "💻",
      description: "Support informatique",
    ),
    Service(
      id: 34,
      name: "Développeur",
      category: ServiceCategory.TECH,
      icon: "👨‍💻",
      description: "Développement logiciel",
    ),
    Service(
      id: 35,
      name: "Graphiste",
      category: ServiceCategory.CREATIVE,
      icon: "🎨",
      description: "Design graphique",
    ),
    Service(
      id: 36,
      name: "Photographe",
      category: ServiceCategory.CREATIVE,
      icon: "📸",
      description: "Photographie",
    ),
    Service(
      id: 37,
      name: "Formateur",
      category: ServiceCategory.CREATIVE,
      icon: "👨‍🏫",
      description: "Formation et enseignement",
    ),
    Service(
      id: 38,
      name: "Infirmier",
      category: ServiceCategory.HEALTH,
      icon: "🏥",
      description: "Soins infirmiers",
    ),
    Service(
      id: 39,
      name: "Couturier",
      category: ServiceCategory.HEALTH,
      icon: "✂️",
      description: "Couture et retouches",
    ),
    Service(
      id: 40,
      name: "Agent de sécurité",
      category: ServiceCategory.SECURITY,
      icon: "🛡️",
      description: "Sécurité et surveillance",
    ),
    Service(
      id: 41,
      name: "Garde du corps",
      category: ServiceCategory.SECURITY,
      icon: "👮‍♂️",
      description: "Protection rapprochée",
    ),
    Service(
      id: 42,
      name: "Agriculteur",
      category: ServiceCategory.AGRICULTURE,
      icon: "🚜",
      description: "Agriculture et élevage",
    ),
    Service(
      id: 43,
      name: "Éleveur",
      category: ServiceCategory.AGRICULTURE,
      icon: "🐄",
      description: "Élevage et soins animaux",
    ),
    Service(
      id: 44,
      name: "Animateur",
      category: ServiceCategory.EVENTS,
      icon: "🎪",
      description: "Animation et événements",
    ),
    Service(
      id: 45,
      name: "DJ",
      category: ServiceCategory.EVENTS,
      icon: "🎵",
      description: "Animation musicale",
    ),
    Service(
      id: 46,
      name: "Traducteur",
      category: ServiceCategory.OTHER,
      icon: "🌍",
      description: "Traduction et interprétation",
    ),
    Service(
      id: 47,
      name: "Comptable",
      category: ServiceCategory.OTHER,
      icon: "📊",
      description: "Comptabilité et gestion",
    ),
    Service(
      id: 48,
      name: "Avocat",
      category: ServiceCategory.OTHER,
      icon: "⚖️",
      description: "Conseil juridique",
    ),
    Service(
      id: 49,
      name: "Architecte",
      category: ServiceCategory.OTHER,
      icon: "🏗️",
      description: "Architecture et urbanisme",
    ),
    Service(
      id: 50,
      name: "Géomètre",
      category: ServiceCategory.OTHER,
      icon: "📐",
      description: "Topographie et géomètre",
    ),
  ];

  // Méthodes utilitaires
  static List<Service> getServicesByCategory(String category) {
    return services.where((service) => service.category == category).toList();
  }

  static Service? getServiceById(int id) {
    try {
      return services.firstWhere((service) => service.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<Service> searchServices(String query) {
    final lowerQuery = query.toLowerCase();
    return services.where((service) {
      return service.name.toLowerCase().contains(lowerQuery) ||
          service.description.toLowerCase().contains(lowerQuery) ||
          service.category.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  static List<String> getAllCategories() {
    return services.map((service) => service.category).toSet().toList();
  }
}
