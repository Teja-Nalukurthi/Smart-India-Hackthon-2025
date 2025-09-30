import 'package:google_maps_flutter/google_maps_flutter.dart';

enum PlaceType {
  artisan('Artisan', 'Skilled craftspeople and artists'),
  touristSpot('Tourist Spot', 'Popular attractions and landmarks'),
  localFood('Local Shops', 'Local shops, markets, and traditional vendors');

  const PlaceType(this.label, this.description);

  final String label;
  final String description;
}

class MapPlace {
  final String id;
  final String name;
  final String description;
  final LatLng position;
  final PlaceType type;
  final String? imageUrl;
  final double? rating;
  final int? reviewCount;
  final String? address;
  final String? phoneNumber;
  final List<String>? openingHours;
  final String? website;
  final Map<String, dynamic>? additionalInfo;

  const MapPlace({
    required this.id,
    required this.name,
    required this.description,
    required this.position,
    required this.type,
    this.imageUrl,
    this.rating,
    this.reviewCount,
    this.address,
    this.phoneNumber,
    this.openingHours,
    this.website,
    this.additionalInfo,
  });

  factory MapPlace.fromJson(Map<String, dynamic> json) {
    return MapPlace(
      id: json['place_id'] ?? json['id'],
      name: json['name'],
      description: json['description'] ?? 'No description available',
      position: LatLng(
        json['geometry']['location']['lat'],
        json['geometry']['location']['lng'],
      ),
      type: _getPlaceTypeFromJson(json),
      imageUrl: _getImageUrl(json),
      rating: json['rating']?.toDouble(),
      reviewCount: json['user_ratings_total'],
      address: json['formatted_address'] ?? json['vicinity'],
      phoneNumber: json['formatted_phone_number'],
      openingHours: _getOpeningHours(json),
      website: json['website'],
      additionalInfo: json['additional_info'],
    );
  }

  static PlaceType _getPlaceTypeFromJson(Map<String, dynamic> json) {
    final types = List<String>.from(json['types'] ?? []);

    // Check for food-related types
    if (types.any(
      (type) => [
        'restaurant',
        'food',
        'meal_takeaway',
        'meal_delivery',
        'street_vendor',
        'cafe',
        'bakery',
      ].contains(type),
    )) {
      return PlaceType.localFood;
    }

    // Check for tourist attraction types
    if (types.any(
      (type) => [
        'tourist_attraction',
        'museum',
        'art_gallery',
        'park',
        'church',
        'temple',
        'mosque',
        'monument',
        'zoo',
        'aquarium',
      ].contains(type),
    )) {
      return PlaceType.touristSpot;
    }

    // Default to artisan for craft/art related places
    return PlaceType.artisan;
  }

  static String? _getImageUrl(Map<String, dynamic> json) {
    if (json['photos'] != null && json['photos'].isNotEmpty) {
      final photoReference = json['photos'][0]['photo_reference'];
      // Note: In a real implementation, you'd construct the full photo URL
      // using the Google Places Photo API with your API key
      return 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=YOUR_API_KEY';
    }
    return null;
  }

  static List<String>? _getOpeningHours(Map<String, dynamic> json) {
    if (json['opening_hours'] != null &&
        json['opening_hours']['weekday_text'] != null) {
      return List<String>.from(json['opening_hours']['weekday_text']);
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'position': {'lat': position.latitude, 'lng': position.longitude},
      'type': type.name,
      'imageUrl': imageUrl,
      'rating': rating,
      'reviewCount': reviewCount,
      'address': address,
      'phoneNumber': phoneNumber,
      'openingHours': openingHours,
      'website': website,
      'additionalInfo': additionalInfo,
    };
  }

  @override
  String toString() {
    return 'MapPlace(id: $id, name: $name, type: ${type.label}, position: $position)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MapPlace && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
