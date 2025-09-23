import 'package:flutter/material.dart';
import 'common/theme.dart';

void main() {
  runApp(const FibayaAdminApp());
}

class FibayaAdminApp extends StatelessWidget {
  const FibayaAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fibaya - Administration',
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
      home: const AdminHomeScreen(),
    );
  }
}

// Écran temporaire pour l'app admin (à développer plus tard)
class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fibaya - Administration')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.admin_panel_settings,
              size: 100,
              color: AppTheme.primaryGreen,
            ),
            SizedBox(height: 20),
            Text(
              'Interface d\'Administration',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryGreen,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'À développer prochainement',
              style: TextStyle(fontSize: 16, color: AppTheme.textSecondary),
            ),
            SizedBox(height: 20),
            Text(
              'Version Web Flutter',
              style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

