import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_theme.dart';
import '../services/api_service.dart';
import '../services/service_service.dart';
import '../../common/widgets/step_progress_indicator.dart';
import '../../common/utils/phone_validation.dart';

class PrestataireRegistrationScreenAPI extends StatefulWidget {
  const PrestataireRegistrationScreenAPI({super.key});

  @override
  State<PrestataireRegistrationScreenAPI> createState() =>
      _PrestataireRegistrationScreenAPIState();
}

class _PrestataireRegistrationScreenAPIState
    extends State<PrestataireRegistrationScreenAPI> {
  int _currentStep = 1;

  // Form data
  String _serviceType = '';
  String _experience = '';
  String _description = '';
  String _firstName = '';
  String _lastName = '';
  String _phone = '';
  String _selectedCountryCode = '+221';
  String _address = '';
  String _city = '';
  String _zipCode = '';
  String _certifications = '';

  // Controllers
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _certificationsController =
      TextEditingController();

  // File uploads - Version Pro
  bool _hasProfilePhoto = false;
  bool _hasIdCardFront = false;
  bool _hasIdCardBack = false;
  bool _hasDiploma = false;
  bool _hasCv = false;

  // Fichiers réels - Version Pro
  PlatformFile? _profilePhotoFile;
  PlatformFile? _idCardFrontFile;
  PlatformFile? _idCardBackFile;
  PlatformFile? _diplomaFile;
  PlatformFile? _cvFile;

  // File uploads - Version Simple
  bool _hasProfilePhotoSimple = false;
  bool _hasIdCardFrontSimple = false;
  bool _hasIdCardBackSimple = false;

  // Fichiers réels - Version Simple
  PlatformFile? _profilePhotoSimpleFile;
  PlatformFile? _idCardFrontSimpleFile;
  PlatformFile? _idCardBackSimpleFile;

  // Document version selection
  String _selectedDocumentVersion = 'Pro';

  // API Data
  List<Country> _countries = [];
  List<Service> _services = [];
  bool _isLoadingServices = false;

  // Validation errors
  String? _phoneError;
  String? _firstNameError;
  String? _lastNameError;
  String? _addressError;
  String? _cityError;
  String? _zipCodeError;
  String? _certificationsError;

  @override
  void initState() {
    super.initState();
    _descriptionController.text = _description;
    _experienceController.text = _experience;
    _firstNameController.text = _firstName;
    _lastNameController.text = _lastName;
    _phoneController.text = _phone;
    _addressController.text = _address;
    _cityController.text = _city;
    _zipCodeController.text = _zipCode;
    _certificationsController.text = _certifications;
    _loadCountries();
    _loadServices();
  }

  // Méthode pour sélectionner un fichier avec choix de source
  Future<void> _pickFile({
    required String documentType,
    required List<String> allowedExtensions,
    required int maxSizeMB,
    required Function(PlatformFile?) onFileSelected,
    required Function(bool) onUploadStatusChanged,
  }) async {
    // Déterminer si le document peut être une image ou un fichier
    bool canBeImage = allowedExtensions.any(
      (ext) => ['jpg', 'jpeg', 'png'].contains(ext),
    );
    bool canBeFile = allowedExtensions.any((ext) => ['pdf'].contains(ext));

    // Si le document peut être les deux, proposer le choix
    if (canBeImage && canBeFile) {
      _showFileSourceDialog(
        documentType: documentType,
        allowedExtensions: allowedExtensions,
        maxSizeMB: maxSizeMB,
        onFileSelected: onFileSelected,
        onUploadStatusChanged: onUploadStatusChanged,
      );
    } else if (canBeImage) {
      // Seulement des images, utiliser la galerie
      await _pickFromGallery(
        documentType: documentType,
        allowedExtensions: allowedExtensions,
        maxSizeMB: maxSizeMB,
        onFileSelected: onFileSelected,
        onUploadStatusChanged: onUploadStatusChanged,
      );
    } else {
      // Seulement des fichiers, utiliser le sélecteur de fichiers
      await _pickFromFiles(
        documentType: documentType,
        allowedExtensions: allowedExtensions,
        maxSizeMB: maxSizeMB,
        onFileSelected: onFileSelected,
        onUploadStatusChanged: onUploadStatusChanged,
      );
    }
  }

  // Afficher une boîte de dialogue pour choisir la source du fichier
  void _showFileSourceDialog({
    required String documentType,
    required List<String> allowedExtensions,
    required int maxSizeMB,
    required Function(PlatformFile?) onFileSelected,
    required Function(bool) onUploadStatusChanged,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sélectionner $documentType'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galerie'),
              onTap: () {
                Navigator.pop(context);
                _pickFromGallery(
                  documentType: documentType,
                  allowedExtensions: allowedExtensions,
                  maxSizeMB: maxSizeMB,
                  onFileSelected: onFileSelected,
                  onUploadStatusChanged: onUploadStatusChanged,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.folder),
              title: const Text('Fichiers'),
              onTap: () {
                Navigator.pop(context);
                _pickFromFiles(
                  documentType: documentType,
                  allowedExtensions: allowedExtensions,
                  maxSizeMB: maxSizeMB,
                  onFileSelected: onFileSelected,
                  onUploadStatusChanged: onUploadStatusChanged,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Sélectionner depuis la galerie
  Future<void> _pickFromGallery({
    required String documentType,
    required List<String> allowedExtensions,
    required int maxSizeMB,
    required Function(PlatformFile?) onFileSelected,
    required Function(bool) onUploadStatusChanged,
  }) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;
        await _validateAndAssignFile(
          file: file,
          documentType: documentType,
          allowedExtensions: allowedExtensions,
          maxSizeMB: maxSizeMB,
          onFileSelected: onFileSelected,
          onUploadStatusChanged: onUploadStatusChanged,
        );
      }
    } catch (e) {
      // Gestion silencieuse de l'erreur "already_active"
      if (e.toString().contains('already_active')) {
        return;
      }
      _showErrorDialog(
        'Erreur de sélection',
        'Une erreur est survenue lors de la sélection depuis la galerie: $e',
      );
    }
  }

  // Sélectionner depuis les fichiers
  Future<void> _pickFromFiles({
    required String documentType,
    required List<String> allowedExtensions,
    required int maxSizeMB,
    required Function(PlatformFile?) onFileSelected,
    required Function(bool) onUploadStatusChanged,
  }) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;
        await _validateAndAssignFile(
          file: file,
          documentType: documentType,
          allowedExtensions: allowedExtensions,
          maxSizeMB: maxSizeMB,
          onFileSelected: onFileSelected,
          onUploadStatusChanged: onUploadStatusChanged,
        );
      }
    } catch (e) {
      // Gestion silencieuse de l'erreur "already_active"
      if (e.toString().contains('already_active')) {
        return;
      }
      _showErrorDialog(
        'Erreur de sélection',
        'Une erreur est survenue lors de la sélection du fichier: $e',
      );
    }
  }

  // Valider et assigner un fichier
  Future<void> _validateAndAssignFile({
    required PlatformFile file,
    required String documentType,
    required List<String> allowedExtensions,
    required int maxSizeMB,
    required Function(PlatformFile?) onFileSelected,
    required Function(bool) onUploadStatusChanged,
  }) async {
    // Vérifier la taille du fichier
    double fileSizeMB = file.size / (1024 * 1024);
    if (fileSizeMB > maxSizeMB) {
      _showErrorDialog(
        'Fichier trop volumineux',
        'Le fichier $documentType ne doit pas dépasser ${maxSizeMB}MB. Taille actuelle: ${fileSizeMB.toStringAsFixed(2)}MB',
      );
      return;
    }

    // Vérifier l'extension
    String? extension = file.extension?.toLowerCase();
    if (extension != null && !allowedExtensions.contains(extension)) {
      _showErrorDialog(
        'Format non supporté',
        'Le fichier $documentType doit être au format: ${allowedExtensions.join(', ')}',
      );
      return;
    }

    // Assigner le fichier
    onFileSelected(file);
    onUploadStatusChanged(true);
  }

  // Afficher une boîte de dialogue d'erreur
  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _experienceController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipCodeController.dispose();
    _certificationsController.dispose();
    super.dispose();
  }

  // Méthode pour synchroniser les contrôleurs avec les variables d'état
  void _syncControllersWithState() {
    _descriptionController.text = _description;
    _experienceController.text = _experience;
    _firstNameController.text = _firstName;
    _lastNameController.text = _lastName;
    _phoneController.text = _phone;
    _addressController.text = _address;
    _cityController.text = _city;
    _zipCodeController.text = _zipCode;
    _certificationsController.text = _certifications;
  }

  // Méthodes de validation
  void _validatePhone(String value) {
    if (value.isEmpty) {
      _phoneError = 'Numéro invalide';
      return;
    }

    // Trouver le pays sélectionné
    String selectedCountryName = '';
    for (Country country in _countries) {
      if (country.code == _selectedCountryCode) {
        selectedCountryName = country.name;
        break;
      }
    }

    if (selectedCountryName.isEmpty) {
      _phoneError = 'Numéro invalide';
      return;
    }

    // Utiliser la validation spécifique par pays
    _phoneError = PhoneValidation.validatePhoneNumber(value, selectedCountryName);
  }

  // Obtenir la longueur attendue du numéro de téléphone
  int _getExpectedPhoneLength() {
    String selectedCountryName = '';
    for (Country country in _countries) {
      if (country.code == _selectedCountryCode) {
        selectedCountryName = country.name;
        break;
      }
    }

    if (selectedCountryName.isEmpty) return 15; // Valeur par défaut

    final format = PhoneValidation.getCountryFormat(selectedCountryName);
    return format?.totalDigits ?? 15;
  }


  void _validateFirstName(String value) {
    if (value.isEmpty) {
      _firstNameError = 'Prénom requis';
    } else if (value.length < 2) {
      _firstNameError = 'Prénom trop court';
    } else {
      _firstNameError = null;
    }
  }

  void _validateLastName(String value) {
    if (value.isEmpty) {
      _lastNameError = 'Nom requis';
    } else if (value.length < 2) {
      _lastNameError = 'Nom trop court';
    } else {
      _lastNameError = null;
    }
  }

  void _validateAddress(String value) {
    if (value.isEmpty) {
      _addressError = 'Adresse requise';
    } else if (value.length < 5) {
      _addressError = 'Adresse trop courte';
    } else {
      _addressError = null;
    }
  }

  void _validateCity(String value) {
    if (value.isEmpty) {
      _cityError = 'Ville requise';
    } else if (value.length < 2) {
      _cityError = 'Ville trop courte';
    } else {
      _cityError = null;
    }
  }

  void _validateZipCode(String value) {
    if (value.isEmpty) {
      _zipCodeError = 'Code postal requis';
    } else if (value.length < 3) {
      _zipCodeError = 'Code postal trop court';
    } else {
      _zipCodeError = null;
    }
  }

  // Charger les pays depuis l'API
  Future<void> _loadCountries() async {
    try {
      print('🌐 Tentative de connexion à l\'API pour charger les pays...');
      final countries = await ApiService.getAllCountries();
      print('✅ ${countries.length} pays chargés depuis l\'API');
      setState(() {
        _countries = countries;
      });
    } catch (e) {
      print('❌ Erreur lors du chargement des pays depuis l\'API: $e');
      print('🔄 Utilisation de la liste de pays par défaut...');
      // Utiliser une liste de pays par défaut si l'API échoue
      setState(() {
        _countries = _getDefaultCountries();
      });
    }
  }

  // Liste de pays par défaut (basée sur la table countries de la DB)
  List<Country> _getDefaultCountries() {
    return [
    Country(id: 1, name: 'Afghanistan', code: '+93', flag: '🇦🇫', continent: 'Asie', isActive: true),
    Country(id: 2, name: 'Afrique du Sud', code: '+27', flag: '🇿🇦', continent: 'Afrique', isActive: true),
    Country(id: 3, name: 'Albanie', code: '+355', flag: '🇦🇱', continent: 'Europe', isActive: true),
    Country(id: 4, name: 'Algérie', code: '+213', flag: '🇩🇿', continent: 'Afrique', isActive: true),
    Country(id: 5, name: 'Allemagne', code: '+49', flag: '🇩🇪', continent: 'Europe', isActive: true),
    Country(id: 6, name: 'Andorre', code: '+376', flag: '🇦🇩', continent: 'Europe', isActive: true),
    Country(id: 7, name: 'Angola', code: '+244', flag: '🇦🇴', continent: 'Afrique', isActive: true),
    Country(id: 8, name: 'Antigua-et-Barbuda', code: '+1268', flag: '🇦🇬', continent: 'Amérique du Nord', isActive: true),
    Country(id: 9, name: 'Arabie saoudite', code: '+966', flag: '🇸🇦', continent: 'Asie', isActive: true),
    Country(id: 10, name: 'Argentine', code: '+54', flag: '🇦🇷', continent: 'Amérique du Sud', isActive: true),
    Country(id: 11, name: 'Arménie', code: '+374', flag: '🇦🇲', continent: 'Europe', isActive: true),
    Country(id: 12, name: 'Australie', code: '+61', flag: '🇦🇺', continent: 'Océanie', isActive: true),
    Country(id: 13, name: 'Autriche', code: '+43', flag: '🇦🇹', continent: 'Europe', isActive: true),
    Country(id: 14, name: 'Azerbaïdjan', code: '+994', flag: '🇦🇿', continent: 'Europe', isActive: true),
    Country(id: 15, name: 'Bahamas', code: '+1242', flag: '🇧🇸', continent: 'Amérique du Nord', isActive: true),
    Country(id: 16, name: 'Bahreïn', code: '+973', flag: '🇧🇭', continent: 'Asie', isActive: true),
    Country(id: 17, name: 'Bangladesh', code: '+880', flag: '🇧🇩', continent: 'Asie', isActive: true),
    Country(id: 18, name: 'Barbade', code: '+1246', flag: '🇧🇧', continent: 'Amérique du Nord', isActive: true),
    Country(id: 19, name: 'Belgique', code: '+32', flag: '🇧🇪', continent: 'Europe', isActive: true),
    Country(id: 20, name: 'Belize', code: '+501', flag: '🇧🇿', continent: 'Amérique du Nord', isActive: true),
    Country(id: 21, name: 'Bénin', code: '+229', flag: '🇧🇯', continent: 'Afrique', isActive: true),
    Country(id: 22, name: 'Bhoutan', code: '+975', flag: '🇧🇹', continent: 'Asie', isActive: true),
    Country(id: 23, name: 'Biélorussie', code: '+375', flag: '🇧🇾', continent: 'Europe', isActive: true),
    Country(id: 24, name: 'Birmanie', code: '+95', flag: '🇲🇲', continent: 'Asie', isActive: true),
    Country(id: 25, name: 'Bolivie', code: '+591', flag: '🇧🇴', continent: 'Amérique du Sud', isActive: true),
    Country(id: 26, name: 'Bosnie-Herzégovine', code: '+387', flag: '🇧🇦', continent: 'Europe', isActive: true),
    Country(id: 27, name: 'Botswana', code: '+267', flag: '🇧🇼', continent: 'Afrique', isActive: true),
    Country(id: 28, name: 'Brésil', code: '+55', flag: '🇧🇷', continent: 'Amérique du Sud', isActive: true),
    Country(id: 29, name: 'Brunei', code: '+673', flag: '🇧🇳', continent: 'Asie', isActive: true),
    Country(id: 30, name: 'Bulgarie', code: '+359', flag: '🇧🇬', continent: 'Europe', isActive: true),
    Country(id: 31, name: 'Burkina Faso', code: '+226', flag: '🇧🇫', continent: 'Afrique', isActive: true),
    Country(id: 32, name: 'Burundi', code: '+257', flag: '🇧🇮', continent: 'Afrique', isActive: true),
    Country(id: 33, name: 'Cambodge', code: '+855', flag: '🇰🇭', continent: 'Asie', isActive: true),
    Country(id: 34, name: 'Cameroun', code: '+237', flag: '🇨🇲', continent: 'Afrique', isActive: true),
    Country(id: 35, name: 'Canada', code: '+1', flag: '🇨🇦', continent: 'Amérique du Nord', isActive: true),
    Country(id: 36, name: 'Cap-Vert', code: '+238', flag: '🇨🇻', continent: 'Afrique', isActive: true),
    Country(id: 37, name: 'Centrafrique', code: '+236', flag: '🇨🇫', continent: 'Afrique', isActive: true),
    Country(id: 38, name: 'Chili', code: '+56', flag: '🇨🇱', continent: 'Amérique du Sud', isActive: true),
    Country(id: 39, name: 'Chine', code: '+86', flag: '🇨🇳', continent: 'Asie', isActive: true),
    Country(id: 40, name: 'Chypre', code: '+357', flag: '🇨🇾', continent: 'Europe', isActive: true),
    Country(id: 41, name: 'Colombie', code: '+57', flag: '🇨🇴', continent: 'Amérique du Sud', isActive: true),
    Country(id: 42, name: 'Comores', code: '+269', flag: '🇰🇲', continent: 'Afrique', isActive: true),
    Country(id: 43, name: 'Congo', code: '+242', flag: '🇨🇬', continent: 'Afrique', isActive: true),
    Country(id: 44, name: 'Corée du Nord', code: '+850', flag: '🇰🇵', continent: 'Asie', isActive: true),
    Country(id: 45, name: 'Corée du Sud', code: '+82', flag: '🇰🇷', continent: 'Asie', isActive: true),
    Country(id: 46, name: 'Costa Rica', code: '+506', flag: '🇨🇷', continent: 'Amérique du Nord', isActive: true),
    Country(id: 47, name: 'Côte d\'Ivoire', code: '+225', flag: '🇨🇮', continent: 'Afrique', isActive: true),
    Country(id: 48, name: 'Croatie', code: '+385', flag: '🇭🇷', continent: 'Europe', isActive: true),
    Country(id: 49, name: 'Cuba', code: '+53', flag: '🇨🇺', continent: 'Amérique du Nord', isActive: true),
    Country(id: 50, name: 'Danemark', code: '+45', flag: '🇩🇰', continent: 'Europe', isActive: true),
    Country(id: 51, name: 'Djibouti', code: '+253', flag: '🇩🇯', continent: 'Afrique', isActive: true),
    Country(id: 52, name: 'Dominique', code: '+1767', flag: '🇩🇲', continent: 'Amérique du Nord', isActive: true),
    Country(id: 53, name: 'Égypte', code: '+20', flag: '🇪🇬', continent: 'Afrique', isActive: true),
    Country(id: 54, name: 'Émirats arabes unis', code: '+971', flag: '🇦🇪', continent: 'Asie', isActive: true),
    Country(id: 55, name: 'Équateur', code: '+593', flag: '🇪🇨', continent: 'Amérique du Sud', isActive: true),
    Country(id: 56, name: 'Érythrée', code: '+291', flag: '🇪🇷', continent: 'Afrique', isActive: true),
    Country(id: 57, name: 'Espagne', code: '+34', flag: '🇪🇸', continent: 'Europe', isActive: true),
    Country(id: 58, name: 'Estonie', code: '+372', flag: '🇪🇪', continent: 'Europe', isActive: true),
    Country(id: 59, name: 'États-Unis', code: '+1', flag: '🇺🇸', continent: 'Amérique du Nord', isActive: true),
    Country(id: 60, name: 'Éthiopie', code: '+251', flag: '🇪🇹', continent: 'Afrique', isActive: true),
    Country(id: 61, name: 'Eswatini', code: '+268', flag: '🇸🇿', continent: 'Afrique', isActive: true),
    Country(id: 62, name: 'Fidji', code: '+679', flag: '🇫🇯', continent: 'Océanie', isActive: true),
    Country(id: 63, name: 'Finlande', code: '+358', flag: '🇫🇮', continent: 'Europe', isActive: true),
    Country(id: 64, name: 'France', code: '+33', flag: '🇫🇷', continent: 'Europe', isActive: true),
    Country(id: 65, name: 'Gabon', code: '+241', flag: '🇬🇦', continent: 'Afrique', isActive: true),
    Country(id: 66, name: 'Gambie', code: '+220', flag: '🇬🇲', continent: 'Afrique', isActive: true),
    Country(id: 67, name: 'Géorgie', code: '+995', flag: '🇬🇪', continent: 'Europe', isActive: true),
    Country(id: 68, name: 'Ghana', code: '+233', flag: '🇬🇭', continent: 'Afrique', isActive: true),
    Country(id: 69, name: 'Grèce', code: '+30', flag: '🇬🇷', continent: 'Europe', isActive: true),
    Country(id: 70, name: 'Grenade', code: '+1473', flag: '🇬🇩', continent: 'Amérique du Nord', isActive: true),
    Country(id: 71, name: 'Guatemala', code: '+502', flag: '🇬🇹', continent: 'Amérique du Nord', isActive: true),
    Country(id: 72, name: 'Guinée', code: '+224', flag: '🇬🇳', continent: 'Afrique', isActive: true),
    Country(id: 73, name: 'Guinée équatoriale', code: '+240', flag: '🇬🇶', continent: 'Afrique', isActive: true),
    Country(id: 74, name: 'Guinée-Bissau', code: '+245', flag: '🇬🇼', continent: 'Afrique', isActive: true),
    Country(id: 75, name: 'Guyane', code: '+594', flag: '🇬🇫', continent: 'Amérique du Sud', isActive: true),
    Country(id: 76, name: 'Haïti', code: '+509', flag: '🇭🇹', continent: 'Amérique du Nord', isActive: true),
    Country(id: 77, name: 'Honduras', code: '+504', flag: '🇭🇳', continent: 'Amérique du Nord', isActive: true),
    Country(id: 78, name: 'Hong Kong', code: '+852', flag: '🇭🇰', continent: 'Asie', isActive: true),
    Country(id: 79, name: 'Hongrie', code: '+36', flag: '🇭🇺', continent: 'Europe', isActive: true),
    Country(id: 80, name: 'Inde', code: '+91', flag: '🇮🇳', continent: 'Asie', isActive: true),
    Country(id: 81, name: 'Indonésie', code: '+62', flag: '🇮🇩', continent: 'Asie', isActive: true),
    Country(id: 82, name: 'Irak', code: '+964', flag: '🇮🇶', continent: 'Asie', isActive: true),
    Country(id: 83, name: 'Iran', code: '+98', flag: '🇮🇷', continent: 'Asie', isActive: true),
    Country(id: 84, name: 'Irlande', code: '+353', flag: '🇮🇪', continent: 'Europe', isActive: true),
    Country(id: 85, name: 'Islande', code: '+354', flag: '🇮🇸', continent: 'Europe', isActive: true),
    Country(id: 86, name: 'Israël', code: '+972', flag: '🇮🇱', continent: 'Asie', isActive: true),
    Country(id: 87, name: 'Italie', code: '+39', flag: '🇮🇹', continent: 'Europe', isActive: true),
    Country(id: 88, name: 'Jamaïque', code: '+1876', flag: '🇯🇲', continent: 'Amérique du Nord', isActive: true),
    Country(id: 89, name: 'Japon', code: '+81', flag: '🇯🇵', continent: 'Asie', isActive: true),
    Country(id: 90, name: 'Jordanie', code: '+962', flag: '🇯🇴', continent: 'Asie', isActive: true),
    Country(id: 91, name: 'Kazakhstan', code: '+7', flag: '🇰🇿', continent: 'Asie', isActive: true),
    Country(id: 92, name: 'Kenya', code: '+254', flag: '🇰🇪', continent: 'Afrique', isActive: true),
    Country(id: 93, name: 'Kirghizistan', code: '+996', flag: '🇰🇬', continent: 'Asie', isActive: true),
    Country(id: 94, name: 'Kiribati', code: '+686', flag: '🇰🇮', continent: 'Océanie', isActive: true),
    Country(id: 95, name: 'Kosovo', code: '+383', flag: '🇽🇰', continent: 'Europe', isActive: true),
    Country(id: 96, name: 'Koweït', code: '+965', flag: '🇰🇼', continent: 'Asie', isActive: true),
    Country(id: 97, name: 'Laos', code: '+856', flag: '🇱🇦', continent: 'Asie', isActive: true),
    Country(id: 98, name: 'Lesotho', code: '+266', flag: '🇱🇸', continent: 'Afrique', isActive: true),
    Country(id: 99, name: 'Lettonie', code: '+371', flag: '🇱🇻', continent: 'Europe', isActive: true),
    Country(id: 100, name: 'Liban', code: '+961', flag: '🇱🇧', continent: 'Asie', isActive: true),
    Country(id: 101, name: 'Liberia', code: '+231', flag: '🇱🇷', continent: 'Afrique', isActive: true),
    Country(id: 102, name: 'Libye', code: '+218', flag: '🇱🇾', continent: 'Afrique', isActive: true),
    Country(id: 103, name: 'Liechtenstein', code: '+423', flag: '🇱🇮', continent: 'Europe', isActive: true),
    Country(id: 104, name: 'Lituanie', code: '+370', flag: '🇱🇹', continent: 'Europe', isActive: true),
    Country(id: 105, name: 'Luxembourg', code: '+352', flag: '🇱🇺', continent: 'Europe', isActive: true),
    Country(id: 106, name: 'Macao', code: '+853', flag: '🇲🇴', continent: 'Asie', isActive: true),
    Country(id: 107, name: 'Macédoine du Nord', code: '+389', flag: '🇲🇰', continent: 'Europe', isActive: true),
    Country(id: 108, name: 'Madagascar', code: '+261', flag: '🇲🇬', continent: 'Afrique', isActive: true),
    Country(id: 109, name: 'Malaisie', code: '+60', flag: '🇲🇾', continent: 'Asie', isActive: true),
    Country(id: 110, name: 'Malawi', code: '+265', flag: '🇲🇼', continent: 'Afrique', isActive: true),
    Country(id: 111, name: 'Maldives', code: '+960', flag: '🇲🇻', continent: 'Asie', isActive: true),
    Country(id: 112, name: 'Mali', code: '+223', flag: '🇲🇱', continent: 'Afrique', isActive: true),
    Country(id: 113, name: 'Malte', code: '+356', flag: '🇲🇹', continent: 'Europe', isActive: true),
    Country(id: 114, name: 'Maroc', code: '+212', flag: '🇲🇦', continent: 'Afrique', isActive: true),
    Country(id: 115, name: 'Marshall', code: '+692', flag: '🇲🇭', continent: 'Océanie', isActive: true),
    Country(id: 116, name: 'Maurice', code: '+230', flag: '🇲🇺', continent: 'Afrique', isActive: true),
    Country(id: 117, name: 'Mauritanie', code: '+222', flag: '🇲🇷', continent: 'Afrique', isActive: true),
    Country(id: 118, name: 'Mexique', code: '+52', flag: '🇲🇽', continent: 'Amérique du Nord', isActive: true),
    Country(id: 119, name: 'Micronésie', code: '+691', flag: '🇫🇲', continent: 'Océanie', isActive: true),
    Country(id: 120, name: 'Moldavie', code: '+373', flag: '🇲🇩', continent: 'Europe', isActive: true),
    Country(id: 121, name: 'Monaco', code: '+377', flag: '🇲🇨', continent: 'Europe', isActive: true),
    Country(id: 122, name: 'Mongolie', code: '+976', flag: '🇲🇳', continent: 'Asie', isActive: true),
    Country(id: 123, name: 'Monténégro', code: '+382', flag: '🇲🇪', continent: 'Europe', isActive: true),
    Country(id: 124, name: 'Mozambique', code: '+258', flag: '🇲🇿', continent: 'Afrique', isActive: true),
    Country(id: 125, name: 'Namibie', code: '+264', flag: '🇳🇦', continent: 'Afrique', isActive: true),
    Country(id: 126, name: 'Nauru', code: '+674', flag: '🇳🇷', continent: 'Océanie', isActive: true),
    Country(id: 127, name: 'Népal', code: '+977', flag: '🇳🇵', continent: 'Asie', isActive: true),
    Country(id: 128, name: 'Nicaragua', code: '+505', flag: '🇳🇮', continent: 'Amérique du Nord', isActive: true),
    Country(id: 129, name: 'Niger', code: '+227', flag: '🇳🇪', continent: 'Afrique', isActive: true),
    Country(id: 130, name: 'Nigeria', code: '+234', flag: '🇳🇬', continent: 'Afrique', isActive: true),
    Country(id: 131, name: 'Norvège', code: '+47', flag: '🇳🇴', continent: 'Europe', isActive: true),
    Country(id: 132, name: 'Nouvelle-Calédonie', code: '+687', flag: '🇳🇨', continent: 'Océanie', isActive: true),
    Country(id: 133, name: 'Nouvelle-Zélande', code: '+64', flag: '🇳🇿', continent: 'Océanie', isActive: true),
    Country(id: 134, name: 'Oman', code: '+968', flag: '🇴🇲', continent: 'Asie', isActive: true),
    Country(id: 135, name: 'Ouganda', code: '+256', flag: '🇺🇬', continent: 'Afrique', isActive: true),
    Country(id: 136, name: 'Ouzbékistan', code: '+998', flag: '🇺🇿', continent: 'Asie', isActive: true),
    Country(id: 137, name: 'Pakistan', code: '+92', flag: '🇵🇰', continent: 'Asie', isActive: true),
    Country(id: 138, name: 'Palau', code: '+680', flag: '🇵🇼', continent: 'Océanie', isActive: true),
    Country(id: 139, name: 'Palestine', code: '+970', flag: '🇵🇸', continent: 'Asie', isActive: true),
    Country(id: 140, name: 'Panama', code: '+507', flag: '🇵🇦', continent: 'Amérique du Nord', isActive: true),
    Country(id: 141, name: 'Papouasie-Nouvelle-Guinée', code: '+675', flag: '🇵🇬', continent: 'Océanie', isActive: true),
    Country(id: 142, name: 'Paraguay', code: '+595', flag: '🇵🇾', continent: 'Amérique du Sud', isActive: true),
    Country(id: 143, name: 'Pays-Bas', code: '+31', flag: '🇳🇱', continent: 'Europe', isActive: true),
    Country(id: 144, name: 'Pérou', code: '+51', flag: '🇵🇪', continent: 'Amérique du Sud', isActive: true),
    Country(id: 145, name: 'Philippines', code: '+63', flag: '🇵🇭', continent: 'Asie', isActive: true),
    Country(id: 146, name: 'Pologne', code: '+48', flag: '🇵🇱', continent: 'Europe', isActive: true),
    Country(id: 147, name: 'Polynésie française', code: '+689', flag: '🇵🇫', continent: 'Océanie', isActive: true),
    Country(id: 148, name: 'Porto Rico', code: '+1787', flag: '🇵🇷', continent: 'Amérique du Nord', isActive: true),
    Country(id: 149, name: 'Portugal', code: '+351', flag: '🇵🇹', continent: 'Europe', isActive: true),
    Country(id: 150, name: 'Qatar', code: '+974', flag: '🇶🇦', continent: 'Asie', isActive: true),
    Country(id: 151, name: 'République démocratique du Congo', code: '+243', flag: '🇨🇩', continent: 'Afrique', isActive: true),
    Country(id: 152, name: 'République dominicaine', code: '+1809', flag: '🇩🇴', continent: 'Amérique du Nord', isActive: true),
    Country(id: 153, name: 'République tchèque', code: '+420', flag: '🇨🇿', continent: 'Europe', isActive: true),
    Country(id: 154, name: 'Roumanie', code: '+40', flag: '🇷🇴', continent: 'Europe', isActive: true),
    Country(id: 155, name: 'Royaume-Uni', code: '+44', flag: '🇬🇧', continent: 'Europe', isActive: true),
    Country(id: 156, name: 'Russie', code: '+7', flag: '🇷🇺', continent: 'Europe', isActive: true),
    Country(id: 157, name: 'Rwanda', code: '+250', flag: '🇷🇼', continent: 'Afrique', isActive: true),
    Country(id: 158, name: 'Saint-Kitts-et-Nevis', code: '+1869', flag: '🇰🇳', continent: 'Amérique du Nord', isActive: true),
    Country(id: 159, name: 'Saint-Marin', code: '+378', flag: '🇸🇲', continent: 'Europe', isActive: true),
    Country(id: 160, name: 'Saint-Vincent-et-les-Grenadines', code: '+1784', flag: '🇻🇨', continent: 'Amérique du Nord', isActive: true),
    Country(id: 161, name: 'Sainte-Lucie', code: '+1758', flag: '🇱🇨', continent: 'Amérique du Nord', isActive: true),
    Country(id: 162, name: 'Salomon', code: '+677', flag: '🇸🇧', continent: 'Océanie', isActive: true),
    Country(id: 163, name: 'Salvador', code: '+503', flag: '🇸🇻', continent: 'Amérique du Nord', isActive: true),
    Country(id: 164, name: 'Samoa', code: '+685', flag: '🇼🇸', continent: 'Océanie', isActive: true),
    Country(id: 165, name: 'São Tomé-et-Príncipe', code: '+239', flag: '🇸🇹', continent: 'Afrique', isActive: true),
    Country(id: 166, name: 'Sénégal', code: '+221', flag: '🇸🇳', continent: 'Afrique', isActive: true),
    Country(id: 167, name: 'Serbie', code: '+381', flag: '🇷🇸', continent: 'Europe', isActive: true),
    Country(id: 168, name: 'Seychelles', code: '+248', flag: '🇸🇨', continent: 'Afrique', isActive: true),
    Country(id: 169, name: 'Sierra Leone', code: '+232', flag: '🇸🇱', continent: 'Afrique', isActive: true),
    Country(id: 170, name: 'Singapour', code: '+65', flag: '🇸🇬', continent: 'Asie', isActive: true),
    Country(id: 171, name: 'Slovaquie', code: '+421', flag: '🇸🇰', continent: 'Europe', isActive: true),
    Country(id: 172, name: 'Slovénie', code: '+386', flag: '🇸🇮', continent: 'Europe', isActive: true),
    Country(id: 173, name: 'Somalie', code: '+252', flag: '🇸🇴', continent: 'Afrique', isActive: true),
    Country(id: 174, name: 'Soudan', code: '+249', flag: '🇸🇩', continent: 'Afrique', isActive: true),
    Country(id: 175, name: 'Soudan du Sud', code: '+211', flag: '🇸🇸', continent: 'Afrique', isActive: true),
    Country(id: 176, name: 'Sri Lanka', code: '+94', flag: '🇱🇰', continent: 'Asie', isActive: true),
    Country(id: 177, name: 'Suède', code: '+46', flag: '🇸🇪', continent: 'Europe', isActive: true),
    Country(id: 178, name: 'Suisse', code: '+41', flag: '🇨🇭', continent: 'Europe', isActive: true),
    Country(id: 179, name: 'Suriname', code: '+597', flag: '🇸🇷', continent: 'Amérique du Sud', isActive: true),
    Country(id: 180, name: 'Syrie', code: '+963', flag: '🇸🇾', continent: 'Asie', isActive: true),
    Country(id: 181, name: 'Tadjikistan', code: '+992', flag: '🇹🇯', continent: 'Asie', isActive: true),
    Country(id: 182, name: 'Taïwan', code: '+886', flag: '🇹🇼', continent: 'Asie', isActive: true),
    Country(id: 183, name: 'Tanzanie', code: '+255', flag: '🇹🇿', continent: 'Afrique', isActive: true),
    Country(id: 184, name: 'Tchad', code: '+235', flag: '🇹🇩', continent: 'Afrique', isActive: true),
    Country(id: 185, name: 'Thaïlande', code: '+66', flag: '🇹🇭', continent: 'Asie', isActive: true),
    Country(id: 186, name: 'Timor oriental', code: '+670', flag: '🇹🇱', continent: 'Asie', isActive: true),
    Country(id: 187, name: 'Togo', code: '+228', flag: '🇹🇬', continent: 'Afrique', isActive: true),
    Country(id: 188, name: 'Tonga', code: '+676', flag: '🇹🇴', continent: 'Océanie', isActive: true),
    Country(id: 189, name: 'Trinité-et-Tobago', code: '+1868', flag: '🇹🇹', continent: 'Amérique du Nord', isActive: true),
    Country(id: 190, name: 'Tunisie', code: '+216', flag: '🇹🇳', continent: 'Afrique', isActive: true),
    Country(id: 191, name: 'Turkménistan', code: '+993', flag: '🇹🇲', continent: 'Asie', isActive: true),
    Country(id: 192, name: 'Turquie', code: '+90', flag: '🇹🇷', continent: 'Europe', isActive: true),
    Country(id: 193, name: 'Tuvalu', code: '+688', flag: '🇹🇻', continent: 'Océanie', isActive: true),
    Country(id: 194, name: 'Ukraine', code: '+380', flag: '🇺🇦', continent: 'Europe', isActive: true),
    Country(id: 195, name: 'Uruguay', code: '+598', flag: '🇺🇾', continent: 'Amérique du Sud', isActive: true),
    Country(id: 196, name: 'Vanuatu', code: '+678', flag: '🇻🇺', continent: 'Océanie', isActive: true),
    Country(id: 197, name: 'Vatican', code: '+379', flag: '🇻🇦', continent: 'Europe', isActive: true),
    Country(id: 198, name: 'Venezuela', code: '+58', flag: '🇻🇪', continent: 'Amérique du Sud', isActive: true),
    Country(id: 199, name: 'Vietnam', code: '+84', flag: '🇻🇳', continent: 'Asie', isActive: true),
    Country(id: 200, name: 'Yémen', code: '+967', flag: '🇾🇪', continent: 'Asie', isActive: true),
    Country(id: 201, name: 'Zambie', code: '+260', flag: '🇿🇲', continent: 'Afrique', isActive: true),
    Country(id: 202, name: 'Zimbabwe', code: '+263', flag: '🇿🇼', continent: 'Afrique', isActive: true),
  ];
}



  // Charger les services depuis l'API
  Future<void> _loadServices() async {
    setState(() {
      _isLoadingServices = true;
    });

    try {
      final services = await ServiceService.getAllServices();
      setState(() {
        _services = services;
        _isLoadingServices = false;
      });
    } catch (e) {
      print('Erreur lors du chargement des services: $e');
      setState(() {
        _isLoadingServices = false;
      });
    }
  }

  bool _isStepComplete(int stepNumber) {
    switch (stepNumber) {
      case 1:
        return _serviceType.isNotEmpty &&
            _experience.isNotEmpty &&
            _description.isNotEmpty;
      case 2:
        return _firstName.isNotEmpty &&
            _lastName.isNotEmpty &&
            _phone.isNotEmpty &&
            _address.isNotEmpty &&
            _city.isNotEmpty &&
            _zipCode.isNotEmpty &&
            _certifications.isNotEmpty;
      case 3:
        if (_selectedDocumentVersion == 'Pro') {
          return _hasProfilePhoto &&
              _hasIdCardFront &&
              _hasIdCardBack &&
              _hasDiploma &&
              _hasCv;
        } else {
          return _hasProfilePhotoSimple &&
              _hasIdCardFrontSimple &&
              _hasIdCardBackSimple;
        }
      default:
        return false;
    }
  }

  // Soumettre l'application
  void _submitApplication() {
    Navigator.pushReplacementNamed(context, '/confirmation');
  }

  // Header avec logo Fibaya Pro et texte d'introduction
  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        left: 20,
        right: 20,
        bottom: 20,
      ),
      child: Column(
        children: [
          // Logo Fibaya Pro
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppTheme.primaryGreen,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.people, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              const Text(
                'Fibaya Pro',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Texte d'introduction
          Text(
            'Rejoignez notre réseau de prestataires professionnels',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0x0D065b32), // primary/5
              Color(0x1A065b32), // accent/10
            ],
          ),
        ),
        child: Column(
          children: [
            // Header avec logo et texte d'introduction
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      StepProgressIndicator(
                        currentStep: _currentStep,
                        totalSteps: 4,
                        completedSteps: [
                          _isStepComplete(1),
                          _isStepComplete(2),
                          _isStepComplete(3),
                          _isStepComplete(4),
                        ],
                        stepTitles: [
                          'Étape 1',
                          'Informations personnelles',
                          'Documents à fournir',
                          'Récapitulatif',
                        ],
                        stepDescriptions: [
                          'Sélection de service',
                          'Vos coordonnées et informations de contact',
                          'Téléchargez vos documents officiels',
                          'Vérifiez vos informations avant soumission',
                        ],
                        showStepHeader: false,
                      ),
                      const SizedBox(height: 24),
                      Container(
                        margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        decoration: BoxDecoration(
                          color: Colors.white, // Fond blanc principal
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: _buildCurrentStep(),
                      ),
                      _buildNavigationButtons(),
                      _buildFooter(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 1:
        return _buildStep1();
      case 2:
        return _buildStep2();
      case 3:
        return _buildStep3();
      case 4:
        return _buildStep4();
      default:
        return const SizedBox();
    }
  }

  Widget _buildStep1() {
    return Column(
      children: [
        // Banner vert foncé avec le titre - prend toute la largeur et collé en haut
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF065b32), // Vert foncé
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choisissez votre spécialité',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Sélectionnez votre domaine d\'expertise principal',
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Contenu avec padding
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isLoadingServices)
                const Center(child: CircularProgressIndicator())
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: _services.length,
                  itemBuilder: (context, index) {
                    final service = _services[index];
                    final isSelected = _serviceType == service.name;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _serviceType = service.name;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.primaryGreen
                                : Colors.grey[300]!,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          color: isSelected
                              ? AppTheme.primaryGreen.withValues(alpha: 0.05)
                              : Colors.white,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _getIconForService(service.icon),
                              size: 24,
                              color: isSelected
                                  ? AppTheme.primaryGreen
                                  : Colors.grey[600],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              service.name ==
                                      'Installateur/Reparateur de climatisation'
                                  ? 'Install/Repar/climatisation'
                                  : service.name,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? AppTheme.primaryGreen
                                    : Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              const SizedBox(height: 16),
              // Experience
              const Text(
                'Années d\'expérience',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryGreen,
                ),
              ),
              const SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              TextField(
                controller: _experienceController,
                keyboardType: TextInputType.number,
                maxLength: 2,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppTheme.primaryGreen,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  hintText: 'Nombre d\'années d\'expérience',
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  prefixIcon: const Icon(
                    Icons.work_history,
                    color: AppTheme.primaryGreen,
                  ),
                      counterText: '', // Masquer le compteur par défaut
                ),
                onChanged: (value) {
                  setState(() {
                    _experience = value;
                  });
                },
                  ),
                  // Compteur de caractères personnalisé
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      '${_experience.length}/2 caractères',
                      style: TextStyle(
                        fontSize: 12,
                        color: _experience.length > 2 ? Colors.red : Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Description
              const Text(
                'Description de vos services',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryGreen,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _descriptionController,
                maxLines: 4,
                maxLength: 500,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppTheme.primaryGreen,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  hintText: 'Décrivez vos services et spécialités...',
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  prefixIcon: const Icon(
                    Icons.description,
                    color: AppTheme.primaryGreen,
                  ),
                  counterStyle: TextStyle(color: Colors.grey.shade600),
                ),
                onChanged: (value) {
                  setState(() {
                    _description = value;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      children: [
        // Banner vert foncé avec le titre - prend toute la largeur et collé en haut
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF065b32), // Vert foncé
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Informations personnelles',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Vos coordonnées et informations de contact',
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),
        ),
        // Contenu avec padding
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // First Name
              const Text(
                'Prénom',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              TextField(
                controller: _firstNameController,
                maxLength: 30,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(
                      color: AppTheme.primaryGreen,
                      width: 2,
                    ),
                  ),
                      errorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                      ),
                  hintText: 'Votre prénom',
                      errorText: _firstNameError,
                      counterText: '', // Masquer le compteur par défaut
                ),
                onChanged: (value) {
                  setState(() {
                    _firstName = value;
                        _validateFirstName(value);
                  });
                },
                  ),
                  // Compteur de caractères personnalisé
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      '${_firstName.length}/30 caractères',
                      style: TextStyle(
                        fontSize: 12,
                        color: _firstName.length > 30 ? Colors.red : Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Last Name
              const Text(
                'Nom',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              TextField(
                controller: _lastNameController,
                maxLength: 25,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(
                      color: AppTheme.primaryGreen,
                      width: 2,
                    ),
                  ),
                      errorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                      ),
                  hintText: 'Votre nom',
                      errorText: _lastNameError,
                      counterText: '', // Masquer le compteur par défaut
                ),
                onChanged: (value) {
                  setState(() {
                    _lastName = value;
                        _validateLastName(value);
                  });
                },
                  ),
                  // Compteur de caractères personnalisé
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      '${_lastName.length}/25 caractères',
                      style: TextStyle(
                        fontSize: 12,
                        color: _lastName.length > 25 ? Colors.red : Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Phone
              const Text(
                'Numéro de téléphone',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      value: _selectedCountryCode,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(
                            color: AppTheme.primaryGreen,
                            width: 2,
                          ),
                        ),
                      ),
                      // Affichage dans le menu fermé : Drapeau + Code
                      selectedItemBuilder: (BuildContext context) {
                        return _countries.map<Widget>((country) {
                          return Text(
                            '${country.flag} ${country.code}',
                            style: const TextStyle(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          );
                        }).toList();
                      },
                      // Affichage dans le menu ouvert : Drapeau + Nom
                      items: _countries.map((country) {
                        return DropdownMenuItem(
                          value: country.code,
                          child: Text(
                            '${country.flag} ${country.name}',
                            style: const TextStyle(fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCountryCode = value ?? '+221';
                          // Revalider le numéro de téléphone quand le pays change
                          if (_phone.isNotEmpty) {
                            _validatePhone(_phone);
                          }
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                      controller: _phoneController,
                          maxLength: _getExpectedPhoneLength(),
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(
                            color: AppTheme.primaryGreen,
                            width: 2,
                          ),
                        ),
                            errorBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 2,
                              ),
                            ),
                            focusedErrorBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 2,
                              ),
                            ),
                        hintText: 'Numéro de téléphone',
                            errorText: _phoneError,
                            counterText: '', // Masquer le compteur par défaut
                      ),
                      keyboardType: TextInputType.phone,
                      onChanged: (value) {
                        setState(() {
                          _phone = value;
                              _validatePhone(value);
                        });
                      },
                        ),
                        // Compteur de caractères
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            '${_phone.length}/${_getExpectedPhoneLength()} caractères',
                            style: TextStyle(
                              fontSize: 12,
                              color: _phone.length > _getExpectedPhoneLength() ? Colors.red : Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Address
              const Text(
                'Adresse',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              TextField(
                controller: _addressController,
                maxLength: 50,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(
                      color: AppTheme.primaryGreen,
                      width: 2,
                    ),
                  ),
                      errorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                      ),
                  hintText: 'Votre adresse',
                      errorText: _addressError,
                      counterText: '', // Masquer le compteur par défaut
                ),
                onChanged: (value) {
                  setState(() {
                    _address = value;
                        _validateAddress(value);
                  });
                },
                  ),
                  // Compteur de caractères personnalisé
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      '${_address.length}/50 caractères',
                      style: TextStyle(
                        fontSize: 12,
                        color: _address.length > 50 ? Colors.red : Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // City
              const Text(
                'Ville',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              TextField(
                controller: _cityController,
                maxLength: 20,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(
                      color: AppTheme.primaryGreen,
                      width: 2,
                    ),
                  ),
                      errorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                      ),
                  hintText: 'Votre ville',
                      errorText: _cityError,
                      counterText: '', // Masquer le compteur par défaut
                ),
                onChanged: (value) {
                  setState(() {
                    _city = value;
                        _validateCity(value);
                  });
                },
                  ),
                  // Compteur de caractères personnalisé
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      '${_city.length}/20 caractères',
                      style: TextStyle(
                        fontSize: 12,
                        color: _city.length > 20 ? Colors.red : Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Zip Code
              const Text(
                'Code postal',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              TextField(
                controller: _zipCodeController,
                keyboardType: TextInputType.text,
                maxLength: 12,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(
                      color: AppTheme.primaryGreen,
                      width: 2,
                    ),
                  ),
                      errorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                      ),
                  hintText: 'Code postal',
                      errorText: _zipCodeError,
                      counterText: '', // Masquer le compteur par défaut
                ),
                onChanged: (value) {
                  setState(() {
                    _zipCode = value;
                        _validateZipCode(value);
                  });
                },
                  ),
                  // Compteur de caractères personnalisé
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      '${_zipCode.length}/12 caractères',
                      style: TextStyle(
                        fontSize: 12,
                        color: _zipCode.length > 12 ? Colors.red : Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Certifications
              const Text(
                'Certifications et diplômes',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              TextField(
                controller: _certificationsController,
                maxLines: 3,
                maxLength: 600,
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.start,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                      focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(
                      color: AppTheme.primaryGreen,
                      width: 2,
                    ),
                  ),
                      errorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                      ),
                  hintText:
                      'Listez vos certifications, diplômes ou formations pertinentes...',
                      errorText: _certificationsError,
                      counterText: '', // Masquer le compteur par défaut
                ),
                onChanged: (value) {
                  setState(() {
                    _certifications = value;
                  });
                },
                  ),
                  // Compteur de caractères personnalisé
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      '${_certifications.length}/600 caractères',
                      style: TextStyle(
                        fontSize: 12,
                        color: _certifications.length > 600 ? Colors.red : Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      children: [
        // Banner vert foncé avec le titre - prend toute la largeur et collé en haut
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF065b32), // Vert foncé
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Documents à fournir',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Téléchargez vos documents officiels',
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),
        ),
        // Contenu avec padding
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Sélection de version avec boutons
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDocumentVersion = 'Simple';
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: _selectedDocumentVersion == 'Simple'
                              ? AppTheme.primaryGreen
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _selectedDocumentVersion == 'Simple'
                                ? AppTheme.primaryGreen
                                : Colors.grey[300]!,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: _selectedDocumentVersion == 'Simple'
                                  ? Colors.white
                                  : Colors.grey[600],
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                'Version Simple',
                                style: TextStyle(
                                  color: _selectedDocumentVersion == 'Simple'
                                      ? Colors.white
                                      : Colors.grey[600],
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDocumentVersion = 'Pro';
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: _selectedDocumentVersion == 'Pro'
                              ? AppTheme.primaryGreen
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _selectedDocumentVersion == 'Pro'
                                ? AppTheme.primaryGreen
                                : Colors.grey[300]!,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.refresh,
                              color: _selectedDocumentVersion == 'Pro'
                                  ? Colors.white
                                  : Colors.grey[600],
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                'Version Pro',
                                style: TextStyle(
                                  color: _selectedDocumentVersion == 'Pro'
                                      ? Colors.white
                                      : Colors.grey[600],
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Message informatif sur les documents requis
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[600], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Tous les documents sont obligatoires. Taille maximale : 5 Mo. Formats acceptés : JPG, PNG, JPEG, PDF.',
                        style: TextStyle(color: Colors.blue[700], fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ...(_selectedDocumentVersion == 'Pro'
                  ? [
                      _buildDocumentUpload(
                        'Photo de profil',
                        _hasProfilePhoto,
                        _profilePhotoFile,
                        ['jpg', 'jpeg', 'png'],
                        5,
                        (file) {
                          setState(() {
                            _profilePhotoFile = file;
                            _hasProfilePhoto = file != null;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildDocumentUpload(
                        'Pièce d\'identité (recto)',
                        _hasIdCardFront,
                        _idCardFrontFile,
                        ['jpg', 'jpeg', 'png'],
                        5,
                        (file) {
                          setState(() {
                            _idCardFrontFile = file;
                            _hasIdCardFront = file != null;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildDocumentUpload(
                        'Pièce d\'identité (verso)',
                        _hasIdCardBack,
                        _idCardBackFile,
                        ['jpg', 'jpeg', 'png'],
                        5,
                        (file) {
                          setState(() {
                            _idCardBackFile = file;
                            _hasIdCardBack = file != null;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildDocumentUpload(
                        'Diplôme / Certification',
                        _hasDiploma,
                        _diplomaFile,
                        ['jpg', 'jpeg', 'png', 'pdf'],
                        10,
                        (file) {
                          setState(() {
                            _diplomaFile = file;
                            _hasDiploma = file != null;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildDocumentUpload(
                        'CV / Curriculum Vitae',
                        _hasCv,
                        _cvFile,
                        ['pdf'],
                        10,
                        (file) {
                          setState(() {
                            _cvFile = file;
                            _hasCv = file != null;
                          });
                        },
                      ),
                    ]
                  : [
                      _buildDocumentUpload(
                        'Photo de profil',
                        _hasProfilePhotoSimple,
                        _profilePhotoSimpleFile,
                        ['jpg', 'jpeg', 'png'],
                        5,
                        (file) {
                          setState(() {
                            _profilePhotoSimpleFile = file;
                            _hasProfilePhotoSimple = file != null;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildDocumentUpload(
                        'Pièce d\'identité (recto)',
                        _hasIdCardFrontSimple,
                        _idCardFrontSimpleFile,
                        ['jpg', 'jpeg', 'png'],
                        5,
                        (file) {
                          setState(() {
                            _idCardFrontSimpleFile = file;
                            _hasIdCardFrontSimple = file != null;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildDocumentUpload(
                        'Pièce d\'identité (verso)',
                        _hasIdCardBackSimple,
                        _idCardBackSimpleFile,
                        ['jpg', 'jpeg', 'png'],
                        5,
                        (file) {
                          setState(() {
                            _idCardBackSimpleFile = file;
                            _hasIdCardBackSimple = file != null;
                          });
                        },
                      ),
                    ]),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentUpload(
    String title,
    bool isUploaded,
    PlatformFile? file,
    List<String> allowedExtensions,
    int maxSizeMB,
    Function(PlatformFile?) onFileSelected,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isUploaded ? Icons.check_circle : Icons.upload_file,
                color: isUploaded ? Colors.green : Colors.grey,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isUploaded ? Colors.green : Colors.black87,
                  ),
                ),
              ),
              if (isUploaded && file != null)
                Text(
                  '${(file.size / (1024 * 1024)).toStringAsFixed(1)} MB',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
            ],
          ),
          if (isUploaded && file != null) ...[
            const SizedBox(height: 8),
            Text(
              file.name,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                _pickFile(
                  documentType: title,
                  allowedExtensions: allowedExtensions,
                  maxSizeMB: maxSizeMB,
                  onFileSelected: onFileSelected,
                  onUploadStatusChanged: (status) {
                    // Status is handled by onFileSelected
                  },
                );
              },
              icon: Icon(isUploaded ? Icons.refresh : Icons.upload),
              label: Text(isUploaded ? 'Remplacer' : 'Télécharger'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isUploaded
                    ? Colors.orange
                    : AppTheme.primaryGreen,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep4() {
    return Column(
      children: [
        // Banner vert foncé avec le titre - prend toute la largeur et collé en haut
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF065b32), // Vert foncé
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Récapitulatif',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Vérifiez vos informations avant soumission',
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),
        ),
        // Contenu avec padding
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryCard('Service', _serviceType),
              _buildSummaryCard('Expérience', '$_experience années'),
              _buildSummaryCard('Description', _description),
              _buildSummaryCard('Nom complet', '$_firstName $_lastName'),
              _buildSummaryCard('Téléphone', '$_selectedCountryCode $_phone'),
              _buildSummaryCard('Adresse', '$_address, $_city $_zipCode'),
              _buildSummaryCard('Certifications', _certifications),
              _buildSummaryCard('Version', _selectedDocumentVersion),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentStep > 1)
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _currentStep--;
                    _syncControllersWithState();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Précédent'),
              ),
            ),
          if (_currentStep > 1) const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _isStepComplete(_currentStep)
                  ? () {
                      if (_currentStep < 4) {
                        setState(() {
                          _currentStep++;
                          _syncControllersWithState();
                        });
                      } else {
                        _submitApplication();
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isStepComplete(_currentStep)
                    ? AppTheme.primaryGreen
                    : Colors.grey[300],
                foregroundColor: _isStepComplete(_currentStep)
                    ? Colors.white
                    : Colors.grey[500],
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: Text(
                _currentStep < 4 ? 'Suivant' : 'Soumettre',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          children: [
            const TextSpan(text: 'Besoin d\'aide ? '),
            WidgetSpan(
              child: GestureDetector(
                onTap: () async {
                  final String emailUri = 'mailto:fibayacontact@gmail.com';
                  if (await canLaunch(emailUri)) {
                    await launch(emailUri);
                  } else {
                    // Fallback si l'ouverture du client mail échoue
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Impossible d\'ouvrir le client mail'),
                      ),
                    );
                  }
                },
                child: Text(
                  'Contactez notre support',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.primaryGreen,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Méthode pour convertir les icônes Material Design en IconData
  IconData _getIconForService(String iconName) {
    switch (iconName) {
      case 'plumbing':
        return Icons.plumbing;
      case 'electrical_services':
        return Icons.electrical_services;
      case 'construction':
        return Icons.construction;
      case 'format_paint':
        return Icons.format_paint;
      case 'grid_view':
        return Icons.grid_view;
      case 'carpenter':
        return Icons.carpenter;
      case 'window':
        return Icons.window;
      case 'view_in_ar':
        return Icons.view_in_ar;
      case 'landscape':
        return Icons.landscape;
      case 'roofing':
        return Icons.roofing;
      case 'forest':
        return Icons.forest;
      case 'lock':
        return Icons.lock;
      case 'ac_unit':
        return Icons.ac_unit;
      case 'air':
        return Icons.air;
      case 'local_fire_department':
        return Icons.local_fire_department;
      case 'thermostat':
        return Icons.thermostat;
      case 'car_repair':
        return Icons.car_repair;
      case 'motorcycle':
        return Icons.motorcycle;
      case 'car_crash':
        return Icons.car_crash;
      case 'color_lens':
        return Icons.color_lens;
      case 'whatshot':
        return Icons.whatshot;
      case 'engineering':
        return Icons.engineering;
      case 'pedal_bike':
        return Icons.pedal_bike;
      case 'local_car_wash':
        return Icons.local_car_wash;
      case 'cleaning_services':
        return Icons.cleaning_services;
      case 'home_repair_service':
        return Icons.home_repair_service;
      case 'delete':
        return Icons.delete;
      case 'factory':
        return Icons.factory;
      case 'iron':
        return Icons.iron;
      case 'restaurant':
        return Icons.restaurant;
      case 'cake':
        return Icons.cake;
      case 'bakery_dining':
        return Icons.bakery_dining;
      case 'kitchen':
        return Icons.kitchen;
      case 'room_service':
        return Icons.room_service;
      case 'restaurant_menu':
        return Icons.restaurant_menu;
      case 'local_bar':
        return Icons.local_bar;
      case 'wine_bar':
        return Icons.wine_bar;
      case 'desk':
        return Icons.desk;
      case 'support_agent':
        return Icons.support_agent;
      case 'drive_eta':
        return Icons.drive_eta;
      case 'tour':
        return Icons.tour;
      case 'content_cut':
        return Icons.content_cut;
      case 'face':
        return Icons.face;
      case 'self_improvement':
        return Icons.self_improvement;
      case 'spa':
        return Icons.spa;
      case 'face_retouching_natural':
        return Icons.face_retouching_natural;
      case 'grass':
        return Icons.grass;
      case 'child_care':
        return Icons.child_care;
      case 'local_laundry_service':
        return Icons.local_laundry_service;
      case 'baby_changing_station':
        return Icons.baby_changing_station;
      case 'school':
        return Icons.school;
      case 'build_circle':
        return Icons.build_circle;
      case 'phone_android':
        return Icons.phone_android;
      case 'computer':
        return Icons.computer;
      case 'tv':
        return Icons.tv;
      case 'signal_cellular_alt':
        return Icons.signal_cellular_alt;
      case 'design_services':
        return Icons.design_services;
      case 'camera_alt':
        return Icons.camera_alt;
      case 'person_add_alt_1':
        return Icons.person_add_alt_1;
      case 'sports_motorsports':
        return Icons.sports_motorsports;
      case 'translate':
        return Icons.translate;
      case 'medical_services':
        return Icons.medical_services;
      case 'shopping_bag':
        return Icons.shopping_bag;
      case 'diamond':
        return Icons.diamond;
      case 'palette':
        return Icons.palette;
      case 'chair':
        return Icons.chair;
      case 'security':
        return Icons.security;
      case 'person_pin':
        return Icons.person_pin;
      case 'visibility':
        return Icons.visibility;
      case 'agriculture':
        return Icons.agriculture;
      case 'pets':
        return Icons.pets;
      case 'music_note':
        return Icons.music_note;
      case 'mic':
        return Icons.mic;
      case 'event':
        return Icons.event;
      case 'theater_comedy':
        return Icons.theater_comedy;
      default:
        return Icons.work;
    }
  }
}
