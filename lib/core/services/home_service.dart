import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/artisan.dart';
import '../models/food_item.dart';
import '../models/folklore.dart';
import '../../shared/services/map_service.dart';
import '../../shared/models/map_place.dart';

class HomeService {
  static final HomeService _instance = HomeService._internal();
  factory HomeService() => _instance;
  HomeService._internal();

  static HomeService get instance => _instance;

  final SupabaseClient _supabase = Supabase.instance.client;

  // Fetch featured artisans
  Future<List<Artisan>> getFeaturedArtisans({int limit = 10}) async {
    try {
      // Try to fetch from Supabase first
      final response = await _supabase
          .from('artisans')
          .select()
          .eq('is_verified', true)
          .order('rating', ascending: false)
          .order('review_count', ascending: false)
          .limit(limit);

      return (response as List).map((json) => Artisan.fromJson(json)).toList();
    } catch (e) {
      print('Supabase fetch failed, using mock data: $e');
      // Fallback to mock data from MapService
      return _getMockArtisans(limit: limit);
    }
  }

  // Get mock artisans from MapService data
  List<Artisan> _getMockArtisans({int limit = 10}) {
    final allPlaces = MapService.getAllMockPlaces();
    final artisanPlaces = allPlaces
        .where((place) => place.type == PlaceType.artisan)
        .take(limit);

    return artisanPlaces
        .map(
          (place) => Artisan(
            id: place.id,
            name: place.name,
            description: place.description,
            category: _getArtisanCategory(place.name),
            imageUrl: place.imageUrl,
            location: place.address ?? 'Pondicherry',
            rating: place.rating ?? 4.0,
            reviewCount: place.reviewCount ?? 0,
            isVerified: true,
            skills: _getSkillsFromName(place.name),
            whatsappNumber: place.phoneNumber,
            latitude: place.position.latitude,
            longitude: place.position.longitude,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        )
        .toList();
  }

  // Helper method to get artisan category from name
  ArtisanCategory _getArtisanCategory(String name) {
    final nameLower = name.toLowerCase();
    if (nameLower.contains('pottery')) return ArtisanCategory.pottery;
    if (nameLower.contains('weaving') || nameLower.contains('handloom'))
      return ArtisanCategory.weaving;
    if (nameLower.contains('furniture') || nameLower.contains('wood'))
      return ArtisanCategory.woodCarving;
    if (nameLower.contains('jewelry')) return ArtisanCategory.jewelry;
    if (nameLower.contains('art') || nameLower.contains('paint'))
      return ArtisanCategory.paintings;
    if (nameLower.contains('brass') || nameLower.contains('metal'))
      return ArtisanCategory.metalwork;
    return ArtisanCategory.handicrafts;
  }

  // Helper method to get skills from artisan name
  List<String> _getSkillsFromName(String name) {
    final nameLower = name.toLowerCase();
    if (nameLower.contains('pottery'))
      return ['Pottery', 'Clay Work', 'Glazing'];
    if (nameLower.contains('weaving'))
      return ['Handloom Weaving', 'Cotton Textiles', 'Traditional Patterns'];
    if (nameLower.contains('furniture'))
      return ['Furniture Restoration', 'Antique Work', 'French Colonial'];
    if (nameLower.contains('jewelry'))
      return ['Jewelry Making', 'Silver Work', 'Traditional Designs'];
    if (nameLower.contains('art'))
      return ['Painting', 'Contemporary Art', 'Cultural Themes'];
    if (nameLower.contains('brass'))
      return ['Brass Work', 'Metal Crafting', 'Traditional Techniques'];
    return ['Handicrafts', 'Traditional Art'];
  }

  // Fetch nearby food items
  Future<List<FoodItem>> getNearbyFood({int limit = 10}) async {
    try {
      // Try to fetch from Supabase first
      final response = await _supabase
          .from('food_items')
          .select()
          .order('rating', ascending: false)
          .order('review_count', ascending: false)
          .limit(limit);

      return (response as List).map((json) => FoodItem.fromJson(json)).toList();
    } catch (e) {
      print('Supabase fetch failed, using mock data: $e');
      // Fallback to mock data from MapService
      return _getMockFoodItems(limit: limit);
    }
  }

  // Get mock food items from MapService data
  List<FoodItem> _getMockFoodItems({int limit = 10}) {
    final allPlaces = MapService.getAllMockPlaces();
    final foodPlaces = allPlaces
        .where((place) => place.type == PlaceType.localFood)
        .take(limit);

    return foodPlaces
        .map(
          (place) => FoodItem(
            id: place.id,
            name: place.name,
            description: place.description,
            imageUrl: place.imageUrl ?? '',
            category: _getFoodCategory(place.name),
            location: place.address ?? 'Pondicherry',
            rating: place.rating ?? 4.0,
            reviewCount: place.reviewCount ?? 0,
            restaurant: place.name,
            isVegetarian: true, // Assume vegetarian for local shops
            isVegan: false,
            ingredients: _getIngredientsFromName(place.name),
            latitude: place.position.latitude,
            longitude: place.position.longitude,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        )
        .toList();
  }

  // Helper method to get food category from name
  FoodCategory _getFoodCategory(String name) {
    final nameLower = name.toLowerCase();
    if (nameLower.contains('sweet') || nameLower.contains('bakery'))
      return FoodCategory.sweets;
    if (nameLower.contains('tea') ||
        nameLower.contains('coffee') ||
        nameLower.contains('coconut'))
      return FoodCategory.beverages;
    if (nameLower.contains('spice')) return FoodCategory.other;
    if (nameLower.contains('market') || nameLower.contains('grocery'))
      return FoodCategory.other;
    return FoodCategory.traditional;
  }

  // Helper method to get ingredients from food name
  List<String> _getIngredientsFromName(String name) {
    final nameLower = name.toLowerCase();
    if (nameLower.contains('sweet'))
      return ['Milk', 'Sugar', 'Ghee', 'Traditional Spices'];
    if (nameLower.contains('tea'))
      return ['Tea Leaves', 'Milk', 'Sugar', 'Cardamom', 'Ginger'];
    if (nameLower.contains('bakery'))
      return ['Flour', 'Butter', 'Sugar', 'Fresh Ingredients'];
    if (nameLower.contains('coconut'))
      return ['Fresh Coconut', 'Natural Water'];
    if (nameLower.contains('spice'))
      return ['Traditional Spices', 'Local Herbs'];
    return ['Fresh Local Ingredients'];
  }

  // Fetch local folklore
  Future<List<Folklore>> getLocalFolklore({int limit = 10}) async {
    try {
      // Try to fetch from Supabase first
      final response = await _supabase
          .from('folklore')
          .select()
          .order('rating', ascending: false)
          .order('review_count', ascending: false)
          .limit(limit);

      return (response as List).map((json) => Folklore.fromJson(json)).toList();
    } catch (e) {
      print('Supabase fetch failed, using mock data: $e');
      // Fallback to mock folklore data
      return _getMockFolklore(limit: limit);
    }
  }

  // Get mock folklore data
  List<Folklore> _getMockFolklore({int limit = 10}) {
    final allPlaces = MapService.getAllMockPlaces();
    final touristPlaces = allPlaces
        .where((place) => place.type == PlaceType.touristSpot)
        .take(limit);

    return touristPlaces
        .map(
          (place) => Folklore(
            id: place.id,
            title: '${place.name} Stories',
            description:
                '${place.description} Learn about the fascinating history and cultural significance of this iconic location.',
            imageUrl: place.imageUrl ?? '',
            type: _getFolkloreType(place.name),
            location: place.address ?? 'Pondicherry',
            rating: place.rating ?? 4.0,
            reviewCount: place.reviewCount ?? 0,
            origin: 'Pondicherry Cultural Heritage',
            significance: 'Important cultural and historical site',
            tags: _getTagsFromName(place.name),
            latitude: place.position.latitude,
            longitude: place.position.longitude,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        )
        .toList();
  }

  // Helper method to get folklore type from place name
  FolkloreType _getFolkloreType(String name) {
    final nameLower = name.toLowerCase();
    if (nameLower.contains('temple') || nameLower.contains('ashram'))
      return FolkloreType.tradition;
    if (nameLower.contains('beach') || nameLower.contains('memorial'))
      return FolkloreType.legend;
    if (nameLower.contains('museum')) return FolkloreType.story;
    if (nameLower.contains('festival') || nameLower.contains('celebration'))
      return FolkloreType.festival;
    return FolkloreType.tradition;
  }

  // Helper method to get tags from place name
  List<String> _getTagsFromName(String name) {
    final nameLower = name.toLowerCase();
    if (nameLower.contains('temple'))
      return ['Temple', 'Hindu', 'Spirituality', 'Architecture'];
    if (nameLower.contains('ashram'))
      return ['Spirituality', 'Meditation', 'Philosophy', 'Peace'];
    if (nameLower.contains('beach'))
      return ['Beach', 'Ocean', 'Nature', 'Recreation'];
    if (nameLower.contains('museum'))
      return ['History', 'Culture', 'Art', 'Heritage'];
    if (nameLower.contains('french'))
      return ['French', 'Colonial', 'Architecture', 'History'];
    return ['Culture', 'Heritage', 'History'];
  }

  // Fetch all home data at once
  Future<Map<String, dynamic>> getHomeData() async {
    try {
      final results = await Future.wait([
        getFeaturedArtisans(limit: 5),
        getNearbyFood(limit: 5),
        getLocalFolklore(limit: 5),
      ]);

      return {
        'artisans': results[0],
        'food': results[1],
        'folklore': results[2],
      };
    } catch (e) {
      throw Exception('Failed to fetch home data: $e');
    }
  }
}
