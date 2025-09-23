import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_screen.dart';

class WelcomeScreenLovable extends StatefulWidget {
  final String firstName;
  final String lastName;

  const WelcomeScreenLovable({
    super.key,
    required this.firstName,
    required this.lastName,
  });

  @override
  State<WelcomeScreenLovable> createState() => _WelcomeScreenLovableState();
}

class _WelcomeScreenLovableState extends State<WelcomeScreenLovable>
    with TickerProviderStateMixin {
  bool _showContent = false;
  bool _showLoadingCircle = false;

  late AnimationController _scaleController;
  late AnimationController _bounceController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();

    // Animation controllers
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Animations
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutCubic,
    );
    _bounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _bounceController,
        curve:
            Curves.easeOut, // EXACT like Lovable - success-bounce 0.8s ease-out
      ),
    );

    // Start animations
    _startAnimations();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  void _startAnimations() async {
    // Show content after 500ms (like Lovable)
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _showContent = true;
      _showLoadingCircle = true; // Show loading circle immediately
    });

    _scaleController.forward();
    _bounceController.forward();

    // Wait 10 seconds then redirect
    await Future.delayed(const Duration(seconds: 10));
    _completeWelcome();
  }

  void _completeWelcome() {
    // Navigate to home screen
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeScreen(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF065b32), Color(0xFF0a7a42)],
          ),
        ),
        child: Stack(
          children: [
            // Animated background elements (like Lovable)
            ...List.generate(6, (index) {
              return Positioned(
                left: (index * 150.0) % MediaQuery.of(context).size.width,
                top: (index * 200.0) % MediaQuery.of(context).size.height,
                child: AnimatedOpacity(
                  opacity: _showContent ? 0.2 : 0.0,
                  duration: Duration(milliseconds: 1000 + (index * 500)),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            }),

            // Main content
            Center(
              child: AnimatedOpacity(
                opacity: _showContent ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 1000),
                child: Transform.translate(
                  offset: _showContent ? Offset.zero : const Offset(0, 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Welcome icon (EXACT like Lovable - success-bounce 0.8s ease-out)
                      AnimatedBuilder(
                        animation: _bounceAnimation,
                        builder: (context, child) {
                          double bounceValue = 0.0;
                          if (_bounceAnimation.value <= 0.2) {
                            bounceValue = 0.0;
                          } else if (_bounceAnimation.value <= 0.4) {
                            bounceValue =
                                -30.0 * ((_bounceAnimation.value - 0.2) / 0.2);
                          } else if (_bounceAnimation.value <= 0.7) {
                            bounceValue =
                                -30.0 +
                                (15.0 * ((_bounceAnimation.value - 0.4) / 0.3));
                          } else if (_bounceAnimation.value <= 0.9) {
                            bounceValue =
                                -15.0 +
                                (11.0 * ((_bounceAnimation.value - 0.7) / 0.2));
                          } else {
                            bounceValue =
                                -4.0 * ((_bounceAnimation.value - 0.9) / 0.1);
                          }

                          return Transform.translate(
                            offset: Offset(0, bounceValue),
                            child: Container(
                              width: 96,
                              height: 96,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
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
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF065b32),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 32),

                      // Welcome message (like Lovable)
                      Column(
                        children: [
                          const Text(
                            'Bienvenue !',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${widget.firstName} ${widget.lastName}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Description (like Lovable)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          children: [
                            Text(
                              'Nous sommes ravis de vous accueillir dans l\'univers FIBAYA',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white.withOpacity(0.9),
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Vous pouvez maintenant profiter de tous nos services.',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.75),
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 48),

                      // Decorative elements (like Lovable)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return AnimatedContainer(
                            duration: Duration(
                              milliseconds: 500 + (index * 100),
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.6),
                              shape: BoxShape.circle,
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 48),

                      // Loading circle (like splash screen)
                      if (_showLoadingCircle)
                        Column(
                          children: [
                            const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                              strokeWidth: 3,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Chargement...',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.8),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                      const SizedBox(height: 48),

                      // Bottom text (like Lovable)
                      Text(
                        'FIBAYA • Votre partenaire de confiance',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
