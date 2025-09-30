import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/providers/favorites_provider.dart';

class SavedItemsScreen extends StatefulWidget {
  const SavedItemsScreen({super.key});

  @override
  State<SavedItemsScreen> createState() => _SavedItemsScreenState();
}

class _SavedItemsScreenState extends State<SavedItemsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock data for saved artisans
  final List<Map<String, dynamic>> _mockArtisans = [
    {
      'id': 'artisan_1',
      'name': 'Rajesh Kumar',
      'craft': 'Traditional Pottery',
      'location': 'Jaipur, Rajasthan',
      'rating': 4.8,
      'image':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=300&q=80',
    },
    {
      'id': 'artisan_3',
      'name': 'Arjun Singh',
      'craft': 'Metalwork & Jewelry',
      'location': 'Udaipur, Rajasthan',
      'rating': 4.9,
      'image':
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-4.0.3&auto=format&fit=crop&w=300&q=80',
    },
  ];

  // Mock data for saved products
  final List<Map<String, dynamic>> _mockProducts = [
    {
      'id': 'product_1',
      'name': 'Handcrafted Clay Vase',
      'artisan': 'Rajesh Kumar',
      'price': 1200.0,
      'image':
          'https://images.unsplash.com/photo-1578662996442-48f60103fc96?ixlib=rb-4.0.3&auto=format&fit=crop&w=300&q=80',
    },
    {
      'id': 'product_5',
      'name': 'Silver Pendant Necklace',
      'artisan': 'Arjun Singh',
      'price': 3500.0,
      'image':
          'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?ixlib=rb-4.0.3&auto=format&fit=crop&w=300&q=80',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Saved Items',
          style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.textLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textLight),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSubtle,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Artisans'),
            Tab(text: 'Products'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildArtisansList(), _buildProductsList()],
      ),
    );
  }

  Widget _buildArtisansList() {
    return Consumer<FavoritesProvider>(
      builder: (context, favoritesProvider, child) {
        final favoriteArtisans = _mockArtisans
            .where(
              (artisan) => favoritesProvider.isArtisanFavorite(artisan['id']),
            )
            .toList();

        if (favoriteArtisans.isEmpty) {
          return _buildEmptyState('No saved artisans', Icons.person_outline);
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: favoriteArtisans.length,
          itemBuilder: (context, index) {
            final artisan = favoriteArtisans[index];
            return _buildArtisanCard(artisan, favoritesProvider);
          },
        );
      },
    );
  }

  Widget _buildProductsList() {
    return Consumer<FavoritesProvider>(
      builder: (context, favoritesProvider, child) {
        final favoriteProducts = _mockProducts
            .where(
              (product) => favoritesProvider.isProductFavorite(product['id']),
            )
            .toList();

        if (favoriteProducts.isEmpty) {
          return _buildEmptyState(
            'No saved products',
            Icons.shopping_bag_outlined,
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: favoriteProducts.length,
          itemBuilder: (context, index) {
            final product = favoriteProducts[index];
            return _buildProductCard(product, favoritesProvider);
          },
        );
      },
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: AppColors.textSubtle),
          const SizedBox(height: 16),
          Text(
            message,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.textSubtle,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start exploring to add items to your favorites!',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSubtle,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildArtisanCard(
    Map<String, dynamic> artisan,
    FavoritesProvider favoritesProvider,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(artisan['image']),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  artisan['name'],
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.textLight,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  artisan['craft'],
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: AppColors.textSubtle,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        artisan['location'],
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSubtle,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              favoritesProvider.isArtisanFavorite(artisan['id'])
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: AppColors.error,
            ),
            onPressed: () {
              favoritesProvider.toggleArtisanFavorite(artisan['id']);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(
    Map<String, dynamic> product,
    FavoritesProvider favoritesProvider,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(product['image']),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'],
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.textLight,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'by ${product['artisan']}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSubtle,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '₹${product['price'].toStringAsFixed(0)}',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              favoritesProvider.isProductFavorite(product['id'])
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: AppColors.error,
            ),
            onPressed: () {
              favoritesProvider.toggleProductFavorite(product['id']);
            },
          ),
        ],
      ),
    );
  }
}
