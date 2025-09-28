import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import '../../common/utils/phone_validation.dart';
import 'prestataire_sms_verification_screen.dart';
import 'welcome_screen.dart';
import '../services/status_check_service.dart';

class PrestataireAuthScreen extends StatefulWidget {
  const PrestataireAuthScreen({super.key});

  @override
  State<PrestataireAuthScreen> createState() => _PrestataireAuthScreenState();
}

class _PrestataireAuthScreenState extends State<PrestataireAuthScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  bool _showContent = false;
  String _selectedCountryCode = '+221'; // Sénégal par défaut
  String? _phoneError;

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Liste complète des pays avec drapeaux et codes (202 pays - ordre alphabétique)
  final List<Map<String, String>> _countries = [
    {'name': 'Afghanistan', 'code': '+93', 'flag': '🇦🇫'},
    {'name': 'Afrique du Sud', 'code': '+27', 'flag': '🇿🇦'},
    {'name': 'Albanie', 'code': '+355', 'flag': '🇦🇱'},
    {'name': 'Algérie', 'code': '+213', 'flag': '🇩🇿'},
    {'name': 'Allemagne', 'code': '+49', 'flag': '🇩🇪'},
    {'name': 'Andorre', 'code': '+376', 'flag': '🇦🇩'},
    {'name': 'Angola', 'code': '+244', 'flag': '🇦🇴'},
    {'name': 'Antigua-et-Barbuda', 'code': '+1268', 'flag': '🇦🇬'},
    {'name': 'Arabie saoudite', 'code': '+966', 'flag': '🇸🇦'},
    {'name': 'Argentine', 'code': '+54', 'flag': '🇦🇷'},
    {'name': 'Arménie', 'code': '+374', 'flag': '🇦🇲'},
    {'name': 'Australie', 'code': '+61', 'flag': '🇦🇺'},
    {'name': 'Autriche', 'code': '+43', 'flag': '🇦🇹'},
    {'name': 'Azerbaïdjan', 'code': '+994', 'flag': '🇦🇿'},
    {'name': 'Bahamas', 'code': '+1242', 'flag': '🇧🇸'},
    {'name': 'Bahreïn', 'code': '+973', 'flag': '🇧🇭'},
    {'name': 'Bangladesh', 'code': '+880', 'flag': '🇧🇩'},
    {'name': 'Barbade', 'code': '+1246', 'flag': '🇧🇧'},
    {'name': 'Belgique', 'code': '+32', 'flag': '🇧🇪'},
    {'name': 'Belize', 'code': '+501', 'flag': '🇧🇿'},
    {'name': 'Bénin', 'code': '+229', 'flag': '🇧🇯'},
    {'name': 'Bhoutan', 'code': '+975', 'flag': '🇧🇹'},
    {'name': 'Biélorussie', 'code': '+375', 'flag': '🇧🇾'},
    {'name': 'Birmanie', 'code': '+95', 'flag': '🇲🇲'},
    {'name': 'Bolivie', 'code': '+591', 'flag': '🇧🇴'},
    {'name': 'Bosnie-Herzégovine', 'code': '+387', 'flag': '🇧🇦'},
    {'name': 'Botswana', 'code': '+267', 'flag': '🇧🇼'},
    {'name': 'Brésil', 'code': '+55', 'flag': '🇧🇷'},
    {'name': 'Brunei', 'code': '+673', 'flag': '🇧🇳'},
    {'name': 'Bulgarie', 'code': '+359', 'flag': '🇧🇬'},
    {'name': 'Burkina Faso', 'code': '+226', 'flag': '🇧🇫'},
    {'name': 'Burundi', 'code': '+257', 'flag': '🇧🇮'},
    {'name': 'Cambodge', 'code': '+855', 'flag': '🇰🇭'},
    {'name': 'Cameroun', 'code': '+237', 'flag': '🇨🇲'},
    {'name': 'Canada', 'code': '+1-1', 'flag': '🇨🇦'},
    {'name': 'Cap-Vert', 'code': '+238', 'flag': '🇨🇻'},
    {'name': 'Centrafrique', 'code': '+236', 'flag': '🇨🇫'},
    {'name': 'Chili', 'code': '+56', 'flag': '🇨🇱'},
    {'name': 'Chine', 'code': '+86', 'flag': '🇨🇳'},
    {'name': 'Chypre', 'code': '+357', 'flag': '🇨🇾'},
    {'name': 'Colombie', 'code': '+57', 'flag': '🇨🇴'},
    {'name': 'Comores', 'code': '+269', 'flag': '🇰🇲'},
    {'name': 'Congo', 'code': '+242', 'flag': '🇨🇬'},
    {'name': 'Corée du Nord', 'code': '+850', 'flag': '🇰🇵'},
    {'name': 'Corée du Sud', 'code': '+82', 'flag': '🇰🇷'},
    {'name': 'Costa Rica', 'code': '+506', 'flag': '🇨🇷'},
    {'name': 'Côte d\'Ivoire', 'code': '+225', 'flag': '🇨🇮'},
    {'name': 'Croatie', 'code': '+385', 'flag': '🇭🇷'},
    {'name': 'Cuba', 'code': '+53', 'flag': '🇨🇺'},
    {'name': 'Danemark', 'code': '+45', 'flag': '🇩🇰'},
    {'name': 'Djibouti', 'code': '+253', 'flag': '🇩🇯'},
    {'name': 'Dominique', 'code': '+1767', 'flag': '🇩🇲'},
    {'name': 'Égypte', 'code': '+20', 'flag': '🇪🇬'},
    {'name': 'Émirats arabes unis', 'code': '+971', 'flag': '🇦🇪'},
    {'name': 'Équateur', 'code': '+593', 'flag': '🇪🇨'},
    {'name': 'Érythrée', 'code': '+291', 'flag': '🇪🇷'},
    {'name': 'Espagne', 'code': '+34', 'flag': '🇪🇸'},
    {'name': 'Estonie', 'code': '+372', 'flag': '🇪🇪'},
    {'name': 'États-Unis', 'code': '+1', 'flag': '🇺🇸'},
    {'name': 'Éthiopie', 'code': '+251', 'flag': '🇪🇹'},
    {'name': 'Eswatini', 'code': '+268', 'flag': '🇸🇿'},
    {'name': 'Fidji', 'code': '+679', 'flag': '🇫🇯'},
    {'name': 'Finlande', 'code': '+358', 'flag': '🇫🇮'},
    {'name': 'France', 'code': '+33', 'flag': '🇫🇷'},
    {'name': 'Gabon', 'code': '+241', 'flag': '🇬🇦'},
    {'name': 'Gambie', 'code': '+220', 'flag': '🇬🇲'},
    {'name': 'Géorgie', 'code': '+995', 'flag': '🇬🇪'},
    {'name': 'Ghana', 'code': '+233', 'flag': '🇬🇭'},
    {'name': 'Grèce', 'code': '+30', 'flag': '🇬🇷'},
    {'name': 'Grenade', 'code': '+1473', 'flag': '🇬🇩'},
    {'name': 'Guatemala', 'code': '+502', 'flag': '🇬🇹'},
    {'name': 'Guinée', 'code': '+224', 'flag': '🇬🇳'},
    {'name': 'Guinée équatoriale', 'code': '+240', 'flag': '🇬🇶'},
    {'name': 'Guinée-Bissau', 'code': '+245', 'flag': '🇬🇼'},
    {'name': 'Guyana', 'code': '+592', 'flag': '🇬🇾'},
    {'name': 'Haïti', 'code': '+509', 'flag': '🇭🇹'},
    {'name': 'Honduras', 'code': '+504', 'flag': '🇭🇳'},
    {'name': 'Hongrie', 'code': '+36', 'flag': '🇭🇺'},
    {'name': 'Inde', 'code': '+91', 'flag': '🇮🇳'},
    {'name': 'Indonésie', 'code': '+62', 'flag': '🇮🇩'},
    {'name': 'Irak', 'code': '+964', 'flag': '🇮🇶'},
    {'name': 'Iran', 'code': '+98', 'flag': '🇮🇷'},
    {'name': 'Irlande', 'code': '+353', 'flag': '🇮🇪'},
    {'name': 'Islande', 'code': '+354', 'flag': '🇮🇸'},
    {'name': 'Israël', 'code': '+972', 'flag': '🇮🇱'},
    {'name': 'Italie', 'code': '+39', 'flag': '🇮🇹'},
    {'name': 'Jamaïque', 'code': '+1876', 'flag': '🇯🇲'},
    {'name': 'Japon', 'code': '+81', 'flag': '🇯🇵'},
    {'name': 'Jordanie', 'code': '+962', 'flag': '🇯🇴'},
    {'name': 'Kazakhstan', 'code': '+7', 'flag': '🇰🇿'},
    {'name': 'Kenya', 'code': '+254', 'flag': '🇰🇪'},
    {'name': 'Kirghizistan', 'code': '+996', 'flag': '🇰🇬'},
    {'name': 'Kiribati', 'code': '+686', 'flag': '🇰🇮'},
    {'name': 'Koweït', 'code': '+965', 'flag': '🇰🇼'},
    {'name': 'Laos', 'code': '+856', 'flag': '🇱🇦'},
    {'name': 'Lesotho', 'code': '+266', 'flag': '🇱🇸'},
    {'name': 'Lettonie', 'code': '+371', 'flag': '🇱🇻'},
    {'name': 'Liban', 'code': '+961', 'flag': '🇱🇧'},
    {'name': 'Liberia', 'code': '+231', 'flag': '🇱🇷'},
    {'name': 'Libye', 'code': '+218', 'flag': '🇱🇾'},
    {'name': 'Liechtenstein', 'code': '+423', 'flag': '🇱🇮'},
    {'name': 'Lituanie', 'code': '+370', 'flag': '🇱🇹'},
    {'name': 'Luxembourg', 'code': '+352', 'flag': '🇱🇺'},
    {'name': 'Macédoine du Nord', 'code': '+389', 'flag': '🇲🇰'},
    {'name': 'Madagascar', 'code': '+261', 'flag': '🇲🇬'},
    {'name': 'Malaisie', 'code': '+60', 'flag': '🇲🇾'},
    {'name': 'Malawi', 'code': '+265', 'flag': '🇲🇼'},
    {'name': 'Maldives', 'code': '+960', 'flag': '🇲🇻'},
    {'name': 'Mali', 'code': '+223', 'flag': '🇲🇱'},
    {'name': 'Malte', 'code': '+356', 'flag': '🇲🇹'},
    {'name': 'Maroc', 'code': '+212', 'flag': '🇲🇦'},
    {'name': 'Marshall', 'code': '+692', 'flag': '🇲🇭'},
    {'name': 'Maurice', 'code': '+230', 'flag': '🇲🇺'},
    {'name': 'Mauritanie', 'code': '+222', 'flag': '🇲🇷'},
    {'name': 'Mexique', 'code': '+52', 'flag': '🇲🇽'},
    {'name': 'Micronésie', 'code': '+691', 'flag': '🇫🇲'},
    {'name': 'Moldavie', 'code': '+373', 'flag': '🇲🇩'},
    {'name': 'Monaco', 'code': '+377', 'flag': '🇲🇨'},
    {'name': 'Mongolie', 'code': '+976', 'flag': '🇲🇳'},
    {'name': 'Monténégro', 'code': '+382', 'flag': '🇲🇪'},
    {'name': 'Mozambique', 'code': '+258', 'flag': '🇲🇿'},
    {'name': 'Myanmar', 'code': '+95', 'flag': '🇲🇲'},
    {'name': 'Namibie', 'code': '+264', 'flag': '🇳🇦'},
    {'name': 'Nauru', 'code': '+674', 'flag': '🇳🇷'},
    {'name': 'Népal', 'code': '+977', 'flag': '🇳🇵'},
    {'name': 'Nicaragua', 'code': '+505', 'flag': '🇳🇮'},
    {'name': 'Niger', 'code': '+227', 'flag': '🇳🇪'},
    {'name': 'Nigeria', 'code': '+234', 'flag': '🇳🇬'},
    {'name': 'Niue', 'code': '+683', 'flag': '🇳🇺'},
    {'name': 'Norvège', 'code': '+47', 'flag': '🇳🇴'},
    {'name': 'Nouvelle-Zélande', 'code': '+64', 'flag': '🇳🇿'},
    {'name': 'Oman', 'code': '+968', 'flag': '🇴🇲'},
    {'name': 'Ouganda', 'code': '+256', 'flag': '🇺🇬'},
    {'name': 'Ouzbékistan', 'code': '+998', 'flag': '🇺🇿'},
    {'name': 'Pakistan', 'code': '+92', 'flag': '🇵🇰'},
    {'name': 'Palaos', 'code': '+680', 'flag': '🇵🇼'},
    {'name': 'Panama', 'code': '+507', 'flag': '🇵🇦'},
    {'name': 'Papouasie-Nouvelle-Guinée', 'code': '+675', 'flag': '🇵🇬'},
    {'name': 'Paraguay', 'code': '+595', 'flag': '🇵🇾'},
    {'name': 'Pays-Bas', 'code': '+31', 'flag': '🇳🇱'},
    {'name': 'Pérou', 'code': '+51', 'flag': '🇵🇪'},
    {'name': 'Philippines', 'code': '+63', 'flag': '🇵🇭'},
    {'name': 'Pologne', 'code': '+48', 'flag': '🇵🇱'},
    {'name': 'Portugal', 'code': '+351', 'flag': '🇵🇹'},
    {'name': 'Qatar', 'code': '+974', 'flag': '🇶🇦'},
    {
      'name': 'République démocratique du Congo',
      'code': '+243',
      'flag': '🇨🇩',
    },
    {'name': 'République tchèque', 'code': '+420', 'flag': '🇨🇿'},
    {'name': 'Roumanie', 'code': '+40', 'flag': '🇷🇴'},
    {'name': 'Royaume-Uni', 'code': '+44', 'flag': '🇬🇧'},
    {'name': 'Russie', 'code': '+7', 'flag': '🇷🇺'},
    {'name': 'Rwanda', 'code': '+250', 'flag': '🇷🇼'},
    {'name': 'Saint-Christophe-et-Niévès', 'code': '+1869', 'flag': '🇰🇳'},
    {'name': 'Sainte-Lucie', 'code': '+1758', 'flag': '🇱🇨'},
    {'name': 'Saint-Marin', 'code': '+378', 'flag': '🇸🇲'},
    {
      'name': 'Saint-Vincent-et-les-Grenadines',
      'code': '+1784',
      'flag': '🇻🇨',
    },
    {'name': 'Salomon', 'code': '+677', 'flag': '🇸🇧'},
    {'name': 'Salvador', 'code': '+503', 'flag': '🇸🇻'},
    {'name': 'Samoa', 'code': '+685', 'flag': '🇼🇸'},
    {'name': 'São Tomé-et-Príncipe', 'code': '+239', 'flag': '🇸🇹'},
    {'name': 'Sénégal', 'code': '+221', 'flag': '🇸🇳'},
    {'name': 'Serbie', 'code': '+381', 'flag': '🇷🇸'},
    {'name': 'Seychelles', 'code': '+248', 'flag': '🇸🇨'},
    {'name': 'Sierra Leone', 'code': '+232', 'flag': '🇸🇱'},
    {'name': 'Singapour', 'code': '+65', 'flag': '🇸🇬'},
    {'name': 'Slovaquie', 'code': '+421', 'flag': '🇸🇰'},
    {'name': 'Slovénie', 'code': '+386', 'flag': '🇸🇮'},
    {'name': 'Somalie', 'code': '+252', 'flag': '🇸🇴'},
    {'name': 'Soudan', 'code': '+249', 'flag': '🇸🇩'},
    {'name': 'Soudan du Sud', 'code': '+211', 'flag': '🇸🇸'},
    {'name': 'Sri Lanka', 'code': '+94', 'flag': '🇱🇰'},
    {'name': 'Suède', 'code': '+46', 'flag': '🇸🇪'},
    {'name': 'Suisse', 'code': '+41', 'flag': '🇨🇭'},
    {'name': 'Suriname', 'code': '+597', 'flag': '🇸🇷'},
    {'name': 'Syrie', 'code': '+963', 'flag': '🇸🇾'},
    {'name': 'Tadjikistan', 'code': '+992', 'flag': '🇹🇯'},
    {'name': 'Tanzanie', 'code': '+255', 'flag': '🇹🇿'},
    {'name': 'Tchad', 'code': '+235', 'flag': '🇹🇩'},
    {'name': 'Tchéquie', 'code': '+420', 'flag': '🇨🇿'},
    {'name': 'Thaïlande', 'code': '+66', 'flag': '🇹🇭'},
    {'name': 'Timor oriental', 'code': '+670', 'flag': '🇹🇱'},
    {'name': 'Togo', 'code': '+228', 'flag': '🇹🇬'},
    {'name': 'Tonga', 'code': '+676', 'flag': '🇹🇴'},
    {'name': 'Trinité-et-Tobago', 'code': '+1868', 'flag': '🇹🇹'},
    {'name': 'Tunisie', 'code': '+216', 'flag': '🇹🇳'},
    {'name': 'Turkménistan', 'code': '+993', 'flag': '🇹🇲'},
    {'name': 'Turquie', 'code': '+90', 'flag': '🇹🇷'},
    {'name': 'Tuvalu', 'code': '+688', 'flag': '🇹🇻'},
    {'name': 'Ukraine', 'code': '+380', 'flag': '🇺🇦'},
    {'name': 'Uruguay', 'code': '+598', 'flag': '🇺🇾'},
    {'name': 'Vanuatu', 'code': '+678', 'flag': '🇻🇺'},
    {'name': 'Vatican', 'code': '+379', 'flag': '🇻🇦'},
    {'name': 'Venezuela', 'code': '+58', 'flag': '🇻🇪'},
    {'name': 'Vietnam', 'code': '+84', 'flag': '🇻🇳'},
    {'name': 'Yémen', 'code': '+967', 'flag': '🇾🇪'},
    {'name': 'Zambie', 'code': '+260', 'flag': '🇿🇲'},
    {'name': 'Zimbabwe', 'code': '+263', 'flag': '🇿🇼'},
  ];

  @override
  void initState() {
    super.initState();

    // Initialize animations
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    // Start animations
    _fadeController.forward();
    _slideController.forward();

    // Show content after a delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _showContent = true;
        });
      }
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

    // Trouver le pays sélectionné
    String selectedCountryName = '';
    for (Map<String, String> country in _countries) {
      if (country['code'] == _selectedCountryCode) {
        selectedCountryName = country['name']!;
        break;
      }
    }

    if (selectedCountryName.isEmpty) {
      return 'Numéro invalide';
    }

    // Utiliser la validation spécifique par pays
    return PhoneValidation.validatePhoneNumber(value, selectedCountryName);
  }

  // Obtenir la longueur attendue du numéro de téléphone
  int _getExpectedPhoneLength() {
    String selectedCountryName = '';
    for (Map<String, String> country in _countries) {
      if (country['code'] == _selectedCountryCode) {
        selectedCountryName = country['name']!;
        break;
      }
    }

    if (selectedCountryName.isEmpty) return 15; // Valeur par défaut

    final format = PhoneValidation.getCountryFormat(selectedCountryName);
    return format?.totalDigits ?? 15;
  }

  // Check if user is approved by admin via API
  Future<bool> _checkAdminApproval() async {
    try {
      // Construire le numéro complet avec le code pays
      String fullPhoneNumber = '$_selectedCountryCode${_phoneController.text}';

      // Appel API pour vérifier si le numéro est validé
      final response = await http.get(
        Uri.parse(
          'http://192.168.1.26:8081/api/prestataires/check-validation/$fullPhoneNumber',
        ),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['isValide'] == true;
      } else {
        // En cas d'erreur, considérer comme non validé
        return false;
      }
    } catch (e) {
      // En cas d'erreur de connexion, considérer comme non validé
      print('Erreur lors de la vérification d\'approbation: $e');
      return false;
    }
  }

  // Show dialog when user is not approved by admin
  void _showNotApprovedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.orange[600], size: 28),
              const SizedBox(width: 12),
              const Text(
                'Non éligible',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Vous n\'êtes pas encore éligible pour utiliser l\'application prestataire.',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 12),
              const Text(
                'Pour être éligible, vous devez d\'abord devenir prestataire et soumettre vos documents pour validation par notre équipe d\'administration.',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Annuler',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to Welcome screen (Devenir Prestataire)
                Navigator.of(context).pushReplacement(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const WelcomeScreen(),
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
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF065b32),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Devenir Prestataire',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitPhoneNumber() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call to verify phone and check admin approval
      await Future.delayed(const Duration(milliseconds: 1500));

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Check if user is approved by admin
        bool isApprovedByAdmin = await _checkAdminApproval();

        if (isApprovedByAdmin) {
          // User is approved, navigate to SMS verification
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  PrestataireSmsVerificationScreen(
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
        } else {
          // User is not approved, show dialog
          _showNotApprovedDialog();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: Colors.red,
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 40,
                      ), // Remonte la section logo/titre
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
                                  'Authentification Prestataire',
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

                              // Phone input with country selector (like Prestataire)
                              Row(
                                children: [
                                  // Country selector
                                  Expanded(
                                    flex: 2,
                                    child: DropdownButtonFormField<String>(
                                      value: _selectedCountryCode,
                                      isExpanded: true,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(12),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(12),
                                          ),
                                          borderSide: BorderSide(
                                            color: Color(0xFF065b32),
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                      // Affichage dans le menu fermé : Drapeau + Code
                                      selectedItemBuilder: (BuildContext context) {
                                        return _countries.map<Widget>((
                                          country,
                                        ) {
                                          return Container(
                                            width: double.infinity,
                                            child: Text(
                                              '${country['flag']} ${country['code']}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          );
                                        }).toList();
                                      },
                                      // Affichage dans le menu ouvert : Drapeau + Nom
                                      items: _countries.map((country) {
                                        return DropdownMenuItem(
                                          value: country['code'],
                                          child: Container(
                                            width: double.infinity,
                                            child: Text(
                                              '${country['flag']} ${country['name']}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedCountryCode =
                                              value ?? '+221';
                                          // Revalider le numéro de téléphone quand le pays change
                                          if (_phoneController
                                              .text
                                              .isNotEmpty) {
                                            _validatePhoneNumber(
                                              _phoneController.text,
                                            );
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextFormField(
                                          controller: _phoneController,
                                          maxLength: _getExpectedPhoneLength(),
                                          textDirection: TextDirection.ltr,
                                          textAlign: TextAlign.start,
                                          textInputAction: TextInputAction.done,
                                          enableSuggestions: false,
                                          autocorrect: false,
                                          smartDashesType:
                                              SmartDashesType.disabled,
                                          smartQuotesType:
                                              SmartQuotesType.disabled,
                                          decoration: InputDecoration(
                                            border: const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(12),
                                              ),
                                            ),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                        Radius.circular(12),
                                                      ),
                                                  borderSide: BorderSide(
                                                    color: Color(0xFF065b32),
                                                    width: 2,
                                                  ),
                                                ),
                                            errorBorder:
                                                const OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                        Radius.circular(12),
                                                      ),
                                                  borderSide: BorderSide(
                                                    color: Colors.red,
                                                    width: 2,
                                                  ),
                                                ),
                                            focusedErrorBorder:
                                                const OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                        Radius.circular(12),
                                                      ),
                                                  borderSide: BorderSide(
                                                    color: Colors.red,
                                                    width: 2,
                                                  ),
                                                ),
                                            hintText: 'Numéro de téléphone',
                                            errorText: _phoneError,
                                            counterText:
                                                '', // Masquer le compteur par défaut
                                          ),
                                          keyboardType: TextInputType.phone,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              _phoneError =
                                                  _validatePhoneNumber(value);
                                            });
                                          },
                                          validator: _validatePhoneNumber,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 24),

                              // Submit button
                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: _isLoading
                                      ? null
                                      : _submitPhoneNumber,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF065b32),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                          ),
                                        )
                                      : const Text(
                                          'Continuer',
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

                      const SizedBox(
                        height: 40,
                      ), // Espacement au lieu de Spacer
                      // Footer
                      Text(
                        'En continuant, vous acceptez nos conditions d\'utilisation',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20), // Espacement en bas
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
