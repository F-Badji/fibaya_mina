import 'package:flutter/material.dart';

// Couleur personnalisée Fibaya
const Color fibayaGreen = Color(0xFF065b32);

class OurServicesScreen extends StatefulWidget {
  const OurServicesScreen({super.key});

  @override
  State<OurServicesScreen> createState() => _OurServicesScreenState();
}

class _OurServicesScreenState extends State<OurServicesScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  // Liste complète des services organisés par catégories
  final List<Map<String, dynamic>> _serviceCategories = [
    {
      'category': '🏗️ BÂTIMENT & CONSTRUCTION',
      'icon': Icons.build,
      'color': fibayaGreen,
      'services': [
        'Plombier(e)',
        'Électricien(e)',
        'Maçon(ne)',
        'Peintre en bâtiment',
        'Carreleur(e)',
        'Menuisier(e)',
        'Vitrier(e)',
        'Plaquiste(e)',
        'Terrassier(e)',
        'Couvreur(e)',
        'Charpentier(e)',
        'Serrurier(e)',
      ],
    },
    {
      'category': '❄️ FROID & CLIMATISATION',
      'icon': Icons.ac_unit,
      'color': Colors.blue,
      'services': [
        'Frigoriste (climatiseur)',
        'Installateur/Reparateur de climatisation',
        'Chauffagiste(e)',
        'Technicien CVC',
      ],
    },
    {
      'category': '⚙️ MÉCANIQUE & MAINTENANCE',
      'icon': Icons.car_repair,
      'color': Colors.orange,
      'services': [
        'Mécanicien automobile',
        'Mécanicien moto',
        'Carrossier',
        'Peintre automobile',
        'Soudeur(e)',
        'Chaudronnier(e)',
        'Mécanicien vélo',
      ],
    },
    {
      'category': '🧹 ENTRETIEN & PROPRETÉ',
      'icon': Icons.cleaning_services,
      'color': Colors.green,
      'services': [
        'Laveur de voitures',
        'Agent d\'entretien',
        'Femme de ménage',
        'Agent de nettoyage',
        'Éboueur',
        'Nettoyage industriel',
        'Repassage',
      ],
    },
    {
      'category': '🍽️ RESTAURATION & ALIMENTAIRE',
      'icon': Icons.restaurant,
      'color': Colors.amber,
      'services': [
        'Cuisinier/Aide-cuisinier',
        'Pâtissier(e)',
        'Boulanger(e)',
        'Boucher(e)',
        'Traiteur(e)',
        'Serveur(e)',
        'Barman(e)',
        'Sommelier(e)',
      ],
    },
    {
      'category': '☕ SERVICE & HÔTELLERIE',
      'icon': Icons.hotel,
      'color': Colors.grey,
      'services': [
        'Réceptionniste(e)',
        'Concierge(e)',
        'Chauffeur(e)',
        'Guide touristique(e)',
      ],
    },
    {
      'category': '💇 BEAUTÉ & BIEN-ÊTRE',
      'icon': Icons.face,
      'color': fibayaGreen,
      'services': [
        'Coiffeur(se)',
        'Maquilleuse',
        'Manucure',
        'Massage',
        'Pédicure',
        'Esthéticienne',
        'Barbier(e)',
      ],
    },
    {
      'category': '🏠 SERVICES À DOMICILE',
      'icon': Icons.home,
      'color': Colors.blue,
      'services': [
        'Jardinier(e)',
        'Garde d\'enfants(e)',
        'Laveur de linge(e)',
        'Nounou',
        'Aide-ménagère',
        'Tuteur(e)',
      ],
    },
    {
      'category': '🔧 RÉPARATION & MAINTENANCE',
      'icon': Icons.build_circle,
      'color': Colors.orange,
      'services': [
        'Réparateur d\'électroménager(e)',
        'Réparateur de téléphone(e)',
        'Réparateur d\'ordinateur(e)',
        'Réparateur de vélo(e)',
        'Réparateur de moto(e)',
        'Réparateur TV(e)',
        'Réparateur lave-linge(e)',
      ],
    },
    {
      'category': '📱 TECHNOLOGIE & COMMUNICATION',
      'icon': Icons.phone_android,
      'color': Colors.grey,
      'services': [
        'Technicien informatique(e)',
        'Installateur d\'antenne(e)',
        'Technicien télécom(e)',
        'Graphiste(e)',
        'Photographe(e)',
      ],
    },
    {
      'category': '🎓 ÉDUCATION & FORMATION',
      'icon': Icons.school,
      'color': Colors.green,
      'services': [
        'Professeur particulier(e)',
        'Formateur(e)',
        'Coach(e)',
        'Traducteur(e)',
      ],
    },
    {
      'category': '🏥 SANTÉ & BIEN-ÊTRE',
      'icon': Icons.medical_services,
      'color': Colors.red,
      'services': ['Infirmier à domicile(e)'],
    },
    {
      'category': '🎨 ARTISANAT & CRÉATION',
      'icon': Icons.palette,
      'color': Colors.amber,
      'services': [
        'Couturier(e)',
        'Cordonnier(e)',
        'Bijoutier(e)',
        'Sculpteur(e)',
        'Peintre artiste(e)',
        'Tapissier(e)',
        'Ébéniste(e)',
      ],
    },
    {
      'category': '🔒 SÉCURITÉ & SURVEILLANCE',
      'icon': Icons.security,
      'color': Colors.grey,
      'services': [
        'Agent de sécurité(e)',
        'Garde du corps(e)',
        'Surveillant(e)',
      ],
    },
    {
      'category': '🌱 AGRICULTURE & ÉLEVAGE',
      'icon': Icons.agriculture,
      'color': Colors.green,
      'services': [
        'Agriculteur(e)',
        'Éleveur(e)',
        'Vétérinaire(e)',
        'Ouvrier agricole(e)',
      ],
    },
    {
      'category': '🎵 DIVERTISSEMENT & ÉVÉNEMENTIEL',
      'icon': Icons.music_note,
      'color': Colors.orange,
      'services': [
        'DJ',
        'Musicien(ne)',
        'Animateur(e)',
        'Organisateur d\'événements(e)',
        'Décorateur(e)',
        'Comédien(ne)',
        'Danseur(e)',
      ],
    },
  ];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _fadeController.forward();

    await Future.delayed(const Duration(milliseconds: 200));
    _slideController.forward();

    await Future.delayed(const Duration(milliseconds: 200));
    _scaleController.forward();

    await Future.delayed(const Duration(milliseconds: 500));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Nos Services',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header avec logo et description
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: _buildHeaderSection(),
              ),
            ),

            const SizedBox(height: 20),

            // Statistiques des services
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: _buildStatsSection(),
              ),
            ),

            const SizedBox(height: 20),

            // Liste des catégories de services
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: _buildServicesList(),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Image Nos Services
          ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 0,
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/images/Nos_services.jpeg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        color: fibayaGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: fibayaGreen.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Icon(Icons.work, color: fibayaGreen, size: 40),
                    );
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'NOS SERVICES',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: 2,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Découvrez tous nos services de proximité pour répondre à tous vos besoins',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    int totalServices = _serviceCategories.fold(
      0,
      (sum, category) => sum + (category['services'] as List).length,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Catégories',
              '${_serviceCategories.length}',
              Icons.category,
              fibayaGreen,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              'Services',
              '$totalServices+',
              Icons.work,
              Colors.blue,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              'Disponibilité',
              '24/7',
              Icons.access_time,
              Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * _animationController.value),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.2), width: 1),
            ),
            child: Column(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildServicesList() {
    return Column(
      children: _serviceCategories.asMap().entries.map((entry) {
        int index = entry.key;
        Map<String, dynamic> category = entry.value;

        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, 50 * (1 - _animationController.value)),
              child: Opacity(
                opacity: _animationController.value,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: _buildCategoryCard(category, index),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category, int index) {
    Color categoryColor = category['color'] as Color;
    IconData categoryIcon = category['icon'] as IconData;
    String categoryName = category['category'] as String;
    List<String> services = category['services'] as List<String>;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: categoryColor.withOpacity(0.05),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          // Header de la catégorie
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: categoryColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: categoryColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: categoryColor.withOpacity(0.3),
                        spreadRadius: 0,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(categoryIcon, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        categoryName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${services.length} services disponibles',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: 16,
                ),
              ],
            ),
          ),

          // Liste des services
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: services
                  .map((service) => _buildServiceChip(service, categoryColor))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceChip(String service, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Text(
        service,
        style: const TextStyle(
          fontSize: 13,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
