import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/custom_network_image.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/models/product.dart';

class ArtisanDetailScreen extends StatefulWidget {
  final String? artisanId;

  const ArtisanDetailScreen({super.key, this.artisanId});

  @override
  State<ArtisanDetailScreen> createState() => _ArtisanDetailScreenState();
}

class _ArtisanDetailScreenState extends State<ArtisanDetailScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  int _currentImageIndex = 0;

  // Sample data - would be loaded from API
  final List<String> _artisanImages = [
    'https://images.unsplash.com/photo-1578662996442-48f60103fc96?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1610832958506-aa56368176cf?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1524492412937-b28074a5d7da?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
  ];

  final List<Product> _sampleProducts = [];
  final List<Review> _sampleReviews = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadSampleData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _loadSampleData() {
    // Sample products
    _sampleProducts.addAll([
      Product(
        id: '1',
        artisanId: 'artisan_1',
        name: 'Handcrafted Pot',
        description:
            'Beautiful terracotta pot made with traditional techniques',
        price: 2000,
        imageUrl:
            'https://images.unsplash.com/photo-1578662996442-48f60103fc96?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
        imageUrls: [],
        category: 'pottery',
        isAvailable: true,
        stockQuantity: 5,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: '2',
        artisanId: 'artisan_1',
        name: 'Handcrafted Bowl',
        description: 'Elegant ceramic bowl perfect for serving',
        price: 1200,
        imageUrl:
            'https://images.unsplash.com/photo-1610832958506-aa56368176cf?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
        imageUrls: [],
        category: 'pottery',
        isAvailable: true,
        stockQuantity: 3,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Product(
        id: '3',
        artisanId: 'artisan_1',
        name: 'Handcrafted Plate',
        description: 'Decorative plate with intricate patterns',
        price: 800,
        imageUrl:
            'https://images.unsplash.com/photo-1524492412937-b28074a5d7da?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
        imageUrls: [],
        category: 'pottery',
        isAvailable: true,
        stockQuantity: 8,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ]);

    // Sample reviews
    _sampleReviews.addAll([
      Review(
        id: '1',
        artisanId: 'artisan_1',
        userId: 'user_1',
        userName: 'Priya Sharma',
        userAvatar:
            'https://images.unsplash.com/photo-1494790108755-2616b612b77c?ixlib=rb-4.0.3&auto=format&fit=crop&w=100&q=80',
        rating: 5,
        comment:
            'Absolutely loved the workshop! The artisan was incredibly patient and knowledgeable, and I left with a beautiful pot I made myself.',
        createdAt: DateTime.now().subtract(const Duration(days: 14)),
        likes: 15,
        dislikes: 2,
      ),
      Review(
        id: '2',
        artisanId: 'artisan_1',
        userId: 'user_2',
        userName: 'Arjun Patel',
        userAvatar:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=100&q=80',
        rating: 4,
        comment:
            'The workshop was well-organized and informative. I enjoyed learning about the history of pottery and trying my hand at the craft.',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        likes: 8,
        dislikes: 1,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: CustomScrollView(
        slivers: [
          // App Bar with Image Gallery
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.backgroundLight,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha((255 * 0.9).round()),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.textLight),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha((255 * 0.9).round()),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.share, color: AppColors.textLight),
                  onPressed: () {
                    // TODO: Implement share functionality
                  },
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: _artisanImages.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentImageIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return CustomNetworkImage(
                        imageUrl: _artisanImages[index],
                        width: double.infinity,
                        height: 300,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                  // Page indicators
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _artisanImages.asMap().entries.map((entry) {
                        return Container(
                          width: _currentImageIndex == entry.key ? 16 : 6,
                          height: 6,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: _currentImageIndex == entry.key
                                ? Colors.white
                                : Colors.white.withAlpha((255 * 0.5).round()),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and verification
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Artisan Workshop',
                          style: AppTextStyles.headlineMedium.copyWith(
                            color: AppColors.textLight,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.verified,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Verified',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSubtle,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),
                  Text(
                    'Handicrafts',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSubtle,
                    ),
                  ),

                  const SizedBox(height: 16),
                  Text(
                    'Discover the ancient art of pottery in a hands-on workshop led by a master artisan. Learn traditional techniques and create your own unique piece to take home.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textLight,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Our Story Section
                  _buildSection(
                    title: 'Our Story',
                    content:
                        'For generations, our family has been dedicated to preserving the rich heritage of Indian pottery. We invite you to join us in our workshop, where you\'ll not only learn the craft but also connect with the stories and traditions that shape our work.',
                  ),

                  // Products Section
                  _buildProductsSection(),

                  // Reviews Section
                  _buildReviewsSection(),

                  // Location Section
                  _buildLocationSection(),

                  const SizedBox(height: 80), // Space for bottom nav
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 1,
          color: AppColors.grey200,
          margin: const EdgeInsets.only(bottom: 24),
        ),
        Text(
          title,
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.textLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textLight,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildProductsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 1,
          color: AppColors.grey200,
          margin: const EdgeInsets.only(bottom: 24),
        ),
        Text(
          'Products',
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.textLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 240,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _sampleProducts.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final product = _sampleProducts[index];
              return _buildProductCard(product);
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildProductCard(Product product) {
    return Container(
      width: 180,
      decoration: BoxDecoration(
        color: Colors.white.withAlpha((255 * 0.5).round()),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomNetworkImage(
            imageUrl: product.imageUrl ?? '',
            width: double.infinity,
            height: 120,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppTextStyles.titleSmall.copyWith(
                      color: AppColors.textLight,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹${product.price.toStringAsFixed(0)}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSubtle,
                    ),
                  ),
                  const Spacer(),
                  CustomButton(
                    text: 'Add to Cart',
                    onPressed: () {
                      // TODO: Add to cart functionality
                    },
                    type: ButtonType.secondary,
                    size: ButtonSize.small,
                    fullWidth: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 1,
          color: AppColors.grey200,
          margin: const EdgeInsets.only(bottom: 24),
        ),
        Text(
          'Reviews & Ratings',
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.textLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        // Rating Summary
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Text(
                  '4.8',
                  style: AppTextStyles.displaySmall.copyWith(
                    color: AppColors.textLight,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < 4 ? Icons.star : Icons.star_half,
                      color: AppColors.primary,
                      size: 18,
                    );
                  }),
                ),
                const SizedBox(height: 4),
                Text(
                  '125 reviews',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSubtle,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 32),
            Expanded(child: _buildRatingBars()),
          ],
        ),

        const SizedBox(height: 24),

        // Review List
        ...(_sampleReviews.map((review) => _buildReviewCard(review)).toList()),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildRatingBars() {
    final ratings = [
      {'stars': 5, 'percentage': 0.7},
      {'stars': 4, 'percentage': 0.2},
      {'stars': 3, 'percentage': 0.05},
      {'stars': 2, 'percentage': 0.03},
      {'stars': 1, 'percentage': 0.02},
    ];

    return Column(
      children: ratings.map((rating) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: [
              SizedBox(
                width: 20,
                child: Text(
                  '${rating['stars']}',
                  style: AppTextStyles.bodySmall,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.grey200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: rating['percentage'] as double,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 30,
                child: Text(
                  '${((rating['percentage'] as double) * 100).toInt()}%',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSubtle,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildReviewCard(Review review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(review.userAvatar),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: AppTextStyles.titleSmall.copyWith(
                        color: AppColors.textLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _getTimeAgo(review.createdAt),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSubtle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < review.rating ? Icons.star : Icons.star_border,
                color: AppColors.primary,
                size: 18,
              );
            }),
          ),
          const SizedBox(height: 8),
          Text(
            review.comment,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textLight,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.thumb_up_outlined,
                    size: 16,
                    color: AppColors.textSubtle,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${review.likes}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSubtle,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Row(
                children: [
                  Icon(
                    Icons.thumb_down_outlined,
                    size: 16,
                    color: AppColors.textSubtle,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${review.dislikes}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSubtle,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 1,
          color: AppColors.grey200,
          margin: const EdgeInsets.only(bottom: 24),
        ),
        Text(
          'Location',
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.textLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.grey200,
            borderRadius: BorderRadius.circular(12),
            image: const DecorationImage(
              image: NetworkImage(
                'https://images.unsplash.com/photo-1524492412937-b28074a5d7da?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerRight,
          child: CustomButton(
            text: 'Get Directions',
            onPressed: () {
              // TODO: Open maps
            },
            type: ButtonType.primary,
            size: ButtonSize.medium,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSubtle,
      currentIndex: 0,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          label: 'Favorites',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
      ],
      onTap: (index) {
        // TODO: Handle navigation
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/home');
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/search');
            break;
          case 2:
            Navigator.pushReplacementNamed(context, '/favorites');
            break;
          case 3:
            Navigator.pushReplacementNamed(context, '/profile');
            break;
        }
      },
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    }
  }
}

// Review model for the screen
class Review {
  final String id;
  final String artisanId;
  final String userId;
  final String userName;
  final String userAvatar;
  final int rating;
  final String comment;
  final DateTime createdAt;
  final int likes;
  final int dislikes;

  Review({
    required this.id,
    required this.artisanId,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.likes,
    required this.dislikes,
  });
}
