import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'personal_info_screen_lovable.dart';
import 'welcome_screen_lovable.dart';
import '../../common/services/api_service.dart';

class SmsVerificationScreenLovable extends StatefulWidget {
  final String phone;
  final String countryCode;

  const SmsVerificationScreenLovable({
    super.key,
    required this.phone,
    required this.countryCode,
  });

  @override
  State<SmsVerificationScreenLovable> createState() =>
      _SmsVerificationScreenLovableState();
}

class _SmsVerificationScreenLovableState
    extends State<SmsVerificationScreenLovable>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  bool _isLoading = false;
  int _timer = 60;
  bool _canResend = false;
  Timer? _timerInstance;

  late AnimationController _fadeController;
  late AnimationController _slideController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

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

    // Start animations
    _fadeController.forward();
    _slideController.forward();

    // Start timer
    _startTimer();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _codeController.dispose();
    _timerInstance?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timerInstance = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timer > 1) {
          _timer--;
        } else {
          _timer = 0;
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  void _resendCode() {
    setState(() {
      _timer = 60;
      _canResend = false;
    });
    _startTimer();
    // Simulate resend logic here
  }

  void _verifyCode() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate verification (like Lovable)
      await Future.delayed(const Duration(milliseconds: 2000));

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Check if user exists in database
        String fullPhone = widget.countryCode + widget.phone;
        print('Phone to check: $fullPhone'); // Debug
        bool userExists = await _checkUserExists(
          widget.phone,
        ); // Passer seulement le numéro sans code pays
        print('User exists: $userExists'); // Debug

        if (userExists) {
          // User exists - get user info and go directly to welcome
          print('User exists, getting info...'); // Debug
          Map<String, String> userInfo = await _getUserInfo(
            widget.phone,
          ); // Passer seulement le numéro sans code pays
          print('User info: $userInfo'); // Debug
          _navigateToWelcome(userInfo['firstName']!, userInfo['lastName']!);
        } else {
          // New user - show success animation then go to personal info
          print('New user, going to personal info...'); // Debug
          _showSuccessAnimation();
        }
      }
    }
  }

  // Check if user exists in database via API
  Future<bool> _checkUserExists(String phone) async {
    try {
      print('Checking phone via API: $phone'); // Debug
      final result = await ApiService.checkUserExists(phone);
      bool exists = result['exists'] ?? false;
      print('Phone exists in database: $exists'); // Debug
      return exists;
    } catch (e) {
      print('Erreur lors de la vérification utilisateur: $e');
      return false;
    }
  }

  // Get user info from database via API
  Future<Map<String, String>> _getUserInfo(String phone) async {
    try {
      print('Getting user info via API: $phone'); // Debug
      final result = await ApiService.getUserInfo(phone);
      if (result != null) {
        return {
          'firstName': result['firstName'] ?? 'Utilisateur',
          'lastName': result['lastName'] ?? 'Inconnu',
        };
      }
      return {'firstName': 'Utilisateur', 'lastName': 'Inconnu'};
    } catch (e) {
      print('Erreur lors de la récupération des infos utilisateur: $e');
      return {'firstName': 'Utilisateur', 'lastName': 'Inconnu'};
    }
  }

  void _navigateToWelcome(String firstName, String lastName) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            WelcomeScreenLovable(firstName: firstName, lastName: lastName),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  void _showSuccessAnimation() {
    // Navigate after animation
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                PersonalInfoScreenLovable(
                  phone: widget.phone,
                  countryCode: widget.countryCode,
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
    });
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
                    const SizedBox(height: 40),

                    // Header (like Lovable) - En haut
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFF065b32), Color(0xFF0a7a42)],
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
                                    'Code de vérification',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Phone number display (like Lovable)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF065b32).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Entrez le code SMS envoyé au numéro:',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '+221${widget.phone}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF065b32),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Code input (like Lovable)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  controller: _codeController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(6),
                                  ],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 8,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: '123456',
                                    hintStyle: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 24,
                                      letterSpacing: 8,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.grey[300]!,
                                        width: 2,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.grey[300]!,
                                        width: 2,
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
                                      return 'Veuillez entrer le code';
                                    }
                                    if (value.length != 6) {
                                      return 'Code invalide';
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 16),

                                // Resend button (like Lovable)
                                Center(
                                  child: _canResend
                                      ? TextButton(
                                          onPressed: _resendCode,
                                          child: const Text(
                                            'Renvoyer le code',
                                            style: TextStyle(
                                              color: Color(0xFF065b32),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        )
                                      : Text(
                                          'Renvoyer dans ${_timer}s',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Submit button (like Lovable)
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _verifyCode,
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
                                            'Vérification...',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      )
                                    : const Text(
                                        'Valider le code',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Back button (like Lovable)
                            SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text(
                                  'Modifier le numéro',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const Spacer(),
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
