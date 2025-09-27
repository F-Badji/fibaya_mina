import 'package:flutter/material.dart';
import '../../common/services/phone_country_service.dart';

// Couleur personnalisée Fibaya
const Color fibayaGreen = Color(0xFF065b32);

class EditPhoneScreen extends StatefulWidget {
  const EditPhoneScreen({Key? key}) : super(key: key);

  @override
  State<EditPhoneScreen> createState() => _EditPhoneScreenState();
}

class _EditPhoneScreenState extends State<EditPhoneScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _verificationCodeController =
      TextEditingController();
  bool _showVerificationCode = false;
  String _selectedCountry = 'Sénégal';
  String _selectedCountryCode = '+221';
  String? _phoneError;

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
  void initState() {
    super.initState();
    _updatePhoneField();
  }

  void _updatePhoneField() {
    final countryCode = PhoneCountryService.getCountryCode(_selectedCountry);
    if (countryCode != null) {
      _selectedCountryCode = countryCode;
      _phoneController.text = '$countryCode ';
      _phoneError = null;
    }
  }

  void _onCountryChanged(String country) {
    setState(() {
      _selectedCountry = country;
      _updatePhoneField();
    });
  }

  void _validatePhone() {
    final phoneNumber = _phoneController.text.trim();
    if (phoneNumber.isEmpty) {
      setState(() {
        _phoneError = 'Veuillez entrer un numéro de téléphone';
      });
      return;
    }

    final isValid = PhoneCountryService.validatePhoneNumber(
      phoneNumber,
      _selectedCountry,
    );
    setState(() {
      _phoneError = isValid
          ? null
          : PhoneCountryService.getPhoneHelpMessage(_selectedCountry);
    });
  }

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
          'Modifier le numéro',
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
                  // Icône de téléphone dans un carré vert
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: fibayaGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.phone_android,
                      color: fibayaGreen,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Titre
                  const Text(
                    'Modifier votre numéro de téléphone',
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
                    'Assurez-vous que votre nouveau numéro est correct pour recevoir les notifications importantes',
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
                    'Sélectionner le pays',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Dropdown pour la sélection du pays
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: _selectedCountry,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        prefixIcon: Icon(Icons.flag, color: fibayaGreen),
                      ),
                      items: _countries.map((country) {
                        return DropdownMenuItem(
                          value: country,
                          child: Text(country),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          _onCountryChanged(value);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Section de saisie du nouveau numéro
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
                    'Nouveau numéro de téléphone',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Champ de saisie avec indicatif automatique
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _phoneError != null
                            ? Colors.red
                            : Colors.grey[300]!,
                      ),
                    ),
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                      onChanged: (value) => _validatePhone(),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.phone,
                          color: fibayaGreen,
                          size: 20,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        hintText: PhoneCountryService.getPhonePlaceholder(
                          _selectedCountry,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),

                  // Message d'erreur ou d'aide
                  if (_phoneError != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red[600],
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _phoneError!,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.red[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    const SizedBox(height: 12),
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
                              'Un code de vérification sera envoyé sur votre nouveau numéro',
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
                ],
              ),
            ),

            // Formulaire de code de vérification (affiché conditionnellement)
            if (_showVerificationCode) ...[
              const SizedBox(height: 20),
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
                      'Code de vérification',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Champ de saisie du code
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: TextField(
                        controller: _verificationCodeController,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          letterSpacing: 2,
                        ),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.security,
                            color: fibayaGreen,
                            size: 20,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          counterText: '',
                          hintText: 'Entrez le code à 6 chiffres',
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Message d'information
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.timer,
                            color: Colors.orange[600],
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Le code expire dans 5 minutes',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.orange[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

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
              onPressed: () => _savePhoneNumber(),
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

  void _savePhoneNumber() {
    if (!_showVerificationCode) {
      // Valider le numéro de téléphone avant d'envoyer le code
      _validatePhone();

      if (_phoneError != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_phoneError!), backgroundColor: Colors.red),
        );
        return;
      }

      // Première étape : envoyer le code de vérification
      setState(() {
        _showVerificationCode = true;
      });

      // Simuler l'envoi du code
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Code de vérification envoyé sur $_selectedCountryCode ${_phoneController.text.substring(_selectedCountryCode.length).trim()}',
          ),
          backgroundColor: fibayaGreen,
        ),
      );
    } else {
      // Deuxième étape : vérifier le code et sauvegarder
      if (_verificationCodeController.text.length == 6) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: const Text('Succès'),
            content: Text(
              'Votre numéro de téléphone $_selectedCountryCode ${_phoneController.text.substring(_selectedCountryCode.length).trim()} a été modifié avec succès',
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
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez entrer un code de vérification valide'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _verificationCodeController.dispose();
    super.dispose();
  }
}
