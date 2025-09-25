import 'package:flutter/material.dart';
import 'client_app/screens/home_screen.dart';
import 'prestataire_app/screens/prestataire_registration_screen_api.dart';
import 'prestataire_app/screens/confirmation_screen.dart';
import 'common/theme.dart';

void main() {
  runApp(const FibayaMinaApp());
}

class FibayaMinaApp extends StatelessWidget {
  const FibayaMinaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fibaya Mina',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: AppTheme.primaryGreen,
        scaffoldBackgroundColor: AppTheme.backgroundWhite,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppTheme.primaryGreen,
          foregroundColor: AppTheme.textWhite,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: AppTheme.primaryButtonStyle,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      routes: {
        '/prestataire-registration': (context) =>
            const PrestataireRegistrationScreenAPI(),
        '/confirmation': (context) => const ConfirmationScreen(),
      },
    );
  }
}
