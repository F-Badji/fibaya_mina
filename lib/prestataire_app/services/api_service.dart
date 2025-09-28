import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
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

  // Enregistrer un nouveau prestataire
  static Future<bool> registerPrestataire({
    required String nom,
    required String prenom,
    required String telephone,
    required String serviceType,
    required String typeService,
    required String experience,
    required String description,
    String? adresse,
    String? ville,
    String? codePostal,
    String? certifications,
    String? versionDocument,
    String? carteIdentiteRecto,
    String? carteIdentiteVerso,
    String? cv,
    String? diplome,
    String? imageProfil,
  }) async {
    try {
      print('🌐 Tentative de connexion à: $baseUrl/prestataires');
      print('📤 Données prestataire envoyées:');
      print('  - nom: $nom');
      print('  - prenom: $prenom');
      print('  - telephone: $telephone');
      print('  - serviceType: $serviceType');
      print('  - typeService: $typeService');
      print('  - experience: $experience');
      print('  - description: $description');
      print('  - carteIdentiteRecto: $carteIdentiteRecto');
      print('  - carteIdentiteVerso: $carteIdentiteVerso');
      print('  - cv: $cv');
      print('  - diplome: $diplome');
      print('  - imageProfil: $imageProfil');

      final response = await http.post(
        Uri.parse('$baseUrl/prestataires'),
        headers: headers,
        body: json.encode({
          'nom': nom,
          'prenom': prenom,
          'telephone': telephone,
          'serviceType': serviceType,
          'typeService': typeService,
          'experience': experience,
          'description': description,
          if (adresse != null) 'adresse': adresse,
          if (ville != null) 'ville': ville,
          if (codePostal != null) 'codePostal': codePostal,
          if (certifications != null) 'certifications': certifications,
          if (versionDocument != null) 'versionDocument': versionDocument,
          if (carteIdentiteRecto != null)
            'carteIdentiteRecto': carteIdentiteRecto,
          if (carteIdentiteVerso != null)
            'carteIdentiteVerso': carteIdentiteVerso,
          if (cv != null) 'cv': cv,
          if (diplome != null) 'diplome': diplome,
          if (imageProfil != null) 'imageProfil': imageProfil,
        }),
      );

      print('📊 Response status: ${response.statusCode}');
      print('📄 Response body: ${response.body}');

      if (response.statusCode == 200) {
        print('✅ Prestataire enregistré avec succès dans la base de données!');
        return true;
      } else {
        print(
          '❌ Erreur enregistrement prestataire: ${response.statusCode} - ${response.body}',
        );
        return false;
      }
    } catch (e) {
      print('❌ Erreur registerPrestataire: $e');
      return false;
    }
  }

  // Enregistrer un nouveau prestataire avec fichiers
  static Future<Map<String, dynamic>> registerPrestataireWithFiles({
    required String nom,
    required String prenom,
    required String telephone,
    required String serviceType,
    required String typeService,
    required String experience,
    required String description,
    String? adresse,
    String? ville,
    String? codePostal,
    String? certifications,
    String? versionDocument,
    PlatformFile? imageProfil,
    PlatformFile? carteIdentiteRecto,
    PlatformFile? carteIdentiteVerso,
    PlatformFile? cv,
    PlatformFile? diplome,
  }) async {
    try {
      print('🌐 Tentative de connexion à: $baseUrl/prestataires/with-files');
      print('📤 Envoi des données prestataire avec fichiers...');

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/prestataires/with-files'),
      );

      // Ajouter les champs texte
      request.fields['nom'] = nom;
      request.fields['prenom'] = prenom;
      request.fields['telephone'] = telephone;
      request.fields['serviceType'] = serviceType;
      request.fields['typeService'] = typeService;
      request.fields['experience'] = experience;
      request.fields['description'] = description;
      if (adresse != null) request.fields['adresse'] = adresse;
      if (ville != null) request.fields['ville'] = ville;
      if (codePostal != null) request.fields['codePostal'] = codePostal;
      if (certifications != null)
        request.fields['certifications'] = certifications;
      if (versionDocument != null)
        request.fields['versionDocument'] = versionDocument;

      // Ajouter les fichiers
      if (imageProfil != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'imageProfil',
            imageProfil.path!,
            filename: imageProfil.name,
          ),
        );
      }
      if (carteIdentiteRecto != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'carteIdentiteRecto',
            carteIdentiteRecto.path!,
            filename: carteIdentiteRecto.name,
          ),
        );
      }
      if (carteIdentiteVerso != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'carteIdentiteVerso',
            carteIdentiteVerso.path!,
            filename: carteIdentiteVerso.name,
          ),
        );
      }
      if (cv != null) {
        request.files.add(
          await http.MultipartFile.fromPath('cv', cv.path!, filename: cv.name),
        );
      }
      if (diplome != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'diplome',
            diplome.path!,
            filename: diplome.name,
          ),
        );
      }

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      print('📊 Response status: ${response.statusCode}');
      print('📄 Response body: $responseBody');

      if (response.statusCode == 200) {
        print('✅ Prestataire enregistré avec succès avec fichiers!');
        return {
          'success': true,
          'message': 'Prestataire enregistré avec succès',
        };
      } else if (response.statusCode == 400) {
        print('❌ Erreur: Ce numéro de téléphone existe déjà!');
        return {
          'success': false,
          'message': 'Ce numéro de téléphone existe déjà',
        };
      } else {
        print(
          '❌ Erreur enregistrement prestataire: ${response.statusCode} - $responseBody',
        );
        return {
          'success': false,
          'message': 'Erreur lors de l\'enregistrement',
        };
      }
    } catch (e) {
      print('❌ Erreur registerPrestataireWithFiles: $e');
      return {'success': false, 'message': 'Erreur de connexion'};
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
