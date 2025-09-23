import 'package:flutter/material.dart';

class ManageDevicesScreen extends StatelessWidget {
  const ManageDevicesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Fond gris clair
      appBar: AppBar(
        title: const Text(
          'Gérer les appareils',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Section Appareil actuel
              const Text(
                'Appareil actuel',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),

              // Carte appareil actuel
              _buildDeviceCard(
                deviceName: 'iPhone 11 Pro',
                appName: 'Application Fibaya',
                connectionMethod: 'Méthode de connexion inconnue',
                date: '7 sept. 2025 17:19',
                isCurrentDevice: true,
              ),

              const SizedBox(height: 24),

              // Section Autres appareils
              Row(
                children: [
                  Expanded(
                    child: const Text(
                      'Autres appareils sur lesquels tu t\'es connecté(e)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.info_outline,
                      size: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Liste des autres appareils
              _buildDeviceCard(
                deviceName: 'Huawei STK-LX1',
                appName: 'Application Fibaya',
                connectionMethod: 'Connecté par code de vérification',
                date: '7 Sept. 2025 04:07',
                isCurrentDevice: false,
              ),

              const SizedBox(height: 12),

              _buildDeviceCard(
                deviceName: 'iPhone 11 Pro',
                appName: 'Application Fibaya',
                connectionMethod: 'Méthode de connexion inconnue',
                date: '4 Sept. 2025 13:02',
                isCurrentDevice: false,
              ),

              const SizedBox(height: 12),

              _buildDeviceCard(
                deviceName: 'iPhone 11 Pro',
                appName: 'Application Fibaya',
                connectionMethod: 'Méthode de connexion inconnue',
                date: '28 Juil. 2025 12:43',
                isCurrentDevice: false,
              ),

              const SizedBox(height: 12),

              _buildDeviceCard(
                deviceName: 'iPhone 11 Pro',
                appName: 'Application Fibaya',
                connectionMethod: 'Méthode de connexion inconnue',
                date: '10 Juil. 2025 09:15',
                isCurrentDevice: false,
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeviceCard({
    required String deviceName,
    required String appName,
    required String connectionMethod,
    required String date,
    required bool isCurrentDevice,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icône téléphone
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.phone_android,
              color: Colors.grey,
              size: 24,
            ),
          ),

          const SizedBox(width: 16),

          // Informations de l'appareil
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deviceName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  appName,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 2),
                Text(
                  connectionMethod,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 2),
                Text(
                  date,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          // Icône de suppression (seulement pour les autres appareils)
          if (!isCurrentDevice) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                // Action de suppression
              },
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Icon(
                  Icons.delete_outline,
                  color: Colors.red[400],
                  size: 18,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}



