import cleaningService from "@/assets/cleaning-service.jpg";
import carWashService from "@/assets/car-wash-service.jpg";
import chefService from "@/assets/chef-service.jpg";

export interface Service {
  id: string;
  name: string;
  category: string;
  icon: string;
  image?: string;
  description: string;
}

export const serviceCategories = {
  MAINTENANCE: "Maintenance & Réparation",
  FOOD: "Alimentation & Restauration", 
  HOSPITALITY: "Hôtellerie & Service",
  BEAUTY: "Beauté & Bien-être",
  HOME: "Maison & Jardin",
  TECH: "Technologie & Réparation",
  CREATIVE: "Créatif & Formation",
  HEALTH: "Santé & Couture",
  SECURITY: "Sécurité & Surveillance",
  AGRICULTURE: "Agriculture & Élevage",
  EVENTS: "Événements & Animation"
};

export const services: Service[] = [
  // Maintenance & Réparation
  { id: "chaudronnier", name: "Chaudronnier", category: serviceCategories.MAINTENANCE, icon: "🔧", description: "Travaux de chaudronnerie et métallurgie" },
  { id: "laveur-voiture", name: "Laveur de voitures", category: serviceCategories.MAINTENANCE, icon: "🚗", image: carWashService, description: "Lavage et entretien véhicules" },
  { id: "reparateur-electromenager", name: "Réparateur d'électroménager", category: serviceCategories.TECH, icon: "⚡", description: "Réparation appareils électroménagers" },
  { id: "reparateur-telephone", name: "Réparateur de téléphone", category: serviceCategories.TECH, icon: "📱", description: "Réparation smartphones et tablettes" },
  { id: "reparateur-ordinateur", name: "Réparateur d'ordinateur", category: serviceCategories.TECH, icon: "💻", description: "Réparation et maintenance informatique" },
  { id: "reparateur-velo", name: "Réparateur de vélo", category: serviceCategories.TECH, icon: "🚲", description: "Réparation et entretien vélos" },
  { id: "reparateur-moto", name: "Réparateur de moto", category: serviceCategories.TECH, icon: "🏍️", description: "Réparation motos et scooters" },
  { id: "technicien-informatique", name: "Technicien informatique", category: serviceCategories.TECH, icon: "🖥️", description: "Support et maintenance IT" },

  // Alimentation & Restauration
  { id: "cuisinier", name: "Cuisinier", category: serviceCategories.FOOD, icon: "👨‍🍳", image: chefService, description: "Cuisine professionnelle" },
  { id: "aide-cuisinier", name: "Aide-cuisinier", category: serviceCategories.FOOD, icon: "🍽️", description: "Assistance en cuisine" },
  { id: "patissier", name: "Pâtissier", category: serviceCategories.FOOD, icon: "🧁", description: "Pâtisserie et desserts" },
  { id: "boulanger", name: "Boulanger", category: serviceCategories.FOOD, icon: "🥖", description: "Boulangerie artisanale" },
  { id: "boucher", name: "Boucher", category: serviceCategories.FOOD, icon: "🥩", description: "Boucherie et découpe" },
  { id: "traiteur", name: "Traiteur", category: serviceCategories.FOOD, icon: "🍱", description: "Service traiteur événements" },
  { id: "cuisinier-domicile", name: "Cuisinier à domicile", category: serviceCategories.HOME, icon: "🏠", description: "Cuisine à domicile" },

  // Nettoyage & Entretien
  { id: "agent-entretien", name: "Agent d'entretien", category: serviceCategories.HOME, icon: "🧽", image: cleaningService, description: "Entretien et nettoyage" },
  { id: "femme-menage", name: "Femme de ménage", category: serviceCategories.HOME, icon: "🧹", description: "Ménage à domicile" },
  { id: "agent-nettoyage", name: "Agent de nettoyage", category: serviceCategories.HOME, icon: "🧼", description: "Nettoyage professionnel" },
  { id: "eboueur", name: "Éboueur", category: serviceCategories.HOME, icon: "🗑️", description: "Collection déchets" },
  { id: "laveur-linge", name: "Laveur de linge", category: serviceCategories.HOME, icon: "👕", description: "Lavage et repassage" },

  // Hôtellerie & Service
  { id: "serveur", name: "Serveur", category: serviceCategories.HOSPITALITY, icon: "🍽️", description: "Service en salle" },
  { id: "receptionniste", name: "Réceptionniste", category: serviceCategories.HOSPITALITY, icon: "🏨", description: "Accueil et réception" },
  { id: "concierge", name: "Concierge", category: serviceCategories.HOSPITALITY, icon: "🔑", description: "Service de conciergerie" },

  // Beauté & Bien-être
  { id: "coiffeur", name: "Coiffeur", category: serviceCategories.BEAUTY, icon: "✂️", description: "Coiffure et coupe" },
  { id: "coiffeuse", name: "Coiffeuse", category: serviceCategories.BEAUTY, icon: "💇‍♀️", description: "Coiffure femme" },
  { id: "maquilleuse", name: "Maquilleuse", category: serviceCategories.BEAUTY, icon: "💄", description: "Maquillage professionnel" },
  { id: "manucure", name: "Manucure", category: serviceCategories.BEAUTY, icon: "💅", description: "Soins des ongles" },
  { id: "massage", name: "Massage", category: serviceCategories.BEAUTY, icon: "💆", description: "Massage thérapeutique" },

  // Maison & Jardin
  { id: "jardinier", name: "Jardinier", category: serviceCategories.HOME, icon: "🌱", description: "Entretien jardins et espaces verts" },
  { id: "garde-enfants", name: "Garde d'enfants", category: serviceCategories.HOME, icon: "👶", description: "Garde et baby-sitting" },

  // Technologie & Installation
  { id: "installateur-antenne", name: "Installateur d'antenne", category: serviceCategories.TECH, icon: "📡", description: "Installation antennes et satellites" },
  { id: "technicien-telecom", name: "Technicien télécom", category: serviceCategories.TECH, icon: "📞", description: "Installation télécommunications" },

  // Créatif & Formation  
  { id: "graphiste", name: "Graphiste", category: serviceCategories.CREATIVE, icon: "🎨", description: "Design graphique et visuel" },
  { id: "photographe", name: "Photographe", category: serviceCategories.CREATIVE, icon: "📷", description: "Photographie professionnelle" },
  { id: "professeur-particulier", name: "Professeur particulier", category: serviceCategories.CREATIVE, icon: "📚", description: "Cours particuliers" },
  { id: "formateur", name: "Formateur", category: serviceCategories.CREATIVE, icon: "🎓", description: "Formation professionnelle" },

  // Santé & Couture
  { id: "infirmier-domicile", name: "Infirmier à domicile", category: serviceCategories.HEALTH, icon: "👩‍⚕️", description: "Soins infirmiers à domicile" },
  { id: "couturier", name: "Couturier", category: serviceCategories.HEALTH, icon: "🪡", description: "Couture et retouches" },
  { id: "cordonnier", name: "Cordonnier", category: serviceCategories.HEALTH, icon: "👞", description: "Réparation chaussures" },
  { id: "bijoutier", name: "Bijoutier", category: serviceCategories.HEALTH, icon: "💎", description: "Bijouterie et réparation" },
  { id: "sculpteur", name: "Sculpteur", category: serviceCategories.CREATIVE, icon: "🗿", description: "Sculpture artistique" },
  { id: "peintre-artiste", name: "Peintre artiste", category: serviceCategories.CREATIVE, icon: "🖼️", description: "Peinture artistique" },

  // Sécurité & Surveillance
  { id: "agent-securite", name: "Agent de sécurité", category: serviceCategories.SECURITY, icon: "🛡️", description: "Sécurité et surveillance" },
  { id: "garde-corps", name: "Garde du corps", category: serviceCategories.SECURITY, icon: "👮", description: "Protection personnelle" },
  { id: "surveillant", name: "Surveillant", category: serviceCategories.SECURITY, icon: "👁️", description: "Surveillance et monitoring" },

  // Agriculture & Élevage
  { id: "agriculteur", name: "Agriculteur", category: serviceCategories.AGRICULTURE, icon: "🚜", description: "Agriculture et cultures" },
  { id: "eleveur", name: "Éleveur", category: serviceCategories.AGRICULTURE, icon: "🐄", description: "Élevage animal" },
  { id: "veterinaire", name: "Vétérinaire", category: serviceCategories.AGRICULTURE, icon: "🐕‍🦺", description: "Soins vétérinaires" },
  { id: "ouvrier-agricole", name: "Ouvrier agricole", category: serviceCategories.AGRICULTURE, icon: "🌾", description: "Travaux agricoles" },

  // Événements & Animation
  { id: "dj", name: "DJ", category: serviceCategories.EVENTS, icon: "🎧", description: "Animation musicale DJ" },
  { id: "musicien", name: "Musicien", category: serviceCategories.EVENTS, icon: "🎵", description: "Musicien professionnel" },
  { id: "animateur", name: "Animateur", category: serviceCategories.EVENTS, icon: "🎪", description: "Animation événements" },
  { id: "organisateur-evenements", name: "Organisateur d'événements", category: serviceCategories.EVENTS, icon: "🎉", description: "Organisation événements" },
  { id: "decorateur", name: "Décorateur", category: serviceCategories.EVENTS, icon: "🎨", description: "Décoration événements" },

  // Autres
  { id: "autre", name: "Autre", category: "Autre", icon: "🔧", description: "Autres services non listés" }
];