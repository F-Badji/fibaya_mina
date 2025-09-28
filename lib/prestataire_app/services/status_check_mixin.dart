import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'status_check_service.dart';
import '../screens/splash_screen.dart';

mixin StatusCheckMixin<T extends StatefulWidget> on State<T> {
  void startStatusCheck(String phone, String countryCode) {
    try {
      // Démarrer la vérification du statut
      final service = StatusCheckService.instance;
      if (service != null) {
        service.startStatusCheck(phone, countryCode, handleUserSuspended);
      } else {
        // Essayer d'initialiser le service si ce n'est pas fait
        print('StatusCheckService non trouvé, tentative d\'initialisation...');
        Get.put(StatusCheckService());
        // Réessayer après initialisation
        final newService = StatusCheckService.instance;
        if (newService != null) {
          newService.startStatusCheck(phone, countryCode, handleUserSuspended);
          print('StatusCheckService initialisé avec succès');
        } else {
          print('Échec de l\'initialisation du StatusCheckService');
        }
      }
    } catch (e) {
      print('Erreur lors du démarrage de la vérification du statut: $e');
    }
  }

  void stopStatusCheck() {
    try {
      // Arrêter la vérification du statut
      final service = StatusCheckService.instance;
      if (service != null) {
        service.stopStatusCheck();
      }
    } catch (e) {
      print('Erreur lors de l\'arrêt de la vérification du statut: $e');
    }
  }

  void handleUserSuspended() {
    // L'utilisateur a été suspendu, rediriger IMMÉDIATEMENT vers l'écran d'authentification
    print('🚨 handleUserSuspended appelé !');

    if (mounted) {
      print('✅ Widget monté, procédure de déconnexion...');

      // Arrêter la vérification du statut
      stopStatusCheck();

      print(
        '⚠️ UTILISATEUR SUSPENDU - Redirection immédiate vers l\'authentification',
      );

      // Redirection IMMÉDIATE sans dialog (comme un nouveau utilisateur)
      Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const SplashScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position:
                    Tween<Offset>(
                      begin: const Offset(-1.0, 0.0),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeInOut,
                      ),
                    ),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
        ),
        (route) => false, // Supprimer toutes les routes précédentes
      );

      print('🎯 Redirection vers SplashScreen effectuée');
    } else {
      print('❌ Widget non monté, impossible de rediriger');
    }
  }
}
