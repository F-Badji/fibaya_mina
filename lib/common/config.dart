/// Configuration pour basculer entre le mode développement et production
class AppConfig {
  /// MODE DÉVELOPPEMENT : true = aller directement à HomeScreen
  /// MODE PRODUCTION : false = suivre le flow complet (Splash -> Auth -> etc.)
  static const bool isDevelopmentMode = true;

  /// URL de base de l'API backend
  /// Pour l'émulateur Android, utilisez l'adresse IP réelle du Mac
  static const String baseApiUrl = 'http://192.168.1.42:8081/api';

  /// Pour basculer facilement :
  /// - Développement : isDevelopmentMode = true
  /// - Production : isDevelopmentMode = false
}
