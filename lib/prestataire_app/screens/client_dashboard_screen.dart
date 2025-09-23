import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shimmer/shimmer.dart';
import '../constants/app_theme.dart';
import '../models/prestataire_model.dart';
import '../widgets/custom_bottom_navigation_bar.dart';
import '../widgets/prestataire_card.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/notification_icon_with_badge.dart';

class ClientDashboardScreen extends StatefulWidget {
  const ClientDashboardScreen({super.key});

  @override
  State<ClientDashboardScreen> createState() => _ClientDashboardScreenState();
}

class _ClientDashboardScreenState extends State<ClientDashboardScreen>
    with TickerProviderStateMixin {
  // GoogleMapController? _mapController; // Pour usage futur
  final LatLng _currentLocation = const LatLng(
    14.7167,
    -17.4677,
  ); // Dakar par défaut
  final Set<Marker> _markers = {};

  late AnimationController _animationController;
  late AnimationController _mapAnimationController;
  late AnimationController _listController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;

  int _selectedIndex = 0;
  String _selectedFilter = 'Proximité';
  List<PrestataireModel> _prestataires = [];
  bool _isLoading = true;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadData();
    _startAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _mapAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _listController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
      ),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutBack),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 1.0, curve: Curves.elasticOut),
      ),
    );
  }

  void _startAnimations() async {
    _animationController.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    _mapAnimationController.forward();
    await Future.delayed(const Duration(milliseconds: 800));
    _listController.forward();
  }

  void _loadData() async {
    // Simulation du chargement des données
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _prestataires = _generatePrestataires();
      _updateMarkers();
    });
  }

  List<PrestataireModel> _generatePrestataires() {
    return [
      PrestataireModel(
        id: 1,
        nom: 'Diallo',
        prenom: 'Amadou',
        telephone: '+221 77 123 4567',
        email: 'amadou.diallo@email.com',
        adresse: 'Plateau, Dakar',
        latitude: 14.7167,
        longitude: -17.4677,
        serviceType: 'Transport',
        rating: 4.8,
        nombreEvaluations: 156,
        prixParHeure: '2000 FCFA',
        experience: '5 ans',
        jobsCompletes: 89,
        statut: 'DISPONIBLE',
        typeService: 'A_DOMICILE',
        description:
            'Service de transport rapide et fiable dans toute la ville',
        imageProfil: 'assets/images/taxi_driver.jpg',
        dateCreation: DateTime.now(),
        dateModification: DateTime.now(),
      ),
      PrestataireModel(
        id: 2,
        nom: 'Ndiaye',
        prenom: 'Fatou',
        telephone: '+221 77 234 5678',
        email: 'fatou.ndiaye@email.com',
        adresse: 'Fann, Dakar',
        latitude: 14.7200,
        longitude: -17.4700,
        serviceType: 'Coiffure',
        rating: 4.9,
        nombreEvaluations: 89,
        prixParHeure: '5000 FCFA',
        experience: '8 ans',
        jobsCompletes: 156,
        statut: 'DISPONIBLE',
        typeService: 'A_DOMICILE',
        description: 'Expert en coiffures traditionnelles et modernes',
        imageProfil: 'assets/images/hairstylist.jpg',
        dateCreation: DateTime.now(),
        dateModification: DateTime.now(),
      ),
      PrestataireModel(
        id: 3,
        nom: 'Sarr',
        prenom: 'Moussa',
        telephone: '+221 77 345 6789',
        email: 'moussa.sarr@email.com',
        adresse: 'Almadies, Dakar',
        latitude: 14.7100,
        longitude: -17.4600,
        serviceType: 'Plomberie',
        rating: 4.7,
        nombreEvaluations: 203,
        prixParHeure: '8000 FCFA',
        experience: '10 ans',
        jobsCompletes: 234,
        statut: 'DISPONIBLE',
        typeService: 'A_DOMICILE',
        description: 'Réparations et installations de plomberie 24h/24',
        imageProfil: 'assets/images/plumber.jpg',
        dateCreation: DateTime.now(),
        dateModification: DateTime.now(),
      ),
      PrestataireModel(
        id: 4,
        nom: 'Diop',
        prenom: 'Marie',
        telephone: '+221 77 456 7890',
        email: 'marie.diop@email.com',
        adresse: 'Mermoz, Dakar',
        latitude: 14.7300,
        longitude: -17.4800,
        serviceType: 'Cuisine',
        rating: 4.6,
        nombreEvaluations: 127,
        prixParHeure: '3000 FCFA',
        experience: '6 ans',
        jobsCompletes: 78,
        statut: 'DISPONIBLE',
        typeService: 'A_DOMICILE',
        description: 'Cuisine africaine authentique et délicieuse',
        imageProfil: 'assets/images/chef.jpg',
        dateCreation: DateTime.now(),
        dateModification: DateTime.now(),
      ),
    ];
  }

  void _updateMarkers() {
    _markers.clear();

    // Marqueur pour la position actuelle
    _markers.add(
      Marker(
        markerId: const MarkerId('current_location'),
        position: _currentLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(
          title: 'Votre position',
          snippet: 'Position actuelle',
        ),
      ),
    );

    // Marqueurs pour les prestataires
    for (int i = 0; i < _prestataires.length; i++) {
      final prestataire = _prestataires[i];
      _markers.add(
        Marker(
          markerId: MarkerId('prestataire_$i'),
          position: LatLng(prestataire.latitude, prestataire.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            prestataire.statut == 'DISPONIBLE'
                ? BitmapDescriptor.hueGreen
                : BitmapDescriptor.hueOrange,
          ),
          infoWindow: InfoWindow(
            title: prestataire.nomComplet,
            snippet:
                '${prestataire.rating} ⭐ (${prestataire.nombreEvaluations} avis)',
          ),
        ),
      );
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    // _mapController = controller; // Pour usage futur
    // Le contrôleur peut être utilisé pour des fonctionnalités futures
  }

  void _toggleFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
    });

    // Trier les prestataires selon le filtre
    if (filter == 'Proximité') {
      _prestataires.sort((a, b) {
        final distanceA = a.calculateDistance(
          _currentLocation.latitude,
          _currentLocation.longitude,
        );
        final distanceB = b.calculateDistance(
          _currentLocation.latitude,
          _currentLocation.longitude,
        );
        return distanceA.compareTo(distanceB);
      });
    } else if (filter == 'Évaluation') {
      _prestataires.sort((a, b) => b.rating.compareTo(a.rating));
    }

    setState(() {});
  }

  // Map<String, double> _latLngToMap(LatLng latLng) => {'latitude': latLng.latitude, 'longitude': latLng.longitude}; // Pour usage futur

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: _isDarkMode
            ? Brightness.light
            : Brightness.dark,
        systemNavigationBarColor: _isDarkMode ? Colors.black : Colors.white,
        systemNavigationBarIconBrightness: _isDarkMode
            ? Brightness.light
            : Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: _isDarkMode ? Colors.grey[900] : Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // En-tête avec recherche
            _buildHeader(),

            // Carte Maps
            _buildMapSection(),

            // Filtres
            _buildFiltersSection(),

            // Liste des prestataires
            Expanded(child: _buildPrestatairesList()),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
      ),
    );
  }

  Widget _buildHeader() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _isDarkMode ? Colors.grey[850] : Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Barre supérieure
                    Row(
                      children: [
                        // Logo et salutation
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bonjour !',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: _isDarkMode
                                        ? Colors.white
                                        : Colors.grey[600],
                                  ),
                            ),
                            Text(
                              'Que souhaitez-vous faire ?',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    color: _isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),

                        const Spacer(),

                        // Boutons d'action
                        Row(
                          children: [
                            // Mode sombre
                            GestureDetector(
                              onTap: () {
                                setState(() => _isDarkMode = !_isDarkMode);
                              },
                              child: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: _isDarkMode
                                      ? AppTheme.primaryGreen
                                      : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  _isDarkMode
                                      ? Icons.light_mode
                                      : Icons.dark_mode,
                                  color: _isDarkMode
                                      ? Colors.white
                                      : Colors.grey[600],
                                ),
                              ),
                            ),

                            const SizedBox(width: 12),

                            // Notifications
                            NotificationIconWithBadge(
                              notificationCount: 3,
                              onTap: () {
                                // Navigation vers les notifications
                              },
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Barre de recherche
                    SearchBarWidget(
                      controller: TextEditingController(),
                      onChanged: (query) {
                        // Logique de recherche
                      },
                      onSearch: () {
                        // Logique de recherche
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMapSection() {
    return AnimatedBuilder(
      animation: _mapAnimationController,
      builder: (context, child) {
        return Container(
          height: 250,
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: _isLoading
                ? Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(color: Colors.white),
                  )
                : GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _currentLocation,
                      zoom: 15.0,
                    ),
                    markers: _markers,
                    mapType: MapType.normal,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                  ),
          ),
        );
      },
    );
  }

  Widget _buildFiltersSection() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(
            'Trier les résultats :',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: _isDarkMode ? Colors.white : Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Row(
              children: ['Proximité', 'Évaluation'].map((filter) {
                final isSelected = _selectedFilter == filter;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => _toggleFilter(filter),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primaryGreen
                            : (_isDarkMode
                                  ? Colors.grey[700]
                                  : Colors.grey[100]),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.primaryGreen
                              : Colors.transparent,
                        ),
                      ),
                      child: Text(
                        filter,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : (_isDarkMode ? Colors.white : Colors.grey[600]),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrestatairesList() {
    return AnimatedBuilder(
      animation: _listController,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.all(20),
          child: _isLoading
              ? _buildShimmerList()
              : AnimationLimiter(
                  child: ListView.builder(
                    itemCount: _prestataires.length,
                    itemBuilder: (context, index) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 600),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: PrestataireCard(
                              prestataire: _prestataires[index],
                              onTap: () {
                                // Navigation vers les détails du prestataire
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        );
      },
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _isDarkMode ? Colors.grey[800] : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: 100,
                            height: 12,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  height: 12,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Container(width: 200, height: 12, color: Colors.white),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _mapAnimationController.dispose();
    _listController.dispose();
    super.dispose();
  }
}
