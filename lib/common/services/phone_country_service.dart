import '../utils/phone_validation.dart';

class PhoneCountryService {
  // Mapping des noms de pays vers les codes de pays
  static const Map<String, String> _countryToCode = {
    'Sénégal': '+221',
    'Mali': '+223',
    'Burkina Faso': '+226',
    'Côte d\'Ivoire': '+225',
    'Guinée': '+224',
    'Niger': '+227',
    'Tchad': '+235',
    'Cameroun': '+237',
    'Gabon': '+241',
    'Congo': '+242',
    'République Démocratique du Congo': '+243',
    'Rwanda': '+250',
    'Burundi': '+257',
    'Tanzanie': '+255',
    'Kenya': '+254',
    'Ouganda': '+256',
    'Éthiopie': '+251',
    'Ghana': '+233',
    'Nigeria': '+234',
    'Bénin': '+229',
    'Togo': '+228',
    'Maroc': '+212',
    'Tunisie': '+216',
    'Algérie': '+213',
    'Égypte': '+20',
    'France': '+33',
    'Belgique': '+32',
    'Suisse': '+41',
    'Canada': '+1-1',
    'États-Unis': '+1',
  };

  // Mapping des codes de pays vers les noms de pays
  static const Map<String, String> _codeToCountry = {
    '+221': 'Sénégal',
    '+223': 'Mali',
    '+226': 'Burkina Faso',
    '+225': 'Côte d\'Ivoire',
    '+224': 'Guinée',
    '+227': 'Niger',
    '+235': 'Tchad',
    '+237': 'Cameroun',
    '+241': 'Gabon',
    '+242': 'Congo',
    '+243': 'République Démocratique du Congo',
    '+250': 'Rwanda',
    '+257': 'Burundi',
    '+255': 'Tanzanie',
    '+254': 'Kenya',
    '+256': 'Ouganda',
    '+251': 'Éthiopie',
    '+233': 'Ghana',
    '+234': 'Nigeria',
    '+229': 'Bénin',
    '+228': 'Togo',
    '+212': 'Maroc',
    '+216': 'Tunisie',
    '+213': 'Algérie',
    '+20': 'Égypte',
    '+33': 'France',
    '+32': 'Belgique',
    '+41': 'Suisse',
    '+1-1': 'Canada',
    '+1': 'États-Unis',
  };

  /// Obtient le code de pays à partir du nom du pays
  static String? getCountryCode(String countryName) {
    return _countryToCode[countryName];
  }

  /// Obtient le nom du pays à partir du code de pays
  static String? getCountryName(String countryCode) {
    return _codeToCountry[countryCode];
  }

  /// Obtient le format de téléphone pour un pays donné
  static PhoneFormat? getPhoneFormat(String countryName) {
    return PhoneValidation.phoneFormats[countryName];
  }

  /// Obtient le format de téléphone pour un code de pays donné
  static PhoneFormat? getPhoneFormatByCode(String countryCode) {
    final countryName = getCountryName(countryCode);
    if (countryName != null) {
      return getPhoneFormat(countryName);
    }
    return null;
  }

  /// Génère un exemple de numéro de téléphone pour un pays donné
  static String generatePhoneExample(String countryName) {
    final format = getPhoneFormat(countryName);
    if (format != null) {
      return '${format.countryCode} ${format.example}';
    }
    return '';
  }

  /// Valide un numéro de téléphone pour un pays donné
  static bool validatePhoneNumber(String phoneNumber, String countryName) {
    final format = getPhoneFormat(countryName);
    if (format == null) return false;

    // Nettoyer le numéro (enlever espaces, tirets, etc.)
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');

    // Vérifier si le numéro commence par le code du pays
    if (!cleanNumber.startsWith(format.countryCode)) {
      return false;
    }

    // Extraire le numéro local (sans le code pays)
    final localNumber = cleanNumber.substring(format.countryCode.length);

    // Vérifier la longueur
    if (localNumber.length != format.totalDigits) {
      return false;
    }

    // Vérifier les préfixes mobiles
    if (format.mobilePrefixes.isNotEmpty) {
      final prefix = localNumber.substring(0, 2);
      return format.mobilePrefixes.contains(prefix);
    }

    return true;
  }

  /// Formate un numéro de téléphone selon le standard du pays
  static String formatPhoneNumber(String phoneNumber, String countryName) {
    final format = getPhoneFormat(countryName);
    if (format == null) return phoneNumber;

    // Nettoyer le numéro
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');

    // Si le numéro ne commence pas par le code du pays, l'ajouter
    if (!cleanNumber.startsWith(format.countryCode)) {
      final localNumber = cleanNumber.replaceAll(RegExp(r'^\+?\d*'), '');
      return '${format.countryCode} $localNumber';
    }

    // Extraire le numéro local
    final localNumber = cleanNumber.substring(format.countryCode.length);

    // Formater selon la longueur attendue
    if (localNumber.length == format.totalDigits) {
      return '${format.countryCode} $localNumber';
    }

    return phoneNumber;
  }

  /// Obtient la longueur maximale attendue pour un pays donné
  static int getExpectedPhoneLength(String countryName) {
    final format = getPhoneFormat(countryName);
    return format?.totalDigits ?? 9;
  }

  /// Obtient le placeholder pour le champ téléphone selon le pays
  static String getPhonePlaceholder(String countryName) {
    final format = getPhoneFormat(countryName);
    if (format != null) {
      return 'Ex: ${format.example}';
    }
    return 'Entrez votre numéro';
  }

  /// Obtient le message d'aide pour la validation téléphone
  static String getPhoneHelpMessage(String countryName) {
    final format = getPhoneFormat(countryName);
    if (format != null) {
      final prefixes = format.mobilePrefixes.take(3).join(', ');
      return 'Format: ${format.totalDigits} chiffres, préfixes: $prefixes...';
    }
    return 'Entrez un numéro de téléphone valide';
  }
}
