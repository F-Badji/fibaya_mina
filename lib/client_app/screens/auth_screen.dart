import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'sms_verification_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String _selectedCountryCode = '+221';
  bool _isLoading = false;

  // Liste des pays avec leurs codes et drapeaux
  final List<Map<String, String>> _countries = [
    {'code': '+221', 'country': 'SN', 'name': 'Sénégal', 'flag': '🇸🇳'},
    {'code': '+33', 'country': 'FR', 'name': 'France', 'flag': '🇫🇷'},
    {'code': '+1', 'country': 'US', 'name': 'États-Unis', 'flag': '🇺🇸'},
    {'code': '+44', 'country': 'GB', 'name': 'Royaume-Uni', 'flag': '🇬🇧'},
    {'code': '+49', 'country': 'DE', 'name': 'Allemagne', 'flag': '🇩🇪'},
    {'code': '+39', 'country': 'IT', 'name': 'Italie', 'flag': '🇮🇹'},
    {'code': '+34', 'country': 'ES', 'name': 'Espagne', 'flag': '🇪🇸'},
    {'code': '+212', 'country': 'MA', 'name': 'Maroc', 'flag': '🇲🇦'},
    {'code': '+213', 'country': 'DZ', 'name': 'Algérie', 'flag': '🇩🇿'},
    {'code': '+216', 'country': 'TN', 'name': 'Tunisie', 'flag': '🇹🇳'},
    {'code': '+225', 'country': 'CI', 'name': 'Côte d\'Ivoire', 'flag': '🇨🇮'},
    {'code': '+226', 'country': 'BF', 'name': 'Burkina Faso', 'flag': '🇧🇫'},
    {'code': '+227', 'country': 'NE', 'name': 'Niger', 'flag': '🇳🇪'},
    {'code': '+228', 'country': 'TG', 'name': 'Togo', 'flag': '🇹🇬'},
    {'code': '+229', 'country': 'BJ', 'name': 'Bénin', 'flag': '🇧🇯'},
    {'code': '+230', 'country': 'MU', 'name': 'Maurice', 'flag': '🇲🇺'},
    {'code': '+231', 'country': 'LR', 'name': 'Libéria', 'flag': '🇱🇷'},
    {'code': '+232', 'country': 'SL', 'name': 'Sierra Leone', 'flag': '🇸🇱'},
    {'code': '+233', 'country': 'GH', 'name': 'Ghana', 'flag': '🇬🇭'},
    {'code': '+234', 'country': 'NG', 'name': 'Nigeria', 'flag': '🇳🇬'},
    {'code': '+235', 'country': 'TD', 'name': 'Tchad', 'flag': '🇹🇩'},
    {
      'code': '+236',
      'country': 'CF',
      'name': 'République centrafricaine',
      'flag': '🇨🇫',
    },
    {'code': '+237', 'country': 'CM', 'name': 'Cameroun', 'flag': '🇨🇲'},
    {'code': '+238', 'country': 'CV', 'name': 'Cap-Vert', 'flag': '🇨🇻'},
    {
      'code': '+239',
      'country': 'ST',
      'name': 'São Tomé-et-Príncipe',
      'flag': '🇸🇹',
    },
    {
      'code': '+240',
      'country': 'GQ',
      'name': 'Guinée équatoriale',
      'flag': '🇬🇶',
    },
    {'code': '+241', 'country': 'GA', 'name': 'Gabon', 'flag': '🇬🇦'},
    {
      'code': '+242',
      'country': 'CG',
      'name': 'République du Congo',
      'flag': '🇨🇬',
    },
    {
      'code': '+243',
      'country': 'CD',
      'name': 'République démocratique du Congo',
      'flag': '🇨🇩',
    },
    {'code': '+244', 'country': 'AO', 'name': 'Angola', 'flag': '🇦🇴'},
    {'code': '+245', 'country': 'GW', 'name': 'Guinée-Bissau', 'flag': '🇬🇼'},
    {
      'code': '+246',
      'country': 'IO',
      'name': 'Territoire britannique de l\'océan Indien',
      'flag': '🇮🇴',
    },
    {'code': '+248', 'country': 'SC', 'name': 'Seychelles', 'flag': '🇸🇨'},
    {'code': '+249', 'country': 'SD', 'name': 'Soudan', 'flag': '🇸🇩'},
    {'code': '+250', 'country': 'RW', 'name': 'Rwanda', 'flag': '🇷🇼'},
    {'code': '+251', 'country': 'ET', 'name': 'Éthiopie', 'flag': '🇪🇹'},
    {'code': '+252', 'country': 'SO', 'name': 'Somalie', 'flag': '🇸🇴'},
    {'code': '+253', 'country': 'DJ', 'name': 'Djibouti', 'flag': '🇩🇯'},
    {'code': '+254', 'country': 'KE', 'name': 'Kenya', 'flag': '🇰🇪'},
    {'code': '+255', 'country': 'TZ', 'name': 'Tanzanie', 'flag': '🇹🇿'},
    {'code': '+256', 'country': 'UG', 'name': 'Ouganda', 'flag': '🇺🇬'},
    {'code': '+257', 'country': 'BI', 'name': 'Burundi', 'flag': '🇧🇮'},
    {'code': '+258', 'country': 'MZ', 'name': 'Mozambique', 'flag': '🇲🇿'},
    {'code': '+260', 'country': 'ZM', 'name': 'Zambie', 'flag': '🇿🇲'},
    {'code': '+261', 'country': 'MG', 'name': 'Madagascar', 'flag': '🇲🇬'},
    {'code': '+262', 'country': 'RE', 'name': 'La Réunion', 'flag': '🇷🇪'},
    {'code': '+263', 'country': 'ZW', 'name': 'Zimbabwe', 'flag': '🇿🇼'},
    {'code': '+264', 'country': 'NA', 'name': 'Namibie', 'flag': '🇳🇦'},
    {'code': '+265', 'country': 'MW', 'name': 'Malawi', 'flag': '🇲🇼'},
    {'code': '+266', 'country': 'LS', 'name': 'Lesotho', 'flag': '🇱🇸'},
    {'code': '+267', 'country': 'BW', 'name': 'Botswana', 'flag': '🇧🇼'},
    {'code': '+268', 'country': 'SZ', 'name': 'Eswatini', 'flag': '🇸🇿'},
    {'code': '+269', 'country': 'KM', 'name': 'Comores', 'flag': '🇰🇲'},
    {'code': '+290', 'country': 'SH', 'name': 'Sainte-Hélène', 'flag': '🇸🇭'},
    {'code': '+291', 'country': 'ER', 'name': 'Érythrée', 'flag': '🇪🇷'},
    {'code': '+297', 'country': 'AW', 'name': 'Aruba', 'flag': '🇦🇼'},
    {'code': '+298', 'country': 'FO', 'name': 'Îles Féroé', 'flag': '🇫🇴'},
    {'code': '+299', 'country': 'GL', 'name': 'Groenland', 'flag': '🇬🇱'},
  ];

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
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
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Sélectionner un pays',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF065b32),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _countries.length,
                itemBuilder: (context, index) {
                  final country = _countries[index];
                  final isSelected = country['code'] == _selectedCountryCode;

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
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected
                            ? const Color(0xFF065b32)
                            : Colors.grey[600],
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedCountryCode = country['code']!;
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendVerificationCode() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    // Simulation d'envoi de SMS
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      // Animation de succès ultra-professionnelle
      _showPremiumSuccess();

      // Attendre puis naviguer avec style premium
      await Future.delayed(const Duration(milliseconds: 1200));

      if (mounted) {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                SmsVerificationScreen(
                  phoneNumber: '$_selectedCountryCode ${_phoneController.text}',
                  countryCode: _selectedCountryCode,
                ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOutCubic,
                    ),
                    child: SlideTransition(
                      position:
                          Tween<Offset>(
                            begin: const Offset(1.0, 0.0),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutQuart,
                            ),
                          ),
                      child: ScaleTransition(
                        scale: Tween<double>(begin: 0.98, end: 1.0).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                          ),
                        ),
                        child: child,
                      ),
                    ),
                  );
                },
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      }
    }
  }

  void _showPremiumSuccess() {
    // Effet haptique professionnel
    HapticFeedback.mediumImpact();

    // Animation de succès ultra-professionnelle
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (context) {
        return AnimatedBuilder(
          animation: _fadeController,
          builder: (context, child) {
            return Container(
              color: Colors.transparent,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 30,
                        spreadRadius: 0,
                        offset: const Offset(0, 15),
                      ),
                      BoxShadow(
                        color: const Color(0xFF065b32).withOpacity(0.1),
                        blurRadius: 20,
                        spreadRadius: 0,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFF065b32),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF065b32).withOpacity(0.3),
                              blurRadius: 15,
                              spreadRadius: 0,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'SMS envoyé !',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF065b32),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Vérifiez votre téléphone',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    // Fermer l'animation après 1 seconde
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),

                    // Logo et titre
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: const Color(0xFF065b32),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF065b32,
                                  ).withOpacity(0.3),
                                  spreadRadius: 5,
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.location_on,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Bienvenue sur FIBAYA',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Entrez votre numéro de téléphone pour continuer',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 60),

                    // Formulaire de numéro de téléphone
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Numéro de téléphone',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              // Sélecteur de pays
                              GestureDetector(
                                onTap: _showCountryPicker,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
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
                                              c['code'] == _selectedCountryCode,
                                        )['flag']!,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        _selectedCountryCode,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF065b32),
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
                              // Champ de numéro
                              Expanded(
                                child: TextFormField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
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
                                    fillColor: Colors.white,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Veuillez entrer votre numéro';
                                    }
                                    if (value.length < 8) {
                                      return 'Numéro trop court';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 80),

                    // Bouton de validation
                    Container(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _sendVerificationCode,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF065b32),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                'Continuer',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),

                    const Spacer(),

                    // Conditions d'utilisation
                    Text(
                      'En continuant, vous acceptez nos conditions d\'utilisation',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 16),

                    // Support
                    Center(
                      child: TextButton(
                        onPressed: () {
                          // Action pour contacter le support
                        },
                        child: const Text(
                          'Besoin d\'aide ? Contactez le support',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF065b32),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
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
