import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../common/models/service.dart';
import '../../common/models/prestataire.dart';
import '../../common/services/prestataire_service.dart';
import 'provider_map_screen.dart';
import 'booking_screen.dart';

class ServiceProvidersScreen extends StatefulWidget {
  final Service service;

  const ServiceProvidersScreen({super.key, required this.service});

  @override
  State<ServiceProvidersScreen> createState() => _ServiceProvidersScreenState();
}

class _ServiceProvidersScreenState extends State<ServiceProvidersScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  final TextEditingController _searchController = TextEditingController();
  List<Prestataire> _allProviders = [];
  List<Prestataire> _filteredProviders = [];
  bool _isLoading = true;
  String _errorMessage = '';
  double? _clientLatitude;
  double? _clientLongitude;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    // Démarrer les animations
    _fadeController.forward();
    _slideController.forward();

    // Initialiser la géolocalisation et les prestataires
    _initializeLocationAndProviders();

    // Écouter les changements de recherche
    _searchController.addListener(_filterProviders);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _initializeLocationAndProviders() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      // Obtenir la position du client
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _clientLatitude = position.latitude;
      _clientLongitude = position.longitude;

      print('📍 Position client: $_clientLatitude, $_clientLongitude');

      // Charger les prestataires disponibles
      await _loadProviders();
    } catch (e) {
      print('❌ Erreur géolocalisation: $e');
      setState(() {
        _errorMessage =
            'Impossible d\'obtenir votre position. Vérifiez les permissions de localisation.';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadProviders() async {
    try {
      if (_clientLatitude == null || _clientLongitude == null) {
        setState(() {
          _errorMessage = 'Position non disponible';
          _isLoading = false;
        });
        return;
      }

      // Obtenir les prestataires disponibles pour le service "À domicile"
      List<Prestataire> prestataires =
          await PrestataireService.getPrestatairesDisponibles(
            serviceType: widget.service.name,
            typeService: 'À domicile',
            clientLatitude: _clientLatitude!,
            clientLongitude: _clientLongitude!,
            rayonKm: 15.0, // Rayon de 15km
          );

      setState(() {
        _allProviders = prestataires;
        _filteredProviders = List.from(_allProviders);
        _isLoading = false;
      });

      print('✅ ${prestataires.length} prestataires chargés');
    } catch (e) {
      print('❌ Erreur chargement prestataires: $e');
      setState(() {
        _errorMessage = 'Erreur lors du chargement des prestataires';
        _isLoading = false;
      });
    }
  }

  void _filterProviders() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredProviders = List.from(_allProviders);
      } else {
        _filteredProviders = _allProviders.where((provider) {
          return provider.nomComplet.toLowerCase().contains(query) ||
              provider.serviceType.toLowerCase().contains(query) ||
              provider.description.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  // Méthode pour obtenir l'icône du service
  Widget _getServiceIcon(String serviceName) {
    final name = serviceName.toLowerCase();
    if (name.contains('chaudronnier') || name.contains('métallurgie')) {
      return const Icon(Icons.build, size: 20, color: Colors.grey);
    }
    if (name.contains('plombier') || name.contains('plomberie')) {
      return const Icon(Icons.build, size: 20, color: Colors.grey);
    }
    if (name.contains('électricien') || name.contains('électricité')) {
      return const Icon(
        Icons.electrical_services,
        size: 20,
        color: Colors.grey,
      );
    }
    if (name.contains('mécanicien') || name.contains('mécanique')) {
      return const Icon(Icons.build, size: 20, color: Colors.grey);
    }
    if (name.contains('nettoyage') || name.contains('ménage')) {
      return const Icon(Icons.cleaning_services, size: 20, color: Colors.grey);
    }
    if (name.contains('cuisine') || name.contains('chef')) {
      return const Icon(Icons.restaurant, size: 20, color: Colors.grey);
    }
    if (name.contains('beauté') || name.contains('coiffure')) {
      return const Icon(Icons.face, size: 20, color: Colors.grey);
    }
    if (name.contains('jardinage') || name.contains('jardin')) {
      return const Icon(Icons.local_florist, size: 20, color: Colors.grey);
    }
    if (name.contains('peinture') || name.contains('peintre')) {
      return const Icon(Icons.format_paint, size: 20, color: Colors.grey);
    }
    if (name.contains('maçon') || name.contains('construction')) {
      return const Icon(Icons.construction, size: 20, color: Colors.grey);
    }
    if (name.contains('climatisation') || name.contains('froid')) {
      return const Icon(Icons.ac_unit, size: 20, color: Colors.grey);
    }
    if (name.contains('sécurité') || name.contains('gardiennage')) {
      return const Icon(Icons.security, size: 20, color: Colors.grey);
    }
    if (name.contains('transport') || name.contains('livraison')) {
      return const Icon(Icons.local_shipping, size: 20, color: Colors.grey);
    }
    if (name.contains('informatique') || name.contains('tech')) {
      return const Icon(Icons.computer, size: 20, color: Colors.grey);
    }
    if (name.contains('santé') || name.contains('médical')) {
      return const Icon(Icons.medical_services, size: 20, color: Colors.grey);
    }
    return const Icon(Icons.build, size: 20, color: Colors.grey);
  }

  // Méthode pour obtenir la description du service
  String _getServiceDescription(String serviceName) {
    final name = serviceName.toLowerCase();
    if (name.contains('chaudronnier') || name.contains('métallurgie')) {
      return 'Maintenance et Réparation';
    }
    if (name.contains('plombier') || name.contains('plomberie')) {
      return 'Installation et Réparation';
    }
    if (name.contains('électricien') || name.contains('électricité')) {
      return 'Installation et Maintenance';
    }
    if (name.contains('mécanicien') || name.contains('mécanique')) {
      return 'Réparation et Maintenance';
    }
    if (name.contains('nettoyage') || name.contains('ménage')) {
      return 'Nettoyage et Ménage';
    }
    if (name.contains('cuisine') || name.contains('chef')) {
      return 'Services Culinaires';
    }
    if (name.contains('beauté') || name.contains('coiffure')) {
      return 'Beauté et Coiffure';
    }
    if (name.contains('jardinage') || name.contains('jardin')) {
      return 'Entretien et Aménagement';
    }
    if (name.contains('peinture') || name.contains('peintre')) {
      return 'Peinture et Décoration';
    }
    if (name.contains('maçon') || name.contains('construction')) {
      return 'Maçonnerie et Construction';
    }
    if (name.contains('climatisation') || name.contains('froid')) {
      return 'Installation et Maintenance';
    }
    if (name.contains('sécurité') || name.contains('gardiennage')) {
      return 'Sécurité et Gardiennage';
    }
    if (name.contains('transport') || name.contains('livraison')) {
      return 'Transport et Livraison';
    }
    if (name.contains('informatique') || name.contains('tech')) {
      return 'Services Informatiques';
    }
    if (name.contains('santé') || name.contains('médical')) {
      return 'Services de Santé';
    }
    return 'Services Professionnels';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  // Header Section (Dark Green) - Full width to top
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 20,
                      left: 20,
                      right: 20,
                      bottom: 20,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xFF065b32), // Dark green
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Back button and title row
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.service.name,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.home_outlined,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 4),
                                      const Text(
                                        'À domicile',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _getServiceDescription(widget.service.name),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Map button
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  'Carte',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Search bar
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.search,
                                size: 20,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                  cursorColor: Colors.white,
                                  decoration: InputDecoration(
                                    hintText: 'Rechercher dans votre zone...',
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.tune,
                                size: 20,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Main Content Area (White)
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // Loading state
                          if (_isLoading)
                            Expanded(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xFF065b32),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Recherche de prestataires...',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else if (_errorMessage.isNotEmpty)
                            Expanded(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      size: 64,
                                      color: Colors.red[300],
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      _errorMessage,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.red[600],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed:
                                          _initializeLocationAndProviders,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF065b32,
                                        ),
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Text('Réessayer'),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else ...[
                            // Provider count
                            Row(
                              children: [
                                Text(
                                  '${_filteredProviders.length} prestataires trouvés',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Provider cards
                            Expanded(
                              child: _filteredProviders.isEmpty
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.search_off,
                                            size: 64,
                                            color: Colors.grey[400],
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'Aucun prestataire trouvé',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Essayez avec d\'autres mots-clés',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[500],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: _filteredProviders.length,
                                      itemBuilder: (context, index) {
                                        final provider =
                                            _filteredProviders[index];
                                        return Column(
                                          children: [
                                            if (index > 0)
                                              const SizedBox(height: 16),
                                            _buildProviderCard(
                                              provider: provider,
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProviderCard({required Prestataire provider}) {
    // Calculer la distance si on a la position du client
    String distanceText = 'Distance inconnue';
    if (_clientLatitude != null && _clientLongitude != null) {
      double distance = provider.calculerDistance(
        _clientLatitude!,
        _clientLongitude!,
      );
      distanceText = '${distance.toStringAsFixed(1)} km';
    }

    // Calculer le temps estimé (approximatif basé sur la distance)
    String timeText = 'Temps estimé';
    if (_clientLatitude != null && _clientLongitude != null) {
      double distance = provider.calculerDistance(
        _clientLatitude!,
        _clientLongitude!,
      );
      int minutes = (distance * 2).round(); // Approximation: 2 min par km
      timeText = '~$minutes min';
    }
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with icon and name
          Row(
            children: [
              _getServiceIcon(provider.serviceType),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider.nomComplet,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      _getServiceDescription(provider.serviceType),
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Rating, price, distance row
          Row(
            children: [
              Row(
                children: [
                  const Icon(Icons.star, size: 16, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(
                    provider.rating.toString(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Text(
                provider.prixParHeure,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                distanceText,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Location and time row
          Row(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 16,
                    color: Color(0xFF4CAF50),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      provider.adresse,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    timeText,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Experience and completed jobs
          Row(
            children: [
              Text(
                provider.experience,
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
              const SizedBox(width: 16),
              Text(
                '${provider.jobsCompletes} missions',
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Action buttons
          Row(
            children: [
              // Urgent button
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BookingScreen(
                          prestataire: provider,
                          serviceType: widget.service.name,
                          typeService: widget.service.name.contains('domicile')
                              ? 'À domicile'
                              : 'En présence',
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF065b32),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'Urgent',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Reserve button
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // Action pour réserver
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Réservation pour ${provider.nomComplet}',
                        ),
                        backgroundColor: const Color(0xFF065b32),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF065b32),
                        width: 2,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Réserver',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF065b32),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
