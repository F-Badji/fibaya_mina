import 'package:flutter/material.dart';

// Couleur personnalisée Fibaya
const Color fibayaGreen = Color(0xFF065b32);

class TermsAndPoliciesScreen extends StatefulWidget {
  const TermsAndPoliciesScreen({super.key});

  @override
  State<TermsAndPoliciesScreen> createState() => _TermsAndPoliciesScreenState();
}

class _TermsAndPoliciesScreenState extends State<TermsAndPoliciesScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Animation controllers
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Animations
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

    // Start animations
    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _slideController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _scaleController.forward();
  }

  @override
  void dispose() {
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
          'Conditions et Politiques',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildHeaderSection(),
                const SizedBox(height: 20),
                _buildContentSections(),
                const SizedBox(height: 20),
                _buildBottomBanner(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
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
          children: [
            // Logo Fibaya
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 0,
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Image.asset(
                'assets/images/fibaya_logo.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    child: const Center(
                      child: Text(
                        'FB',
                        style: TextStyle(
                          color: fibayaGreen,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'FIBAYA',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: fibayaGreen,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Conditions Générales d\'Utilisation',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Dernière mise à jour : 14/9/2025',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentSections() {
    return Column(
      children: [
        _buildSectionCard('1. Introduction et Acceptation', [
          'Bienvenue sur FIBAYA, la plateforme panafricaine de services de proximité qui connecte clients et prestataires de services qualifiés.',
          'En utilisant notre application, vous acceptez ces Conditions Générales d\'Utilisation. Si vous n\'acceptez pas ces conditions, veuillez ne pas utiliser nos services.',
          'FIBAYA s\'engage à fournir une plateforme sécurisée, transparente et équitable pour tous nos utilisateurs.',
        ]),
        const SizedBox(height: 16),
        _buildSectionCard('2. Définitions', [
          'Client : Toute personne utilisant FIBAYA pour demander des services',
          'Prestataire : Toute personne ou entreprise fournissant des services via FIBAYA',
          'Service : Toute prestation demandée et fournie via notre plateforme',
          'Plateforme : L\'application mobile',
          'Compte : L\'espace personnel de chaque utilisateur sur FIBAYA',
        ]),
        const SizedBox(height: 16),
        _buildSectionCard('3. Inscription et Compte Utilisateur', [
          '3.1 Création de compte : Vous devez fournir des informations exactes et à jour lors de votre inscription.',
          '3.2 Vérification d\'identité : FIBAYA se réserve le droit de vérifier l\'identité de tous les utilisateurs.',
          '3.3 Sécurité du compte : Vous êtes responsable de la sécurité de votre compte et de vos identifiants.',
          '3.4 Un compte par personne : Un seul compte est autorisé par personne physique ou morale.',
        ]),
        const SizedBox(height: 16),
        _buildServicesSection(),
        const SizedBox(height: 16),
        _buildSectionCard('5. Paiements et Facturation', [
          '5.1 Méthodes de paiement acceptées : FIBAYA accepte tous les modes de paiement suivants entre clients et prestataires. Cette flexibilité vous permet de choisir le mode de règlement qui vous convient le mieux.',
          'Paiements mobiles et Paiement en espèces :',
          '• Wave : Service de paiement mobile',
          '• Orange Money : Service de paiement mobile',
          '• Free Money : Service de paiement mobile',
          '• Mixx by Yas : Service de paiement mobile',
          '• Autres',
          'Important : Le paiement s\'effectue à la fin de la prestation. Le montant est libéré au prestataire une fois le service terminé.',
          '5.2 Facturation : Des reçus sont fournis pour chaque transaction.',
        ]),
        const SizedBox(height: 16),
        _buildSectionCard('6. Sécurité et Protection contre la Fraude', [
          '6.1 Système de vérification :',
          '• Vérification d\'identité obligatoire pour tous les utilisateurs',
          '• Vérification des documents officiels (CNI, passeport, etc)',
          '• Vérification des qualifications professionnelles',
          '• Vérification des antécédents judiciaires',
          '6.2 Protection contre la fraude :',
          '• Surveillance 24h/24 des transactions suspectes',
          '• Système d\'alerte automatique pour les activités anormales',
          '• Vérification en temps réel des paiements',
          '• Collaboration avec les autorités compétentes',
          '6.3 Mesures de sécurité :',
          '• Chiffrement pour toutes les communications',
          '• Sécurisé des données personnelles',
          '• Authentification à deux facteurs disponible(A venir dans les prochains mois)',
          '• Surveillance continue de l\'application',
        ]),
        const SizedBox(height: 16),
        _buildSectionCard('7. Protection contre le Vol et la Malversation', [
          '7.1 Assurance FIBAYA : Tous les services sont couverts par notre assurance responsabilité civile.',
          '7.2 Protection des biens :',
          '• Traçabilité complète de tous les services',
          '• Photos avant/après pour les services de réparation',
          '• Système de géolocalisation en temps réel',
          '• Enregistrement des interactions client-prestataire',
          '7.3 Procédure de réclamation :',
          '• Signalement immédiat via l\'application',
          '• Enquête sous 24h par notre équipe',
          '• Remboursement intégral en cas de vol avéré',
          '• Suspension immédiate du prestataire concerné',
          '7.4 Collaboration avec les forces de l\'ordre :',
          '• Signalement automatique aux autorités',
          '• Fourniture de toutes les preuves nécessaires',
          '• Support juridique pour les victimes',
        ]),
        const SizedBox(height: 16),
        _buildSectionCard('8. Responsabilités des Utilisateurs', [
          '8.1 Clients :',
          '• Fournir des informations exactes sur les services demandés',
          '• Respecter les prestataires et leurs biens',
          '• Payer les services dans les délais convenus',
          '• Signaler tout comportement inapproprié',
          '8.2 Prestataires :',
          '• Fournir des services de qualité professionnelle',
          '• Respecter les délais convenus',
          '• Maintenir leurs qualifications à jour',
          '• Respecter la confidentialité des clients',
        ]),
        const SizedBox(height: 16),
        _buildSectionCard('9. Propriété Intellectuelle', [
          '9.1 Marque FIBAYA : Tous les droits de propriété intellectuelle appartiennent à FIBAYA.',
          '9.2 Contenu utilisateur : Les utilisateurs conservent leurs droits sur leur contenu.',
          '9.3 Utilisation autorisée : L\'utilisation de FIBAYA est limitée aux fins prévues.',
          '9.4 Interdictions : Toute reproduction non autorisée est interdite.',
        ]),
        const SizedBox(height: 16),
        _buildSectionCard('10. Limitation de Responsabilité', [
          '10.1 Services tiers : FIBAYA n\'est pas responsable des services fournis par des tiers.',
          '10.2 Force majeure : FIBAYA n\'est pas responsable des événements de force majeure.',
          '10.3 Dommages indirects : FIBAYA n\'est pas responsable des dommages indirects.',
          '10.4 Limitation monétaire : La responsabilité de FIBAYA est limitée entre les clients et les prestataires.',
        ]),
        const SizedBox(height: 16),
        _buildSectionCard('11. Résiliation et Suspension', [
          '11.1 Résiliation par l\'utilisateur : Vous pouvez résilier votre compte à tout moment.',
          '11.2 Suspension par FIBAYA : FIBAYA peut suspendre les comptes violant nos conditions.',
          '11.3 Conséquences : La résiliation entraîne la perte d\'accès aux services.',
          '11.4 Données : Vos données sont conservées selon notre politique de confidentialité.',
        ]),
        const SizedBox(height: 16),
        _buildSectionCard('12. Modifications des Conditions', [
          '12.1 Droit de modification : FIBAYA peut modifier ces conditions à tout moment.',
          '12.2 Notification : Les utilisateurs seront notifiés des modifications importantes.',
          '12.3 Acceptation : L\'utilisation continue implique l\'acceptation des nouvelles conditions.',
          '12.4 Version en vigueur : Seule la version la plus récente fait foi.',
        ]),
        const SizedBox(height: 16),
        _buildSectionCard('13. Droit Applicable et Juridiction', [
          '13.1 Droit applicable : Ces conditions sont régies par le droit sénégalais.',
          '13.2 Juridiction : Les tribunaux de Dakar sont compétents pour tout litige.',
          '13.3 Résolution amiable : FIBAYA privilégie la résolution amiable des conflits.',
          '13.4 Médiation : Un service de médiation est disponible pour les utilisateurs.',
        ]),
      ],
    );
  }

  Widget _buildServicesSection() {
    return Container(
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
          const Text(
            '4. Services et Prestations',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            '4.1 Catégories de services : FIBAYA propose des services de proximité incluant mais non limités à :',
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
          const SizedBox(height: 16),
          _buildServiceCategory('BÂTIMENT & CONSTRUCTION', Icons.home, [
            'Plombier, Électricien, Maçon, Peintre en bâtiment',
            'Carreleur, Menuisier, Vitrier, Plaquiste, Terrassier',
          ]),
          const SizedBox(height: 12),
          _buildServiceCategory('FROID & CLIMATISATION', Icons.ac_unit, [
            'Frigoriste (climatiseur), Installateur de climatisation',
            'Chauffagiste, Technicien CVC',
          ]),
          const SizedBox(height: 12),
          _buildServiceCategory('MÉCANIQUE & MAINTENANCE', Icons.build, [
            'Mécanicien automobile, Mécanicien poids lourds',
            'Mécanicien moto, Carrossier, Peintre automobile',
            'Électricien auto, Soudeur, Chaudronnier',
          ]),
          const SizedBox(height: 12),
          _buildServiceCategory('ENTRETIEN & PROPRETÉ', Icons.check_circle, [
            'Laveur de voitures, Agent d\'entretien',
            'Femme de ménage, Agent de nettoyage, Éboueur',
          ]),
          const SizedBox(height: 12),
          _buildServiceCategory(
            'RESTAURATION & ALIMENTAIRE',
            Icons.restaurant,
            [
              'Cuisinier, Aide-cuisinier, Pâtissier',
              'Boulanger, Boucher, Traiteur',
            ],
          ),
          const SizedBox(height: 12),
          _buildServiceCategory('SERVICE & HÔTELLERIE', Icons.local_cafe, [
            'Serveur, Réceptionniste, Concierge',
          ]),
          const SizedBox(height: 12),
          _buildServiceCategory('BEAUTÉ & BIEN-ÊTRE', Icons.face, [
            'Coiffeur, Coiffeuse, Maquilleuse',
            'Manucure, Massage',
          ]),
          const SizedBox(height: 12),
          _buildServiceCategory('SERVICES À DOMICILE', Icons.home_work, [
            'Jardinier, Garde d\'enfants',
            'Cuisinier à domicile, Laveur de linge',
          ]),
          const SizedBox(height: 12),
          _buildServiceCategory(
            'RÉPARATION & MAINTENANCE',
            Icons.build_circle,
            [
              'Réparateur d\'électroménager, Réparateur de téléphone',
              'Réparateur d\'ordinateur, Réparateur de vélo',
              'Réparateur de moto',
            ],
          ),
          const SizedBox(height: 12),
          _buildServiceCategory('TECHNOLOGIE & COMMUNICATION', Icons.computer, [
            'Technicien informatique, Installateur d\'antenne',
            'Technicien télécom, Graphiste, Photographe',
          ]),
          const SizedBox(height: 12),
          _buildServiceCategory('ÉDUCATION & FORMATION', Icons.school, [
            'Professeur particulier, Formateur',
          ]),
          const SizedBox(height: 12),
          _buildServiceCategory('SANTÉ & BIEN-ÊTRE', Icons.local_hospital, [
            'Infirmier à domicile',
          ]),
          const SizedBox(height: 12),
          _buildServiceCategory('ARTISANAT & CRÉATION', Icons.palette, [
            'Couturier, Cordonnier, Bijoutier',
            'Sculpteur, Peintre artiste',
          ]),
          const SizedBox(height: 12),
          _buildServiceCategory('SÉCURITÉ & SURVEILLANCE', Icons.security, [
            'Agent de sécurité, Garde du corps, Surveillant',
          ]),
          const SizedBox(height: 12),
          _buildServiceCategory('AGRICULTURE & ÉLEVAGE', Icons.eco, [
            'Agriculteur, Éleveur, Vétérinaire, Ouvrier agricole',
          ]),
          const SizedBox(height: 12),
          _buildServiceCategory(
            'DIVERTISSEMENT & ÉVÉNEMENTIEL',
            Icons.music_note,
            [
              'DJ, Musicien, Animateur',
              'Organisateur d\'événements, Décorateur',
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            '4.2 Qualité des services : Tous les prestataires sont vérifiés et certifiés par FIBAYA.',
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
          const SizedBox(height: 8),
          const Text(
            '4.3 Disponibilité : Les services sont disponibles selon la géolocalisation et les horaires des prestataires.',
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCategory(
    String title,
    IconData icon,
    List<String> services,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$title :',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              ...services.map(
                (service) => Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 2),
                  child: Text(
                    '• $service',
                    style: const TextStyle(fontSize: 13, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard(String title, List<String> content) {
    return Container(
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          ...content.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: fibayaGreen,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(Icons.check, color: fibayaGreen, size: 30),
          ),
          const SizedBox(height: 16),
          const Text(
            'En utilisant FIBAYA, vous acceptez ces conditions et vous engagez à respecter nos valeurs de transparence, de sécurité et d\'excellence.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Merci de faire confiance à FIBAYA pour vos services de proximité.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.9),
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
