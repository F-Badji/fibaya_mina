import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _flipController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;

  late Animation<double> _flipAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  bool _showSecondPhase = false;
  bool _showLoadingCircle = false;

  @override
  void initState() {
    super.initState();

    // Contrôleur pour l'animation de flip
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 4000), // Ralenti - 4s
      vsync: this,
    );

    // Contrôleur pour l'animation de fade
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Contrôleur pour l'animation de scale
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Animations
    _flipAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _scaleAnimation = Tween<double>(
      begin: 0.98,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _scaleController, curve: Curves.easeOut));

    // Démarrer les animations
    _startAnimations();
  }

  void _startAnimations() async {
    // Phase 1: Start with green background for 2 seconds (ralenti)
    await Future.delayed(const Duration(seconds: 2));

    // Phase 2: Trigger flip animation (ralenti)
    _flipController.forward(); // Start flip animation immediately
    await Future.delayed(const Duration(seconds: 2));

    // Phase 3: Flash effect (ralenti)
    setState(() {
      _showSecondPhase = true;
    });
    _triggerPageFlipFlash();
    await Future.delayed(const Duration(milliseconds: 1500));

    // Phase 4: Loading circle for 5 seconds
    setState(() {
      _showLoadingCircle = true;
    });
    await Future.delayed(const Duration(seconds: 5));

    // Phase 5: Complete the splash screen
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/welcome');
    }
  }

  void _triggerPageFlipFlash() {
    // Effet haptique subtil et raffiné
    HapticFeedback.lightImpact();

    // Flash effect overlay (EXACT like Lovable)
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (context) {
        return AnimatedBuilder(
          animation: _fadeController,
          builder: (context, child) {
            return Container(
              child: Stack(
                children: [
                  // Flash effect overlay (EXACT like Lovable - flash-effect)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.white.withOpacity(0.1),
                            Colors.white.withOpacity(0.8),
                            Colors.white.withOpacity(0.1),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
                        ),
                      ),
                    ),
                  ),

                  // Camera flash circle (EXACT like Lovable - w-32 h-32 = 128x128px)
                  Center(
                    child: AnimatedBuilder(
                      animation: _fadeController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _fadeController.value < 0.5
                              ? 0.8 +
                                    (_fadeController.value * 0.8) // 0.8 to 1.6
                              : 1.6 -
                                    ((_fadeController.value - 0.5) *
                                        1.2), // 1.6 to 0.4
                          child: Opacity(
                            opacity: _fadeController.value < 0.5
                                ? _fadeController.value *
                                      2 // 0 to 1
                                : 2 - (_fadeController.value * 2), // 1 to 0
                            child: Container(
                              width: 128, // w-32
                              height: 128, // h-32
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(
                                  0.8,
                                ), // opacity-80
                                shape: BoxShape.circle, // rounded-full
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    // Fermer l'effet flash après 500ms (EXACT like Lovable - camera-flash 0.5s)
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _flipController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _flipAnimation,
          _fadeAnimation,
          _scaleAnimation,
        ]),
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              color: _showSecondPhase ? Colors.white : const Color(0xFF065b32),
            ),
            child: Center(
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(_flipAnimation.value * 3.14159),
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Opacity(
                    opacity: 1.0,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: _showSecondPhase
                            ? Colors
                                  .white // bg-background (EXACT like Lovable)
                            : const Color(
                                0xFF065b32,
                              ), // bg-primary (EXACT like Lovable)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Logo FIBAYA (like Lovable)
                          Container(
                            width: 96,
                            height: 96,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFF065b32), Color(0xFF0a7a42)],
                              ),
                              borderRadius: BorderRadius.circular(24),
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
                            child: Center(
                              child: Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()
                                  ..setEntry(3, 2, 0.001)
                                  ..rotateY(
                                    -_flipAnimation.value * 3.14159,
                                  ), // Inverse pour corriger le renversement
                                child: Text(
                                  'F',
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Titre FIBAYA (EXACT like Lovable - flip-animation)
                          Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001)
                              ..rotateY(
                                _flipAnimation.value * 3.14159,
                              ), // EXACT like Lovable
                            child: Text(
                              'FIBAYA',
                              style: TextStyle(
                                fontSize: 48, // text-5xl
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                                color: _showSecondPhase
                                    ? const Color(
                                        0xFF065b32,
                                      ) // text-primary (EXACT like Lovable)
                                    : Colors
                                          .white, // text-white (EXACT like Lovable)
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Loading dots ou cercle de chargement
                          if (_showLoadingCircle)
                            // Cercle de chargement de 5 secondes
                            Column(
                              children: [
                                SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      const Color(0xFF065b32),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.identity()
                                    ..setEntry(3, 2, 0.001)
                                    ..rotateY(
                                      -_flipAnimation.value * 3.14159,
                                    ), // Inverse pour corriger le renversement
                                  child: Text(
                                    'Chargement...',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: const Color(0xFF065b32),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          else
                            // Loading dots (EXACT like Lovable - w-2 h-2 = 8x8px)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for (int i = 0; i < 3; i++)
                                  Container(
                                    width: 8,
                                    height: 8,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _showSecondPhase
                                          ? const Color(0xFF065b32).withOpacity(
                                              0.6,
                                            ) // bg-primary/60
                                          : Colors.white.withOpacity(
                                              0.6,
                                            ), // bg-white/60
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
