import 'package:flutter/material.dart';
import '../../common/models/service.dart';
import 'service_providers_screen.dart';
import 'service_providers_presence_screen.dart';

class ServiceSelectionScreen extends StatefulWidget {
  final Service service;

  const ServiceSelectionScreen({super.key, required this.service});

  @override
  State<ServiceSelectionScreen> createState() => _ServiceSelectionScreenState();
}

class _ServiceSelectionScreenState extends State<ServiceSelectionScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isHomeHovered = false;
  bool _isPresenceHovered = false;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    // Démarrer les animations
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  // Méthode pour obtenir l'icône du service
  Widget _getServiceIcon(String serviceName) {
    final name = serviceName.toLowerCase();
    if (name.contains('chaudronnier') || name.contains('métallurgie')) {
      return const Icon(
        Icons.build,
        size: 48,
        color: Colors.grey, // Gris comme dans l'image
      );
    }
    if (name.contains('plombier') || name.contains('plomberie')) {
      return const Icon(Icons.build, size: 48, color: Colors.grey);
    }
    if (name.contains('électricien') || name.contains('électricité')) {
      return const Icon(
        Icons.electrical_services,
        size: 48,
        color: Colors.grey,
      );
    }
    if (name.contains('mécanicien') || name.contains('mécanique')) {
      return const Icon(Icons.build, size: 48, color: Colors.grey);
    }
    if (name.contains('nettoyage') || name.contains('ménage')) {
      return const Icon(Icons.cleaning_services, size: 48, color: Colors.grey);
    }
    if (name.contains('cuisine') || name.contains('chef')) {
      return const Icon(Icons.restaurant, size: 48, color: Colors.grey);
    }
    if (name.contains('beauté') || name.contains('coiffure')) {
      return const Icon(Icons.face, size: 48, color: Colors.grey);
    }
    if (name.contains('jardinage') || name.contains('jardin')) {
      return const Icon(Icons.local_florist, size: 48, color: Colors.grey);
    }
    if (name.contains('peinture') || name.contains('peintre')) {
      return const Icon(Icons.format_paint, size: 48, color: Colors.grey);
    }
    if (name.contains('maçon') || name.contains('construction')) {
      return const Icon(Icons.construction, size: 48, color: Colors.grey);
    }
    if (name.contains('climatisation') || name.contains('froid')) {
      return const Icon(Icons.ac_unit, size: 48, color: Colors.grey);
    }
    if (name.contains('sécurité') || name.contains('gardiennage')) {
      return const Icon(Icons.security, size: 48, color: Colors.grey);
    }
    if (name.contains('transport') || name.contains('livraison')) {
      return const Icon(Icons.local_shipping, size: 48, color: Colors.grey);
    }
    if (name.contains('informatique') || name.contains('tech')) {
      return const Icon(Icons.computer, size: 48, color: Colors.grey);
    }
    if (name.contains('santé') || name.contains('médical')) {
      return const Icon(Icons.medical_services, size: 48, color: Colors.grey);
    }
    return const Icon(Icons.build, size: 48, color: Colors.grey);
  }

  // Méthode pour obtenir la description du service
  String _getServiceDescription(String serviceName) {
    final name = serviceName.toLowerCase();
    if (name.contains('chaudronnier') || name.contains('métallurgie')) {
      return 'Travaux de chaudronnerie et métallurgie';
    }
    if (name.contains('plombier') || name.contains('plomberie')) {
      return 'Installation et réparation de plomberie';
    }
    if (name.contains('électricien') || name.contains('électricité')) {
      return 'Installation et maintenance électrique';
    }
    if (name.contains('mécanicien') || name.contains('mécanique')) {
      return 'Réparation et maintenance automobile';
    }
    if (name.contains('nettoyage') || name.contains('ménage')) {
      return 'Services de nettoyage et ménage';
    }
    if (name.contains('cuisine') || name.contains('chef')) {
      return 'Services culinaires et restauration';
    }
    if (name.contains('beauté') || name.contains('coiffure')) {
      return 'Services de beauté et coiffure';
    }
    if (name.contains('jardinage') || name.contains('jardin')) {
      return 'Entretien et aménagement de jardins';
    }
    if (name.contains('peinture') || name.contains('peintre')) {
      return 'Peinture et décoration intérieure';
    }
    if (name.contains('maçon') || name.contains('construction')) {
      return 'Travaux de maçonnerie et construction';
    }
    if (name.contains('climatisation') || name.contains('froid')) {
      return 'Installation et maintenance de climatisation';
    }
    if (name.contains('sécurité') || name.contains('gardiennage')) {
      return 'Services de sécurité et gardiennage';
    }
    if (name.contains('transport') || name.contains('livraison')) {
      return 'Services de transport et livraison';
    }
    if (name.contains('informatique') || name.contains('tech')) {
      return 'Services informatiques et technologiques';
    }
    if (name.contains('santé') || name.contains('médical')) {
      return 'Services de santé et médicaux';
    }
    return 'Services professionnels de qualité';
  }

  void _onServiceOptionSelected(String option) {
    if (option == 'À domicile') {
      // Naviguer vers l'écran des prestataires à domicile
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ServiceProvidersScreen(service: widget.service),
        ),
      );
    } else if (option == 'En présence') {
      // Naviguer vers l'écran des prestataires en présence
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              ServiceProvidersPresenceScreen(service: widget.service),
        ),
      );
    } else {
      // Afficher un message de confirmation pour les autres options
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Option sélectionnée: $option pour ${widget.service.name}',
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: const Color(0xFF065b32),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  // Header Section (Dark Green) - Full width to top
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 20,
                      left: 20,
                      right: 20,
                      bottom: 20,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xFF065b32), // Dark green
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Back button and title row
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.service.name,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Choisissez votre préférence',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Main Content Area (White)
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          // Service Icon and Description
                          Column(
                            children: [
                              _getServiceIcon(widget.service.name),
                              const SizedBox(height: 16),
                              Text(
                                _getServiceDescription(widget.service.name),
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),

                          const SizedBox(height: 40),

                          // Question
                          const Text(
                            'Comment souhaitez-vous\nrecevoir ce service?',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF065b32),
                              height: 1.3,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 32),

                          // Service Options
                          Expanded(
                            child: Column(
                              children: [
                                // Option 1: À domicile
                                GestureDetector(
                                  onTap: () =>
                                      _onServiceOptionSelected('À domicile'),
                                  onTapDown: (_) {
                                    setState(() {
                                      _isHomeHovered = true;
                                    });
                                  },
                                  onTapUp: (_) {
                                    setState(() {
                                      _isHomeHovered = false;
                                    });
                                  },
                                  onTapCancel: () {
                                    setState(() {
                                      _isHomeHovered = false;
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _isHomeHovered
                                          ? const Color(
                                              0xFF0A7A3A,
                                            ) // Slightly lighter green when hovered
                                          : const Color(
                                              0xFF065b32,
                                            ), // Dark green normally
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        const Icon(
                                          Icons.home_outlined,
                                          size: 32,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(height: 8),
                                        const Text(
                                          'À domicile',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        const Text(
                                          'Le prestataire vient chez vous',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white70,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // Option 2: En présence
                                GestureDetector(
                                  onTap: () =>
                                      _onServiceOptionSelected('En présence'),
                                  onTapDown: (_) {
                                    setState(() {
                                      _isPresenceHovered = true;
                                    });
                                  },
                                  onTapUp: (_) {
                                    setState(() {
                                      _isPresenceHovered = false;
                                    });
                                  },
                                  onTapCancel: () {
                                    setState(() {
                                      _isPresenceHovered = false;
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _isPresenceHovered
                                          ? const Color(
                                              0xFF81C784,
                                            ) // Mint green when hovered
                                          : Colors.white, // White normally
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: const Color(
                                          0xFF4CAF50,
                                        ), // Light green border
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons
                                              .groups_outlined, // Two people with one partially behind
                                          size: 32,
                                          color: _isPresenceHovered
                                              ? Colors
                                                    .white // White when hovered
                                              : const Color(
                                                  0xFF4CAF50,
                                                ), // Green normally
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'En présence',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: _isPresenceHovered
                                                ? Colors
                                                      .white // White when hovered
                                                : const Color(
                                                    0xFF4CAF50,
                                                  ), // Green normally
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Vous vous rendez chez le prestataire',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: _isPresenceHovered
                                                ? Colors
                                                      .white // White when hovered
                                                : const Color(
                                                    0xFF4CAF50,
                                                  ), // Green normally
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 40), // Espacement fixe
                                // Option 3: Trouver des prestataires
                                GestureDetector(
                                  onTap: () => _onServiceOptionSelected(
                                    'Trouver des prestataires',
                                  ),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.flash_on,
                                          size: 20,
                                          color: Colors.amber,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            'Trouvez des prestataires disponibles près de vous en quelques secondes',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[700],
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
