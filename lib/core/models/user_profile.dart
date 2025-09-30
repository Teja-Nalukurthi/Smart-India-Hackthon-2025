class UserProfile {
  final String id;
  final String email;
  final String fullName;
  final String? avatarUrl;
  final String? phoneNumber;
  final String? location;
  final String? bio;
  final UserRole role;
  final bool isVerified;
  final double? latitude;
  final double? longitude;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.id,
    required this.email,
    required this.fullName,
    this.avatarUrl,
    this.phoneNumber,
    this.location,
    this.bio,
    required this.role,
    required this.isVerified,
    this.latitude,
    this.longitude,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      email: json['email'],
      fullName: json['full_name'],
      avatarUrl: json['avatar_url'],
      phoneNumber: json['phone_number'],
      location: json['location'],
      bio: json['bio'],
      role: UserRole.values.firstWhere(
        (e) => e.toString().split('.').last == json['role'],
        orElse: () => UserRole.customer,
      ),
      isVerified: json['is_verified'] ?? false,
      // Handle location_point geometry - extract lat/lng if present
      latitude: _extractLatitudeFromLocationPoint(json['location_point']),
      longitude: _extractLongitudeFromLocationPoint(json['location_point']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  static double? _extractLatitudeFromLocationPoint(dynamic locationPoint) {
    // Handle PostGIS POINT geometry if present
    if (locationPoint is String && locationPoint.startsWith('POINT(')) {
      try {
        final coords = locationPoint
            .replaceAll('POINT(', '')
            .replaceAll(')', '')
            .split(' ');
        return double.parse(coords[1]); // Latitude is second value
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static double? _extractLongitudeFromLocationPoint(dynamic locationPoint) {
    // Handle PostGIS POINT geometry if present
    if (locationPoint is String && locationPoint.startsWith('POINT(')) {
      try {
        final coords = locationPoint
            .replaceAll('POINT(', '')
            .replaceAll(')', '')
            .split(' ');
        return double.parse(coords[0]); // Longitude is first value
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'id': id,
      'email': email,
      'full_name': fullName,
      'role': role.toString().split('.').last,
      'is_verified': isVerified,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };

    // Only add non-null optional fields
    if (avatarUrl != null) {
      json['avatar_url'] = avatarUrl;
    }
    if (phoneNumber != null) {
      json['phone_number'] = phoneNumber;
    }
    if (location != null) {
      json['location'] = location;
    }
    if (bio != null) {
      json['bio'] = bio;
    }

    // Add location_point as PostGIS POINT if lat/lng are available
    if (latitude != null && longitude != null) {
      json['location_point'] = 'POINT($longitude $latitude)';
    }

    return json;
  }
}

enum UserRole { customer, artisan, admin }
