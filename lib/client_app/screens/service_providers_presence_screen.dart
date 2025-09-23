import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../common/models/service.dart';
import '../../common/models/prestataire.dart';
import '../../common/services/prestataire_service.dart';
import 'booking_screen.dart';

class ServiceProvidersPresenceScreen extends StatefulWidget {
  final Service service;

  const ServiceProvidersPresenceScreen({super.key, required this.service});

  @override
  State<ServiceProvidersPresenceScreen> createState() =>
      _ServiceProvidersPresenceScreenState();
}

class _ServiceProvidersPresenceScreenState
    extends State<ServiceProvidersPresenceScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  List<Prestataire> _providers = [];
  List<Prestataire> _filteredProviders = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';

  // Géolocalisation
  double? _clientLatitude;
  double? _clientLongitude;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
    _initializeLocationAndProviders();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _initializeLocationAndProviders() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Obtenir la position du client
      await _getCurrentLocation();

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

  Future<void> _getCurrentLocation() async {
    try {
      print('🔍 Vérification des permissions de localisation...');
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Permissions de localisation refusées définitivement');
      }

      if (permission == LocationPermission.denied) {
        throw Exception('Permissions de localisation refusées');
      }

      print('📍 Début de la géolocalisation...');
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _clientLatitude = position.latitude;
        _clientLongitude = position.longitude;
      });

      print(
        '✅ Position récupérée: ${position.latitude}, ${position.longitude}',
      );
    } catch (e) {
      print('❌ Erreur géolocalisation: $e');
      rethrow;
    }
  }

  Future<void> _loadProviders() async {
    try {
      if (_clientLatitude == null || _clientLongitude == null) {
        throw Exception('Position client non disponible');
      }

      // Obtenir les prestataires disponibles pour le service "En présence"
      List<Prestataire> prestataires =
          await PrestataireService.getPrestatairesDisponibles(
            serviceType: widget.service.name,
            typeService: 'En présence',
            clientLatitude: _clientLatitude!,
            clientLongitude: _clientLongitude!,
            rayonKm: 20.0, // Rayon de 20km pour les services en présence
          );

      setState(() {
        _providers = prestataires;
        _filteredProviders = prestataires;
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

  void _filterProviders(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredProviders = _providers;
      } else {
        _filteredProviders = _providers.where((provider) {
          return provider.nomComplet.toLowerCase().contains(
                query.toLowerCase(),
              ) ||
              provider.serviceType.toLowerCase().contains(
                query.toLowerCase(),
              ) ||
              provider.description.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text('${widget.service.name} - En présence'),
        backgroundColor: const Color(0xFF065b32),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _initializeLocationAndProviders,
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                // Barre de recherche
                _buildSearchBar(),

                // Contenu principal
                Expanded(child: _buildContent()),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: TextField(
        onChanged: _filterProviders,
        decoration: InputDecoration(
          hintText: 'Rechercher un prestataire...',
          prefixIcon: const Icon(Icons.search, color: Color(0xFF065b32)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF065b32), width: 2),
          ),
          filled: true,
          fillColor: Colors.grey[50],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    if (_filteredProviders.isEmpty) {
      return _buildEmptyState();
    }

    return _buildProvidersList();
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF065b32)),
          ),
          const SizedBox(height: 16),
          const Text(
            'Recherche des prestataires disponibles...',
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Text(
            'Service: ${widget.service.name}',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              'Erreur',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _initializeLocationAndProviders,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF065b32),
                foregroundColor: Colors.white,
              ),
              child: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty
                ? 'Aucun prestataire disponible'
                : 'Aucun résultat trouvé',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isEmpty
                ? 'Aucun prestataire n\'est disponible pour ce service en présence dans votre zone'
                : 'Essayez avec d\'autres mots-clés',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _initializeLocationAndProviders,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF065b32),
              foregroundColor: Colors.white,
            ),
            child: const Text('Actualiser'),
          ),
        ],
      ),
    );
  }

  Widget _buildProvidersList() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _filteredProviders.length,
      itemBuilder: (context, index) {
        final provider = _filteredProviders[index];
        return Column(
          children: [
            if (index > 0) const SizedBox(height: 16),
            _buildProviderCard(provider: provider),
          ],
        );
      },
    );
  }

  Widget _buildProviderCard({required Prestataire provider}) {
    // Calculer la distance
    String distanceText = 'Distance inconnue';
    if (_clientLatitude != null && _clientLongitude != null) {
      double distance = provider.calculerDistance(
        _clientLatitude!,
        _clientLongitude!,
      );
      distanceText = '${distance.toStringAsFixed(1)} km';
    }

    // Calculer le temps de trajet estimé
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête du prestataire
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: const Color(0xFF065b32).withOpacity(0.1),
                child: Text(
                  provider.nomComplet[0],
                  style: const TextStyle(
                    color: Color(0xFF065b32),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider.nomComplet,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      provider.serviceType,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${provider.rating} (${provider.nombreEvaluations} avis)',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    provider.prixParHeure,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF065b32),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'En présence',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Informations de localisation
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.red, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  provider.adresse,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ),
              Text(
                distanceText,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Temps de trajet
          Row(
            children: [
              Icon(Icons.access_time, color: Colors.orange, size: 20),
              const SizedBox(width: 8),
              Text(
                timeText,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),

          if (provider.description.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              provider.description,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          const SizedBox(height: 16),

          // Action buttons
          Row(
            children: [
              // Bouton Réserver
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BookingScreen(
                          prestataire: provider,
                          serviceType: widget.service.name,
                          typeService: 'En présence',
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF065b32),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Réserver',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Bouton Voir profil
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Profil de ${provider.nomComplet}'),
                        backgroundColor: const Color(0xFF065b32),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF065b32)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Voir profil',
                      style: TextStyle(
                        color: Color(0xFF065b32),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
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
