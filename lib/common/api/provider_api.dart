import 'api_service.dart';

class Provider {
  final int id;
  final String name;
  final String serviceType;
  final double rating;
  final String price;
  final String distance;
  final String location;
  final String time;
  final String profileImage;
  final String phone;
  final String experience;
  final int completedJobs;
  final double latitude;
  final double longitude;

  Provider({
    required this.id,
    required this.name,
    required this.serviceType,
    required this.rating,
    required this.price,
    required this.distance,
    required this.location,
    required this.time,
    required this.profileImage,
    required this.phone,
    required this.experience,
    required this.completedJobs,
    required this.latitude,
    required this.longitude,
  });

  factory Provider.fromJson(Map<String, dynamic> json) {
    return Provider(
      id: json['id'],
      name: json['name'],
      serviceType: json['serviceType'],
      rating: json['rating'].toDouble(),
      price: json['price'],
      distance: json['distance'],
      location: json['location'],
      time: json['time'],
      profileImage: json['profileImage'],
      phone: json['phone'],
      experience: json['experience'],
      completedJobs: json['completedJobs'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'serviceType': serviceType,
      'rating': rating,
      'price': price,
      'distance': distance,
      'location': location,
      'time': time,
      'profileImage': profileImage,
      'phone': phone,
      'experience': experience,
      'completedJobs': completedJobs,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class ProviderApi {
  // Récupérer tous les prestataires
  static Future<List<Provider>> getAllProviders() async {
    try {
      final response = await ApiService.get('/providers');
      final List<dynamic> providersData = response['data'] ?? [];

      return providersData.map((json) => Provider.fromJson(json)).toList();
    } catch (e) {
      // En cas d'erreur, retourner les prestataires par défaut
      return _getDefaultProviders();
    }
  }

  // Récupérer les prestataires par service
  static Future<List<Provider>> getProvidersByService(int serviceId) async {
    try {
      final response = await ApiService.get('/providers/service/$serviceId');
      final List<dynamic> providersData = response['data'] ?? [];

      return providersData.map((json) => Provider.fromJson(json)).toList();
    } catch (e) {
      return _getDefaultProviders();
    }
  }

  // Récupérer les prestataires proches
  static Future<List<Provider>> getNearbyProviders(
    double latitude,
    double longitude,
    double radius,
  ) async {
    try {
      final response = await ApiService.get(
        '/providers/nearby?lat=$latitude&lng=$longitude&radius=$radius',
      );
      final List<dynamic> providersData = response['data'] ?? [];

      return providersData.map((json) => Provider.fromJson(json)).toList();
    } catch (e) {
      return _getDefaultProviders();
    }
  }

  // Prestataires par défaut (fallback)
  static List<Provider> _getDefaultProviders() {
    return [
      Provider(
        id: 1,
        name: 'Jean Dupont',
        serviceType: 'Installation et Réparation',
        rating: 4.8,
        price: '25 F CFA/h',
        distance: '1.2km',
        location: '2.5 km',
        time: '15 min',
        profileImage: 'assets/images/jean_dupont.jpg',
        phone: '+33 6 12 34 56 78',
        experience: '5 ans d\'expérience',
        completedJobs: 127,
        latitude: 48.8576,
        longitude: 2.3532,
      ),
      Provider(
        id: 2,
        name: 'Marie Laurent',
        serviceType: 'Installation et Réparation',
        rating: 4.9,
        price: '30 F CFA/h',
        distance: '2.1km',
        location: '2.5 km',
        time: '15 min',
        profileImage: 'assets/images/marie_laurent.jpg',
        phone: '+33 6 23 45 67 89',
        experience: '8 ans d\'expérience',
        completedJobs: 203,
        latitude: 48.8556,
        longitude: 2.3512,
      ),
      Provider(
        id: 3,
        name: 'Ahmed Benali',
        serviceType: 'Installation et Réparation',
        rating: 4.7,
        price: '28 F CFA/h',
        distance: '1.8km',
        location: '2.5 km',
        time: '15 min',
        profileImage: 'assets/images/ahmed_benali.jpg',
        phone: '+33 6 34 56 78 90',
        experience: '3 ans d\'expérience',
        completedJobs: 89,
        latitude: 48.8586,
        longitude: 2.3542,
      ),
    ];
  }
}
