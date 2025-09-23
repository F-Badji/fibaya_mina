import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_theme.dart';

class PrestataireRegistrationScreen extends StatefulWidget {
  const PrestataireRegistrationScreen({super.key});

  @override
  State<PrestataireRegistrationScreen> createState() =>
      _PrestataireRegistrationScreenState();
}

class _PrestataireRegistrationScreenState
    extends State<PrestataireRegistrationScreen> {
  int _currentStep = 1;

  // Form data
  String _serviceType = '';
  String _experience = '';
  String _description = ''; // Used in step 4 summary
  String _firstName = '';
  String _lastName = '';
  String _phone = '';
  String _email = '';
  String _address = ''; // Used in step 4 summary
  String _city = ''; // Used in step 4 summary
  String _zipCode = ''; // Used in step 4 summary
  String _certifications = ''; // Used in step 4 summary

  // File uploads
  bool _hasProfilePhoto = false;
  bool _hasIdCardFront = false;
  bool _hasIdCardBack = false;
  bool _hasDiploma = false;
  bool _hasCv = false;

  final List<Map<String, dynamic>> _serviceTypes = [
    // BÂTIMENT & CONSTRUCTION
    {'id': 'plombier', 'label': 'Plombier(e)', 'icon': Icons.plumbing},
    {
      'id': 'electricien',
      'label': 'Électricien(e)',
      'icon': Icons.electrical_services,
    },
    {'id': 'macon', 'label': 'Maçon(ne)', 'icon': Icons.construction},
    {
      'id': 'peintre_batiment',
      'label': 'Peintre en bâtiment',
      'icon': Icons.format_paint,
    },
    {'id': 'carreleur', 'label': 'Carreleur(e)', 'icon': Icons.grid_view},
    {'id': 'menuisier', 'label': 'Menuisier(e)', 'icon': Icons.carpenter},
    {'id': 'vitrier', 'label': 'Vitrier(e)', 'icon': Icons.window},
    {'id': 'plaquiste', 'label': 'Plaquiste(e)', 'icon': Icons.view_in_ar},
    {'id': 'terrassier', 'label': 'Terrassier(e)', 'icon': Icons.landscape},
    {'id': 'couvreur', 'label': 'Couvreur(e)', 'icon': Icons.roofing},
    {'id': 'charpentier', 'label': 'Charpentier(e)', 'icon': Icons.forest},
    {'id': 'serrurier', 'label': 'Serrurier(e)', 'icon': Icons.lock},

    // FROID & CLIMATISATION
    {
      'id': 'frigoriste',
      'label': 'Frigoriste (climatiseur)',
      'icon': Icons.ac_unit,
    },
    {
      'id': 'installateur_climatisation',
      'label': 'Installateur/Reparateur de climatisation',
      'icon': Icons.air,
    },
    {
      'id': 'chauffagiste',
      'label': 'Chauffagiste(e)',
      'icon': Icons.local_fire_department,
    },
    {
      'id': 'technicien_cvc',
      'label': 'Technicien CVC',
      'icon': Icons.thermostat,
    },

    // MÉCANIQUE & MAINTENANCE
    {
      'id': 'mecanicien_auto',
      'label': 'Mécanicien automobile',
      'icon': Icons.car_repair,
    },
    {
      'id': 'mecanicien_moto',
      'label': 'Mécanicien moto',
      'icon': Icons.motorcycle,
    },
    {'id': 'carrossier', 'label': 'Carrossier', 'icon': Icons.car_crash},
    {
      'id': 'peintre_auto',
      'label': 'Peintre automobile',
      'icon': Icons.color_lens,
    },
    {'id': 'soudeur', 'label': 'Soudeur(e)', 'icon': Icons.whatshot},
    {
      'id': 'chaudronnier',
      'label': 'Chaudronnier(e)',
      'icon': Icons.engineering,
    },
    {
      'id': 'mecanicien_velo',
      'label': 'Mécanicien vélo',
      'icon': Icons.pedal_bike,
    },

    // ENTRETIEN & PROPRETÉ
    {
      'id': 'laveur_voitures',
      'label': 'Laveur de voitures',
      'icon': Icons.local_car_wash,
    },
    {
      'id': 'agent_entretien',
      'label': 'Agent d\'entretien',
      'icon': Icons.cleaning_services,
    },
    {
      'id': 'femme_menage',
      'label': 'Femme de ménage',
      'icon': Icons.home_repair_service,
    },
    {
      'id': 'agent_nettoyage',
      'label': 'Agent de nettoyage',
      'icon': Icons.cleaning_services,
    },
    {'id': 'eboueur', 'label': 'Éboueur', 'icon': Icons.delete},
    {
      'id': 'nettoyage_industriel',
      'label': 'Nettoyage industriel',
      'icon': Icons.factory,
    },
    {'id': 'repassage', 'label': 'Repassage', 'icon': Icons.iron},

    // RESTAURATION & ALIMENTAIRE
    {
      'id': 'cuisinier',
      'label': 'Cuisinier/Aide-cuisinier',
      'icon': Icons.restaurant,
    },
    {'id': 'patissier', 'label': 'Pâtissier(e)', 'icon': Icons.cake},
    {'id': 'boulanger', 'label': 'Boulanger(e)', 'icon': Icons.bakery_dining},
    {'id': 'boucher', 'label': 'Boucher(e)', 'icon': Icons.kitchen},
    {'id': 'traiteur', 'label': 'Traiteur(e)', 'icon': Icons.room_service},
    {'id': 'serveur', 'label': 'Serveur(e)', 'icon': Icons.restaurant_menu},
    {'id': 'barman', 'label': 'Barman(e)', 'icon': Icons.local_bar},
    {'id': 'sommelier', 'label': 'Sommelier(e)', 'icon': Icons.wine_bar},

    // SERVICE & HÔTELLERIE
    {'id': 'receptionniste', 'label': 'Réceptionniste(e)', 'icon': Icons.desk},
    {'id': 'concierge', 'label': 'Concierge(e)', 'icon': Icons.support_agent},
    {'id': 'chauffeur', 'label': 'Chauffeur(e)', 'icon': Icons.drive_eta},
    {
      'id': 'guide_touristique',
      'label': 'Guide touristique(e)',
      'icon': Icons.tour,
    },

    // BEAUTÉ & BIEN-ÊTRE
    {'id': 'coiffeur', 'label': 'Coiffeur(se)', 'icon': Icons.content_cut},
    {'id': 'maquilleuse', 'label': 'Maquilleuse', 'icon': Icons.face},
    {'id': 'manucure', 'label': 'Manucure', 'icon': Icons.self_improvement},
    {'id': 'massage', 'label': 'Massage', 'icon': Icons.spa},
    {'id': 'pedicure', 'label': 'Pédicure', 'icon': Icons.self_improvement},
    {
      'id': 'estheticienne',
      'label': 'Esthéticienne',
      'icon': Icons.face_retouching_natural,
    },
    {'id': 'barbier', 'label': 'Barbier(e)', 'icon': Icons.content_cut},

    // SERVICES À DOMICILE
    {'id': 'jardinier', 'label': 'Jardinier(e)', 'icon': Icons.grass},
    {
      'id': 'garde_enfants',
      'label': 'Garde d\'enfants(e)',
      'icon': Icons.child_care,
    },
    {
      'id': 'laveur_linge',
      'label': 'Laveur de linge(e)',
      'icon': Icons.local_laundry_service,
    },
    {'id': 'nounou', 'label': 'Nounou', 'icon': Icons.baby_changing_station},
    {
      'id': 'aide_menagere',
      'label': 'Aide-ménagère',
      'icon': Icons.home_repair_service,
    },
    {'id': 'tuteur', 'label': 'Tuteur(e)', 'icon': Icons.school},

    // RÉPARATION & MAINTENANCE
    {
      'id': 'reparateur_electromenager',
      'label': 'Réparateur d\'électroménager(e)',
      'icon': Icons.build_circle,
    },
    {
      'id': 'reparateur_telephone',
      'label': 'Réparateur de téléphone(e)',
      'icon': Icons.phone_android,
    },
    {
      'id': 'reparateur_ordinateur',
      'label': 'Réparateur d\'ordinateur(e)',
      'icon': Icons.computer,
    },
    {
      'id': 'reparateur_velo',
      'label': 'Réparateur de vélo(e)',
      'icon': Icons.pedal_bike,
    },
    {
      'id': 'reparateur_moto',
      'label': 'Réparateur de moto(e)',
      'icon': Icons.motorcycle,
    },
    {'id': 'reparateur_tv', 'label': 'Réparateur TV(e)', 'icon': Icons.tv},
    {
      'id': 'reparateur_lave_linge',
      'label': 'Réparateur lave-linge(e)',
      'icon': Icons.local_laundry_service,
    },

    // TECHNOLOGIE & COMMUNICATION
    {
      'id': 'technicien_informatique',
      'label': 'Technicien informatique(e)',
      'icon': Icons.computer,
    },
    {
      'id': 'installateur_antenne',
      'label': 'Installateur d\'antenne(e)',
      'icon': Icons.signal_cellular_alt,
    },
    {
      'id': 'technicien_telecom',
      'label': 'Technicien télécom(e)',
      'icon': Icons.signal_cellular_alt,
    },
    {'id': 'graphiste', 'label': 'Graphiste(e)', 'icon': Icons.design_services},
    {'id': 'photographe', 'label': 'Photographe(e)', 'icon': Icons.camera_alt},

    // ÉDUCATION & FORMATION
    {
      'id': 'professeur_particulier',
      'label': 'Professeur particulier(e)',
      'icon': Icons.school,
    },
    {
      'id': 'formateur',
      'label': 'Formateur(e)',
      'icon': Icons.person_add_alt_1,
    },
    {'id': 'coach', 'label': 'Coach(e)', 'icon': Icons.sports_motorsports},
    {'id': 'traducteur', 'label': 'Traducteur(e)', 'icon': Icons.translate},

    // SANTÉ & BIEN-ÊTRE
    {
      'id': 'infirmier_domicile',
      'label': 'Infirmier à domicile(e)',
      'icon': Icons.medical_services,
    },

    // ARTISANAT & CRÉATION
    {'id': 'couturier', 'label': 'Couturier(e)', 'icon': Icons.content_cut},
    {'id': 'cordonnier', 'label': 'Cordonnier(e)', 'icon': Icons.shopping_bag},
    {'id': 'bijoutier', 'label': 'Bijoutier(e)', 'icon': Icons.diamond},
    {'id': 'sculpteur', 'label': 'Sculpteur(e)', 'icon': Icons.palette},
    {
      'id': 'peintre_artiste',
      'label': 'Peintre artiste(e)',
      'icon': Icons.palette,
    },
    {'id': 'tapissier', 'label': 'Tapissier(e)', 'icon': Icons.chair},
    {'id': 'ebeniste', 'label': 'Ébéniste(e)', 'icon': Icons.carpenter},

    // SÉCURITÉ & SURVEILLANCE
    {
      'id': 'agent_securite',
      'label': 'Agent de sécurité(e)',
      'icon': Icons.security,
    },
    {
      'id': 'garde_corps',
      'label': 'Garde du corps(e)',
      'icon': Icons.person_pin,
    },
    {'id': 'surveillant', 'label': 'Surveillant(e)', 'icon': Icons.visibility},

    // AGRICULTURE & ÉLEVAGE
    {'id': 'agriculteur', 'label': 'Agriculteur(e)', 'icon': Icons.agriculture},
    {'id': 'eleveur', 'label': 'Éleveur(e)', 'icon': Icons.pets},
    {
      'id': 'veterinaire',
      'label': 'Vétérinaire(e)',
      'icon': Icons.medical_services,
    },
    {
      'id': 'ouvrier_agricole',
      'label': 'Ouvrier agricole(e)',
      'icon': Icons.agriculture,
    },

    // DIVERTISSEMENT & ÉVÉNEMENTIEL
    {'id': 'dj', 'label': 'DJ', 'icon': Icons.music_note},
    {'id': 'musicien', 'label': 'Musicien(ne)', 'icon': Icons.music_note},
    {'id': 'animateur', 'label': 'Animateur(e)', 'icon': Icons.mic},
    {
      'id': 'organisateur_evenements',
      'label': 'Organisateur d\'événements(e)',
      'icon': Icons.event,
    },
    {
      'id': 'decorateur',
      'label': 'Décorateur(e)',
      'icon': Icons.home_repair_service,
    },
    {'id': 'comedien', 'label': 'Comédien(ne)', 'icon': Icons.theater_comedy},
    {'id': 'danseur', 'label': 'Danseur(e)', 'icon': Icons.music_note},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0x0D065b32), // primary/5
              Color(0x1A065b32), // accent/10
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 32),

                // Header
                _buildHeader(),

                const SizedBox(height: 32),

                // Progress Steps
                _buildProgressSteps(),

                const SizedBox(height: 32),

                // Main Card
                _buildMainCard(),

                const SizedBox(height: 32),

                // Footer
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.people, size: 32, color: Colors.white),
            ),
            const SizedBox(width: 12),
            const Text(
              'Fibaya Pro',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryGreen,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Rejoignez notre réseau de prestataires professionnels',
          style: TextStyle(fontSize: 18, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildProgressSteps() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 1; i <= 4; i++) ...[
          _buildStepIndicator(i),
          if (i < 4) _buildStepConnector(i),
        ],
      ],
    );
  }

  Widget _buildStepIndicator(int stepNumber) {
    final isCompleted = _isStepComplete(stepNumber);
    final isCurrent = _currentStep == stepNumber;

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isCompleted || isCurrent
            ? AppTheme.primaryGreen
            : Colors.grey[300],
        shape: BoxShape.circle,
        border: isCompleted
            ? Border.all(color: AppTheme.primaryGreen, width: 2)
            : null,
      ),
      child: Center(
        child: isCompleted
            ? const Icon(Icons.check, color: Colors.white, size: 20)
            : Text(
                stepNumber.toString(),
                style: TextStyle(
                  color: isCurrent ? Colors.white : Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildStepConnector(int stepNumber) {
    return Container(
      width: 48,
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: _currentStep > stepNumber
          ? AppTheme.primaryGreen
          : Colors.grey[300],
    );
  }

  Widget _buildMainCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          // Card Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.build, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      _getStepTitle(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _getStepDescription(),
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ],
            ),
          ),

          // Card Content
          Padding(
            padding: const EdgeInsets.all(32),
            child: _buildStepContent(),
          ),

          // Navigation Buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 0, 32, 16),
            child: _buildNavigationButtons(),
          ),

          // Section Document version Simple (uniquement pour l'étape 3)
          if (_currentStep == 3) ...[
            const SizedBox(height: 64),
            // Sous-en-tête Pro (style vert comme en haut)
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Row(
                    children: [
                      Icon(Icons.build, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Document version Simple',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Téléchargez vos pièces justificatives',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Rapide Section Cards
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Photo de profil (Rapide)
                  _buildFileUpload(
                    title: 'Photo de profil *',
                    icon: Icons.camera_alt,
                    description:
                        'Cliquez pour télécharger votre photo de profil',
                    subtitle: 'Format JPG, PNG (max 5MB)',
                    isUploaded: _hasProfilePhoto,
                    onTap: () {
                      setState(() {
                        _hasProfilePhoto = true;
                      });
                    },
                  ),

                  const SizedBox(height: 24),

                  // Carte d'identité - Recto (Rapide)
                  _buildFileUpload(
                    title: 'Carte d\'identité - Recto *',
                    icon: Icons.upload,
                    description:
                        'Téléchargez le recto de votre carte d\'identité',
                    subtitle: 'Assurez-vous que tous les détails sont lisibles',
                    isUploaded: _hasIdCardFront,
                    onTap: () {
                      setState(() {
                        _hasIdCardFront = true;
                      });
                    },
                  ),

                  const SizedBox(height: 24),

                  // Carte d'identité - Verso (Rapide)
                  _buildFileUpload(
                    title: 'Carte d\'identité - Verso *',
                    icon: Icons.description,
                    description:
                        'Téléchargez le verso de votre carte d\'identité',
                    subtitle: 'Format JPG, PNG (max 5MB)',
                    isUploaded: _hasIdCardBack,
                    onTap: () {
                      setState(() {
                        _hasIdCardBack = true;
                      });
                    },
                  ),

                  const SizedBox(height: 24),

                  // Rapide Navigation Buttons
                  _buildNavigationButtons(),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 1:
        return 'Choisissez votre spécialité';
      case 2:
        return 'Informations personnelles';
      case 3:
        return 'Documents version Pro';
      case 4:
        return 'Récapitulatif';
      default:
        return '';
    }
  }

  String _getStepDescription() {
    switch (_currentStep) {
      case 1:
        return 'Sélectionnez votre domaine d\'expertise principal';
      case 2:
        return 'Renseignez vos coordonnées personnelles';
      case 3:
        return 'Téléchargez vos pièces justificatives';
      case 4:
        return 'Vérifiez vos informations avant envoi';
      default:
        return '';
    }
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 1:
        return _buildStep1();
      case 2:
        return _buildStep2();
      case 3:
        return _buildStep3();
      case 4:
        return _buildStep4();
      default:
        return const SizedBox();
    }
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Service Types Grid - Intégré dans le scroll global
        GridView.builder(
          shrinkWrap: true, // Permet au GridView de s'adapter à son contenu
          physics:
              const NeverScrollableScrollPhysics(), // Désactive le scroll local
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: _serviceTypes.length,
          itemBuilder: (context, index) {
            final service = _serviceTypes[index];
            final isSelected = _serviceType == service['id'];

            return GestureDetector(
              onTap: () {
                setState(() {
                  _serviceType = service['id']!;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primaryGreen
                        : Colors.grey[300]!,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: isSelected
                      ? AppTheme.primaryGreen.withOpacity(0.05)
                      : Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      service['icon'] as IconData,
                      size: 24,
                      color: isSelected
                          ? AppTheme.primaryGreen
                          : Colors.grey[600],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      service['label']!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? AppTheme.primaryGreen
                            : Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 32),

        // Experience
        const Text(
          'Années d\'expérience',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _experience.isEmpty ? null : _experience,
          decoration: InputDecoration(
            hintText: 'Sélectionnez votre expérience',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Color(0xFF065b32)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Color(0xFF065b32), width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Color(0xFF065b32)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          items: const [
            DropdownMenuItem(value: '0-2', child: Text('0 à 2 ans')),
            DropdownMenuItem(value: '3-5', child: Text('3 à 5 ans')),
            DropdownMenuItem(value: '6-10', child: Text('6 à 10 ans')),
            DropdownMenuItem(value: '10+', child: Text('Plus de 10 ans')),
          ],
          onChanged: (value) {
            setState(() {
              _experience = value ?? '';
            });
          },
        ),

        const SizedBox(height: 24),

        // Description
        const Text(
          'Description de vos services',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Décrivez brièvement vos compétences et services...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF065b32)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF065b32), width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF065b32)),
            ),
          ),
          onChanged: (value) {
            setState(() {
              _description = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name fields
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Prénom *',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF065b32)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF065b32),
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF065b32)),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _firstName = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nom *',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF065b32)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF065b32),
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF065b32)),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _lastName = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Contact fields
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Téléphone *',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: '+33 6 12 34 56 78',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF065b32)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF065b32),
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF065b32)),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _phone = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Email *',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF065b32)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF065b32),
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF065b32)),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _email = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Address
        const Text(
          'Adresse complète',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF065b32)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF065b32), width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF065b32)),
            ),
          ),
          onChanged: (value) {
            setState(() {
              _address = value;
            });
          },
        ),

        const SizedBox(height: 24),

        // City and Zip
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ville',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF065b32)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF065b32),
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF065b32)),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _city = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Code postal',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF065b32)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF065b32),
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF065b32)),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _zipCode = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Certifications
        const Text(
          'Certifications et diplômes',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          maxLines: 3,
          decoration: InputDecoration(
            hintText:
                'Listez vos certifications, diplômes ou formations pertinentes...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF065b32)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF065b32), width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF065b32)),
            ),
          ),
          onChanged: (value) {
            setState(() {
              _certifications = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Profile Photo
        _buildFileUpload(
          title: 'Photo de profil *',
          icon: Icons.camera_alt,
          description: 'Cliquez pour télécharger votre photo de profil',
          subtitle: 'Format JPG, PNG (max 5MB)',
          isUploaded: _hasProfilePhoto,
          onTap: () {
            setState(() {
              _hasProfilePhoto = true;
            });
          },
        ),

        const SizedBox(height: 32),

        // ID Card Front
        _buildFileUpload(
          title: 'Carte d\'identité - Recto *',
          icon: Icons.upload,
          description: 'Téléchargez le recto de votre carte d\'identité',
          subtitle: 'Assurez-vous que tous les détails sont lisibles',
          isUploaded: _hasIdCardFront,
          onTap: () {
            setState(() {
              _hasIdCardFront = true;
            });
          },
        ),

        const SizedBox(height: 32),

        // ID Card Back
        _buildFileUpload(
          title: 'Carte d\'identité - Verso *',
          icon: Icons.description,
          description: 'Téléchargez le verso de votre carte d\'identité',
          subtitle: 'Format JPG, PNG (max 5MB)',
          isUploaded: _hasIdCardBack,
          onTap: () {
            setState(() {
              _hasIdCardBack = true;
            });
          },
        ),

        const SizedBox(height: 32),

        // Dernier diplôme
        _buildFileUpload(
          title: 'Dernier diplôme',
          icon: Icons.school,
          description: 'Téléchargez votre dernier diplôme',
          subtitle: 'Format PDF, JPG, PNG (max 5MB)',
          isUploaded: _hasDiploma,
          onTap: () {
            setState(() {
              _hasDiploma = true;
            });
          },
        ),

        const SizedBox(height: 32),

        // CV
        _buildFileUpload(
          title: 'CV',
          icon: Icons.receipt_long,
          description: 'Téléchargez votre CV',
          subtitle: 'Format PDF (recommandé), JPG, PNG (max 5MB)',
          isUploaded: _hasCv,
          onTap: () {
            setState(() {
              _hasCv = true;
            });
          },
        ),
      ],
    );
  }

  Widget _buildFileUpload({
    required String title,
    required IconData icon,
    required String description,
    required String subtitle,
    required bool isUploaded,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey[300]!,
                width: 2,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Icon(icon, size: 48, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  textAlign: TextAlign.center,
                ),
                if (isUploaded) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          size: 16,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Fichier téléchargé',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Récapitulatif de votre candidature',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              _buildSummaryItem(
                'Service:',
                _serviceTypes.firstWhere(
                      (s) => s['id'] == _serviceType,
                    )['label'] ??
                    '',
              ),

              _buildSummaryItem('Nom complet:', '$_firstName $_lastName'),

              _buildSummaryItem('Contact:', '$_email | $_phone'),

              _buildSummaryItem('Expérience:', _experience),

              if (_description.isNotEmpty)
                _buildSummaryItem('Description:', _description),

              if (_address.isNotEmpty) _buildSummaryItem('Adresse:', _address),

              if (_city.isNotEmpty || _zipCode.isNotEmpty)
                _buildSummaryItem('Ville:', '$_city $_zipCode'.trim()),

              if (_certifications.isNotEmpty)
                _buildSummaryItem('Certifications:', _certifications),

              const SizedBox(height: 16),
              const Text(
                'Documents:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  if (_hasProfilePhoto) _buildDocumentBadge('Photo de profil'),
                  if (_hasIdCardFront) _buildDocumentBadge('CI Recto'),
                  if (_hasIdCardBack) _buildDocumentBadge('CI Verso'),
                  if (_hasDiploma) _buildDocumentBadge('Diplôme'),
                  if (_hasCv) _buildDocumentBadge('CV'),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.primaryGreen.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.2)),
          ),
          child: Text(
            'Prochaines étapes: Une fois votre candidature soumise, notre équipe l\'examinera sous 24-48h. Vous recevrez un email de confirmation avec les détails de validation de votre profil.',
            style: TextStyle(fontSize: 14, color: AppTheme.primaryGreen),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 16, color: Colors.black),
          children: [
            TextSpan(
              text: label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            TextSpan(text: ' $value'),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Bouton Précédent
        Flexible(
          flex: 1,
          child: ElevatedButton(
            onPressed: _currentStep > 1
                ? () {
                    setState(() {
                      _currentStep--;
                    });
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              side: BorderSide(color: Colors.grey[300]!),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Précédent'),
          ),
        ),

        const SizedBox(width: 12),

        // Bouton Suivant ou Soumettre
        Flexible(
          flex: 2,
          child: _currentStep < 4
              ? ElevatedButton(
                  onPressed: _isStepComplete(_currentStep)
                      ? () {
                          setState(() {
                            _currentStep++;
                          });
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Suivant'),
                )
              : ElevatedButton(
                  onPressed:
                      _hasProfilePhoto && _hasIdCardFront && _hasIdCardBack
                      ? () {
                          _submitApplication();
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Soumettre',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return const Text(
      'Besoin d\'aide ? Contactez notre support à fibayacontact@gmail.com',
      style: TextStyle(fontSize: 14, color: Colors.grey),
      textAlign: TextAlign.center,
    );
  }

  bool _isStepComplete(int stepNumber) {
    switch (stepNumber) {
      case 1:
        return _serviceType.isNotEmpty;
      case 2:
        return _firstName.isNotEmpty &&
            _lastName.isNotEmpty &&
            _phone.isNotEmpty &&
            _email.isNotEmpty;
      case 3:
        return _hasProfilePhoto && _hasIdCardFront && _hasIdCardBack;
      default:
        return false;
    }
  }

  void _submitApplication() {
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Votre dossier a été envoyé pour validation. Vous recevrez une confirmation sous 24-48h.',
        ),
        backgroundColor: AppTheme.primaryGreen,
      ),
    );

    // Navigate to next screen
    Navigator.pushReplacementNamed(context, '/location-permission');
  }
}
