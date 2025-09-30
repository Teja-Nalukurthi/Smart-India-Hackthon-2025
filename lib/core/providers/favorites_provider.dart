import 'package:flutter/foundation.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<String> _favoriteArtisanIds = [];
  final List<String> _favoriteProductIds = [];

  List<String> get favoriteArtisanIds => List.unmodifiable(_favoriteArtisanIds);
  List<String> get favoriteProductIds => List.unmodifiable(_favoriteProductIds);

  bool isArtisanFavorite(String artisanId) {
    return _favoriteArtisanIds.contains(artisanId);
  }

  bool isProductFavorite(String productId) {
    return _favoriteProductIds.contains(productId);
  }

  void toggleArtisanFavorite(String artisanId) {
    if (_favoriteArtisanIds.contains(artisanId)) {
      _favoriteArtisanIds.remove(artisanId);
    } else {
      _favoriteArtisanIds.add(artisanId);
    }
    notifyListeners();

    // TODO: Sync with backend/local storage
    _syncFavoritesWithStorage();
  }

  void toggleProductFavorite(String productId) {
    if (_favoriteProductIds.contains(productId)) {
      _favoriteProductIds.remove(productId);
    } else {
      _favoriteProductIds.add(productId);
    }
    notifyListeners();

    // TODO: Sync with backend/local storage
    _syncFavoritesWithStorage();
  }

  Future<void> loadFavorites() async {
    // TODO: Load favorites from backend/local storage
    // For now, just simulate loading
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock some favorites
    _favoriteArtisanIds.clear();
    _favoriteProductIds.clear();

    // Add some sample favorites
    _favoriteArtisanIds.addAll(['artisan_1', 'artisan_3']);
    _favoriteProductIds.addAll(['product_1', 'product_5']);

    notifyListeners();
  }

  Future<void> clearAllFavorites() async {
    _favoriteArtisanIds.clear();
    _favoriteProductIds.clear();
    notifyListeners();

    // TODO: Sync with backend/local storage
    await _syncFavoritesWithStorage();
  }

  Future<void> _syncFavoritesWithStorage() async {
    // TODO: Implement actual sync with Supabase or local storage
    await Future.delayed(const Duration(milliseconds: 100));
  }
}
