class Artisan {
  final String id;
  final String name;
  final String description;
  final String category; // pottery, weaving, wood-carving, etc.
  final String? imageUrl;
  final String location;
  final double rating;
  final int reviewCount;
  final bool isVerified;
  final String story;
  final List<String> skills;
  final double? latitude;
  final double? longitude;
  final DateTime createdAt;
  final DateTime updatedAt;

  Artisan({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    this.imageUrl,
    required this.location,
    required this.rating,
    required this.reviewCount,
    required this.isVerified,
    required this.story,
    required this.skills,
    this.latitude,
    this.longitude,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Artisan.fromJson(Map<String, dynamic> json) {
    return Artisan(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      imageUrl: json['image_url'],
      location: json['location'],
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['review_count'],
      isVerified: json['is_verified'],
      story: json['story'],
      skills: List<String>.from(json['skills'] ?? []),
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'image_url': imageUrl,
      'location': location,
      'rating': rating,
      'review_count': reviewCount,
      'is_verified': isVerified,
      'story': story,
      'skills': skills,
      'latitude': latitude,
      'longitude': longitude,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
