import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'prestataire_registration_screen_api.dart';

class PrestataireSmsVerificationScreen extends StatefulWidget {
  final String phone;
  final String countryCode;

  const PrestataireSmsVerificationScreen({
    super.key,
    required this.phone,
    required this.countryCode,
  });

  @override
  State<PrestataireSmsVerificationScreen> createState() => _PrestataireSmsVerificationScreenState();
}

class _PrestataireSmsVerificationScreenState extends State<PrestataireSmsVerificationScreen>
    with TickerProviderStateMixin {
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  bool _isLoading = false;
  bool _showContent = false;
  int _countdown = 60;
  bool _canResend = false;

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

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
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));

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

    // Start countdown
    _startCountdown();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _startCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _countdown--;
          if (_countdown > 0) {
            _startCountdown();
          } else {
            _canResend = true;
          }
        });
      }
    });
  }

  void _onDigitChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
        _verifyCode();
      }
    }
  }


  Future<void> _verifyCode() async {
    final code = _controllers.map((controller) => controller.text).join();
    
    if (code.length != 6) {
      _showErrorSnackBar('Veuillez entrer le code complet');
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

        // Navigate to Prestataire Registration screen
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const PrestataireRegistrationScreenAPI(),
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
        
        _showErrorSnackBar('Code de vérification invalide');
      }
    }
  }

  Future<void> _resendCode() async {
    if (!_canResend) return;

    setState(() {
      _canResend = false;
      _countdown = 60;
    });

    _startCountdown();

    // Simulate resend API call
    await Future.delayed(const Duration(milliseconds: 1000));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Code de vérification renvoyé'),
          backgroundColor: Color(0xFF065b32),
        ),
      );
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF065b32),
          ),
        ),
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  
                  // Logo header
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
                                    color: const Color(0xFF065b32).withOpacity(0.15),
                                    blurRadius: 20,
                                    spreadRadius: 0,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.sms,
                                  size: 28,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Vérification SMS',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF065b32),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Card
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
                          // Header
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
                                SizedBox(height: 8),
                                Text(
                                  'Entrez le code à 6 chiffres envoyé sur votre numéro',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Phone number display
                          Center(
                            child: Text(
                              '${widget.countryCode} ${widget.phone}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF065b32),
                              ),
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Code input fields
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(6, (index) {
                              return SizedBox(
                                width: 45,
                                height: 55,
                                child: TextFormField(
                                  controller: _controllers[index],
                                  focusNode: _focusNodes[index],
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  maxLength: 1,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  decoration: InputDecoration(
                                    counterText: '',
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
                                  ),
                                  onChanged: (value) => _onDigitChanged(value, index),
                                  onTap: () {
                                    if (_controllers[index].text.isNotEmpty) {
                                      _controllers[index].selection = TextSelection.fromPosition(
                                        TextPosition(offset: _controllers[index].text.length),
                                      );
                                    }
                                  },
                                ),
                              );
                            }),
                          ),

                          const SizedBox(height: 24),

                          // Verify button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
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
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                    )
                                  : const Text(
                                      'Vérifier',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Resend code
                          Center(
                            child: _canResend
                                ? TextButton(
                                    onPressed: _resendCode,
                                    child: const Text(
                                      'Renvoyer le code',
                                      style: TextStyle(
                                        color: Color(0xFF065b32),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  )
                                : Text(
                                    'Renvoyer le code dans ${_countdown}s',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
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
                    'Vous n\'avez pas reçu le code ? Vérifiez vos messages SMS',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
