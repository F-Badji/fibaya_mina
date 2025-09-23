import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

class NotificationsDetailScreen extends StatefulWidget {
  const NotificationsDetailScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsDetailScreen> createState() =>
      _NotificationsDetailScreenState();
}

class _NotificationsDetailScreenState extends State<NotificationsDetailScreen> {
  // États des switches pour la section "À propos de la charge de la batterie"
  bool _lowBatteryCharge = true;

  // États des switches pour la section "Services"
  bool _promotions = true;
  bool _newFeatures = true;
  bool _recommendedServices = true;
  bool _partnerPrograms = true;

  // États des switches pour la section "Promotions et actualités d'autres services"
  bool _otherServices = true;
  bool _card = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section "À propos de la charge de la batterie"
            _buildSectionTitle('À propos de la charge de la batterie'),
            const SizedBox(height: 8),
            _buildSectionCard(
              children: [
                _buildNotificationRow(
                  title: 'Charge de la batterie faible',
                  value: _lowBatteryCharge,
                  onChanged: (value) {
                    setState(() {
                      _lowBatteryCharge = value;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Section "Services"
            _buildSectionTitle('Services'),
            const SizedBox(height: 8),
            _buildSectionCard(
              children: [
                _buildNotificationRow(
                  title: 'Promotions',
                  value: _promotions,
                  onChanged: (value) {
                    setState(() {
                      _promotions = value;
                    });
                  },
                ),
                _buildNotificationRow(
                  title: 'Nouvelles fonctionnalités',
                  value: _newFeatures,
                  onChanged: (value) {
                    setState(() {
                      _newFeatures = value;
                    });
                  },
                ),
                _buildNotificationRow(
                  title: 'Services recommandés',
                  value: _recommendedServices,
                  onChanged: (value) {
                    setState(() {
                      _recommendedServices = value;
                    });
                  },
                ),
                _buildNotificationRow(
                  title: 'Programmes partenaires',
                  value: _partnerPrograms,
                  onChanged: (value) {
                    setState(() {
                      _partnerPrograms = value;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Section "Promotions et actualités d'autres services"
            _buildSectionTitle('Promotions et actualités d\'autres services'),
            const SizedBox(height: 8),
            _buildSectionCard(
              children: [
                _buildNotificationRow(
                  title: 'Autres services',
                  value: _otherServices,
                  onChanged: (value) {
                    setState(() {
                      _otherServices = value;
                    });
                  },
                ),
                _buildNotificationRow(
                  title: 'Carte',
                  value: _card,
                  onChanged: (value) {
                    setState(() {
                      _card = value;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey[600],
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildSectionCard({required List<Widget> children}) {
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
      child: Column(children: children),
    );
  }

  Widget _buildNotificationRow({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.primaryGreen,
          ),
        ],
      ),
    );
  }
}






