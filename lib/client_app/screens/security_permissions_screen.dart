import 'package:flutter/material.dart';
import 'manage_devices_screen.dart';
import 'prestataires_details_screen.dart';
import 'appels_securises_details_screen.dart';
import 'service_qualite_details_screen.dart';
import 'centre_securite_details_screen.dart';
import 'controle_photo_details_screen.dart';
import 'retour_service_details_screen.dart';
import 'urgence_screen.dart';

// Couleur personnalisée Fibaya
const Color fibayaGreen = Color(0xFF065b32);

class SecurityPermissionsScreen extends StatefulWidget {
  const SecurityPermissionsScreen({Key? key}) : super(key: key);

  @override
  State<SecurityPermissionsScreen> createState() =>
      _SecurityPermissionsScreenState();
}

class _SecurityPermissionsScreenState extends State<SecurityPermissionsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    // Animation continue en boucle
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Fond gris clair
      appBar: AppBar(
        title: const Text(
          'Sécurité et autorisations',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // En haut - 2 cartes
                  Row(
                    children: [
                      Expanded(
                        child: _buildSecurityCard(
                          title: 'Prestataire',
                          imagePath: 'assets/images/Prestataire.png',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const PrestatairesDetailsScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildSecurityCard(
                          title: 'Appel sécurisé',
                          imagePath: 'assets/images/Appel_securise.png',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const AppelsSecurisesDetailsScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Au milieu - 2 cartes
                  Row(
                    children: [
                      Expanded(
                        child: _buildSecurityCard(
                          title: 'Service qualité',
                          imagePath: 'assets/images/Service_qualite.png',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ServiceQualiteDetailsScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildSecurityCard(
                          title: 'Centre sécurité',
                          imagePath: 'assets/images/Centre_securite.png',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const CentreSecuriteDetailsScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // En bas - 2 cartes
                  Row(
                    children: [
                      Expanded(
                        child: _buildSecurityCard(
                          title: 'Contrôle photo',
                          imagePath: 'assets/images/Controle_photo.png',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ControlePhotoDetailsScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildSecurityCard(
                          title: 'Retour service',
                          imagePath: 'assets/images/Retour_service.png',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const RetourServiceDetailsScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Section Urgence
                  _buildUrgenceSection(),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          // Section Appareils en bas
          Padding(
            padding: const EdgeInsets.all(16),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ManageDevicesScreen(),
                  ),
                );
              },
              child: _buildDevicesSection(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityCard({
    required String title,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[200],
                child: const Icon(
                  Icons.image_not_supported,
                  color: Colors.grey,
                  size: 40,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDevicesSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8), // Gris très clair
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Les deux icônes côte à côte - centrées
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icône principale (téléphone) avec animation
              AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F0F0), // Fond gris très clair
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF4CAF50), // Contour vert
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.phone_android,
                        color: Color(0xFF4CAF50), // Vert
                        size: 40,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Texte descriptif sous les icônes - centré
          const Text(
            'Tes appareils connectés',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Gérez les appareils connectés à votre compte.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildUrgenceSection() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UrgenceScreen()),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            // Icône d'urgence
            const Icon(Icons.emergency, color: Color(0xFFE53E3E), size: 24),
            const SizedBox(width: 16),
            // Texte
            const Expanded(
              child: Text(
                'Urgence',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            // Flèche
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }
}
