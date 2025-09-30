class Artisan {
  final String id;
  final String? userId;
  final String name;
  final String description;
  final ArtisanCategory category;
  final String? imageUrl;
  final String location;
  final double rating;
  final int reviewCount;
  final bool isVerified;
  final String? story;
  final List<String> skills;
  final String? whatsappNumber;
  final double? latitude;
  final double? longitude;
  final DateTime createdAt;
  final DateTime updatedAt;

  Artisan({
    required this.id,
    this.userId,
    required this.name,
    required this.description,
    required this.category,
    this.imageUrl,
    required this.location,
    required this.rating,
    required this.reviewCount,
    required this.isVerified,
    this.story,
    required this.skills,
    this.whatsappNumber,
    this.latitude,
    this.longitude,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Artisan.fromJson(Map<String, dynamic> json) {
    return Artisan(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      description: json['description'],
      category: ArtisanCategory.values.firstWhere(
        (e) => e.toString().split('.').last == json['category'],
        orElse: () => ArtisanCategory.other,
      ),
      imageUrl: json['image_url'],
      location: json['location'],
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewCount: json['review_count'] ?? 0,
      isVerified: json['is_verified'] ?? false,
      story: json['story'],
      skills: List<String>.from(json['skills'] ?? []),
      whatsappNumber: json['whatsapp_number'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'description': description,
      'category': category.toString().split('.').last,
      'image_url': imageUrl,
      'location': location,
      'rating': rating,
      'review_count': reviewCount,
      'is_verified': isVerified,
      'story': story,
      'skills': skills,
      'whatsapp_number': whatsappNumber,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

enum ArtisanCategory {
  pottery,
  weaving,
  woodCarving,
  metalwork,
  jewelry,
  textiles,
  handicrafts,
  paintings,
  sculptures,
  leatherWork,
  other,
}
