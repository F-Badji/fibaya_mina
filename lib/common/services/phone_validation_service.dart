import 'package:flutter/material.dart';

class PhoneValidationService {
  // Règles de validation par pays
  static const Map<String, PhoneValidationRule> _phoneRules = {
    '+221': PhoneValidationRule(
      countryName: 'Sénégal',
      length: 9,
      prefixes: ['78', '77', '70', '76', '75'],
    ),
    '+33': PhoneValidationRule(
      countryName: 'France',
      length: 9,
      prefixes: ['6', '7'],
    ),
    '+1': PhoneValidationRule(
      countryName: 'États-Unis/Canada',
      length: 10,
      prefixes: ['2', '3', '4', '5', '6', '7', '8', '9'],
    ),
    '+44': PhoneValidationRule(
      countryName: 'Royaume-Uni',
      length: 10,
      prefixes: ['7'],
    ),
    '+49': PhoneValidationRule(
      countryName: 'Allemagne',
      length: 10,
      prefixes: ['1', '2', '3', '4', '5', '6', '7', '8', '9'],
    ),
    '+39': PhoneValidationRule(
      countryName: 'Italie',
      length: 10,
      prefixes: ['3'],
    ),
    '+34': PhoneValidationRule(
      countryName: 'Espagne',
      length: 9,
      prefixes: ['6', '7', '8', '9'],
    ),
    '+212': PhoneValidationRule(
      countryName: 'Maroc',
      length: 9,
      prefixes: ['6', '7'],
    ),
    '+213': PhoneValidationRule(
      countryName: 'Algérie',
      length: 9,
      prefixes: ['5', '6', '7'],
    ),
    '+216': PhoneValidationRule(
      countryName: 'Tunisie',
      length: 8,
      prefixes: ['2', '4', '5', '9'],
    ),
    '+225': PhoneValidationRule(
      countryName: 'Côte d\'Ivoire',
      length: 8,
      prefixes: ['0', '4', '5', '6', '7'],
    ),
    '+226': PhoneValidationRule(
      countryName: 'Burkina Faso',
      length: 8,
      prefixes: ['6', '7'],
    ),
    '+227': PhoneValidationRule(
      countryName: 'Niger',
      length: 8,
      prefixes: ['9'],
    ),
    '+228': PhoneValidationRule(
      countryName: 'Togo',
      length: 8,
      prefixes: ['9'],
    ),
    '+229': PhoneValidationRule(
      countryName: 'Bénin',
      length: 8,
      prefixes: ['9'],
    ),
    '+230': PhoneValidationRule(
      countryName: 'Maurice',
      length: 7,
      prefixes: ['5', '6', '7'],
    ),
    '+231': PhoneValidationRule(
      countryName: 'Libéria',
      length: 8,
      prefixes: ['7', '8'],
    ),
    '+232': PhoneValidationRule(
      countryName: 'Sierra Leone',
      length: 8,
      prefixes: ['7', '8'],
    ),
    '+233': PhoneValidationRule(
      countryName: 'Ghana',
      length: 9,
      prefixes: ['2', '5'],
    ),
    '+234': PhoneValidationRule(
      countryName: 'Nigeria',
      length: 10,
      prefixes: ['7', '8', '9'],
    ),
    '+235': PhoneValidationRule(
      countryName: 'Tchad',
      length: 8,
      prefixes: ['6', '7'],
    ),
    '+236': PhoneValidationRule(
      countryName: 'République centrafricaine',
      length: 8,
      prefixes: ['7'],
    ),
    '+237': PhoneValidationRule(
      countryName: 'Cameroun',
      length: 9,
      prefixes: ['6', '7'],
    ),
    '+238': PhoneValidationRule(
      countryName: 'Cap-Vert',
      length: 7,
      prefixes: ['9'],
    ),
    '+239': PhoneValidationRule(
      countryName: 'São Tomé-et-Príncipe',
      length: 7,
      prefixes: ['9'],
    ),
    '+240': PhoneValidationRule(
      countryName: 'Guinée équatoriale',
      length: 9,
      prefixes: ['2', '5'],
    ),
    '+241': PhoneValidationRule(
      countryName: 'Gabon',
      length: 8,
      prefixes: ['6', '7'],
    ),
    '+242': PhoneValidationRule(
      countryName: 'République du Congo',
      length: 9,
      prefixes: ['0', '4', '5', '6'],
    ),
    '+243': PhoneValidationRule(
      countryName: 'République démocratique du Congo',
      length: 9,
      prefixes: ['8', '9'],
    ),
    '+244': PhoneValidationRule(
      countryName: 'Angola',
      length: 9,
      prefixes: ['9'],
    ),
    '+245': PhoneValidationRule(
      countryName: 'Guinée-Bissau',
      length: 7,
      prefixes: ['9'],
    ),
    '+246': PhoneValidationRule(
      countryName: 'Territoire britannique de l\'océan Indien',
      length: 7,
      prefixes: ['3'],
    ),
    '+248': PhoneValidationRule(
      countryName: 'Seychelles',
      length: 7,
      prefixes: ['2', '4', '5', '7'],
    ),
    '+249': PhoneValidationRule(
      countryName: 'Soudan',
      length: 9,
      prefixes: ['9'],
    ),
    '+250': PhoneValidationRule(
      countryName: 'Rwanda',
      length: 9,
      prefixes: ['7'],
    ),
    '+251': PhoneValidationRule(
      countryName: 'Éthiopie',
      length: 9,
      prefixes: ['9'],
    ),
    '+252': PhoneValidationRule(
      countryName: 'Somalie',
      length: 8,
      prefixes: ['6', '7'],
    ),
    '+253': PhoneValidationRule(
      countryName: 'Djibouti',
      length: 8,
      prefixes: ['7'],
    ),
    '+254': PhoneValidationRule(
      countryName: 'Kenya',
      length: 9,
      prefixes: ['7'],
    ),
    '+255': PhoneValidationRule(
      countryName: 'Tanzanie',
      length: 9,
      prefixes: ['6', '7'],
    ),
    '+256': PhoneValidationRule(
      countryName: 'Ouganda',
      length: 9,
      prefixes: ['7'],
    ),
    '+257': PhoneValidationRule(
      countryName: 'Burundi',
      length: 8,
      prefixes: ['7'],
    ),
    '+258': PhoneValidationRule(
      countryName: 'Mozambique',
      length: 9,
      prefixes: ['8'],
    ),
    '+260': PhoneValidationRule(
      countryName: 'Zambie',
      length: 9,
      prefixes: ['7', '9'],
    ),
    '+261': PhoneValidationRule(
      countryName: 'Madagascar',
      length: 9,
      prefixes: ['3'],
    ),
    '+262': PhoneValidationRule(
      countryName: 'Réunion',
      length: 9,
      prefixes: ['6', '7'],
    ),
    '+263': PhoneValidationRule(
      countryName: 'Zimbabwe',
      length: 9,
      prefixes: ['7'],
    ),
    '+264': PhoneValidationRule(
      countryName: 'Namibie',
      length: 9,
      prefixes: ['8'],
    ),
    '+265': PhoneValidationRule(
      countryName: 'Malawi',
      length: 9,
      prefixes: ['9'],
    ),
    '+266': PhoneValidationRule(
      countryName: 'Lesotho',
      length: 8,
      prefixes: ['5', '6'],
    ),
    '+267': PhoneValidationRule(
      countryName: 'Botswana',
      length: 7,
      prefixes: ['7'],
    ),
    '+268': PhoneValidationRule(
      countryName: 'Eswatini',
      length: 8,
      prefixes: ['7'],
    ),
    '+269': PhoneValidationRule(
      countryName: 'Comores',
      length: 7,
      prefixes: ['3'],
    ),
    '+290': PhoneValidationRule(
      countryName: 'Sainte-Hélène',
      length: 4,
      prefixes: ['2', '3', '4', '5', '6', '7', '8'],
    ),
    '+291': PhoneValidationRule(
      countryName: 'Érythrée',
      length: 7,
      prefixes: ['1', '7'],
    ),
    '+297': PhoneValidationRule(
      countryName: 'Aruba',
      length: 7,
      prefixes: ['5', '6', '7', '9'],
    ),
    '+298': PhoneValidationRule(
      countryName: 'Îles Féroé',
      length: 6,
      prefixes: ['2', '3', '4', '5', '6', '7', '8'],
    ),
    '+299': PhoneValidationRule(
      countryName: 'Groenland',
      length: 6,
      prefixes: ['2', '3', '4', '5', '6', '7', '8'],
    ),
  };

