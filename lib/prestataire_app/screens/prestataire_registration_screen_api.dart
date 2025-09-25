import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../constants/app_theme.dart';
import '../services/api_service.dart';
import '../services/service_service.dart';
import '../../common/widgets/step_progress_indicator.dart';

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
  String _phoneError = '';
  String _selectedCountryCode = '+221';
  String _address = '';
  String _city = '';
  String _zipCode = '';
  String _certifications = '';

  // Controllers
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
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

  @override
  void initState() {
    super.initState();
    _descriptionController.text = _description;
    _experienceController.text = _experience;
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
    _zipCodeController.dispose();
    _certificationsController.dispose();
    super.dispose();
  }

  // Charger les pays depuis l'API
  Future<void> _loadCountries() async {
    try {
      final countries = await ApiService.getAllCountries();
      setState(() {
        _countries = countries;
      });
    } catch (e) {
      print('Erreur lors du chargement des pays: $e');
    }
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

  // Valider le numéro de téléphone
  String? _validatePhone(String phone) {
    if (phone.isEmpty) {
      return 'Le numéro de téléphone est requis';
    }

    // Supprimer tous les espaces et caractères non numériques sauf +
    String cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');

    // Vérifier que le numéro commence par le code pays
    if (!cleanPhone.startsWith(_selectedCountryCode)) {
      return 'Le numéro doit commencer par $_selectedCountryCode';
    }

    // Vérifier la longueur minimale (code pays + au moins 7 chiffres)
    if (cleanPhone.length < _selectedCountryCode.length + 7) {
      return 'Le numéro de téléphone est trop court';
    }

    return null;
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
            _certifications.isNotEmpty &&
            _validatePhone(_phone) == null;
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
              TextField(
                controller: _experienceController,
                keyboardType: TextInputType.number,
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
                ),
                onChanged: (value) {
                  setState(() {
                    _experience = value;
                  });
                },
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
              TextField(
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
                  hintText: 'Votre prénom',
                ),
                onChanged: (value) {
                  setState(() {
                    _firstName = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              // Last Name
              const Text(
                'Nom',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextField(
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
                  hintText: 'Votre nom',
                ),
                onChanged: (value) {
                  setState(() {
                    _lastName = value;
                  });
                },
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
                  Expanded(
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
                      items: _countries.map((country) {
                        return DropdownMenuItem(
                          value: country.code,
                          child: Text('${country.flag} ${country.code}'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCountryCode = value ?? '+221';
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 3,
                    child: TextField(
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
                        hintText: 'Numéro de téléphone',
                        errorText: _phoneError.isNotEmpty ? _phoneError : null,
                      ),
                      keyboardType: TextInputType.phone,
                      onChanged: (value) {
                        setState(() {
                          _phone = value;
                          _phoneError = _validatePhone(value) ?? '';
                        });
                      },
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
              TextField(
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
                  hintText: 'Votre adresse complète',
                ),
                onChanged: (value) {
                  setState(() {
                    _address = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              // City
              const Text(
                'Ville',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextField(
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
                  hintText: 'Votre ville',
                ),
                onChanged: (value) {
                  setState(() {
                    _city = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              // Zip Code
              const Text(
                'Code postal',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _zipCodeController,
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
                  hintText: 'Code postal',
                ),
                onChanged: (value) {
                  setState(() {
                    _zipCode = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              // Certifications
              const Text(
                'Certifications et diplômes',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _certificationsController,
                maxLines: 3,
                maxLength: 600,
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.start,
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
                  hintText:
                      'Listez vos certifications, diplômes ou formations pertinentes...',
                ),
                onChanged: (value) {
                  setState(() {
                    _certifications = value;
                  });
                },
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
      child: Text(
        'Besoin d\'aide ? Contactez notre support à fibayacontact@gmail.com',
        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        textAlign: TextAlign.center,
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
