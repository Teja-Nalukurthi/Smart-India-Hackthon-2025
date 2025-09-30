import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../models/map_place.dart';
import '../../core/constants/app_constants.dart';

class MapService {
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api/place';
  static String get _apiKey => AppConstants.googleMapsApiKey;

  // For demo purposes, we'll use mock data if API key is not set
  static bool get _useMockData =>
      _apiKey.isEmpty || _apiKey == 'your_google_maps_api_key';

  /// Get nearby places based on location and type
  static Future<List<MapPlace>> getNearbyPlaces({
    required LatLng center,
    required PlaceType type,
    double radiusInMeters = 5000,
  }) async {
    if (_useMockData) {
      return _getMockPlaces(center, type);
    }

    try {
      final String typeQuery = _getSearchQuery(type);
      final url = Uri.parse(
        '$_baseUrl/nearbysearch/json?location=${center.latitude},${center.longitude}&radius=$radiusInMeters&type=$typeQuery&key=$_apiKey',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'] ?? [];

        return results
            .map((json) => MapPlace.fromJson(json))
            .where((place) => place.type == type)
            .take(20) // Limit results
            .toList();
      } else {
        throw Exception('Failed to fetch places: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching places: $e');
      // Fallback to mock data on error
      return _getMockPlaces(center, type);
    }
  }

  /// Search for places by text query
  static Future<List<MapPlace>> searchPlaces({
    required String query,
    LatLng? center,
    double radiusInMeters = 10000,
  }) async {
    if (_useMockData) {
      return _getMockSearchResults(query, center);
    }

    try {
      String url = '$_baseUrl/textsearch/json?query=$query&key=$_apiKey';

      if (center != null) {
        url +=
            '&location=${center.latitude},${center.longitude}&radius=$radiusInMeters';
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'] ?? [];

        return results.map((json) => MapPlace.fromJson(json)).take(20).toList();
      } else {
        throw Exception('Failed to search places: ${response.statusCode}');
      }
    } catch (e) {
      print('Error searching places: $e');
      return _getMockSearchResults(query, center);
    }
  }

  /// Get current user location
  static Future<LatLng> getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied');
      }

      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      print('Error getting current location: $e');
      // Return Puducherry as default location
      return const LatLng(11.9416, 79.8083);
    }
  }

  /// Check if location services are enabled
  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Check and request location permissions
  static Future<bool> checkLocationPermissions() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  /// Get all mock places as markers for map display
  static Future<Set<Marker>> getAllMarkersForMap() async {
    final allPlaces = getAllMockPlaces();
    final Set<Marker> markers = {};

    for (final place in allPlaces) {
      markers.add(
        Marker(
          markerId: MarkerId(place.id),
          position: place.position,
          icon: _getMarkerIcon(place.type),
          infoWindow: InfoWindow(title: place.name, snippet: place.description),
        ),
      );
    }

    return markers;
  }

  /// Get marker icon for place type
  static BitmapDescriptor _getMarkerIcon(PlaceType type) {
    switch (type) {
      case PlaceType.artisan:
        return BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueViolet,
        );
      case PlaceType.touristSpot:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      case PlaceType.localFood:
        return BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueYellow,
        );
    }
  }

  /// Get all mock places for feed integration
  static List<MapPlace> getAllMockPlaces() {
    const pondicherryCenter = LatLng(11.9416, 79.8083);
    final allPlaces = <MapPlace>[];

    // Get all place types
    for (final type in PlaceType.values) {
      allPlaces.addAll(_getMockPlaces(pondicherryCenter, type));
    }

    return allPlaces;
  }

  /// Get search query string for different place types
  static String _getSearchQuery(PlaceType type) {
    switch (type) {
      case PlaceType.artisan:
        return 'art_gallery'; // Closest match in Google Places API
      case PlaceType.touristSpot:
        return 'tourist_attraction';
      case PlaceType.localFood:
        return 'store'; // Changed to show local shops instead of restaurants
    }
  }

  /// Mock data for development/demo purposes - ALL PLACES IN PONDICHERRY
  static List<MapPlace> _getMockPlaces(LatLng center, PlaceType type) {
    final List<MapPlace> allMockPlaces = [
      // Artisans in Pondicherry area (all coordinates around 11.94, 79.80)
      MapPlace(
        id: 'artisan_1',
        name: 'Ravi Traditional Pottery Studio',
        description:
            'Master potter creating beautiful earthenware using centuries-old techniques. Learn the art of clay shaping and glazing in this authentic Pondicherry workshop.',
        position: const LatLng(11.9356, 79.8256),
        type: PlaceType.artisan,
        imageUrl:
            'https://images.unsplash.com/photo-1578662996442-48f60103fc96?ixlib=rb-4.0.3&w=800',
        rating: 4.8,
        reviewCount: 124,
        address: 'Mission Street, French Quarter, Pondicherry',
        phoneNumber: '+91-413-2334567',
        openingHours: ['Mon-Sat: 9:00 AM - 6:00 PM', 'Sun: 10:00 AM - 4:00 PM'],
        website: 'www.ravipottery.com',
      ),
      MapPlace(
        id: 'artisan_2',
        name: 'Marie\'s Colonial Furniture Restoration',
        description:
            'Expert restoration of French colonial furniture and antiques using traditional techniques',
        position: const LatLng(11.9440, 79.8150),
        type: PlaceType.artisan,
        imageUrl:
            'https://images.unsplash.com/photo-1559827260-dc66d52bef19?ixlib=rb-4.0.3&w=800',
        rating: 4.7,
        reviewCount: 18,
        address: 'Heritage Quarter, Pondicherry',
        phoneNumber: '+91-413-2334568',
      ),
      MapPlace(
        id: 'artisan_3',
        name: 'Lakshmi Handloom Weaving Center',
        description:
            'Traditional Tamil handloom weaving creating beautiful cotton textiles and khadi cloth',
        position: const LatLng(11.9480, 79.8090),
        type: PlaceType.artisan,
        imageUrl:
            'https://images.unsplash.com/photo-1584464491033-06628f3a6b7b?ixlib=rb-4.0.3&w=800',
        rating: 4.6,
        reviewCount: 32,
        address: 'Tamil Quarter, Pondicherry',
        phoneNumber: '+91-413-2334569',
      ),
      MapPlace(
        id: 'artisan_4',
        name: 'Karthik Brass Works',
        description:
            'Traditional brass and copper utensil crafting using ancient South Indian techniques',
        position: const LatLng(11.9380, 79.8180),
        type: PlaceType.artisan,
        imageUrl:
            'https://images.unsplash.com/photo-1567016376408-0226e4d0c1ea?ixlib=rb-4.0.3&w=800',
        rating: 4.5,
        reviewCount: 41,
        address: 'Craft Street, Pondicherry',
        phoneNumber: '+91-413-2334570',
      ),
      MapPlace(
        id: 'artisan_5',
        name: 'Sundari Jewelry Workshop',
        description:
            'Handcrafted traditional Tamil jewelry using silver and precious stones in French colonial setting',
        position: const LatLng(11.9320, 79.8220),
        type: PlaceType.artisan,
        imageUrl:
            'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?ixlib=rb-4.0.3&w=800',
        rating: 4.9,
        reviewCount: 67,
        address: 'Jeweler Street, French Quarter, Pondicherry',
        phoneNumber: '+91-413-2334571',
      ),
      MapPlace(
        id: 'artisan_6',
        name: 'Auroville Art & Craft Center',
        description:
            'Contemporary and traditional art workshop combining international and local techniques',
        position: const LatLng(11.9500, 79.8000),
        type: PlaceType.artisan,
        imageUrl:
            'https://images.unsplash.com/photo-1609081219090-a6d81d3085bf?ixlib=rb-4.0.3&w=800',
        rating: 4.4,
        reviewCount: 29,
        address: 'Near Auroville, Pondicherry',
        phoneNumber: '+91-413-2334572',
      ),

      // Tourist Spots in Pondicherry area
      MapPlace(
        id: 'tourist_1',
        name: 'Sri Aurobindo Ashram',
        description:
            'Famous spiritual center founded by Sri Aurobindo and The Mother, a place of peace and meditation',
        position: const LatLng(11.9350, 79.8300),
        type: PlaceType.touristSpot,
        imageUrl:
            'https://images.unsplash.com/photo-1580931657346-6e6af8b94315?ixlib=rb-4.0.3&w=800',
        rating: 4.6,
        reviewCount: 2150,
        address: 'Rue de la Marine, French Quarter, Pondicherry',
        phoneNumber: '+91-413-2233656',
      ),
      MapPlace(
        id: 'tourist_2',
        name: 'Promenade Beach',
        description:
            'Beautiful seaside promenade perfect for evening walks with French colonial architecture backdrop',
        position: const LatLng(11.9270, 79.8370),
        type: PlaceType.touristSpot,
        imageUrl:
            'https://images.unsplash.com/photo-1539650116574-75c0c6d68137?ixlib=rb-4.0.3&w=800',
        rating: 4.5,
        reviewCount: 890,
        address: 'Beach Road, Pondicherry',
      ),
      MapPlace(
        id: 'tourist_3',
        name: 'Pondicherry Museum',
        description:
            'Museum showcasing local history, French colonial artifacts, and cultural heritage of Pondicherry',
        position: const LatLng(11.9380, 79.8280),
        type: PlaceType.touristSpot,
        imageUrl:
            'https://images.unsplash.com/photo-1566127992631-137a642a90f4?ixlib=rb-4.0.3&w=800',
        rating: 4.2,
        reviewCount: 456,
        address: 'St. Louis Street, Pondicherry',
      ),
      MapPlace(
        id: 'tourist_4',
        name: 'Basilica of the Sacred Heart of Jesus',
        description:
            'Beautiful Gothic church with stunning architecture and peaceful atmosphere for prayer and reflection',
        position: const LatLng(11.9400, 79.8240),
        type: PlaceType.touristSpot,
        imageUrl:
            'https://images.unsplash.com/photo-1520637836862-4d197d17c838?ixlib=rb-4.0.3&w=800',
        rating: 4.4,
        reviewCount: 678,
        address: 'Mission Street, Pondicherry',
      ),
      MapPlace(
        id: 'tourist_5',
        name: 'Paradise Beach',
        description:
            'Pristine golden sand beach accessible by boat, perfect for swimming and water sports',
        position: const LatLng(11.9180, 79.8450),
        type: PlaceType.touristSpot,
        imageUrl:
            'https://images.unsplash.com/photo-1544551763-46a013bb70d5?ixlib=rb-4.0.3&w=800',
        rating: 4.3,
        reviewCount: 1240,
        address: 'Paradise Beach Road, Pondicherry',
      ),
      MapPlace(
        id: 'tourist_6',
        name: 'Auroville Matrimandir',
        description:
            'Iconic golden meditation dome surrounded by beautiful gardens in the international township',
        position: const LatLng(11.9550, 79.8100),
        type: PlaceType.touristSpot,
        imageUrl:
            'https://images.unsplash.com/photo-1582407947304-fd86f028f716?ixlib=rb-4.0.3&w=800',
        rating: 4.7,
        reviewCount: 2890,
        address: 'Auroville, Pondicherry',
      ),
      MapPlace(
        id: 'tourist_7',
        name: 'French War Memorial',
        description:
            'Historic monument commemorating French soldiers, showcasing colonial heritage',
        position: const LatLng(11.9290, 79.8350),
        type: PlaceType.touristSpot,
        imageUrl:
            'https://images.unsplash.com/photo-1553913861-c0fddf2619e1?ixlib=rb-4.0.3&w=800',
        rating: 4.1,
        reviewCount: 234,
        address: 'Beach Road, French Quarter, Pondicherry',
      ),
      MapPlace(
        id: 'tourist_8',
        name: 'Bharathi Park',
        description:
            'Charming park in the heart of French Quarter with colonial architecture and peaceful walking paths',
        position: const LatLng(11.9360, 79.8290),
        type: PlaceType.touristSpot,
        imageUrl:
            'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?ixlib=rb-4.0.3&w=800',
        rating: 4.0,
        reviewCount: 567,
        address: 'Government Square, French Quarter, Pondicherry',
      ),

      // Local Food Shops (NOT restaurants) in Pondicherry
      MapPlace(
        id: 'food_1',
        name: 'Ananda Bhavan Sweets',
        description:
            'Traditional South Indian sweets and snacks shop famous for authentic Pondicherry laddu and murukku',
        position: const LatLng(11.9420, 79.8200),
        type: PlaceType.localFood,
        imageUrl:
            'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?ixlib=rb-4.0.3&w=800',
        rating: 4.6,
        reviewCount: 234,
        address: 'MG Road, Pondicherry',
        phoneNumber: '+91-413-2336789',
      ),
      MapPlace(
        id: 'food_2',
        name: 'French Colony Bakery',
        description:
            'Authentic French pastries and bread shop maintaining colonial baking traditions since 1960',
        position: const LatLng(11.9340, 79.8280),
        type: PlaceType.localFood,
        imageUrl:
            'https://images.unsplash.com/photo-1555507036-ab794f575c5f?ixlib=rb-4.0.3&w=800',
        rating: 4.8,
        reviewCount: 456,
        address: 'Suffren Street, French Quarter, Pondicherry',
        phoneNumber: '+91-413-2337890',
      ),
      MapPlace(
        id: 'food_3',
        name: 'Coconut Lagoon Fresh Coconut Shop',
        description:
            'Fresh tender coconut water and coconut-based traditional drinks and snacks',
        position: const LatLng(11.9260, 79.8340),
        type: PlaceType.localFood,
        imageUrl:
            'https://images.unsplash.com/photo-1447933601403-0c6688de566e?ixlib=rb-4.0.3&w=800',
        rating: 4.4,
        reviewCount: 189,
        address: 'Beach Road, Pondicherry',
        phoneNumber: '+91-413-2338901',
      ),
      MapPlace(
        id: 'food_4',
        name: 'Pondicherry Spice Market',
        description:
            'Traditional spice shop offering authentic South Indian spices, masalas, and cooking ingredients',
        position: const LatLng(11.9460, 79.8160),
        type: PlaceType.localFood,
        imageUrl:
            'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?ixlib=rb-4.0.3&w=800',
        rating: 4.5,
        reviewCount: 123,
        address: 'Market Street, Tamil Quarter, Pondicherry',
        phoneNumber: '+91-413-2339012',
      ),
      MapPlace(
        id: 'food_5',
        name: 'Grand Bazaar Local Grocery',
        description:
            'Traditional local grocery shop with fresh vegetables, regional specialties, and homemade pickles',
        position: const LatLng(11.9400, 79.8190),
        type: PlaceType.localFood,
        imageUrl:
            'https://images.unsplash.com/photo-1542838132-92c53300491e?ixlib=rb-4.0.3&w=800',
        rating: 4.3,
        reviewCount: 67,
        address: 'Grand Bazaar Street, Pondicherry',
        phoneNumber: '+91-413-2340123',
      ),
      MapPlace(
        id: 'food_6',
        name: 'Auroville Organic Farm Shop',
        description:
            'Organic vegetables, fruits, and healthy food products from Auroville community farms',
        position: const LatLng(11.9520, 79.8120),
        type: PlaceType.localFood,
        imageUrl:
            'https://images.unsplash.com/photo-1506976785307-8732e854ad03?ixlib=rb-4.0.3&w=800',
        rating: 4.7,
        reviewCount: 345,
        address: 'Auroville Road, Pondicherry',
        phoneNumber: '+91-413-2341234',
      ),
      MapPlace(
        id: 'food_7',
        name: 'Tamil Traditional Tea Stall',
        description:
            'Authentic South Indian tea and coffee with traditional snacks like vadai and bondas',
        position: const LatLng(11.9480, 79.8080),
        type: PlaceType.localFood,
        imageUrl:
            'https://images.unsplash.com/photo-1571934811356-5cc061b6821f?ixlib=rb-4.0.3&w=800',
        rating: 4.2,
        reviewCount: 89,
        address: 'Old Bus Stand, Tamil Quarter, Pondicherry',
        phoneNumber: '+91-413-2342345',
      ),
      MapPlace(
        id: 'food_8',
        name: 'Heritage Sweet House',
        description:
            'Family-run sweet shop specializing in traditional Pondicherry sweets and French-inspired desserts',
        position: const LatLng(11.9320, 79.8230),
        type: PlaceType.localFood,
        imageUrl:
            'https://images.unsplash.com/photo-1518047601542-79f18c655718?ixlib=rb-4.0.3&w=800',
        rating: 4.6,
        reviewCount: 201,
        address: 'Heritage Street, French Quarter, Pondicherry',
        phoneNumber: '+91-413-2343456',
      ),
    ];

    // Filter by type and return places within reasonable distance
    return allMockPlaces.where((place) => place.type == type).where((place) {
      final distance = Geolocator.distanceBetween(
        center.latitude,
        center.longitude,
        place.position.latitude,
        place.position.longitude,
      );
      return distance <= 50000; // 50km radius for demo
    }).toList();
  }

  /// Mock search results for development
  static List<MapPlace> _getMockSearchResults(String query, LatLng? center) {
    final allPlaces = [
      ..._getMockPlaces(
        center ?? const LatLng(11.9416, 79.8083),
        PlaceType.artisan,
      ),
      ..._getMockPlaces(
        center ?? const LatLng(11.9416, 79.8083),
        PlaceType.touristSpot,
      ),
      ..._getMockPlaces(
        center ?? const LatLng(11.9416, 79.8083),
        PlaceType.localFood,
      ),
    ];

    // Simple text search in name and description
    final searchQuery = query.toLowerCase();
    return allPlaces
        .where(
          (place) =>
              place.name.toLowerCase().contains(searchQuery) ||
              place.description.toLowerCase().contains(searchQuery),
        )
        .take(10)
        .toList();
  }
}
