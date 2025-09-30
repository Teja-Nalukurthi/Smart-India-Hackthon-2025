class Folklore {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final FolkloreType type;
  final String location;
  final double rating;
  final int reviewCount;
  final String? origin;
  final String? significance;
  final List<String> tags;
  final String? videoUrl;
  final String? audioUrl;
  final double? latitude;
  final double? longitude;
  final DateTime createdAt;
  final DateTime updatedAt;

  Folklore({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.type,
    required this.location,
    required this.rating,
    required this.reviewCount,
    this.origin,
    this.significance,
    required this.tags,
    this.videoUrl,
    this.audioUrl,
    this.latitude,
    this.longitude,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Folklore.fromJson(Map<String, dynamic> json) {
    return Folklore(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['image_url'] ?? '',
      type: FolkloreType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => FolkloreType.other,
      ),
      location: json['location'],
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewCount: json['review_count'] ?? 0,
      origin: json['origin'],
      significance: json['significance'],
      tags: List<String>.from(json['tags'] ?? []),
      videoUrl: json['video_url'],
      audioUrl: json['audio_url'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'type': type.toString().split('.').last,
      'location': location,
      'rating': rating,
      'review_count': reviewCount,
      'origin': origin,
      'significance': significance,
      'tags': tags,
      'video_url': videoUrl,
      'audio_url': audioUrl,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

enum FolkloreType {
  dance,
  music,
  story,
  festival,
  tradition,
  legend,
  ritual,
  performance,
  other,
}
