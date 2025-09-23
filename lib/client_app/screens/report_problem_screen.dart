import 'package:flutter/material.dart';

// Couleur personnalisée Fibaya
const Color fibayaGreen = Color(0xFF065b32);

class ReportProblemScreen extends StatefulWidget {
  const ReportProblemScreen({Key? key}) : super(key: key);

  @override
  State<ReportProblemScreen> createState() => _ReportProblemScreenState();
}

class _ReportProblemScreenState extends State<ReportProblemScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedCategory = '';
  String _selectedService = '';
  String _selectedPriority = 'Moyen';
  Set<String> _selectedProblems = {};

  final List<String> _problemTypes = [
    'Paiement non débité',
    'Double facturation',
    'Remboursement non reçu',
    'Erreur de montant',
    'Carte refusée',
    'Problème de portefeuille électronique',
    'Prestataire en retard',
    'Prestataire ne répond pas',
    'Service de mauvaise qualité',
    'Prestataire impoli',
    'Prestataire non qualifié',
    'Prestataire absent',
    'Prestataire a endommagé quelque chose',
    'Prestataire a volé quelque chose',
    'Application qui plante',
    'Problème de connexion',
    'Erreur de géolocalisation',
    'Problème de notification',
    'Interface qui ne répond pas',
    'Problème de téléchargement',
    'Erreur de synchronisation',
    'Impossible de se connecter',
    'Mot de passe oublié',
    'Compte bloqué',
    'Informations incorrectes',
    'Problème de vérification',
    'Compte suspendu',
    'Service non disponible',
    'Prix incorrect',
    'Description inexacte',
    'Service annulé sans préavis',
    'Service non terminé',
    'Matériel manquant',
    'Données personnelles exposées',
    'Compte piraté',
    'Transaction suspecte',
    'Profil falsifié',
    'Harcèlement',
    'Menaces',
    'Facture incorrecte',
    'Frais cachés',
    'Taxe incorrecte',
    'Promotion non appliquée',
    'Code promo non valide',
    'Problème de livraison',
    'Produit endommagé',
    'Commande incorrecte',
    'Problème de communication',
    'Attente trop longue',
    'Problème d\'annulation',
  ];

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
          'Signaler un problème',
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
            // Carte d'introduction
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Icône d'exclamation dans un cercle vert
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: fibayaGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Icon(Icons.warning, color: fibayaGreen, size: 40),
                  ),
                  const SizedBox(height: 20),

                  // Titre
                  const Text(
                    'Aidez-nous à améliorer FIBAYA',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),

                  // Texte descriptif
                  Text(
                    'Décrivez votre problème et nous vous aiderons rapidement',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Carte du formulaire
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Catégorie du problème
                  _buildDropdownField(
                    'Catégorie du problème',
                    _selectedCategory.isEmpty
                        ? 'Sélectionnez une option'
                        : _selectedCategory,
                    () => _showCategoryDialog(),
                  ),
                  const SizedBox(height: 16),

                  // Service concerné
                  _buildDropdownField(
                    'Service concerné',
                    _selectedService.isEmpty
                        ? 'Sélectionnez une option'
                        : _selectedService,
                    () => _showServiceDialog(),
                  ),
                  const SizedBox(height: 16),

                  // Priorité
                  _buildDropdownField(
                    'Priorité',
                    _selectedPriority,
                    () => _showPriorityDialog(),
                  ),
                  const SizedBox(height: 16),

                  // Type de problème
                  const Text(
                    'Type de problème (sélection multiple)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Carte des types de problèmes
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _problemTypes.map((problem) {
                  bool isSelected = _selectedProblems.contains(problem);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedProblems.remove(problem);
                        } else {
                          _selectedProblems.add(problem);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? fibayaGreen : Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? fibayaGreen : Colors.grey[300]!,
                        ),
                      ),
                      child: Text(
                        problem,
                        style: TextStyle(
                          fontSize: 14,
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // Carte de description
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Description détaillée',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: TextField(
                      controller: _descriptionController,
                      maxLines: 4,
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Décrivez votre problème en détail...',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Bouton d'envoi
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isFormValid() ? () => _submitReport() : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isFormValid()
                      ? fibayaGreen
                      : Colors.grey[400],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: _isFormValid() ? 4 : 0,
                ),
                child: Text(
                  'Envoyer le signalement',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Carte de support
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: fibayaGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: fibayaGreen.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Icon(Icons.headset_mic, color: fibayaGreen, size: 40),
                  const SizedBox(height: 16),

                  const Text(
                    'Besoin d\'aide immédiate ?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  Text(
                    'Contactez notre support 24h/24 via WhatsApp ou appel gratuit.',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField(String title, String value, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      color: value.contains('Sélectionnez')
                          ? Colors.grey[400]
                          : Colors.black,
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey[600],
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showCategoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        content: Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                spreadRadius: 0,
                blurRadius: 25,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 0,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // En-tête avec gradient
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.grey[50]!, Colors.grey[100]!],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: fibayaGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.category, color: fibayaGreen, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Catégorie du problème',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              // Liste des options avec barre de défilement personnalisée
              Container(
                constraints: const BoxConstraints(maxHeight: 350),
                child: Scrollbar(
                  thumbVisibility: true,
                  trackVisibility: true,
                  thickness: 6,
                  radius: const Radius.circular(10),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      children: [
                        _buildCategoryOption('Problème de paiement'),
                        _buildCategoryOption('Problème avec un prestataire'),
                        _buildCategoryOption('Problème technique'),
                        _buildCategoryOption('Problème de compte'),
                        _buildCategoryOption('Problème de service'),
                        _buildCategoryOption('Problème de sécurité'),
                        _buildCategoryOption('Problème de facturation'),
                        _buildCategoryOption('Autre'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryOption(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedCategory = title;
            });
            Navigator.pop(context);
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.05),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: fibayaGreen,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showServiceDialog() {
    final List<String> services = [
      'Plombier(e)',
      'Électricien(e)',
      'Maçon(ne)',
      'Peintre en bâtiment',
      'Carreleur(e)',
      'Menuisier(e)',
      'Vitrier(e)',
      'Plaquiste(e)',
      'Terrassier(e)',
      'Frigoriste (climatiseur)',
      'Installateur/Reparateur de climatisation',
      'Chauffagiste(e)',
      'Technicien CVC',
      'Mécanicien automobile',
      'Mécanicien moto',
      'Carrossier',
      'Peintre automobile',
      'Soudeur(e)',
      'Chaudronnier(e)',
      'Laveur de voitures',
      'Agent d\'entretien',
      'Femme de ménage',
      'Agent de nettoyage',
      'Éboueur',
      'Cuisinier/Aide-cuisinier',
      'Pâtissier(e)',
      'Boulanger(e)',
      'Boucher(e)',
      'Traiteur(e)',
      'Serveur(e)',
      'Réceptionniste(e)',
      'Concierge(e)',
      'Coiffeur(se)',
      'Maquilleuse',
      'Manucure',
      'Massage',
      'Jardinier(e)',
      'Garde d\'enfants(e)',
      'Laveur de linge(e)',
      'Réparateur d\'électroménager(e)',
      'Réparateur de téléphone(e)',
      'Réparateur d\'ordinateur(e)',
      'Réparateur de vélo(e)',
      'Réparateur de moto(e)',
      'Technicien informatique(e)',
      'Installateur d\'antenne(e)',
      'Technicien télécom(e)',
      'Graphiste(e)',
      'Photographe(e)',
      'Professeur particulier(e)',
      'Formateur(e)',
      'Infirmier à domicile(e)',
      'Couturier(e)',
      'Cordonnier(e)',
      'Bijoutier(e)',
      'Sculpteur(e)',
      'Peintre artiste(e)',
      'Agent de sécurité(e)',
      'Garde du corps(e)',
      'Surveillant(e)',
      'Agriculteur(e)',
      'Éleveur(e)',
      'Vétérinaire(e)',
      'Ouvrier agricole(e)',
      'DJ',
      'Musicien(ne)',
      'Animateur(e)',
      'Organisateur d\'événements(e)',
      'Décorateur(e)',
      'Autre',
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        content: Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 0,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // En-tête
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: const Row(
                  children: [
                    Text(
                      'Service concerné',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              // Liste des options
              Container(
                constraints: const BoxConstraints(maxHeight: 400),
                child: SingleChildScrollView(
                  child: Column(
                    children: services
                        .map((service) => _buildServiceOption(service))
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceOption(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedService = title;
            });
            Navigator.pop(context);
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.05),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.blue[400],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPriorityDialog() {
    final List<String> priorities = ['Faible', 'Moyen', 'Élevé', 'Urgent'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        content: Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 0,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // En-tête
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: const Row(
                  children: [
                    Text(
                      'Priorité',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              // Liste des options
              Container(
                constraints: const BoxConstraints(maxHeight: 300),
                child: SingleChildScrollView(
                  child: Column(
                    children: priorities
                        .map((priority) => _buildPriorityOption(priority))
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityOption(String title) {
    Color priorityColor;
    switch (title) {
      case 'Faible':
        priorityColor = fibayaGreen;
        break;
      case 'Moyen':
        priorityColor = Colors.orange[400]!;
        break;
      case 'Élevé':
        priorityColor = Colors.red[400]!;
        break;
      case 'Urgent':
        priorityColor = Colors.purple[400]!;
        break;
      default:
        priorityColor = Colors.grey[400]!;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedPriority = title;
            });
            Navigator.pop(context);
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.05),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: priorityColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isFormValid() {
    return _selectedCategory.isNotEmpty &&
        _selectedService.isNotEmpty &&
        _selectedPriority.isNotEmpty &&
        _selectedProblems.isNotEmpty;
  }

  void _submitReport() {
    if (_selectedProblems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner au moins un type de problème'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Signalement envoyé'),
        content: const Text(
          'Votre signalement a été envoyé avec succès. Nous vous contacterons bientôt.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Fermer le dialog
              Navigator.pop(context); // Retourner à l'écran précédent
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}
