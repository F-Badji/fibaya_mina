import 'package:flutter/material.dart';

// Couleur personnalisée Fibaya
const Color fibayaGreen = Color(0xFF065b32);

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
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
          'Politique',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () => _showContextMenu(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo FIBAYA
            Center(
              child: Text(
                'FIBAYA',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: fibayaGreen,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Barre de navigation
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.list, color: Colors.grey[600], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Avis de confidentialité de Fibaya et...',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showSharePolicyDialog(),
                    child: Icon(Icons.share, color: fibayaGreen, size: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Titre principal
            const Text(
              'Avis de confidentialité de Fibaya',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),

            // Paragraphe introductif
            const Text(
              'Fibaya est une application mobile permettant de commander des services de proximité auprès de nos prestataires partenaires.',
              style: TextStyle(fontSize: 16, color: Colors.black, height: 1.5),
            ),
            const SizedBox(height: 24),

            // Section 1
            _buildSection(
              title: '1. Quel est l\'objet de cet avis de confidentialité ?',
              content: [
                'Nous nous engageons à protéger la vie privée et nous souhaitons être transparents quant à nos activités et à la manière dont nous traitons vos données à caractère personnel.',
                'L\'objectif de cet Avis de confidentialité est donc de vous informer sur la façon dont nous traitons vos données à caractère personnel et les raisons d\'un tel traitement.',
              ],
            ),

            // Section 2
            _buildSection(
              title: '2. Qui traite vos données à caractère personnel ?',
              content: [
                'Fibaya est le responsable du traitement de vos données à caractère personnel. Nous déterminons les finalités et les moyens du traitement de vos données personnelles conformément aux lois en vigueur sur la protection de la vie privée.',
              ],
            ),

            // Section 3
            _buildSection(
              title:
                  '3. Quelles données à caractère personnel sont traitées, comment et pourquoi ?',
              content: [
                '3.1 Les catégories de données à caractère personnel que nous traitons, ainsi que les finalités et les bases juridiques du traitement sont précisées dans le tableau ci-dessous.',
              ],
            ),

            // Tableau des données
            _buildDataTable(),
            const SizedBox(height: 24),

            // Section 4
            _buildSection(
              title:
                  '4. Comment vos données à caractère personnel sont-elles protégées ?',
              content: [
                '4.1 Nous avons mis en œuvre des mesures techniques et organisationnelles appropriées pour protéger vos données à caractère personnel contre la perte, l\'utilisation abusive, l\'accès non autorisé, la divulgation, l\'altération ou la destruction.',
                '4.2 Ces mesures incluent le chiffrement des données, l\'authentification sécurisée, et des contrôles d\'accès stricts.',
              ],
            ),

            // Section 5
            _buildSection(
              title: '5. Avec qui partageons-nous vos données ?',
              content: [
                '5.1 Nous ne partageons vos données personnelles qu\'avec nos prestataires de services de confiance, uniquement dans la mesure nécessaire pour fournir nos services.',
                '5.2 Vos données peuvent être partagées avec les prestataires de services que vous sélectionnez via notre plateforme, dans le but de faciliter la prestation de services.',
              ],
            ),

            // Section 6
            _buildSection(
              title: '6. Vos droits',
              content: [
                '6.1 Vous avez le droit d\'accéder, de rectifier, de supprimer ou de limiter le traitement de vos données personnelles.',
                '6.2 Vous pouvez retirer votre consentement à tout moment pour les traitements basés sur le consentement.',
                '6.3 Vous avez le droit de porter plainte auprès de l\'autorité de contrôle compétente.',
              ],
            ),

            const SizedBox(height: 40),

            // Pied de page
            _buildFooter(),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required List<String> content}) {
    return Column(
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
        ...content
            .map(
              (paragraph) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  paragraph,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    height: 1.5,
                  ),
                ),
              ),
            )
            .toList(),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildDataTable() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // En-têtes du tableau
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Catégories de données',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                Container(width: 1, height: 20, color: Colors.grey[300]),
                Expanded(
                  flex: 3,
                  child: Text(
                    'Finalités',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Lignes du tableau
          _buildTableRow('Nom ou pseudonyme', 'Pour créer votre compte'),
          _buildTableRow(
            'Numéro de téléphone',
            'Pour vous identifier et vous autoriser en tant qu\'utilisateur',
          ),
          _buildTableRow(
            'Adresses de destination',
            'Pour communiquer avec vous au sujet de votre commande\nPour vous présenter les services disponibles',
          ),
          _buildTableRow(
            'Préférences des clients',
            'Pour traiter et exécuter votre commande selon vos préférences',
          ),
          _buildTableRow(
            'Informations de paiement',
            'Les paiements sont effectués en dehors de l\'application FIBAYA. FIBAYA n\'est pas responsable de la sécurité des transactions de paiement.',
          ),
          _buildTableRow(
            'Données de géolocalisation',
            'Pour vérifier la disponibilité des prestataires\nPour vous attribuer un prestataire\nPour envoyer votre localisation au prestataire',
          ),
          _buildTableRow(
            'Identifiant de l\'appareil',
            'Pour prévenir la fraude et sécuriser nos systèmes',
          ),
          _buildTableRow(
            'Type et modèle de l\'appareil',
            'Pour optimiser l\'expérience utilisateur',
          ),
          _buildTableRow(
            'Système d\'exploitation',
            'Pour assurer la compatibilité de l\'application',
          ),
          _buildTableRow(
            'Identifiant utilisateur Fibaya',
            'Pour améliorer nos applications et l\'expérience utilisateur',
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(String category, String purpose) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              category,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.grey[300],
            margin: const EdgeInsets.symmetric(horizontal: 8),
          ),
          Expanded(
            flex: 3,
            child: Text(
              purpose,
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Center(
          child: Text(
            'Fibaya',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: fibayaGreen,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '© 2025 Fibaya. Tous droits réservés.',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          'Version 1.0 - Dernière mise à jour : 12/9/2025',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _showContextMenu(BuildContext context) {
    try {
      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: '',
        barrierColor: Colors.black.withOpacity(0.3),
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) {
          return Container();
        },
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(1.0, 0.0), // Commence depuis la droite
                  end: Offset.zero, // Se positionne à sa place finale
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                ),
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: const EdgeInsets.only(right: 16, top: 60),
                width: 240,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      spreadRadius: 0,
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      spreadRadius: 0,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header avec une petite flèche pointant vers le menu hamburger
                    Container(
                      padding: const EdgeInsets.only(top: 8, bottom: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 0,
                            height: 0,
                            margin: const EdgeInsets.only(right: 24),
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: Colors.white, width: 10),
                                left: BorderSide(
                                  color: Colors.transparent,
                                  width: 10,
                                ),
                                right: BorderSide(
                                  color: Colors.transparent,
                                  width: 10,
                                ),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 0,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildMenuItem(
                      icon: Icons.share_rounded,
                      title: 'Partager',
                      onTap: () {
                        Navigator.pop(context);
                        _showSimpleDialog(
                          'Partager',
                          'Fonctionnalité de partage',
                        );
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.print_rounded,
                      title: 'Imprimer',
                      onTap: () {
                        Navigator.pop(context);
                        _showSimpleDialog(
                          'Imprimer',
                          'Fonctionnalité d\'impression',
                        );
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.bookmark_add_rounded,
                      title: 'Marquer',
                      onTap: () {
                        Navigator.pop(context);
                        _showSimpleDialog(
                          'Marquer',
                          'Fonctionnalité de marquage',
                        );
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.search_rounded,
                      title: 'Rechercher',
                      onTap: () {
                        Navigator.pop(context);
                        _showSimpleDialog(
                          'Rechercher',
                          'Fonctionnalité de recherche',
                        );
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.text_increase_rounded,
                      title: 'Taille du texte',
                      onTap: () {
                        Navigator.pop(context);
                        _showSimpleDialog(
                          'Taille du texte',
                          'Fonctionnalité de taille de texte',
                        );
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.language_rounded,
                      title: 'Langue',
                      onTap: () {
                        Navigator.pop(context);
                        _showSimpleDialog('Langue', 'Fonctionnalité de langue');
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.help_center_rounded,
                      title: 'Aide',
                      onTap: () {
                        Navigator.pop(context);
                        _showSimpleDialog('Aide', 'Fonctionnalité d\'aide');
                      },
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      print('Erreur dans le menu hamburger: $e');
    }
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: fibayaGreen.withOpacity(0.1),
        highlightColor: fibayaGreen.withOpacity(0.05),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [fibayaGreen.withOpacity(0.8), fibayaGreen],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: fibayaGreen.withOpacity(0.3),
                      spreadRadius: 0,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.grey[400],
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSimpleDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showSharePolicyDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Partager la politique',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: const Text(
            'Partager la politique de confidentialité FIBAYA via email, SMS ou réseaux sociaux.',
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Annuler',
                    style: TextStyle(
                      fontSize: 16,
                      color: fibayaGreen,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Ici vous pouvez ajouter la logique de partage
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Fonctionnalité de partage à implémenter',
                        ),
                        backgroundColor: fibayaGreen,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: fibayaGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Partager',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
