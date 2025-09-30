import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/services/home_service.dart';
import '../../../../core/models/artisan.dart';
import '../../../../core/models/food_item.dart';
import '../../../../core/models/folklore.dart';
import '../../../../shared/widgets/custom_network_image.dart';
import '../widgets/map_view_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final HomeService _homeService = HomeService.instance;

  List<Artisan> _artisans = [];
  List<FoodItem> _foodItems = [];
  List<Folklore> _folkloreItems = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadHomeData();
  }

  Future<void> _loadHomeData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await _homeService.getHomeData();
      setState(() {
        _artisans = data['artisans'] as List<Artisan>;
        _foodItems = data['food'] as List<FoodItem>;
        _folkloreItems = data['folklore'] as List<Folklore>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
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
      body: SafeArea(
        child: Column(
          children: [
            // Fixed Header with Search Bar (not collapsible)
            Container(
              color: AppColors.backgroundLight,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'GoLocal',
                            style: AppTextStyles.headlineLarge.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'The soul of a place, in your pocket.',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.primary.withAlpha(
                                (255 * 0.8).round(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          // TODO: Add filter functionality
                        },
                        icon: const Icon(
                          Icons.tune,
                          color: AppColors.primary,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Tab Bar (fixed below header)
                  TabBar(
                    controller: _tabController,
                    labelColor: AppColors.primary,
                    unselectedLabelColor: AppColors.textSubtle,
                    indicatorColor: AppColors.primary,
                    indicatorWeight: 2,
                    tabs: const [
                      Tab(icon: Icon(Icons.view_list), text: 'Feed'),
                      Tab(icon: Icon(Icons.map), text: 'Map'),
                    ],
                  ),
                ],
              ),
            ),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics:
                    const NeverScrollableScrollPhysics(), // Disable swiping between tabs
                children: [_buildFeedView(), _buildMapView()],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0), // Move FAB up from bottom
        child: FloatingActionButton.extended(
          heroTag: "home_chat_fab", // Unique hero tag
          onPressed: () {
            Navigator.pushNamed(context, '/chat');
          },
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.auto_awesome),
          label: const Text('Ask Naradha'),
          elevation: 6,
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat, // Position it at the end
      // Remove bottomNavigationBar - handled by MainNavigationWrapper
    );
  }

  Widget _buildFeedView() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              'Failed to load data',
              style: AppTextStyles.titleMedium.copyWith(color: AppColors.error),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSubtle,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadHomeData,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Hero Section
          Container(
            height: 200,
            margin: const EdgeInsets.only(bottom: 32),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  CustomNetworkImage(
                    imageUrl:
                        'https://images.unsplash.com/photo-1524492412937-b28074a5d7da?ixlib=rb-4.0.3&auto=format&fit=crop&w=1171&q=80',
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0x80000000)],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Discover the heart of India',
                          style: AppTextStyles.titleLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Explore curated experiences, from ancient crafts to hidden culinary gems.',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white.withAlpha((255 * 0.9).round()),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '100+ experiences',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.white.withAlpha((255 * 0.7).round()),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Featured Artisans Section
          _buildSection(
            title: 'Featured Artisans',
            items: _artisans
                .map(
                  (artisan) => _buildArtisanCard(
                    artisan.name,
                    artisan.description,
                    artisan.imageUrl ??
                        'https://images.unsplash.com/photo-1578662996442-48f60103fc96?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80',
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/artisan-detail',
                      arguments: artisan,
                    ),
                  ),
                )
                .toList(),
          ),

          // Nearby Food Section
          _buildSection(
            title: 'Nearby Food',
            items: _foodItems
                .map(
                  (food) => _buildFoodCard(
                    food.name,
                    food.description,
                    food.imageUrl,
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/food-detail',
                      arguments: food,
                    ),
                  ),
                )
                .toList(),
          ),

          // Local Folklore Section
          _buildSection(
            title: 'Local Folklore',
            items: _folkloreItems
                .map(
                  (folklore) => _buildFolkloreCard(
                    folklore.title,
                    folklore.description,
                    folklore.imageUrl,
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/folklore-detail',
                      arguments: folklore,
                    ),
                  ),
                )
                .toList(),
          ),

          // Kala Mitra CTA
          Container(
            margin: const EdgeInsets.only(
              top: 24,
              bottom: 80,
            ), // Added bottom margin for FAB
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha((255 * 0.05).round()),
              border: Border.all(
                color: AppColors.primary.withAlpha((255 * 0.1).round()),
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kala Mitra',
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Connect with local artisans and support their craft.',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary.withAlpha(
                            (255 * 0.8).round(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Navigate to Kala Mitra section
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Learn More'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapView() {
    return const MapViewWidget();
  }

  Widget _buildSection({required String title, required List<Widget> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 12),
          child: Text(
            title,
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (items.isEmpty)
          Container(
            height: 180,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.grey100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 48,
                    color: AppColors.textSubtle,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No data available',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSubtle,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          SizedBox(
            height: 180,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(width: 16),
              itemBuilder: (context, index) => items[index],
            ),
          ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildArtisanCard(
    String title,
    String subtitle,
    String imageUrl, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap:
          onTap ??
          () {
            Navigator.pushNamed(context, '/artisan-detail');
          },
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomNetworkImage(
              imageUrl: imageUrl,
              width: double.infinity,
              height: 100,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.titleSmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Text(
                        subtitle,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary.withAlpha(
                            (255 * 0.8).round(),
                          ),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodCard(
    String title,
    String subtitle,
    String imageUrl, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap:
          onTap ??
          () {
            Navigator.pushNamed(context, '/food-detail');
          },
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomNetworkImage(
              imageUrl: imageUrl,
              width: double.infinity,
              height: 100,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.titleSmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Text(
                        subtitle,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary.withAlpha(
                            (255 * 0.8).round(),
                          ),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFolkloreCard(
    String title,
    String subtitle,
    String imageUrl, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap:
          onTap ??
          () {
            Navigator.pushNamed(context, '/folklore-detail');
          },
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomNetworkImage(
              imageUrl: imageUrl,
              width: double.infinity,
              height: 100,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.titleSmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Text(
                        subtitle,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary.withAlpha(
                            (255 * 0.8).round(),
                          ),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
