import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../../common/models/service.dart';

class ProviderMapScreen extends StatefulWidget {
  final Service service;
  final Map<String, dynamic> provider;

  const ProviderMapScreen({
    super.key,
    required this.service,
    required this.provider,
  });

  @override
  State<ProviderMapScreen> createState() => _ProviderMapScreenState();
}

class _ProviderMapScreenState extends State<ProviderMapScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  GoogleMapController? _mapController;
  LatLng? _clientLocation;
  LatLng? _providerLocation;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  bool _isReserveHovered = false;

  // Variables pour la géolocalisation et le calcul d'itinéraire
  String _estimatedTime = 'Calcul...';
  String _estimatedDistance = 'Calcul...';
  List<LatLng> _routePoints = [];
  Timer? _locationTimer;
  static const String _googleMapsApiKey =
      'AIzaSyD2jkqjACY7AcOledA2Tf92dsodQUin8u4';

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

    // Initialiser les positions (simulées pour l'exemple)
    _initializeLocations();
  }

  void _initializeLocations() async {
    // Obtenir la vraie position du client via GPS
    await _getCurrentLocation();

    // Vérifier si le widget est encore monté avant de continuer
    if (!mounted) return;

    // Position du prestataire (simulée selon le prestataire)
    switch (widget.provider['name']) {
      case 'Jean Dupont':
        _providerLocation = const LatLng(48.8576, 2.3532);
        break;
      case 'Marie Laurent':
        _providerLocation = const LatLng(48.8556, 2.3512);
        break;
      case 'Ahmed Benali':
        _providerLocation = const LatLng(48.8586, 2.3542);
        break;
      default:
        _providerLocation = const LatLng(48.8576, 2.3532);
    }

    _createMarkersAndPolylines();

    // Démarrer le suivi en temps réel
    _startRealTimeLocationTracking();

    // Calculer l'itinéraire initial
    _calculateRoute();
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Demander la permission de localisation
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Si la permission est refusée, utiliser une position par défaut
          _clientLocation = const LatLng(48.8566, 2.3522); // Paris par défaut
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Si la permission est définitivement refusée, utiliser une position par défaut
        _clientLocation = const LatLng(48.8566, 2.3522); // Paris par défaut
        return;
      }

      // Obtenir la position actuelle
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _clientLocation = LatLng(position.latitude, position.longitude);
    } catch (e) {
      // En cas d'erreur, utiliser une position par défaut
      _clientLocation = const LatLng(48.8566, 2.3522); // Paris par défaut
    }
  }

  void _createMarkersAndPolylines() {
    if (_clientLocation != null && _providerLocation != null && mounted) {
      // Utiliser la position simulée du prestataire pour le mouvement en temps réel
      final currentProviderLocation = _getSimulatedProviderLocation();

      setState(() {
        _markers = {
          // Marqueur du client (comme Yango - point bleu)
          Marker(
            markerId: const MarkerId('client'),
            position: _clientLocation!,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueBlue,
            ),
            infoWindow: const InfoWindow(
              title: 'Votre position',
              snippet: 'Vous êtes ici',
            ),
          ),
          // Marqueur du prestataire (comme Yango - point vert avec photo)
          Marker(
            markerId: MarkerId(widget.provider['name']),
            position: currentProviderLocation,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen,
            ),
            infoWindow: InfoWindow(
              title: widget.provider['name'],
              snippet: 'Prestataire disponible - $_estimatedTime',
            ),
          ),
        };

        // Ligne de trajectoire avec l'itinéraire calculé
        List<LatLng> routePoints = _routePoints.isNotEmpty
            ? _routePoints
            : [_clientLocation!, currentProviderLocation];

        _polylines = {
          Polyline(
            polylineId: const PolylineId('trajectory'),
            points: routePoints,
            color: const Color(0xFF4CAF50),
            width: 5,
            patterns: _routePoints.isNotEmpty
                ? [] // Ligne continue pour l'itinéraire réel
                : [], // Ligne continue par défaut
          ),
        };
      });
    }
  }

  void _fitMapToMarkers() {
    if (_mapController != null &&
        _clientLocation != null &&
        _providerLocation != null) {
      // Calculer les limites pour inclure les deux marqueurs
      double minLat = _clientLocation!.latitude < _providerLocation!.latitude
          ? _clientLocation!.latitude
          : _providerLocation!.latitude;
      double maxLat = _clientLocation!.latitude > _providerLocation!.latitude
          ? _clientLocation!.latitude
          : _providerLocation!.latitude;
      double minLng = _clientLocation!.longitude < _providerLocation!.longitude
          ? _clientLocation!.longitude
          : _providerLocation!.longitude;
      double maxLng = _clientLocation!.longitude > _providerLocation!.longitude
          ? _clientLocation!.longitude
          : _providerLocation!.longitude;

      _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(minLat - 0.01, minLng - 0.01),
            northeast: LatLng(maxLat + 0.01, maxLng + 0.01),
          ),
          100.0, // padding
        ),
      );
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _locationTimer?.cancel();
    super.dispose();
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

  // Méthode pour démarrer la géolocalisation en temps réel
  void _startRealTimeLocationTracking() {
    _locationTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted) {
        _getCurrentLocation();
        _calculateRoute();
      }
    });
  }

  // Méthode pour calculer l'itinéraire entre client et prestataire
  Future<void> _calculateRoute() async {
    if (_clientLocation == null || _providerLocation == null) return;

    try {
      final String url =
          'https://maps.googleapis.com/maps/api/directions/json?'
          'origin=${_clientLocation!.latitude},${_clientLocation!.longitude}&'
          'destination=${_providerLocation!.latitude},${_providerLocation!.longitude}&'
          'key=$_googleMapsApiKey&'
          'mode=driving&'
          'traffic_model=best_guess&'
          'departure_time=now';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' && data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          final leg = route['legs'][0];

          // Calculer le temps et la distance
          final duration = leg['duration']['text'];
          final distance = leg['distance']['text'];

          // Extraire les points de l'itinéraire
          final points = route['overview_polyline']['points'];
          _routePoints = _decodePolyline(points);

          if (mounted) {
            setState(() {
              _estimatedTime = duration;
              _estimatedDistance = distance;
              _createMarkersAndPolylines();
            });
          }
        }
      }
    } catch (e) {
      print('Erreur lors du calcul de l\'itinéraire: $e');
    }
  }

  // Méthode pour décoder la polyline de Google Maps
  List<LatLng> _decodePolyline(String polyline) {
    List<LatLng> points = [];
    int index = 0;
    int lat = 0;
    int lng = 0;

    while (index < polyline.length) {
      int b, shift = 0, result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  // Méthode pour calculer la distance entre deux points
  double _calculateDistance(LatLng point1, LatLng point2) {
    return Geolocator.distanceBetween(
      point1.latitude,
      point1.longitude,
      point2.latitude,
      point2.longitude,
    );
  }

  // Méthode pour obtenir la position simulée du prestataire (en temps réel)
  LatLng _getSimulatedProviderLocation() {
    // Simulation de mouvement du prestataire
    final baseLocation = _providerLocation ?? const LatLng(48.8576, 2.3532);
    final random = DateTime.now().millisecondsSinceEpoch % 1000;
    final offset = (random - 500) / 100000.0; // Petit décalage

    return LatLng(
      baseLocation.latitude + offset,
      baseLocation.longitude + offset,
    );
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
              child: Stack(
                children: [
                  // Map section - Full screen
                  Positioned.fill(
                    child: _clientLocation != null && _providerLocation != null
                        ? GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: _clientLocation!,
                              zoom: 15.0,
                            ),
                            markers: _markers,
                            polylines: _polylines,
                            onMapCreated: (GoogleMapController controller) {
                              _mapController = controller;
                              _fitMapToMarkers();
                            },
                            mapType: MapType.normal,
                            myLocationEnabled: true,
                            myLocationButtonEnabled: false,
                            zoomControlsEnabled: false,
                            mapToolbarEnabled: false,
                            compassEnabled: false,
                          )
                        : const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 16),
                                Text(
                                  'Chargement de la carte...',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),

                  // Back button - Floating on top
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 20,
                    left: 20,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                  ),

                  // Main Content Area - Carte blanche en bas - Floating
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Provider info header - Exactement comme l'image
                          Row(
                            children: [
                              // Provider icon (cercle vert foncé avec icône blanche)
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF065b32),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: _getServiceIcon(widget.service.name),
                              ),
                              const SizedBox(width: 16),
                              // Provider details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.provider['name'],
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          size: 12,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 4),
                                        const Text(
                                          'Liberté 6. Dakar - Sénégal',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Temps et distance estimés
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF065b32),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Temps estimé',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    Text(
                                      _estimatedTime,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text(
                                      'Distance',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    Text(
                                      _estimatedDistance,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Action buttons - À l'intérieur de la carte blanche
                          Column(
                            children: [
                              // Second row: Order button (full width)
                              Container(
                                width: double.infinity,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF065b32),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Commander',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              // Third row: Reserve button (full width)
                              GestureDetector(
                                onTapDown: (_) {
                                  setState(() {
                                    _isReserveHovered = true;
                                  });
                                },
                                onTapUp: (_) {
                                  setState(() {
                                    _isReserveHovered = false;
                                  });
                                },
                                onTapCancel: () {
                                  setState(() {
                                    _isReserveHovered = false;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: double.infinity,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: _isReserveHovered
                                        ? const Color(0xFF065b32)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFF065b32),
                                      width: 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Réserver',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: _isReserveHovered
                                            ? Colors.white
                                            : const Color(0xFF065b32),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
}
