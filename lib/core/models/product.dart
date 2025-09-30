class Product {
  final String id;
  final String artisanId;
  final String name;
  final String description;
  final double price;
  final String? imageUrl;
  final List<String> imageUrls;
  final ProductCategory category;
  final bool isAvailable;
  final int stockQuantity;
  final Map<String, dynamic>? specifications;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.artisanId,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
    required this.imageUrls,
    required this.category,
    required this.isAvailable,
    required this.stockQuantity,
    this.specifications,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      artisanId: json['artisan_id'],
      name: json['name'],
      description: json['description'],
      price: (json['price']).toDouble(),
      imageUrl: json['image_url'],
      imageUrls: List<String>.from(json['image_urls'] ?? []),
      category: ProductCategory.values.firstWhere(
        (e) => e.toString().split('.').last == json['category'],
        orElse: () => ProductCategory.other,
      ),
      isAvailable: json['is_available'] ?? true,
      stockQuantity: json['stock_quantity'] ?? 0,
      specifications: json['specifications'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'artisan_id': artisanId,
      'name': name,
      'description': description,
      'price': price,
      'image_url': imageUrl,
      'image_urls': imageUrls,
      'category': category.toString().split('.').last,
      'is_available': isAvailable,
      'stock_quantity': stockQuantity,
      'specifications': specifications,
    };
  }
}

enum ProductCategory {
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
  foodProducts,
  other,
}
