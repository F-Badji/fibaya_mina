import 'package:flutter/material.dart';

class OurFaqScreen extends StatefulWidget {
  const OurFaqScreen({super.key});

  @override
  State<OurFaqScreen> createState() => _OurFaqScreenState();
}

class _OurFaqScreenState extends State<OurFaqScreen>
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

  // État pour gérer l'expansion des questions selon les maquettes
  final Map<String, bool> _isExpanded = {
    'Qu\'est-ce que Fibaya ?': false,
    'Comment créer un compte ?': false,
    'L\'application est-elle gratuite ?':
        true, // Étendue par défaut comme dans la maquette
    'Comment passer une commande ?': false,
    'Puis-je annuler une commande ?':
        true, // Étendue par défaut comme dans la maquette
    'Comment modifier une commande ?': false,
    'Quels modes de paiement sont acceptés ?':
        true, // Étendue par défaut comme dans la maquette
    'Quand suis-je facturé ?': false,
    'Puis-je obtenir un reçu ?': false,
    'Comment contacter le support ?':
        true, // Étendue par défaut comme dans la maquette
    'Quels sont vos horaires de support ?': false,
    'Comment signaler un problème ?': false,
  };

  // Liste complète des FAQ organisées par catégories selon les maquettes
  final List<Map<String, dynamic>> _faqCategories = [
    {
      'category': 'Général',
      'icon': Icons.info_outline,
      'color': Colors.blue,
      'questions': [
        {
          'question': 'Qu\'est-ce que Fibaya ?',
          'answer':
              'Fibaya est une plateforme de services à domicile qui connecte les clients avec des prestataires qualifiés pour divers services comme le ménage, la garde d\'enfants, la réparation, etc.',
        },
        {
          'question': 'Comment créer un compte ?',
          'answer':
              'Pour créer un compte, cliquez sur "S\'inscrire", remplissez le formulaire avec vos informations personnelles et validez votre numéro de téléphone.',
        },
        {
          'question': 'L\'application est-elle gratuite ?',
          'answer':
              'L\'inscription et l\'utilisation de base de l\'application sont gratuites. Seuls les services commandés sont payants.',
        },
      ],
    },
    {
      'category': 'Commandes',
      'icon': Icons.shopping_cart,
      'color': Colors.green,
      'questions': [
        {
          'question': 'Comment passer une commande ?',
          'answer':
              'Sélectionnez le service souhaité, choisissez un prestataire, définissez la date et l\'heure, puis confirmez votre commande.',
        },
        {
          'question': 'Puis-je annuler une commande ?',
          'answer':
              'Oui, vous pouvez annuler une commande jusqu\'à 2 heures avant le début du service prévu.',
        },
        {
          'question': 'Comment modifier une commande ?',
          'answer':
              'Vous pouvez modifier les détails de votre commande en contactant directement le prestataire ou en passant par le support client.',
        },
      ],
    },
    {
      'category': 'Paiements',
      'icon': Icons.account_balance_wallet,
      'color': Colors.orange,
      'questions': [
        {
          'question': 'Quels modes de paiement sont acceptés ?',
          'answer':
              'Nous acceptons les cartes bancaires, les virements, Orange Money, MTN Money et les paiements en espèces.',
        },
        {
          'question': 'Quand suis-je facturé ?',
          'answer':
              'Le paiement est effectué après la réalisation du service et votre validation.',
        },
        {
          'question': 'Puis-je obtenir un reçu ?',
          'answer':
              'Oui, un reçu électronique vous est envoyé par email après chaque paiement.',
        },
      ],
    },
    {
      'category': 'Support',
      'icon': Icons.support_agent,
      'color': Colors.purple,
      'questions': [
        {
          'question': 'Comment contacter le support ?',
          'answer':
              'Vous pouvez nous contacter via l\'application, par email à support@fibaya.sn ou par téléphone au +221 XX XXX XX XX.',
        },
        {
          'question': 'Quels sont vos horaires de support ?',
          'answer':
              'Notre support est disponible du lundi au vendredi de 8h à 18h et le samedi de 9h à 15h.',
        },
        {
          'question': 'Comment signaler un problème ?',
          'answer':
              'Si vous rencontrez un problème avec un service ou un prestataire, veuillez le signaler via la section "Aide et Support" de l\'application.',
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'FAQ',
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
            // Section Questions Fréquentes avec icône
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: _buildHeaderSection(),
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

            // Liste des FAQ
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: _buildFaqList(),
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
          // Image FAQ
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
                  'assets/images/FAQ.jpeg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Icône de tête
                          Icon(Icons.person, color: Colors.blue[800], size: 50),
                          // Point d'interrogation
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.help_outline,
                                color: Colors.blue,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Questions Fréquentes',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Trouvez rapidement les réponses à vos questions',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
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
                hintText: 'Rechercher dans la FAQ...',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqList() {
    return Column(
      children: _faqCategories.map((category) {
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
    List<Map<String, dynamic>> questions =
        category['questions'] as List<Map<String, dynamic>>;

    // Filtrer les questions selon la recherche
    List<Map<String, dynamic>> filteredQuestions = questions.where((question) {
      if (_searchQuery.isEmpty) return true;
      return question['question'].toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          question['answer'].toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    if (filteredQuestions.isEmpty && _searchQuery.isNotEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header de la catégorie
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: categoryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: categoryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(categoryIcon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 16),
              Text(
                categoryName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Liste des questions
        Column(
          children: filteredQuestions.map((question) {
            return Container(
              margin: const EdgeInsets.only(bottom: 4),
              child: _buildQuestionCard(question),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildQuestionCard(Map<String, dynamic> question) {
    String questionText = question['question'] as String;
    String answer = question['answer'] as String;
    bool isExpanded = _isExpanded[questionText] ?? false;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        key: PageStorageKey(questionText),
        initiallyExpanded: isExpanded,
        onExpansionChanged: (bool expanded) {
          setState(() {
            _isExpanded[questionText] = expanded;
          });
        },
        title: Text(
          questionText,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        trailing: Icon(
          isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          color: Colors.grey[600],
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 16.0,
            ),
            child: Text(
              answer,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
