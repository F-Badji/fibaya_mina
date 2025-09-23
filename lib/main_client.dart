import 'package:flutter/material.dart';
import 'client_app/screens/splash_screen.dart';
import 'client_app/screens/home_screen.dart';
import 'common/theme.dart';
import 'common/config.dart';

void main() {
  runApp(const FibayaClientApp());
}

class FibayaClientApp extends StatelessWidget {
  const FibayaClientApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fibaya - Client',
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
      home: AppConfig.isDevelopmentMode
          ? const HomeScreen() // MODE DÉVELOPPEMENT - Directement à l'accueil
          : const SplashScreen(), // MODE PRODUCTION - Flow complet
    );
  }
}
