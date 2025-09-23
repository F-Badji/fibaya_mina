import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

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
                const SizedBox(height: 64),

                // Hero Section
                _buildHeroSection(context),

                const SizedBox(height: 64),

                // Features
                _buildFeaturesSection(),

                const SizedBox(height: 64),

                // CTA Section
                _buildCTASection(context),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Column(
      children: [
        // Logo et titre
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.people, size: 40, color: Colors.white),
            ),
            const SizedBox(width: 12),
            const Text(
              'Fibaya Pro',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryGreen,
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Description
        const Text(
          'La plateforme qui connecte les meilleurs prestataires de services aux clients exigeants',
          style: TextStyle(fontSize: 20, color: Colors.grey, height: 1.5),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 32),

        // Bouton CTA
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/prestataire-registration');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryGreen,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Devenir Prestataire',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesSection() {
    return Column(
      children: [
        _buildFeatureCard(
          icon: Icons.security,
          title: 'Validation Professionnelle',
          description:
              'Processus de vérification rigoureux pour garantir la qualité',
        ),
        const SizedBox(height: 24),
        _buildFeatureCard(
          icon: Icons.build,
          title: 'Services Variés',
          description:
              'Plomberie, électricité, menuiserie, coiffure et bien plus',
        ),
        const SizedBox(height: 24),
        _buildFeatureCard(
          icon: Icons.star,
          title: 'Confiance',
          description:
              'Système de notation et d\'avis pour une transparence totale',
        ),
      ],
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: AppTheme.primaryGreen),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCTASection(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppTheme.primaryGreen,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const Text(
              'Rejoignez notre réseau de prestataires qualifiés',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Développez votre activité avec Fibaya Pro et atteignez de nouveaux clients',
              style: TextStyle(fontSize: 16, color: Colors.white, height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/prestataire-registration');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppTheme.primaryGreen,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Commencer l\'inscription',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
