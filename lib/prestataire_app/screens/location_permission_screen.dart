import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

class LocationPermissionScreen extends StatelessWidget {
  const LocationPermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header avec titre FIBAYA
            Container(
              padding: const EdgeInsets.all(20),
              child: const Center(
                child: Text(
                  'FIBAYA',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            // Contenu principal
            Expanded(
              child: Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1A000000),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icône de localisation
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color(
                            0x1A065b32,
                          ), // AppTheme.primaryGreen.withOpacity(0.1)
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: const Icon(
                          Icons.location_on,
                          size: 40,
                          color: AppTheme.primaryGreen,
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Titre
                      const Text(
                        'Autorisation de Localisation',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 20),

                      // Texte explicatif
                      const Text(
                        'Afin de vous connecter avec les fournisseurs de services à proximité, FIBAYA a besoin d\'accéder à votre position.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 40),

                      // Bouton "Autoriser la Localisation"
                      Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppTheme.primaryGreen,
                              Color(
                                0xCC065b32,
                              ), // AppTheme.primaryGreen.withOpacity(0.8)
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Gérer l'autorisation de localisation
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Autorisation de localisation accordée',
                                ),
                                backgroundColor: AppTheme.primaryGreen,
                              ),
                            );

                            // Redirection vers la page d'accueil prestataire
                            Future.delayed(const Duration(seconds: 1), () {
                              Navigator.pushReplacementNamed(context, '/home');
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Autoriser la Localisation',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Bouton "Refuser"
                      Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFE0E0E0),
                            width: 1,
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Gérer le refus de localisation
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Localisation refusée'),
                                backgroundColor: Colors.orange,
                              ),
                            );

                            // Redirection vers la page d'accueil prestataire même en cas de refus
                            Future.delayed(const Duration(seconds: 1), () {
                              Navigator.pushReplacementNamed(context, '/home');
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Refuser',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
