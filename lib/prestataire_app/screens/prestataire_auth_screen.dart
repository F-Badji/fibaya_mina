import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../common/utils/phone_validation.dart';
import 'prestataire_sms_verification_screen.dart';

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

  // Liste des pays avec drapeaux et codes (tous les pays de la base de données)
  final List<Map<String, String>> _countries = [
    // Afrique
    {'name': 'Sénégal', 'code': '+221', 'flag': '🇸🇳'},
    {'name': 'Mali', 'code': '+223', 'flag': '🇲🇱'},
    {'name': 'Burkina Faso', 'code': '+226', 'flag': '🇧🇫'},
    {'name': 'Côte d\'Ivoire', 'code': '+225', 'flag': '🇨🇮'},
    {'name': 'Guinée', 'code': '+224', 'flag': '🇬🇳'},
    {'name': 'Gambie', 'code': '+220', 'flag': '🇬🇲'},
    {'name': 'Guinée-Bissau', 'code': '+245', 'flag': '🇬🇼'},
    {'name': 'Cap-Vert', 'code': '+238', 'flag': '🇨🇻'},
    {'name': 'Mauritanie', 'code': '+222', 'flag': '🇲🇷'},
    {'name': 'Niger', 'code': '+227', 'flag': '🇳🇪'},
    {'name': 'Tchad', 'code': '+235', 'flag': '🇹🇩'},
    {'name': 'Cameroun', 'code': '+237', 'flag': '🇨🇲'},
    {'name': 'Gabon', 'code': '+241', 'flag': '🇬🇦'},
    {'name': 'Congo', 'code': '+242', 'flag': '🇨🇬'},
    {'name': 'République démocratique du Congo', 'code': '+243', 'flag': '🇨🇩'},
    {'name': 'Centrafrique', 'code': '+236', 'flag': '🇨🇫'},
    {'name': 'Togo', 'code': '+228', 'flag': '🇹🇬'},
    {'name': 'Bénin', 'code': '+229', 'flag': '🇧🇯'},
    {'name': 'Nigeria', 'code': '+234', 'flag': '🇳🇬'},
    {'name': 'Ghana', 'code': '+233', 'flag': '🇬🇭'},
    {'name': 'Liberia', 'code': '+231', 'flag': '🇱🇷'},
    {'name': 'Sierra Leone', 'code': '+232', 'flag': '🇸🇱'},
    {'name': 'Maroc', 'code': '+212', 'flag': '🇲🇦'},
    {'name': 'Algérie', 'code': '+213', 'flag': '🇩🇿'},
    {'name': 'Tunisie', 'code': '+216', 'flag': '🇹🇳'},
    {'name': 'Égypte', 'code': '+20', 'flag': '🇪🇬'},
    {'name': 'Afrique du Sud', 'code': '+27', 'flag': '🇿🇦'},
    {'name': 'Kenya', 'code': '+254', 'flag': '🇰🇪'},
    {'name': 'Éthiopie', 'code': '+251', 'flag': '🇪🇹'},
    {'name': 'Ouganda', 'code': '+256', 'flag': '🇺🇬'},
    {'name': 'Tanzanie', 'code': '+255', 'flag': '🇹🇿'},
    {'name': 'Rwanda', 'code': '+250', 'flag': '🇷🇼'},
    {'name': 'Burundi', 'code': '+257', 'flag': '🇧🇮'},
    {'name': 'Madagascar', 'code': '+261', 'flag': '🇲🇬'},
    {'name': 'Maurice', 'code': '+230', 'flag': '🇲🇺'},
    {'name': 'Seychelles', 'code': '+248', 'flag': '🇸🇨'},
    {'name': 'Comores', 'code': '+269', 'flag': '🇰🇲'},
    {'name': 'Djibouti', 'code': '+253', 'flag': '🇩🇯'},
    {'name': 'Somalie', 'code': '+252', 'flag': '🇸🇴'},
    {'name': 'Soudan', 'code': '+249', 'flag': '🇸🇩'},
    {'name': 'Soudan du Sud', 'code': '+211', 'flag': '🇸🇸'},
    {'name': 'Érythrée', 'code': '+291', 'flag': '🇪🇷'},
    {'name': 'Zimbabwe', 'code': '+263', 'flag': '🇿🇼'},
    {'name': 'Zambie', 'code': '+260', 'flag': '🇿🇲'},
    {'name': 'Botswana', 'code': '+267', 'flag': '🇧🇼'},
    {'name': 'Namibie', 'code': '+264', 'flag': '🇳🇦'},
    {'name': 'Angola', 'code': '+244', 'flag': '🇦🇴'},
    {'name': 'Mozambique', 'code': '+258', 'flag': '🇲🇿'},
    {'name': 'Malawi', 'code': '+265', 'flag': '🇲🇼'},
    {'name': 'Lesotho', 'code': '+266', 'flag': '🇱🇸'},
    {'name': 'Eswatini', 'code': '+268', 'flag': '🇸🇿'},
    {'name': 'São Tomé-et-Príncipe', 'code': '+239', 'flag': '🇸🇹'},
    {'name': 'Guinée équatoriale', 'code': '+240', 'flag': '🇬🇶'},
    
    // Europe
    {'name': 'France', 'code': '+33', 'flag': '🇫🇷'},
    {'name': 'Belgique', 'code': '+32', 'flag': '🇧🇪'},
    {'name': 'Suisse', 'code': '+41', 'flag': '🇨🇭'},
    {'name': 'Pays-Bas', 'code': '+31', 'flag': '🇳🇱'},
    {'name': 'Suède', 'code': '+46', 'flag': '🇸🇪'},
    {'name': 'Norvège', 'code': '+47', 'flag': '🇳🇴'},
    {'name': 'Danemark', 'code': '+45', 'flag': '🇩🇰'},
    {'name': 'Finlande', 'code': '+358', 'flag': '🇫🇮'},
    {'name': 'Pologne', 'code': '+48', 'flag': '🇵🇱'},
    {'name': 'République tchèque', 'code': '+420', 'flag': '🇨🇿'},
    {'name': 'Hongrie', 'code': '+36', 'flag': '🇭🇺'},
    {'name': 'Roumanie', 'code': '+40', 'flag': '🇷🇴'},
    {'name': 'Bulgarie', 'code': '+359', 'flag': '🇧🇬'},
    {'name': 'Grèce', 'code': '+30', 'flag': '🇬🇷'},
    {'name': 'Portugal', 'code': '+351', 'flag': '🇵🇹'},
    {'name': 'Espagne', 'code': '+34', 'flag': '🇪🇸'},
    {'name': 'Italie', 'code': '+39', 'flag': '🇮🇹'},
    {'name': 'Royaume-Uni', 'code': '+44', 'flag': '🇬🇧'},
    {'name': 'Allemagne', 'code': '+49', 'flag': '🇩🇪'},
    {'name': 'Autriche', 'code': '+43', 'flag': '🇦🇹'},
    {'name': 'Turquie', 'code': '+90', 'flag': '🇹🇷'},
    {'name': 'Russie', 'code': '+7', 'flag': '🇷🇺'},
    {'name': 'Ukraine', 'code': '+380', 'flag': '🇺🇦'},
    {'name': 'Albanie', 'code': '+355', 'flag': '🇦🇱'},
    {'name': 'Andorre', 'code': '+376', 'flag': '🇦🇩'},
    
    // Amérique du Nord
    {'name': 'États-Unis', 'code': '+1', 'flag': '🇺🇸'},
    {'name': 'Canada', 'code': '+1', 'flag': '🇨🇦'},
    
    // Amérique du Sud
    {'name': 'Brésil', 'code': '+55', 'flag': '🇧🇷'},
    {'name': 'Argentine', 'code': '+54', 'flag': '🇦🇷'},
    
    // Asie
    {'name': 'Chine', 'code': '+86', 'flag': '🇨🇳'},
    {'name': 'Japon', 'code': '+81', 'flag': '🇯🇵'},
    {'name': 'Inde', 'code': '+91', 'flag': '🇮🇳'},
    {'name': 'Corée du Sud', 'code': '+82', 'flag': '🇰🇷'},
    {'name': 'Corée du Nord', 'code': '+850', 'flag': '🇰🇵'},
    {'name': 'Mongolie', 'code': '+976', 'flag': '🇲🇳'},
    {'name': 'Kazakhstan', 'code': '+7', 'flag': '🇰🇿'},
    {'name': 'Ouzbékistan', 'code': '+998', 'flag': '🇺🇿'},
    {'name': 'Kirghizistan', 'code': '+996', 'flag': '🇰🇬'},
    {'name': 'Tadjikistan', 'code': '+992', 'flag': '🇹🇯'},
    {'name': 'Turkménistan', 'code': '+993', 'flag': '🇹🇲'},
    {'name': 'Afghanistan', 'code': '+93', 'flag': '🇦🇫'},
    {'name': 'Pakistan', 'code': '+92', 'flag': '🇵🇰'},
    {'name': 'Bangladesh', 'code': '+880', 'flag': '🇧🇩'},
    {'name': 'Sri Lanka', 'code': '+94', 'flag': '🇱🇰'},
    {'name': 'Népal', 'code': '+977', 'flag': '🇳🇵'},
    {'name': 'Bhoutan', 'code': '+975', 'flag': '🇧🇹'},
    {'name': 'Maldives', 'code': '+960', 'flag': '🇲🇻'},
    {'name': 'Thaïlande', 'code': '+66', 'flag': '🇹🇭'},
    {'name': 'Vietnam', 'code': '+84', 'flag': '🇻🇳'},
    {'name': 'Cambodge', 'code': '+855', 'flag': '🇰🇭'},
    {'name': 'Laos', 'code': '+856', 'flag': '🇱🇦'},
    {'name': 'Myanmar', 'code': '+95', 'flag': '🇲🇲'},
    {'name': 'Malaisie', 'code': '+60', 'flag': '🇲🇾'},
    {'name': 'Singapour', 'code': '+65', 'flag': '🇸🇬'},
    {'name': 'Indonésie', 'code': '+62', 'flag': '🇮🇩'},
    {'name': 'Philippines', 'code': '+63', 'flag': '🇵🇭'},
    
    // Moyen-Orient
    {'name': 'Arabie saoudite', 'code': '+966', 'flag': '🇸🇦'},
    {'name': 'Émirats arabes unis', 'code': '+971', 'flag': '🇦🇪'},
    {'name': 'Qatar', 'code': '+974', 'flag': '🇶🇦'},
    {'name': 'Koweït', 'code': '+965', 'flag': '🇰🇼'},
    {'name': 'Bahreïn', 'code': '+973', 'flag': '🇧🇭'},
    {'name': 'Oman', 'code': '+968', 'flag': '🇴🇲'},
    {'name': 'Jordanie', 'code': '+962', 'flag': '🇯🇴'},
    {'name': 'Liban', 'code': '+961', 'flag': '🇱🇧'},
    {'name': 'Irak', 'code': '+964', 'flag': '🇮🇶'},
    {'name': 'Iran', 'code': '+98', 'flag': '🇮🇷'},
    {'name': 'Israël', 'code': '+972', 'flag': '🇮🇱'},
    
    // Océanie
    {'name': 'Australie', 'code': '+61', 'flag': '🇦🇺'},
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

  Future<void> _submitPhoneNumber() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 1500));

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Navigate to SMS verification
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
                                  flex: 1,
                                  child: DropdownButtonFormField<String>(
                                    value: _selectedCountryCode,
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
                                      return _countries.map<Widget>((country) {
                                        return Text(
                                          '${country['flag']} ${country['code']}',
                                          style: const TextStyle(fontSize: 14),
                                          overflow: TextOverflow.ellipsis,
                                        );
                                      }).toList();
                                    },
                                    // Affichage dans le menu ouvert : Drapeau + Nom
                                    items: _countries.map((country) {
                                      return DropdownMenuItem(
                                        value: country['code'],
                                        child: Text(
                                          '${country['flag']} ${country['name']}',
                                          style: const TextStyle(fontSize: 16),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedCountryCode = value ?? '+221';
                                        // Revalider le numéro de téléphone quand le pays change
                                        if (_phoneController.text.isNotEmpty) {
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
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(12),
                                                ),
                                                borderSide: BorderSide(
                                                  color: Color(0xFF065b32),
                                                  width: 2,
                                                ),
                                              ),
                                          errorBorder: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(12),
                                            ),
                                            borderSide: BorderSide(
                                              color: Colors.red,
                                              width: 2,
                                            ),
                                          ),
                                          focusedErrorBorder:
                                              const OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
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
                                            _phoneError = _validatePhoneNumber(
                                              value,
                                            );
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

                    const Spacer(),

                    // Footer
                    Text(
                      'En continuant, vous acceptez nos conditions d\'utilisation',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
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
