class Product {
  final String id;
  final String artisanId;
  final String name;
  final String description;
  final double price;
  final String? imageUrl;
  final List<String> imageUrls;
  final String category;
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
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image_url'],
      imageUrls: List<String>.from(json['image_urls'] ?? []),
      category: json['category'],
      isAvailable: json['is_available'],
      stockQuantity: json['stock_quantity'],
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
      'category': category,
      'is_available': isAvailable,
      'stock_quantity': stockQuantity,
      'specifications': specifications,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
