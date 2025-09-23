import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_theme.dart';
import 'our_services_screen.dart';
import 'report_problem_screen.dart';
import 'accessibility_screen.dart';
import 'about_fibaya_screen.dart';
import 'account_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Paramètres Apparence
  bool _themeMode = false;

  // Paramètres Notifications
  bool _allNotifications = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _pushNotifications = true;

  // État de la section À propos
  bool _showAllAboutItems = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _themeMode = prefs.getBool('theme_mode') ?? false;
      _allNotifications = prefs.getBool('all_notifications') ?? true;
      _emailNotifications = prefs.getBool('email_notifications') ?? true;
      _smsNotifications = prefs.getBool('sms_notifications') ?? false;
      _pushNotifications = prefs.getBool('push_notifications') ?? true;
    });
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header avec dégradé vert-blanc
            Container(
              padding: const EdgeInsets.only(
                top: 50,
                left: 20,
                right: 20,
                bottom: 20,
              ),
              // Header transparent
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Titre Paramètres
                  const Text(
                    'Paramètres',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryGreen,
                    ),
                  ),
                ],
              ),
            ),

            // Contenu principal
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // Carte de Contact (comme dans l'image)
                    _buildContactCard(),

                    const SizedBox(height: 16),

                    // Section Apparence
                    _buildSectionCard(
                      title: 'Apparence',
                      subtitle: 'Ajustez l\'affichage de l\'application.',
                      children: [
                        _buildSettingRow(
                          icon: Icons.light_mode,
                          title: 'Mode Thème',
                          trailing: Switch(
                            value: _themeMode,
                            onChanged: (value) {
                              setState(() {
                                _themeMode = value;
                              });
                              _saveSetting('theme_mode', value);
                            },
                            activeColor: AppTheme.primaryGreen,
                          ),
                        ),
                        _buildSettingRow(
                          icon: Icons.language,
                          title: 'Langue de l\'application',
                          subtitle: 'Français (par défaut)',
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey,
                          ),
                          onTap: () {
                            _showLanguageDialog();
                          },
                        ),
                        _buildSettingRow(
                          icon: Icons.accessibility,
                          title: 'Accessibilité',
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey,
                          ),
                          onTap: () {
                            _showAccessibilityDialog();
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Section À propos
                    _buildAboutSection(),

                    const SizedBox(height: 16),

                    // Section Notifications
                    _buildSectionCard(
                      title: 'Notifications',
                      subtitle: 'Gérez vos alertes et rappels.',
                      children: [
                        _buildSettingRow(
                          icon: Icons.notifications,
                          title: 'Activer toutes les notifications',
                          trailing: Switch(
                            value: _allNotifications,
                            onChanged: (value) {
                              setState(() {
                                _allNotifications = value;
                              });
                              _saveSetting('all_notifications', value);
                            },
                            activeColor: AppTheme.primaryGreen,
                          ),
                        ),
                        _buildSettingRow(
                          icon: Icons.email,
                          title: 'Notifications par e-mail',
                          trailing: Switch(
                            value: _emailNotifications,
                            onChanged: (value) {
                              setState(() {
                                _emailNotifications = value;
                              });
                              _saveSetting('email_notifications', value);
                            },
                            activeColor: AppTheme.primaryGreen,
                          ),
                        ),
                        _buildSettingRow(
                          icon: Icons.sms,
                          title: 'Notifications par SMS',
                          trailing: Switch(
                            value: _smsNotifications,
                            onChanged: (value) {
                              setState(() {
                                _smsNotifications = value;
                              });
                              _saveSetting('sms_notifications', value);
                            },
                            activeColor: AppTheme.primaryGreen,
                          ),
                        ),
                        _buildSettingRow(
                          icon: Icons.push_pin,
                          title: 'Notifications push',
                          trailing: Switch(
                            value: _pushNotifications,
                            onChanged: (value) {
                              setState(() {
                                _pushNotifications = value;
                              });
                              _saveSetting('push_notifications', value);
                            },
                            activeColor: AppTheme.primaryGreen,
                          ),
                        ),
                        _buildSettingRow(
                          icon: Icons.keyboard_arrow_down,
                          title: 'Voir plus',
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey,
                          ),
                          onTap: () {
                            _showMoreNotificationsDialog();
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Section Compte
                    _buildSectionCard(
                      title: 'Compte',
                      subtitle: 'Gestion de votre compte.',
                      children: [
                        _buildSettingRow(
                          icon: Icons.person,
                          title: 'Compte',
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey,
                          ),
                          onTap: () {
                            _showAccountDialog();
                          },
                        ),
                        _buildSettingRow(
                          icon: Icons.lock,
                          title: 'Confidentialité',
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey,
                          ),
                          onTap: () {
                            _showPrivacyDialog();
                          },
                        ),
                        _buildSettingRow(
                          icon: Icons.security,
                          title: 'Sécurité et autorisations',
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey,
                          ),
                          onTap: () {
                            _showSecurityDialog();
                          },
                        ),
                        _buildSettingRow(
                          icon: Icons.share,
                          title: 'Invitez vos amis à utiliser Fibaya',
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey,
                          ),
                          onTap: () {
                            _showInviteFriendsDialog();
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Section Assistance et Informations
                    _buildSectionCard(
                      title: 'Assistance et Informations',
                      subtitle: 'Aide et informations sur l\'application.',
                      children: [
                        _buildSettingRow(
                          icon: Icons.flag,
                          title: 'Signaler un problème',
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey,
                          ),
                          onTap: () {
                            _showReportProblemDialog();
                          },
                        ),
                        _buildSettingRow(
                          icon: Icons.help_outline,
                          title: 'Assistance',
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey,
                          ),
                          onTap: () {
                            _showAssistanceDialog();
                          },
                        ),
                        _buildSettingRow(
                          icon: Icons.info_outline,
                          title: 'Conditions et politiques',
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey,
                          ),
                          onTap: () {
                            _showTermsAndPoliciesDialog();
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: CustomBottomNavigationBar(
      //   currentIndex: _currentBottomNavIndex,
      //   onTap: (index) {
      //     setState(() {
      //       _currentBottomNavIndex = index;
      //     });
      //     _navigateToScreen(index);
      //   },
      // ),
    );
  }

  Widget _buildContactCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar avec bouton d'ajout
          Stack(
            children: [
              // Cercle principal de l'avatar
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person, size: 40, color: Colors.grey[600]),
              ),
              // Bouton d'ajout (cercle vert avec +)
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => _showAddPhotoModal(),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 16),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Nom du contact
          const Text(
            'Fatima Diallo',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 8),

          // Numéro de téléphone (avec astérisques)
          Text(
            '+221 ** ** ** 00',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre de la section
          const Text(
            'À propos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 12),

          // Grille des éléments À propos
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio:
                3.0, // Grilles ajustées pour éviter le débordement
            children: [
              _buildAboutCard(
                imagePath: 'assets/images/fibaya_logo.png',
                title: 'Fibaya',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutFibayaScreen(),
                  ),
                ),
              ),
              _buildAboutCard(
                imagePath: 'assets/images/Nos_services.jpeg',
                title: 'Nos services',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OurServicesScreen(),
                  ),
                ),
              ),
              if (_showAllAboutItems) ...[
                _buildAboutCard(
                  imagePath: 'assets/images/Engagement.jpeg',
                  title: 'Engagement',
                  onTap: () => _showAboutDialog('Engagement'),
                ),
                _buildAboutCard(
                  imagePath: 'assets/images/Nos_clients.png',
                  title: 'Nos clients',
                  onTap: () => _showAboutDialog('Nos clients'),
                ),
                _buildAboutCard(
                  imagePath: 'assets/images/Partenaires.jpeg',
                  title: 'Nos partenaires',
                  onTap: () => _showAboutDialog('Partenaires'),
                ),
                _buildAboutCard(
                  imagePath: 'assets/images/FAQ.jpeg',
                  title: 'FAQ',
                  onTap: () => _showAboutDialog('FAQ'),
                ),
              ],
            ],
          ),

          const SizedBox(height: 12),

          // Bouton "Voir plus/moins"
          Center(
            child: Container(
              width: 120,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _showAllAboutItems = !_showAllAboutItems;
                  });
                },
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  _showAllAboutItems ? 'Voir moins' : 'Voir plus',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutCard({
    required String imagePath,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            const BoxShadow(
              color: Color(0x0D000000),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image de l'élément
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey[50],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.image, color: Colors.grey[400], size: 15);
                  },
                ),
              ),
            ),

            const SizedBox(height: 4),

            // Titre de l'élément
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String subtitle,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSettingRow({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey[600], size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  void _showAccountDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AccountScreen()),
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Confidentialité'),
        content: const Text(
          'Fonctionnalité à implémenter : politique de confidentialité',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showSecurityDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Sécurité et autorisations'),
        content: const Text(
          'Fonctionnalité à implémenter : sécurité et autorisations',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showInviteFriendsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Inviter des amis'),
        content: const Text(
          'Fonctionnalité à implémenter : invitation d\'amis à utiliser Fibaya',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showReportProblemDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ReportProblemScreen()),
    );
  }

  void _showAssistanceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Barre de glissement
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // En-tête
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Contactez le service client',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            // Options de contact
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // Option WhatsApp
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      // Ouvrir WhatsApp
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[200]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          // Icône WhatsApp
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xFF25D366),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: Image.asset(
                                'assets/images/WhatsApp.png',
                                width: 50,
                                height: 50,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.chat,
                                    color: Colors.white,
                                    size: 24,
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'WhatsApp',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Messages et notes vocales uniquement',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Option Appel gratuit
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      // Faire un appel
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[200]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          // Icône Appel
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: const Icon(
                              Icons.phone,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Text(
                              'Appel gratuit',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Information d'horaire
            Center(
              child: Text(
                'Ouvert jusqu\'à 23h',
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showTermsAndPoliciesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Conditions et politiques'),
        content: const Text(
          'Fonctionnalité à implémenter : conditions et politiques',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    String selectedLanguage = 'Français';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Choisir la langue',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Français (par défaut)
              _buildLanguageOption(
                'Français (par défaut)',
                'Français',
                selectedLanguage,
                true,
                () => setState(() => selectedLanguage = 'Français'),
              ),
              const SizedBox(height: 12),

              // English
              _buildLanguageOption(
                'English',
                'English',
                selectedLanguage,
                false,
                () => setState(() => selectedLanguage = 'English'),
              ),
              const SizedBox(height: 12),

              // العربية (Arabe)
              _buildLanguageOption(
                'العربية',
                'العربية',
                selectedLanguage,
                false,
                () => setState(() => selectedLanguage = 'العربية'),
              ),
              const SizedBox(height: 12),

              // Wolof
              _buildLanguageOption(
                'Wolof',
                'Wolof',
                selectedLanguage,
                false,
                () => setState(() => selectedLanguage = 'Wolof'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Annuler',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Langue changée vers $selectedLanguage'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text(
                'Confirmer',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
    String title,
    String value,
    String selectedLanguage,
    bool isDefault,
    VoidCallback onTap,
  ) {
    bool isSelected = selectedLanguage == value;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green[50] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.language,
              color: isSelected ? Colors.green[600] : Colors.grey[600],
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: isSelected ? Colors.green[700] : Colors.black,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: Colors.green[600], size: 20),
          ],
        ),
      ),
    );
  }

  void _showAccessibilityDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AccessibilityScreen()),
    );
  }

  void _showAboutDialog(String item) {
    String content = '';
    switch (item) {
      case 'Fibaya':
        content =
            'Découvrez l\'histoire et la mission de Fibaya, la plateforme panafricaine de services de proximité.';
        break;
      case 'Nos services':
        content =
            'Explorez tous les services disponibles sur la plateforme Fibaya.';
        break;
      case 'Engagement':
        content =
            'Découvrez notre engagement envers nos utilisateurs et la communauté.';
        break;
      case 'Nos clients':
        content = 'Rencontrez nos clients et leurs témoignages.';
        break;
      case 'Partenaires':
        content =
            'Découvrez nos partenaires qui nous accompagnent dans notre mission.';
        break;
      case 'FAQ':
        content =
            'Consultez les questions fréquemment posées et leurs réponses.';
        break;
      default:
        content = 'Informations sur $item';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(item),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showMoreNotificationsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Plus de notifications'),
        content: const Text(
          'Fonctionnalité à implémenter : paramètres avancés de notifications',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  void _showAddPhotoModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Poignée (trait horizontal gris)
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),

              // Titre
              const Text(
                'Ajouter une photo de profil',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),

              // Option 1: Prendre une photo
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  _takePhoto();
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Row(
                    children: [
                      // Icône appareil photo
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Texte
                      const Text(
                        'Prendre une photo',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Option 2: Choisir depuis la galerie
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  _chooseFromGallery();
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Row(
                    children: [
                      // Icône galerie
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.photo_library,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Texte
                      const Text(
                        'Choisir depuis la galerie',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _takePhoto() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fonctionnalité à implémenter : Prendre une photo'),
      ),
    );
  }

  void _chooseFromGallery() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Fonctionnalité à implémenter : Choisir depuis la galerie',
        ),
      ),
    );
  }
}
