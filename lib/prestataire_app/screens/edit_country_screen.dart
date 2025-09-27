import 'package:flutter/material.dart';
import '../../common/services/phone_country_service.dart';

// Couleur personnalisée Fibaya
const Color fibayaGreen = Color(0xFF065b32);

class EditCountryScreen extends StatefulWidget {
  const EditCountryScreen({Key? key}) : super(key: key);

  @override
  State<EditCountryScreen> createState() => _EditCountryScreenState();
}

class _EditCountryScreenState extends State<EditCountryScreen> {
  String _selectedCountry = 'Sénégal';

  final List<String> _countries = [
    'Sénégal',
    'Mali',
    'Burkina Faso',
    'Côte d\'Ivoire',
    'Guinée',
    'Niger',
    'Tchad',
    'Cameroun',
    'Gabon',
    'Congo',
    'République Démocratique du Congo',
    'Rwanda',
    'Burundi',
    'Tanzanie',
    'Kenya',
    'Ouganda',
    'Éthiopie',
    'Ghana',
    'Nigeria',
    'Bénin',
    'Togo',
    'Maroc',
    'Tunisie',
    'Algérie',
    'Égypte',
    'France',
    'Belgique',
    'Suisse',
    'Canada',
    'États-Unis',
  ];

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
          'Modifier le pays',
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
          children: [
            // Bloc d'information principal
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
                  // Icône de pays dans un carré vert
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: fibayaGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.public, color: fibayaGreen, size: 40),
                  ),
                  const SizedBox(height: 20),

                  // Titre
                  const Text(
                    'Modifier votre pays du compte',
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
                    'Le pays de votre compte détermine les services disponibles et les options de paiement',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Section de sélection du pays
            Container(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre
                  const Text(
                    'Sélectionner un pays',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Liste des pays
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      children: _countries.map((country) {
                        bool isSelected = country == _selectedCountry;
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedCountry = country;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? fibayaGreen.withOpacity(0.1)
                                  : Colors.transparent,
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey[200]!,
                                  width: 0.5,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.flag,
                                  color: isSelected
                                      ? fibayaGreen
                                      : Colors.grey[400],
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    country,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: isSelected
                                          ? fibayaGreen
                                          : Colors.black,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  Icon(
                                    Icons.check_circle,
                                    color: fibayaGreen,
                                    size: 20,
                                  ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Message d'information
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info, color: Colors.blue[600], size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Initialement, le pays de votre compte est défini selon la date et le lieu d\'inscription.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0, -1),
                blurRadius: 4,
              ),
            ],
          ),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => _saveCountry(),
              style: ElevatedButton.styleFrom(
                backgroundColor: fibayaGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Sauvegarder',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _saveCountry() {
    final countryCode = PhoneCountryService.getCountryCode(_selectedCountry);
    final phoneFormat = PhoneCountryService.getPhoneFormat(_selectedCountry);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Succès'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Votre pays du compte a été modifié en $_selectedCountry'),
            const SizedBox(height: 12),
            if (countryCode != null && phoneFormat != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Format téléphone pour $_selectedCountry:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Code: $countryCode',
                      style: TextStyle(color: Colors.blue[700]),
                    ),
                    Text(
                      'Longueur: ${phoneFormat.totalDigits} chiffres',
                      style: TextStyle(color: Colors.blue[700]),
                    ),
                    Text(
                      'Exemple: ${phoneFormat.example}',
                      style: TextStyle(color: Colors.blue[700]),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Fermer le dialog
              Navigator.pop(context); // Retourner à l'écran précédent
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