  /// Valide un numéro de téléphone selon les règles du pays
  static PhoneValidationResult validatePhoneNumber(String phoneNumber, String countryCode) {
    // Nettoyer le numéro (supprimer espaces, tirets, etc.)
    String cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    
    // Vérifier si le numéro est vide
    if (cleanNumber.isEmpty) {
      return PhoneValidationResult(
        isValid: false,
        errorMessage: 'Numéro invalide',
      );
    }

    // Obtenir les règles pour le pays
    final rule = _phoneRules[countryCode];
    if (rule == null) {
      // Si pas de règle spécifique, validation basique
      if (cleanNumber.length < 7 || cleanNumber.length > 15) {
        return PhoneValidationResult(
          isValid: false,
          errorMessage: 'Numéro invalide',
        );
      }
      return PhoneValidationResult(isValid: true);
    }

    // Vérifier la longueur
    if (cleanNumber.length != rule.length) {
      return PhoneValidationResult(
        isValid: false,
        errorMessage: 'Numéro invalide',
      );
    }

    // Vérifier les préfixes autorisés
    bool hasValidPrefix = false;
    for (String prefix in rule.prefixes) {
      if (cleanNumber.startsWith(prefix)) {
        hasValidPrefix = true;
        break;
      }
    }

    if (!hasValidPrefix) {
      return PhoneValidationResult(
        isValid: false,
        errorMessage: 'Numéro invalide',
      );
    }

    return PhoneValidationResult(isValid: true);
  }

  /// Obtient les règles de validation pour un pays
  static PhoneValidationRule? getPhoneRule(String countryCode) {
    return _phoneRules[countryCode];
  }
}

class PhoneValidationRule {
  final String countryName;
  final int length;
  final List<String> prefixes;

  const PhoneValidationRule({
    required this.countryName,
    required this.length,
    required this.prefixes,
  });
}

class PhoneValidationResult {
  final bool isValid;
  final String? errorMessage;

  const PhoneValidationResult({
    required this.isValid,
    this.errorMessage,
  });
}
