import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'sms_verification_screen_lovable.dart';

class AuthScreenLovable extends StatefulWidget {
  const AuthScreenLovable({super.key});

  @override
  State<AuthScreenLovable> createState() => _AuthScreenLovableState();
}

class _AuthScreenLovableState extends State<AuthScreenLovable>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  bool _showContent = false;
  String _selectedCountryCode = '+221'; // Sénégal par défaut

  // Règles de validation par pays
  final Map<String, Map<String, dynamic>> _phoneValidationRules = {
    '+221': {
      'minLength': 9,
      'maxLength': 9,
      'pattern': r'^[0-9]{9}$',
      'example': '771234567',
    },
    '+33': {
      'minLength': 9,
      'maxLength': 9,
      'pattern': r'^[0-9]{9}$',
      'example': '123456789',
    },
    '+225': {
      'minLength': 8,
      'maxLength': 10,
      'pattern': r'^[0-9]{8,10}$',
      'example': '12345678',
    },
    '+223': {
      'minLength': 8,
      'maxLength': 8,
      'pattern': r'^[0-9]{8}$',
      'example': '12345678',
    },
    '+226': {
      'minLength': 8,
      'maxLength': 8,
      'pattern': r'^[0-9]{8}$',
      'example': '12345678',
    },
    '+227': {
      'minLength': 8,
      'maxLength': 8,
      'pattern': r'^[0-9]{8}$',
      'example': '12345678',
    },
    '+224': {
      'minLength': 8,
      'maxLength': 9,
      'pattern': r'^[0-9]{8,9}$',
      'example': '12345678',
    },
    '+220': {
      'minLength': 7,
      'maxLength': 7,
      'pattern': r'^[0-9]{7}$',
      'example': '1234567',
    },
    '+245': {
      'minLength': 7,
      'maxLength': 7,
      'pattern': r'^[0-9]{7}$',
      'example': '1234567',
    },
    '+238': {
      'minLength': 7,
      'maxLength': 7,
      'pattern': r'^[0-9]{7}$',
      'example': '1234567',
    },
    '+212': {
      'minLength': 9,
      'maxLength': 9,
      'pattern': r'^[0-9]{9}$',
      'example': '123456789',
    },
    '+213': {
      'minLength': 9,
      'maxLength': 9,
      'pattern': r'^[0-9]{9}$',
      'example': '123456789',
    },
    '+216': {
      'minLength': 8,
      'maxLength': 8,
      'pattern': r'^[0-9]{8}$',
      'example': '12345678',
    },
    '+20': {
      'minLength': 10,
      'maxLength': 10,
      'pattern': r'^[0-9]{10}$',
      'example': '1234567890',
    },
    '+234': {
      'minLength': 10,
      'maxLength': 10,
      'pattern': r'^[0-9]{10}$',
      'example': '1234567890',
    },
    '+233': {
      'minLength': 9,
      'maxLength': 9,
      'pattern': r'^[0-9]{9}$',
      'example': '123456789',
    },
    '+237': {
      'minLength': 9,
      'maxLength': 9,
      'pattern': r'^[0-9]{9}$',
      'example': '123456789',
    },
    '+243': {
      'minLength': 9,
      'maxLength': 9,
      'pattern': r'^[0-9]{9}$',
      'example': '123456789',
    },
    '+242': {
      'minLength': 9,
      'maxLength': 9,
      'pattern': r'^[0-9]{9}$',
      'example': '123456789',
    },
    '+241': {
      'minLength': 8,
      'maxLength': 8,
      'pattern': r'^[0-9]{8}$',
      'example': '12345678',
    },
    '+235': {
      'minLength': 8,
      'maxLength': 8,
      'pattern': r'^[0-9]{8}$',
      'example': '12345678',
    },
    '+236': {
      'minLength': 8,
      'maxLength': 8,
      'pattern': r'^[0-9]{8}$',
      'example': '12345678',
    },
    '+228': {
      'minLength': 8,
      'maxLength': 8,
      'pattern': r'^[0-9]{8}$',
      'example': '12345678',
    },
    '+229': {
      'minLength': 8,
      'maxLength': 8,
      'pattern': r'^[0-9]{8}$',
      'example': '12345678',
    },
    '+261': {
      'minLength': 9,
      'maxLength': 9,
      'pattern': r'^[0-9]{9}$',
      'example': '123456789',
    },
    '+230': {
      'minLength': 7,
      'maxLength': 7,
      'pattern': r'^[0-9]{7}$',
      'example': '1234567',
    },
    '+248': {
      'minLength': 7,
      'maxLength': 7,
      'pattern': r'^[0-9]{7}$',
      'example': '1234567',
    },
    '+269': {
      'minLength': 7,
      'maxLength': 7,
      'pattern': r'^[0-9]{7}$',
      'example': '1234567',
    },
    '+253': {
      'minLength': 8,
      'maxLength': 8,
      'pattern': r'^[0-9]{8}$',
      'example': '12345678',
    },
    '+251': {
      'minLength': 9,
      'maxLength': 9,
      'pattern': r'^[0-9]{9}$',
      'example': '123456789',
    },
    '+254': {
      'minLength': 9,
      'maxLength': 9,
      'pattern': r'^[0-9]{9}$',
      'example': '123456789',
    },
    '+255': {
      'minLength': 9,
      'maxLength': 9,
      'pattern': r'^[0-9]{9}$',
      'example': '123456789',
    },
    '+256': {
      'minLength': 9,
      'maxLength': 9,
      'pattern': r'^[0-9]{9}$',
      'example': '123456789',
    },
    '+250': {
      'minLength': 9,
      'maxLength': 9,
      'pattern': r'^[0-9]{9}$',
      'example': '123456789',
    },
    '+257': {
      'minLength': 8,
      'maxLength': 8,
      'pattern': r'^[0-9]{8}$',
      'example': '12345678',
    },
    '+27': {
      'minLength': 9,
      'maxLength': 9,
      'pattern': r'^[0-9]{9}$',
      'example': '123456789',
    },
    '+263': {
      'minLength': 9,
      'maxLength': 9,
      'pattern': r'^[0-9]{9}$',
      'example': '123456789',
    },
    '+260': {
      'minLength': 9,
      'maxLength': 9,
      'pattern': r'^[0-9]{9}$',
      'example': '123456789',
    },
    '+267': {
      'minLength': 7,
      'maxLength': 7,
      'pattern': r'^[0-9]{7}$',
      'example': '1234567',
    },
    '+264': {
      'minLength': 9,
      'maxLength': 9,
      'pattern': r'^[0-9]{9}$',
      'example': '123456789',
    },
    '+244': {
      'minLength': 9,
      'maxLength': 9,
      'pattern': r'^[0-9]{9}$',
      'example': '123456789',
    },
    '+258': {
      'minLength': 9,
      'maxLength': 9,
      'pattern': r'^[0-9]{9}$',
      'example': '123456789',
    },
    '+265': {
      'minLength': 9,
      'maxLength': 9,
      'pattern': r'^[0-9]{9}$',
      'example': '123456789',
    },
    '+266': {
      'minLength': 8,
      'maxLength': 8,
      'pattern': r'^[0-9]{8}$',
      'example': '12345678',
    },
    '+268': {
      'minLength': 8,
      'maxLength': 8,
      'pattern': r'^[0-9]{8}$',
      'example': '12345678',
    },
    '+1': {
      'minLength': 10,
      'maxLength': 10,
      'pattern': r'^[0-9]{10}$',
      'example': '1234567890',
    },
    '+44': {
      'minLength': 10,
      'maxLength': 10,
      'pattern': r'^[0-9]{10}$',
      'example': '1234567890',
    },
    '+49': {
      'minLength': 10,
      'maxLength': 11,
      'pattern': r'^[0-9]{10,11}$',
      'example': '1234567890',
    },
    '+39': {
      'minLength': 9,
      'maxLength': 10,
      'pattern': r'^[0-9]{9,10}$',
      'example': '123456789',
    },
    '+34': {
      'minLength': 9,
      'maxLength': 9,
      'pattern': r'^[0-9]{9}$',
      'example': '123456789',
    },
    '+351': {
      'minLength': 9,
      'maxLength': 9,
      'pattern': r'^[0-9]{9}$',
      'example': '123456789',
    },
    '+32': {
      'minLength': 9,
      'maxLength': 9,
      'pattern': r'^[0-9]{9}$',
      'example': '123456789',
    },
    '+41': {
      'minLength': 9,
      'maxLength': 9,
      'pattern': r'^[0-9]{9}$',
      'example': '123456789',
    },
    '+31': {
      'minLength': 9,
      'maxLength': 9,
      'pattern': r'^[0-9]{9}$',
      'example': '123456789',
    },
    '+46': {
      'minLength': 9,
      'maxLength': 9,
      'pattern': r'^[0-9]{9}$',
      'example': '123456789',
    },
    '+47': {
      'minLength': 8,
      'maxLength': 8,
      'pattern': r'^[0-9]{8}$',
      'example': '12345678',
    },
    '+45': {
      'minLength': 8,
      'maxLength': 8,
      'pattern': r'^[0-9]{8}$',
      'example': '12345678',
    },
    '+358': {
      'minLength': 9,
      'maxLength': 10,
      'pattern': r'^[0-9]{9,10}$',
      'example': '123456789',
    },
    '+48': {
      'minLength': 9,
      'maxLength': 9,
      'pattern': r'^[0-9]{9}$',
      'example': '123456789',
    },
    '+420': {
      'minLength': 9,
      'maxLength': 9,
      'pattern': r'^[0-9]{9}$',
      'example': '123456789',
    },
    '+36': {
      'minLength': 9,
      'maxLength': 9,
      'pattern': r'^[0-9]{9}$',
      'example': '123456789',
    },
    '+40': {
      'minLength': 9,
      'maxLength': 9,
      'pattern': r'^[0-9]{9}$',
      'example': '123456789',
    },
    '+359': {
      'minLength': 9,
      'maxLength': 9,
      'pattern': r'^[0-9]{9}$',
      'example': '123456789',
    },
    '+30': {
      'minLength': 10,
      'maxLength': 10,
      'pattern': r'^[0-9]{10}$',
      'example': '1234567890',
    },
    '+90': {
      'minLength': 10,
      'maxLength': 10,
      'pattern': r'^[0-9]{10}$',
      'example': '1234567890',
    },
    '+7': {
      'minLength': 10,
      'maxLength': 10,
      'pattern': r'^[0-9]{10}$',
      'example': '1234567890',
    },
    '+86': {
      'minLength': 11,
      'maxLength': 11,
      'pattern': r'^[0-9]{11}$',
      'example': '12345678901',
    },
    '+81': {
      'minLength': 10,
      'maxLength': 11,
      'pattern': r'^[0-9]{10,11}$',
      'example': '1234567890',
    },
    '+82': {
      'minLength': 10,
      'maxLength': 11,
      'pattern': r'^[0-9]{10,11}$',
      'example': '1234567890',
    },
    '+91': {
      'minLength': 10,
      'maxLength': 10,
      'pattern': r'^[0-9]{10}$',
      'example': '1234567890',
    },
    '+55': {
      'minLength': 10,
      'maxLength': 11,
      'pattern': r'^[0-9]{10,11}$',
      'example': '1234567890',
    },
    '+54': {
      'minLength': 10,
      'maxLength': 10,
      'pattern': r'^[0-9]{10}$',
      'example': '1234567890',
    },
    '+56': {
      'minLength': 8,
      'maxLength': 9,
      'pattern': r'^[0-9]{8,9}$',
      'example': '12345678',
    },
    '+57': {
      'minLength': 10,
      'maxLength': 10,
      'pattern': r'^[0-9]{10}$',
      'example': '1234567890',
    },
    '+51': {
      'minLength': 9,
      'maxLength': 9,
      'pattern': r'^[0-9]{9}$',
      'example': '123456789',
    },
    '+58': {
      'minLength': 10,
      'maxLength': 10,
      'pattern': r'^[0-9]{10}$',
      'example': '1234567890',
    },
    '+52': {
      'minLength': 10,
      'maxLength': 10,
      'pattern': r'^[0-9]{10}$',
      'example': '1234567890',
    },
    '+61': {
      'minLength': 9,
      'maxLength': 9,
      'pattern': r'^[0-9]{9}$',
      'example': '123456789',
    },
    '+64': {
      'minLength': 8,
      'maxLength': 9,
      'pattern': r'^[0-9]{8,9}$',
      'example': '12345678',
    },
  };

  late AnimationController _fadeController;
  late AnimationController _slideController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Liste complète des pays avec drapeaux et codes
  final List<Map<String, String>> _countries = [
    {'name': 'Sénégal', 'code': '+221', 'flag': '🇸🇳'},
    {'name': 'France', 'code': '+33', 'flag': '🇫🇷'},
    {'name': 'Côte d\'Ivoire', 'code': '+225', 'flag': '🇨🇮'},
    {'name': 'Mali', 'code': '+223', 'flag': '🇲🇱'},
    {'name': 'Burkina Faso', 'code': '+226', 'flag': '🇧🇫'},
    {'name': 'Niger', 'code': '+227', 'flag': '🇳🇪'},
    {'name': 'Guinée', 'code': '+224', 'flag': '🇬🇳'},
    {'name': 'Gambie', 'code': '+220', 'flag': '🇬🇲'},
    {'name': 'Guinée-Bissau', 'code': '+245', 'flag': '🇬🇼'},
    {'name': 'Cap-Vert', 'code': '+238', 'flag': '🇨🇻'},
    {'name': 'Maroc', 'code': '+212', 'flag': '🇲🇦'},
    {'name': 'Algérie', 'code': '+213', 'flag': '🇩🇿'},
    {'name': 'Tunisie', 'code': '+216', 'flag': '🇹🇳'},
    {'name': 'Égypte', 'code': '+20', 'flag': '🇪🇬'},
    {'name': 'Nigeria', 'code': '+234', 'flag': '🇳🇬'},
    {'name': 'Ghana', 'code': '+233', 'flag': '🇬🇭'},
    {'name': 'Cameroun', 'code': '+237', 'flag': '🇨🇲'},
    {
      'name': 'République Démocratique du Congo',
      'code': '+243',
      'flag': '🇨🇩',
    },
    {'name': 'Congo', 'code': '+242', 'flag': '🇨🇬'},
    {'name': 'Gabon', 'code': '+241', 'flag': '🇬🇦'},
    {'name': 'Tchad', 'code': '+235', 'flag': '🇹🇩'},
    {'name': 'République Centrafricaine', 'code': '+236', 'flag': '🇨🇫'},
    {'name': 'Togo', 'code': '+228', 'flag': '🇹🇬'},
    {'name': 'Bénin', 'code': '+229', 'flag': '🇧🇯'},
    {'name': 'Madagascar', 'code': '+261', 'flag': '🇲🇬'},
    {'name': 'Maurice', 'code': '+230', 'flag': '🇲🇺'},
    {'name': 'Seychelles', 'code': '+248', 'flag': '🇸🇨'},
    {'name': 'Comores', 'code': '+269', 'flag': '🇰🇲'},
    {'name': 'Djibouti', 'code': '+253', 'flag': '🇩🇯'},
    {'name': 'Éthiopie', 'code': '+251', 'flag': '🇪🇹'},
    {'name': 'Kenya', 'code': '+254', 'flag': '🇰🇪'},
    {'name': 'Tanzanie', 'code': '+255', 'flag': '🇹🇿'},
    {'name': 'Ouganda', 'code': '+256', 'flag': '🇺🇬'},
    {'name': 'Rwanda', 'code': '+250', 'flag': '🇷🇼'},
    {'name': 'Burundi', 'code': '+257', 'flag': '🇧🇮'},
    {'name': 'Afrique du Sud', 'code': '+27', 'flag': '🇿🇦'},
    {'name': 'Zimbabwe', 'code': '+263', 'flag': '🇿🇼'},
    {'name': 'Zambie', 'code': '+260', 'flag': '🇿🇲'},
    {'name': 'Botswana', 'code': '+267', 'flag': '🇧🇼'},
    {'name': 'Namibie', 'code': '+264', 'flag': '🇳🇦'},
    {'name': 'Angola', 'code': '+244', 'flag': '🇦🇴'},
    {'name': 'Mozambique', 'code': '+258', 'flag': '🇲🇿'},
    {'name': 'Malawi', 'code': '+265', 'flag': '🇲🇼'},
    {'name': 'Lesotho', 'code': '+266', 'flag': '🇱🇸'},
    {'name': 'Eswatini', 'code': '+268', 'flag': '🇸🇿'},
    {'name': 'États-Unis', 'code': '+1', 'flag': '🇺🇸'},
    {'name': 'Canada', 'code': '+1', 'flag': '🇨🇦'},
    {'name': 'Royaume-Uni', 'code': '+44', 'flag': '🇬🇧'},
    {'name': 'Allemagne', 'code': '+49', 'flag': '🇩🇪'},
    {'name': 'Italie', 'code': '+39', 'flag': '🇮🇹'},
    {'name': 'Espagne', 'code': '+34', 'flag': '🇪🇸'},
    {'name': 'Portugal', 'code': '+351', 'flag': '🇵🇹'},
    {'name': 'Belgique', 'code': '+32', 'flag': '🇧🇪'},
    {'name': 'Suisse', 'code': '+41', 'flag': '🇨🇭'},
    {'name': 'Pays-Bas', 'code': '+31', 'flag': '🇳🇱'},
    {'name': 'Suède', 'code': '+46', 'flag': '🇸🇪'},
    {'name': 'Norvège', 'code': '+47', 'flag': '🇳🇴'},
    {'name': 'Danemark', 'code': '+45', 'flag': '🇩🇰'},
    {'name': 'Finlande', 'code': '+358', 'flag': '🇫🇮'},
    {'name': 'Pologne', 'code': '+48', 'flag': '🇵🇱'},
    {'name': 'République Tchèque', 'code': '+420', 'flag': '🇨🇿'},
    {'name': 'Hongrie', 'code': '+36', 'flag': '🇭🇺'},
    {'name': 'Roumanie', 'code': '+40', 'flag': '🇷🇴'},
    {'name': 'Bulgarie', 'code': '+359', 'flag': '🇧🇬'},
    {'name': 'Grèce', 'code': '+30', 'flag': '🇬🇷'},
    {'name': 'Turquie', 'code': '+90', 'flag': '🇹🇷'},
    {'name': 'Russie', 'code': '+7', 'flag': '🇷🇺'},
    {'name': 'Chine', 'code': '+86', 'flag': '🇨🇳'},
    {'name': 'Japon', 'code': '+81', 'flag': '🇯🇵'},
    {'name': 'Corée du Sud', 'code': '+82', 'flag': '🇰🇷'},
    {'name': 'Inde', 'code': '+91', 'flag': '🇮🇳'},
    {'name': 'Brésil', 'code': '+55', 'flag': '🇧🇷'},
    {'name': 'Argentine', 'code': '+54', 'flag': '🇦🇷'},
    {'name': 'Chili', 'code': '+56', 'flag': '🇨🇱'},
    {'name': 'Colombie', 'code': '+57', 'flag': '🇨🇴'},
    {'name': 'Pérou', 'code': '+51', 'flag': '🇵🇪'},
    {'name': 'Venezuela', 'code': '+58', 'flag': '🇻🇪'},
    {'name': 'Mexique', 'code': '+52', 'flag': '🇲🇽'},
    {'name': 'Australie', 'code': '+61', 'flag': '🇦🇺'},
    {'name': 'Nouvelle-Zélande', 'code': '+64', 'flag': '🇳🇿'},
  ];

  @override
  void initState() {
    super.initState();

    // Animation controllers
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    // Animations
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOutCubic,
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutQuart),
        );

    // Listener pour mettre à jour l'affichage des erreurs
    _phoneController.addListener(() {
      setState(() {});
    });

    // Start animations
    _fadeController.forward();
    _slideController.forward();

    // Show content after 500ms (like Lovable)
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _showContent = true;
      });
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // Validation sécurisée des numéros de téléphone
  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer votre numéro';
    }

    // Vérifier si le numéro contient des chiffres répétés (1111, 2222, etc.)
    if (_hasRepeatedDigits(value)) {
      return 'Numéro invalide';
    }

    // Vérifier si le numéro contient des séquences (1234, 5678, etc.)
    if (_hasSequentialDigits(value)) {
      return 'Numéro invalide';
    }

    // Récupérer les règles de validation pour le pays sélectionné
    final rules = _phoneValidationRules[_selectedCountryCode];
    if (rules == null) {
      return 'Numéro invalide';
    }

    final minLength = rules['minLength'] as int;
    final maxLength = rules['maxLength'] as int;
    final pattern = rules['pattern'] as String;

    // Vérifier la longueur
    if (value.length < minLength || value.length > maxLength) {
      return 'Numéro invalide';
    }

    // Vérifier le pattern avec regex
    final regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Numéro invalide';
    }

    // Vérifications supplémentaires de sécurité
    if (_isSuspiciousNumber(value)) {
      return 'Numéro invalide';
    }

    return null; // Numéro valide
  }

  // Vérifier les chiffres répétés (1111, 2222, etc.)
  bool _hasRepeatedDigits(String number) {
    for (int i = 0; i < number.length - 3; i++) {
      String substring = number.substring(i, i + 4);
      if (substring == substring[0] * 4) {
        return true; // 4 chiffres identiques consécutifs
      }
    }
    return false;
  }

  // Vérifier les séquences (1234, 5678, etc.)
  bool _hasSequentialDigits(String number) {
    for (int i = 0; i < number.length - 3; i++) {
      String substring = number.substring(i, i + 4);
      if (_isSequential(substring)) {
        return true;
      }
    }
    return false;
  }

  // Vérifier si une chaîne est séquentielle
  bool _isSequential(String str) {
    List<int> digits = str.split('').map((e) => int.tryParse(e) ?? -1).toList();
    if (digits.contains(-1)) return false;

    // Vérifier séquence croissante (1234)
    bool ascending = true;
    for (int i = 1; i < digits.length; i++) {
      if (digits[i] != digits[i - 1] + 1) {
        ascending = false;
        break;
      }
    }

    // Vérifier séquence décroissante (4321)
    bool descending = true;
    for (int i = 1; i < digits.length; i++) {
      if (digits[i] != digits[i - 1] - 1) {
        descending = false;
        break;
      }
    }

    return ascending || descending;
  }

  // Vérifier les numéros suspects
  bool _isSuspiciousNumber(String number) {
    // Numéros avec trop de zéros
    int zeroCount = number.split('0').length - 1;
    if (zeroCount > number.length * 0.6) {
      return true;
    }

    // Numéros avec trop de 1
    int oneCount = number.split('1').length - 1;
    if (oneCount > number.length * 0.5) {
      return true;
    }

    // Numéros trop simples (ex: 1000000, 2000000)
    if (number.startsWith('1') &&
        number.substring(1).split('0').length == number.length) {
      return true;
    }
    if (number.startsWith('2') &&
        number.substring(1).split('0').length == number.length) {
      return true;
    }

    return false;
  }

  // Obtenir le texte de format selon le pays
  String _getPhoneFormatText() {
    final rules = _phoneValidationRules[_selectedCountryCode];
    if (rules != null) {
      final minLength = rules['minLength'] as int;
      final maxLength = rules['maxLength'] as int;
      final example = rules['example'] as String;

      if (minLength == maxLength) {
        return 'Format: $_selectedCountryCode$example (${minLength} chiffres)';
      } else {
        return 'Format: $_selectedCountryCode$example (${minLength}-${maxLength} chiffres)';
      }
    }
    return 'Format: sans l\'indicatif pays ($_selectedCountryCode)';
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CountryPickerModal(
        countries: _countries,
        selectedCountryCode: _selectedCountryCode,
        onCountrySelected: (countryCode) {
          setState(() {
            _selectedCountryCode = countryCode;
          });
        },
      ),
    );
  }

  void _sendVerificationCode() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call (like Lovable)
      await Future.delayed(const Duration(milliseconds: 1500));

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Navigate to SMS verification
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                SmsVerificationScreenLovable(
                  phone: _phoneController.text,
                  countryCode: _selectedCountryCode,
                ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position:
                          Tween<Offset>(
                            begin: const Offset(1.0, 0.0),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeInOutCubic,
                            ),
                          ),
                      child: child,
                    ),
                  );
                },
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // bg-secondary/30
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 40), // Remonte la section logo/titre
                    // Logo header (EXACT like Lovable - fade-in-up 0.6s ease-out)
                    Transform.translate(
                      offset: Offset(0, _showContent ? 0 : 30),
                      child: Opacity(
                        opacity: _showContent ? 1.0 : 0.0,
                        child: Center(
                          child: Column(
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFF065b32),
                                      Color(0xFF0a7a42),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF065b32,
                                      ).withOpacity(0.15),
                                      blurRadius: 20,
                                      spreadRadius: 0,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Text(
                                    'F',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'FIBAYA',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF065b32),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Authentification sécurisée',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Card (like Lovable)
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF065b32).withOpacity(0.08),
                            blurRadius: 20,
                            spreadRadius: 0,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Card Header
                            const Center(
                              child: Column(
                                children: [
                                  Text(
                                    'Numéro de téléphone',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Entrez votre numéro pour recevoir un code de vérification',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Phone input with country selector (like Lovable)
                            Row(
                              children: [
                                // Country selector
                                GestureDetector(
                                  onTap: _showCountryPicker,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.grey[300]!,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          _countries.firstWhere(
                                            (c) =>
                                                c['code'] ==
                                                _selectedCountryCode,
                                          )['flag']!,
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          _selectedCountryCode,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Icon(
                                          Icons.keyboard_arrow_down,
                                          color: Colors.grey[600],
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Phone number field
                                Expanded(
                                  child: TextFormField(
                                    controller: _phoneController,
                                    keyboardType: TextInputType.phone,
                                    maxLength: 16, // Limitation de sécurité
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    decoration: InputDecoration(
                                      hintText: 'Numéro de téléphone',
                                      hintStyle: TextStyle(
                                        color: Colors.grey[400],
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: Colors.grey[300]!,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                          color: Colors.grey[300]!,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: Color(0xFF065b32),
                                          width: 2,
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 16,
                                          ),
                                      counterText: '', // Masquer le compteur
                                    ),
                                    validator: _validatePhoneNumber,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 60),

                            // Submit button (like Lovable)
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: _isLoading
                                    ? null
                                    : _sendVerificationCode,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF065b32),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: _isLoading
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Colors.white.withOpacity(
                                                      0.8,
                                                    ),
                                                  ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          const Text(
                                            'Envoi en cours...',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      )
                                    : const Text(
                                        'Recevoir le code SMS',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const Spacer(), // Pousse le texte de support vers le bas
                    // Support (like Lovable)
                    Center(
                      child: Text(
                        'Besoin d\'aide ? Contactez le support',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CountryPickerModal extends StatefulWidget {
  final List<Map<String, String>> countries;
  final String selectedCountryCode;
  final Function(String) onCountrySelected;

  const CountryPickerModal({
    super.key,
    required this.countries,
    required this.selectedCountryCode,
    required this.onCountrySelected,
  });

  @override
  State<CountryPickerModal> createState() => _CountryPickerModalState();
}

class _CountryPickerModalState extends State<CountryPickerModal> {
  List<Map<String, String>> _filteredCountries = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredCountries = List.from(widget.countries);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCountries(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCountries = List.from(widget.countries);
      } else {
        _filteredCountries = widget.countries.where((country) {
          String name = country['name']!.toLowerCase();
          String code = country['code']!;
          String searchQuery = query.toLowerCase();

          // Recherche par nom complet
          if (name.contains(searchQuery)) return true;

          // Recherche par code
          if (code.contains(query)) return true;

          // Recherche par mots séparés (ex: "gal" trouve "Sénégal")
          List<String> nameWords = name.split(' ');
          for (String word in nameWords) {
            if (word.contains(searchQuery)) return true;
          }

          // Recherche par syllabes (ex: "gal" trouve "Sénégal")
          for (int i = 0; i < name.length - searchQuery.length + 1; i++) {
            if (name.substring(i, i + searchQuery.length) == searchQuery) {
              return true;
            }
          }

          // Recherche par début de mot (ex: "sen" trouve "Sénégal")
          for (String word in nameWords) {
            if (word.startsWith(searchQuery)) return true;
          }

          // Recherche par fin de mot (ex: "gal" trouve "Sénégal")
          for (String word in nameWords) {
            if (word.endsWith(searchQuery)) return true;
          }

          return false;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Sélectionner un pays',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
          // Search field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              onChanged: _filterCountries,
              decoration: InputDecoration(
                hintText: 'Rechercher un pays...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF065b32),
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Countries list
          Expanded(
            child: _filteredCountries.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/recherche.png',
                          width: 64,
                          height: 64,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Aucun pays trouvé',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Essayez avec d\'autres mots-clés',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredCountries.length,
                    itemBuilder: (context, index) {
                      final country = _filteredCountries[index];
                      final isSelected =
                          country['code'] == widget.selectedCountryCode;

                      return ListTile(
                        leading: Text(
                          country['flag']!,
                          style: const TextStyle(fontSize: 24),
                        ),
                        title: Text(
                          country['name']!,
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? const Color(0xFF065b32)
                                : Colors.black87,
                          ),
                        ),
                        trailing: Text(
                          country['code']!,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? const Color(0xFF065b32)
                                : Colors.grey[600],
                          ),
                        ),
                        selected: isSelected,
                        selectedTileColor: const Color(
                          0xFF065b32,
                        ).withOpacity(0.1),
                        onTap: () {
                          widget.onCountrySelected(country['code']!);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
