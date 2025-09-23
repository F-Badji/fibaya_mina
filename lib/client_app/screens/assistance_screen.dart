import 'package:flutter/material.dart';

// Couleur personnalisée Fibaya
const Color fibayaGreen = Color(0xFF065b32);

class AssistanceScreen extends StatefulWidget {
  const AssistanceScreen({Key? key}) : super(key: key);

  @override
  State<AssistanceScreen> createState() => _AssistanceScreenState();
}

class _AssistanceScreenState extends State<AssistanceScreen> {
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
          'Assistance',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Carte d'introduction
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Icône d'assistance dans un cercle vert
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: fibayaGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Icon(
                      Icons.headset_mic,
                      color: fibayaGreen,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Titre
                  const Text(
                    'Centre d\'Assistance FIBAYA',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),

                  // Texte descriptif
                  Text(
                    'Nous sommes là pour vous aider 24h/24, 7j/7',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Options d'assistance
            _buildAssistanceOption(
              icon: Icons.chat,
              title: 'Chat vers WhatsApp',
              subtitle: 'Discutez avec notre équipe de support',
              onTap: () => _showComingSoonDialog('Chat vers WhatsApp'),
              imagePath: 'assets/images/WhatsApp.png',
            ),

            const SizedBox(height: 12),

            _buildAssistanceOption(
              icon: Icons.phone,
              title: 'Appel téléphonique',
              subtitle: 'Appelez-nous directement',
              onTap: () => _showComingSoonDialog('Appel téléphonique'),
              imagePath: 'assets/images/telephone_noir.png',
            ),

            const SizedBox(height: 12),

            _buildAssistanceOption(
              icon: Icons.email,
              title: 'Email de support',
              subtitle: 'Envoyez-nous un email détaillé',
              onTap: () => _showComingSoonDialog('Email de support'),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildAssistanceOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    String? imagePath,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: fibayaGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: imagePath != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.asset(
                        imagePath,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(icon, color: fibayaGreen, size: 24);
                        },
                      ),
                    )
                  : Icon(icon, color: fibayaGreen, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
          ],
        ),
      ),
    );
  }

  void _showComingSoonDialog(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text('$feature - Bientôt disponible'),
        content: Text(
          'Cette fonctionnalité sera bientôt disponible. En attendant, vous pouvez nous contacter via les autres moyens d\'assistance.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
