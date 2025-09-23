import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

class OurPartnersScreen extends StatefulWidget {
  const OurPartnersScreen({super.key});

  @override
  State<OurPartnersScreen> createState() => _OurPartnersScreenState();
}

class _OurPartnersScreenState extends State<OurPartnersScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Liste complète des partenaires organisés par catégories
  final List<Map<String, dynamic>> _partnerCategories = [
    {
      'category': 'Partenaires Technologiques',
      'icon': Icons.phone_android,
      'color': Colors.blue,
      'description':
          'Nos partenaires technologiques nous aident à offrir la meilleure expérience utilisateur.',
      'partners': [
        {
          'name': 'Orange Sénégal',
          'type': 'Opérateur Télécoms',
          'description':
              'Partenariat stratégique pour les services de paiement mobile et solutions de connectivité. Collaboration de longue date avec des services innovants.',
          'color': Colors.blue,
        },
        {
          'name': 'MTN Sénégal',
          'type': 'Opérateur Télécoms',
          'description':
              'Solutions de paiement mobile avancées et services de communication. Partenaire technologique de confiance pour nos transactions.',
          'color': Colors.orange,
        },
        {
          'name': 'Free Sénégal',
          'type': 'Opérateur Télécoms',
          'description':
              'Services de connectivité haut débit et solutions de paiement digital. Innovation et performance au service de nos utilisateurs.',
          'color': Colors.red,
        },
        {
          'name': 'Google Cloud',
          'type': 'Services Cloud',
          'description':
              'Infrastructure cloud sécurisée et solutions d\'intelligence artificielle. Partenaire technologique pour la scalabilité de notre plateforme.',
          'color': Colors.green,
        },
      ],
    },
    {
      'category': 'Partenaires Financiers',
      'icon': Icons.account_balance,
      'color': Colors.green,
      'description':
          'Des institutions financières de confiance pour sécuriser vos transactions.',
      'partners': [
        {
          'name': 'Ecobank Sénégal',
          'type': 'Institution Bancaire',
          'description':
              'Solutions bancaires complètes et paiements sécurisés. Partenaire financier de référence pour nos transactions et services de paiement.',
          'color': Colors.green,
        },
        {
          'name': 'Société Générale',
          'type': 'Banque Internationale',
          'description':
              'Services financiers avancés, virements internationaux et solutions de trésorerie. Excellence bancaire au service de nos clients.',
          'color': Colors.blue,
        },
        {
          'name': 'Banque Atlantique',
          'type': 'Banque Panafricaine',
          'description':
              'Partenariat bancaire stratégique avec services d\'assurance intégrés. Solutions financières innovantes pour l\'Afrique.',
          'color': Colors.orange,
        },
        {
          'name': 'PayPal',
          'type': 'Paiement Digital',
          'description':
              'Solutions de paiement en ligne sécurisées et internationales. Facilité de transaction pour nos clients du monde entier.',
          'color': Colors.blue,
        },
      ],
    },
    {
      'category': 'Partenaires Logistiques',
      'icon': Icons.local_shipping,
      'color': Colors.orange,
      'description':
          'Un réseau de partenaires logistiques pour une livraison rapide et fiable.',
      'partners': [
        {
          'name': 'DHL Sénégal',
          'type': 'Transport Express International',
          'description':
              'Livraison rapide et sécurisée dans le monde entier. Partenaire logistique de référence pour nos envois internationaux.',
          'color': Colors.red,
        },
        {
          'name': 'Chronopost',
          'type': 'Service de Livraison',
          'description':
              'Livraison nationale et internationale avec suivi en temps réel. Solutions logistiques adaptées à tous vos besoins.',
          'color': Colors.blue,
        },
        {
          'name': 'Jumia Services',
          'type': 'Logistique E-commerce',
          'description':
              'Solutions logistiques innovantes et réseau de distribution étendu. Expertise e-commerce pour une livraison optimale.',
          'color': Colors.orange,
        },
        {
          'name': 'Uber Eats',
          'type': 'Livraison de Repas',
          'description':
              'Réseau de livraison de repas rapide et fiable. Partenaire pour nos services de livraison alimentaire.',
          'color': Colors.grey,
        },
      ],
    },
    {
      'category': 'Partenaires Services',
      'icon': Icons.business_center,
      'color': Colors.purple,
      'description': 'Des prestataires de services qualifiés et certifiés.',
      'partners': [
        {
          'name': 'Fédération des Prestataires',
          'type': 'Organisation Professionnelle',
          'description':
              'Certification et formation continue des prestataires. Garantie de qualité et professionnalisme pour tous nos services.',
          'color': Colors.purple,
        },
        {
          'name': 'Chambre de Commerce',
          'type': 'Institution Économique',
          'description':
              'Accompagnement et développement des entreprises. Partenaire institutionnel pour la croissance de notre écosystème.',
          'color': Colors.teal,
        },
      ],
    },
    {
      'category': 'Partenaires Institutionnels',
      'icon': Icons.account_balance,
      'color': Colors.blue,
      'description':
          'Des partenaires institutionnels pour la conformité et le développement.',
      'partners': [
        {
          'name': 'Ministère du Commerce',
          'type': 'Institution Publique',
          'description':
              'Cadre réglementaire et légal pour nos activités. Partenaire institutionnel pour la conformité et la transparence.',
          'color': Colors.blue,
        },
        {
          'name': 'ONFP',
          'type': 'Formation Professionnelle',
          'description':
              'Formation et certification des prestataires de services. Excellence professionnelle et développement des compétences.',
          'color': Colors.green,
        },
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
    _searchController.dispose();
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
          'Nos Partenaires',
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
            // Section Nos Partenaires Stratégiques
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: _buildStrategicPartnersSection(),
              ),
            ),

            const SizedBox(height: 20),

            // Section de recherche
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: _buildSearchSection(),
              ),
            ),

            const SizedBox(height: 20),

            // Liste des catégories de partenaires
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: _buildPartnersList(),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStrategicPartnersSection() {
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
          // Image Nos Partenaires
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
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/images/Partenaires.jpeg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.blue[600],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.handshake,
                        color: Colors.white,
                        size: 40,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Nos Partenaires Stratégiques',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Un réseau de partenaires de confiance pour vous offrir le meilleur',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          // Chip avec les caractéristiques
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.green[200]!, width: 1),
            ),
            child: const Text(
              'Partenaires certifiés • Collaboration durable • Excellence garantie',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.search, color: AppTheme.primaryGreen, size: 24),
              const SizedBox(width: 12),
              const Text(
                'Rechercher un partenaire',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!, width: 1),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.grey[600], size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Tapez le nom d\'un parten...',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPartnersList() {
    return Column(
      children: _partnerCategories.map((category) {
        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, 50 * (1 - _animationController.value)),
              child: Opacity(
                opacity: _animationController.value,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: _buildCategorySection(category),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildCategorySection(Map<String, dynamic> category) {
    String categoryName = category['category'] as String;
    IconData categoryIcon = category['icon'] as IconData;
    Color categoryColor = category['color'] as Color;
    String description = category['description'] as String;
    List<Map<String, dynamic>> partners =
        category['partners'] as List<Map<String, dynamic>>;

    // Filtrer les partenaires selon la recherche
    List<Map<String, dynamic>> filteredPartners = partners.where((partner) {
      if (_searchQuery.isEmpty) return true;
      return partner['name'].toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
             partner['type'].toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    if (filteredPartners.isEmpty && _searchQuery.isNotEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header de la catégorie
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: categoryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: categoryColor,
                  borderRadius: BorderRadius.circular(12),
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
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Liste des partenaires
        Column(
          children: filteredPartners.map((partner) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: _buildPartnerCard(partner),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPartnerCard(Map<String, dynamic> partner) {
    String name = partner['name'] as String;
    String type = partner['type'] as String;
    String description = partner['description'] as String;
    Color color = partner['color'] as Color;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icône du partenaire
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.business, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          // Informations du partenaire
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    type,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
