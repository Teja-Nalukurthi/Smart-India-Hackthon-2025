class FoodItem {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final FoodCategory category;
  final String location;
  final double rating;
  final int reviewCount;
  final double? price;
  final String? restaurant;
  final bool isVegetarian;
  final bool isVegan;
  final List<String> ingredients;
  final double? latitude;
  final double? longitude;
  final DateTime createdAt;
  final DateTime updatedAt;

  FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.location,
    required this.rating,
    required this.reviewCount,
    this.price,
    this.restaurant,
    required this.isVegetarian,
    required this.isVegan,
    required this.ingredients,
    this.latitude,
    this.longitude,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['image_url'] ?? '',
      category: FoodCategory.values.firstWhere(
        (e) => e.toString().split('.').last == json['category'],
        orElse: () => FoodCategory.other,
      ),
      location: json['location'],
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewCount: json['review_count'] ?? 0,
      price: json['price']?.toDouble(),
      restaurant: json['restaurant'],
      isVegetarian: json['is_vegetarian'] ?? false,
      isVegan: json['is_vegan'] ?? false,
      ingredients: List<String>.from(json['ingredients'] ?? []),
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
      'image_url': imageUrl,
      'category': category.toString().split('.').last,
      'location': location,
      'rating': rating,
      'review_count': reviewCount,
      'price': price,
      'restaurant': restaurant,
      'is_vegetarian': isVegetarian,
      'is_vegan': isVegan,
      'ingredients': ingredients,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

enum FoodCategory {
  streetFood,
  traditional,
  sweets,
  beverages,
  snacks,
  mainCourse,
  appetizer,
  dessert,
  other,
}
