import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class StatusCheckService extends GetxService {
  // Instance singleton avec gestion d'erreur
  static StatusCheckService? get instance {
    try {
      return Get.find<StatusCheckService>();
    } catch (e) {
      print('StatusCheckService non trouvé, initialisation...');
      return null;
    }
  }

  Timer? _statusTimer;
  String? _currentPhoneNumber;
  String? _currentCountryCode;
  Function()? _onStatusChanged;

  // Démarrer la vérification périodique du statut
  void startStatusCheck(
    String phoneNumber,
    String countryCode,
    Function() onStatusChanged,
  ) {
    _currentPhoneNumber = phoneNumber;
    _currentCountryCode = countryCode;
    _onStatusChanged = onStatusChanged;

    // Vérifier le statut toutes les 10 secondes pour une détection plus rapide
    _statusTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _checkUserStatus();
    });

    print('🔍 Vérification du statut démarrée pour: $countryCode$phoneNumber');
  }

  // Arrêter la vérification
  void stopStatusCheck() {
    _statusTimer?.cancel();
    _statusTimer = null;
    _currentPhoneNumber = null;
    _currentCountryCode = null;
    _onStatusChanged = null;
    print('⏹️ Vérification du statut arrêtée');
  }

  // Vérifier le statut de l'utilisateur
  Future<void> _checkUserStatus() async {
    if (_currentPhoneNumber == null || _currentCountryCode == null) {
      print('❌ Numéro de téléphone ou code pays manquant');
      return;
    }

    try {
      String fullPhoneNumber = '$_currentCountryCode$_currentPhoneNumber';
      print('🔍 Vérification du statut pour: $fullPhoneNumber');

      final response = await http.get(
        Uri.parse(
          'http://192.168.1.26:8081/api/prestataires/check-validation/$fullPhoneNumber',
        ),
        headers: {'Content-Type': 'application/json'},
      );

      print('📡 Réponse du serveur: ${response.statusCode}');
      print('📄 Corps de la réponse: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        bool isValide = data['isValide'] == true;

        print('🔍 Statut vérifié: ${isValide ? "Éligible" : "Non éligible"}');

        // Si l'utilisateur n'est plus éligible, déclencher la déconnexion
        if (!isValide && _onStatusChanged != null) {
          print('⚠️ Utilisateur suspendu détecté - Déconnexion automatique');
          _onStatusChanged!();
        } else if (!isValide) {
          print('⚠️ Utilisateur suspendu détecté mais callback non défini');
        }
      } else {
        print('❌ Erreur HTTP: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Erreur lors de la vérification du statut: $e');
    }
  }

  // Vérification manuelle du statut (pour les cas urgents)
  Future<bool> checkStatusManually(
    String phoneNumber,
    String countryCode,
  ) async {
    try {
      String fullPhoneNumber = '$countryCode$phoneNumber';

      final response = await http.get(
        Uri.parse(
          'http://192.168.1.26:8081/api/prestataires/check-validation/$fullPhoneNumber',
        ),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['isValide'] == true;
      }
      return false;
    } catch (e) {
      print('❌ Erreur lors de la vérification manuelle: $e');
      return false;
    }
  }
}
