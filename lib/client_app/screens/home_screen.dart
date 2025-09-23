import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../common/models/service.dart';
import '../../common/models/services_data.dart';
import '../../common/widgets/service_card.dart';
import '../../common/widgets/welcome_dialog.dart';
import 'service_selection_screen.dart';
import 'notification_center_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  String _searchQuery = '';
  String _selectedCategory = 'all';
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _serviceSearchController =
      TextEditingController();

  // States for icon hover effects
  bool _isNotificationPressed = false;
  bool _isProfilePressed = false;
  bool _isMenuPressed = false;

  // Location states
  String _currentAddress = 'Localisation en cours...';
  bool _isLoadingLocation = true;
  bool _locationPermissionGranted = false;

  // Animation controller for floating action button
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fabAnimation = Tween<double>(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: Curves.easeInOut),
    );
    _fabAnimationController.repeat(reverse: true);

    // Initialize location
    _initializeLocation();

    // Précharger l'image et afficher la boîte de dialogue de bienvenue
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Précharger l'image et attendre qu'elle soit chargée
      await precacheImage(
        const AssetImage('assets/images/fibaya.png'),
        context,
      );

      // Afficher la boîte de dialogue de bienvenue une fois l'image chargée
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible:
              false, // Empêche la fermeture en cliquant à l'extérieur
          builder: (BuildContext context) {
            return const WelcomeDialog();
          },
        );
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _serviceSearchController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  // Location methods
  Future<void> _initializeLocation() async {
    await _checkLocationPermission();
    if (_locationPermissionGranted) {
      await _getCurrentLocation();
    } else {
      // En mode développement, essayer quand même la géolocalisation
      await _getCurrentLocation();
    }
  }

  Future<void> _checkLocationPermission() async {
    print('🔍 Vérification des permissions de localisation...');
    LocationPermission permission = await Geolocator.checkPermission();
    print('📱 Permission actuelle: $permission');

    if (permission == LocationPermission.denied) {
      print('❌ Permission refusée, demande de permission...');
      permission = await Geolocator.requestPermission();
      print('📱 Nouvelle permission: $permission');
      if (permission == LocationPermission.denied) {
        print('❌ Permission toujours refusée');
        setState(() {
          _currentAddress = 'Permission de localisation refusée';
          _isLoadingLocation = false;
          _locationPermissionGranted = false;
        });
        _showLocationPermissionDialog();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _currentAddress = 'Localisation désactivée dans les paramètres';
        _isLoadingLocation = false;
        _locationPermissionGranted = false;
      });
      _showLocationSettingsDialog();
      return;
    }

    setState(() {
      _locationPermissionGranted = true;
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      print('📍 Début de la géolocalisation...');
      setState(() {
        _isLoadingLocation = true;
        _currentAddress = 'Localisation en cours...';
      });

      print('🌍 Récupération de la position...');
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print(
        '✅ Position récupérée: ${position.latitude}, ${position.longitude}',
      );

      print('🏠 Conversion des coordonnées en adresse...');
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      print('📋 Nombre de placemarks trouvés: ${placemarks.length}');

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        print('🏠 Placemark: ${place.toString()}');
        String address = _formatAddress(place);
        print('📍 Adresse formatée: $address');

        print('🔄 Mise à jour de l\'interface avec l\'adresse: $address');
        setState(() {
          _currentAddress = address;
          _isLoadingLocation = false;
        });
        print('✅ Interface mise à jour');
      } else {
        print('❌ Aucun placemark trouvé');
        setState(() {
          _currentAddress = 'Adresse non trouvée';
          _isLoadingLocation = false;
        });
      }
    } catch (e) {
      setState(() {
        _currentAddress = 'Erreur de localisation';
        _isLoadingLocation = false;
      });
    }
  }

  String _formatAddress(Placemark place) {
    print('🔧 Formatage de l\'adresse...');
    List<String> addressParts = [];

    print('🏠 Street: ${place.street}');
    print('🏙️ Locality: ${place.locality}');
    print('🌍 AdministrativeArea: ${place.administrativeArea}');
    print('🌎 Country: ${place.country}');

    if (place.street != null && place.street!.isNotEmpty) {
      addressParts.add(place.street!);
    }
    if (place.locality != null && place.locality!.isNotEmpty) {
      addressParts.add(place.locality!);
    }
    if (place.administrativeArea != null &&
        place.administrativeArea!.isNotEmpty) {
      addressParts.add(place.administrativeArea!);
    }
    if (place.country != null && place.country!.isNotEmpty) {
      addressParts.add(place.country!);
    }

    String result = addressParts.join(', ');
    print('📍 Adresse finale: $result');
    return result;
  }

  void _showLocationPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Localisation requise'),
          content: const Text(
            'FIBAYA a besoin d\'accéder à votre position pour vous proposer les meilleurs services près de chez vous.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _checkLocationPermission();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF065b32),
                foregroundColor: Colors.white,
              ),
              child: const Text('Autoriser'),
            ),
          ],
        );
      },
    );
  }

  void _showLocationSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Localisation désactivée'),
          content: const Text(
            'La localisation est désactivée dans les paramètres. Veuillez l\'activer pour utiliser FIBAYA.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF065b32),
                foregroundColor: Colors.white,
              ),
              child: const Text('Paramètres'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatItem(
    IconData icon,
    String value,
    String label,
    Color iconColor,
  ) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.white70),
        ),
      ],
    );
  }

  List<Service> get _filteredServices {
    List<Service> filtered = ServicesData.services;

    if (_selectedCategory != 'all') {
      filtered = filtered
          .where((service) => service.category == _selectedCategory)
          .toList();
    }

    // Recherche combinée : _searchQuery (recherche générale) + _serviceSearchController (recherche de services)
    String combinedSearch = _searchQuery;
    if (_serviceSearchController.text.isNotEmpty) {
      combinedSearch = _serviceSearchController.text;
    }

    if (combinedSearch.isNotEmpty) {
      filtered = filtered
          .where(
            (service) =>
                service.name.toLowerCase().contains(
                  combinedSearch.toLowerCase(),
                ) ||
                service.description.toLowerCase().contains(
                  combinedSearch.toLowerCase(),
                ),
          )
          .toList();
    }

    return filtered;
  }

  List<Map<String, dynamic>> get _categories {
    final categories = [
      {'key': 'all', 'label': 'Tous', 'count': ServicesData.services.length},
    ];

    // Ajouter les catégories principales dans l'ordre souhaité
    final mainCategories = [
      ServiceCategory.BUILDING,
      ServiceCategory.HVAC,
      ServiceCategory.MECHANICS,
      ServiceCategory.CLEANING,
      ServiceCategory.COOKING,
      ServiceCategory.SERVICE,
      ServiceCategory.BEAUTY,
      ServiceCategory.HOME,
      ServiceCategory.TECH,
      ServiceCategory.CREATIVE,
      ServiceCategory.HEALTH,
      ServiceCategory.SECURITY,
      ServiceCategory.AGRICULTURE,
      ServiceCategory.EVENTS,
      ServiceCategory.OTHER,
    ];

    for (final category in mainCategories) {
      final count = ServicesData.services
          .where((s) => s.category == category)
          .length;
      if (count > 0) {
        // Extraire le nom court de la catégorie (sans emoji et sans "&")
        String shortLabel = category;
        if (category.contains('🛠️'))
          shortLabel = 'Bâtiment';
        else if (category.contains('❄️'))
          shortLabel = 'Froid';
        else if (category.contains('⚙️'))
          shortLabel = 'Mécanique';
        else if (category.contains('🧹'))
          shortLabel = 'Entretien';
        else if (category.contains('🧑‍🍳'))
          shortLabel = 'Cuisine';
        else if (category.contains('☕'))
          shortLabel = 'Service';
        else if (category.contains('Beauté'))
          shortLabel = 'Beauté';
        else if (category.contains('Maison'))
          shortLabel = 'Maison';
        else if (category.contains('Technologie'))
          shortLabel = 'Tech';
        else if (category.contains('Créatif'))
          shortLabel = 'Créatif';
        else if (category.contains('Santé'))
          shortLabel = 'Santé';
        else if (category.contains('Sécurité'))
          shortLabel = 'Sécurité';
        else if (category.contains('Agriculture'))
          shortLabel = 'Agriculture';
        else if (category.contains('Événements'))
          shortLabel = 'Événements';
        else if (category.contains('Autre'))
          shortLabel = 'Autre';

        categories.add({'key': category, 'label': shortLabel, 'count': count});
      }
    }

    return categories;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        bottom: false,
        child: Column(
          children: [
            // Fixed Top Navigation Bar (White) - Always visible
            Container(
              height: 95, // Fixed height for navigation (20 + 75)
              color: Colors.white,
              child: Column(
                children: [
                  // Extra white space for badge visibility
                  Container(height: 20, color: Colors.white),
                  // Top Navigation Bar (White)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Logo Fibaya
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF065b32),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.location_on,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'FIBAYA',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF065b32),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.red,
                                    size: 12,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      _currentAddress,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: _getCurrentLocation,
                                    child: Icon(
                                      _isLoadingLocation
                                          ? Icons.refresh
                                          : Icons.my_location,
                                      color: const Color(0xFF065b32),
                                      size: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Right icons - Simple outline style with hover effect
                        Row(
                          children: [
                            // Notifications with badge
                            Stack(
                              children: [
                                GestureDetector(
                                  onTapDown: (_) {
                                    setState(() {
                                      _isNotificationPressed = true;
                                    });
                                  },
                                  onTapUp: (_) {
                                    setState(() {
                                      _isNotificationPressed = false;
                                    });
                                  },
                                  onTapCancel: () {
                                    setState(() {
                                      _isNotificationPressed = false;
                                    });
                                  },
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const NotificationCenterScreen(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: _isNotificationPressed
                                          ? const Color(0xFF065b32)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.notifications_outlined,
                                      color: _isNotificationPressed
                                          ? Colors.white
                                          : Colors.black,
                                      size: 24,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 4,
                                  top: 0,
                                  child: Container(
                                    width: 16,
                                    height: 16,
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Center(
                                      child: Text(
                                        '3',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTapDown: (_) {
                                setState(() {
                                  _isProfilePressed = true;
                                });
                              },
                              onTapUp: (_) {
                                setState(() {
                                  _isProfilePressed = false;
                                });
                              },
                              onTapCancel: () {
                                setState(() {
                                  _isProfilePressed = false;
                                });
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: _isProfilePressed
                                      ? const Color(0xFF065b32)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.person_outline,
                                  color: _isProfilePressed
                                      ? Colors.white
                                      : Colors.black,
                                  size: 24,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTapDown: (_) {
                                setState(() {
                                  _isMenuPressed = true;
                                });
                              },
                              onTapUp: (_) {
                                setState(() {
                                  _isMenuPressed = false;
                                });
                              },
                              onTapCancel: () {
                                setState(() {
                                  _isMenuPressed = false;
                                });
                              },
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                        ) => const ProfileScreen(),
                                    transitionsBuilder:
                                        (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                          child,
                                        ) {
                                          const begin = Offset(1.0, 0.0);
                                          const end = Offset.zero;
                                          const curve = Curves.easeInOut;

                                          var tween = Tween(
                                            begin: begin,
                                            end: end,
                                          ).chain(CurveTween(curve: curve));
                                          var offsetAnimation = animation.drive(
                                            tween,
                                          );

                                          return SlideTransition(
                                            position: offsetAnimation,
                                            child: child,
                                          );
                                        },
                                    transitionDuration: const Duration(
                                      milliseconds: 1200,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: _isMenuPressed
                                      ? const Color(0xFF065b32)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.menu,
                                  color: _isMenuPressed
                                      ? Colors.white
                                      : Colors.black,
                                  size: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Main Header Section (Dark Green)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(color: Color(0xFF065b32)),
                      child: Column(
                        children: [
                          // Badge "Plateforme N°1 en RDC" - Centered
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF065b32),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Plateforme N°1',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Main text - Centered
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Trouvez le ',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'service parfait',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF4CAF50), // Light green
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'près de chez ',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'vous',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF4CAF50), // Light green
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Description text - Centered
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Besoin d\'un service fiable ?',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Plus de 60 services à votre disposition, en temps réel.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),

                          const SizedBox(height: 32),

                          // Statistics section - WHITE ICONS
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatItem(
                                Icons.people,
                                '10,000+',
                                'Prestataires actifs',
                                Colors.white,
                              ),
                              _buildStatItem(
                                Icons.star,
                                '4.8/5',
                                'Note moyenne',
                                Colors.white,
                              ),
                              _buildStatItem(
                                Icons.location_on,
                                'Rapide',
                                'Temps de réponse',
                                Colors.white,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Categories Filter Bar
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _categories.map((category) {
                            final isSelected =
                                _selectedCategory == category['key'];
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedCategory = category['key'];
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFF065b32)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: isSelected
                                        ? null
                                        : Border.all(color: Colors.grey[300]!),
                                  ),
                                  child: Text(
                                    '${category['label']} (${category['count']})',
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.grey[700],
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    // Search Section
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Title
                          const Text(
                            'Trouvez le service parfait près de chez vous',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          // Subtitle
                          const Text(
                            'Plus de 60 services disponibles',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF4CAF50),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          // Search Card
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Service Search Button
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    border: Border.all(
                                      color: Colors.grey[300]!,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.build_circle_outlined,
                                        color: const Color(0xFF065b32),
                                        size: 48,
                                      ),
                                      const SizedBox(width: 12),
                                      const Expanded(
                                        child: Text(
                                          'Que cherchez-vous ?',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Container(
                                        width: 24,
                                        height: 24,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF065b32),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.white,
                                          size: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                // Service Search Input
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey[300]!,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.search,
                                        color: const Color(0xFF065b32),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: TextField(
                                          controller: _serviceSearchController,
                                          onChanged: (value) {
                                            setState(() {
                                              // La recherche se fait automatiquement via _filteredServices
                                            });
                                          },
                                          decoration: const InputDecoration(
                                            hintText:
                                                'Rechercher des services disponibles',
                                            hintStyle: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16,
                                            ),
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.zero,
                                          ),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
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
                      ),
                    ),

                    // Services List
                    _filteredServices.isEmpty
                        ? Container(
                            height: 300,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Icône de recherche personnalisée
                                  Container(
                                    width: 80,
                                    height: 80,
                                    child: Image.asset(
                                      'assets/images/recherche.png',
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  // Titre principal
                                  const Text(
                                    'Aucun service trouvé',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF757575),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Message secondaire
                                  Text(
                                    'Essayez avec d\'autres mots-clés',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF9E9E9E),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Column(
                            children: _filteredServices.map((service) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: ServiceCard(
                                  service: service,
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ServiceSelectionScreen(
                                              service: service,
                                            ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _fabAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _fabAnimation.value),
            child: FloatingActionButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Fonctionnalité carte en cours de développement',
                    ),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              backgroundColor: const Color(0xFF065b32),
              child: const Icon(Icons.location_on, color: Colors.white),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
