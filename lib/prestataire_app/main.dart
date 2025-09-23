import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/splash_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/prestataire_registration_screen.dart';
import 'screens/location_permission_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const FibayaPrestataireApp());
}

class FibayaPrestataireApp extends StatelessWidget {
  const FibayaPrestataireApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FIBAYA - Prestataire',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: const Color(0xFF065b32),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF065b32),
          foregroundColor: Colors.white,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF065b32),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/prestataire-registration': (context) =>
            const PrestataireRegistrationScreen(),
        '/location-permission': (context) => const LocationPermissionScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
