import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../common/config.dart';

class ApiService {
  static String get baseUrl => AppConfig.baseApiUrl;

  // Headers communs
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Obtenir tous les pays
  static Future<List<Country>> getAllCountries() async {
    try {
      print('🌐 Tentative de connexion à: $baseUrl/countries');
      print('📡 Headers: $headers');

      final response = await http
          .get(Uri.parse('$baseUrl/countries'), headers: headers)
          .timeout(const Duration(seconds: 15));

      print('📊 Status Code: ${response.statusCode}');
      print('📄 Response Headers: ${response.headers}');
      print(
        '📝 Response Body (first 200 chars): ${response.body.length > 200 ? response.body.substring(0, 200) + "..." : response.body}',
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        List<Country> countries = jsonData
            .map((json) => Country.fromJson(json))
            .toList();
        print('✅ ${countries.length} pays chargés avec succès');
        return countries;
      } else {
        print('❌ Erreur API: ${response.statusCode} - ${response.body}');
        throw Exception(
          'Erreur lors du chargement des pays: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Erreur API getAllCountries: $e');
      rethrow;
    }
  }

  // Vérifier si un utilisateur existe
  static Future<Map<String, dynamic>> checkUserExists(String phone) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/check-user-exists?phone=$phone'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
          'Erreur lors de la vérification: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Erreur checkUserExists: $e');
      // En cas d'erreur, considérer comme nouvel utilisateur
      return {'exists': false};
    }
  }

  // Envoyer un code SMS
  static Future<bool> sendSmsCode(String phone) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/send-sms'),
        headers: headers,
        body: json.encode({'phone': phone}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Erreur sendSmsCode: $e');
      return false;
    }
  }

  // Vérifier le code SMS
  static Future<bool> verifySmsCode(String phone, String code) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/verify-sms'),
        headers: headers,
        body: json.encode({'phone': phone, 'code': code}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Erreur verifySmsCode: $e');
      return false;
    }
  }

  // Enregistrer un nouvel utilisateur
  static Future<bool> registerUser({
    required String phone,
    required String countryCode,
    required String firstName,
    required String lastName,
  }) async {
    try {
      print('🌐 Tentative de connexion à: $baseUrl/auth/register');
      print(
        '📤 Données envoyées: phone=$phone, countryCode=$countryCode, firstName=$firstName, lastName=$lastName',
      );

      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: headers,
        body: json.encode({
          'phone': phone,
          'countryCode': countryCode,
          'firstName': firstName,
          'lastName': lastName,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        print('✅ Utilisateur enregistré avec succès dans la base de données!');
        return true;
      } else {
        print(
          '❌ Erreur enregistrement: ${response.statusCode} - ${response.body}',
        );
        return false;
      }
    } catch (e) {
      print('❌ Erreur registerUser: $e');
      return false;
    }
  }

  // Obtenir les informations d'un utilisateur
  static Future<Map<String, dynamic>?> getUserInfo(String phone) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/user-info?phone=$phone'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print('Erreur getUserInfo: $e');
      return null;
    }
  }
}

// Modèle Country
class Country {
  final int id;
  final String name;
  final String code;
  final String flag;
  final String continent;
  final bool isActive;

  Country({
    required this.id,
    required this.name,
    required this.code,
    required this.flag,
    required this.continent,
    required this.isActive,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      flag: json['flag'],
      continent: json['continent'],
      isActive: json['isActive'],
    );
  }
}
