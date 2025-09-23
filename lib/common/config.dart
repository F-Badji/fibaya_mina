/// Configuration pour basculer entre le mode développement et production
class AppConfig {
  /// MODE DÉVELOPPEMENT : true = aller directement à HomeScreen
  /// MODE PRODUCTION : false = suivre le flow complet (Splash -> Auth -> etc.)
  static const bool isDevelopmentMode = true;

  /// Pour basculer facilement :
  /// - Développement : isDevelopmentMode = true
  /// - Production : isDevelopmentMode = false
}
