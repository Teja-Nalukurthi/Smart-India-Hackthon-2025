import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/favorites_provider.dart';
import '../../../../shared/widgets/custom_button.dart';
import 'edit_profile_screen.dart';
import 'my_bookings_screen.dart';
import 'saved_items_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // If loading, show spinner for a brief moment
        if (authProvider.isLoading) {
          return Scaffold(
            backgroundColor: AppColors.backgroundLight,
            body: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          );
        }

        // If not authenticated, show login prompt
        if (!authProvider.isAuthenticated) {
          return Scaffold(
            backgroundColor: AppColors.backgroundLight,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.account_circle_outlined,
                    size: 80,
                    color: AppColors.textSubtle,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Please sign in to view your profile',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.textSubtle,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: const Text('Sign In'),
                  ),
                ],
              ),
            ),
          );
        }

        final userProfile = authProvider.currentUserProfile;

        // If authenticated but no profile, show a minimal profile with what we have
        if (userProfile == null) {
          return Scaffold(
            backgroundColor: AppColors.backgroundLight,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primary,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Profile Loading...',
                    style: AppTextStyles.titleLarge.copyWith(
                      color: AppColors.textLight,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please wait while we set up your profile',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSubtle,
                    ),
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: 'Create Profile',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfileScreen(),
                        ),
                      );
                    },
                    type: ButtonType.primary,
                    size: ButtonSize.medium,
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: 'Sign Out',
                    onPressed: () async {
                      await authProvider.signOut();
                      if (!context.mounted) return;
                      Navigator.pushReplacementNamed(context, '/');
                    },
                    type: ButtonType.secondary,
                    size: ButtonSize.medium,
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                expandedHeight: 100,
                floating: false,
                pinned: true,
                backgroundColor: AppColors.backgroundLight,
                elevation: 0,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                    'Profile',
                    style: AppTextStyles.headlineSmall.copyWith(
                      color: AppColors.textLight,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(
                      Icons.settings_outlined,
                      color: AppColors.textLight,
                    ),
                    onPressed: () {
                      // TODO: Navigate to settings
                    },
                  ),
                ],
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // User Info Card
                      _buildUserInfoCard(userProfile),

                      const SizedBox(height: 24),

                      // Quick Stats
                      _buildQuickStats(),

                      const SizedBox(height: 24),

                      // Menu Items
                      _buildMenuSection(),

                      const SizedBox(
                        height: 24,
                      ), // Reduced space since no bottom nav
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Remove bottomNavigationBar - handled by MainNavigationWrapper
        );
      },
    );
  }

  Widget _buildUserInfoCard(userProfile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar and Edit Button
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: userProfile.avatarUrl != null
                    ? NetworkImage(userProfile.avatarUrl!)
                    : null,
                child: userProfile.avatarUrl == null
                    ? const Icon(Icons.person, size: 60, color: Colors.white)
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () {
                      // TODO: Change profile picture
                    },
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Text(
            userProfile.fullName,
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.textLight,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            userProfile.email,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSubtle,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            userProfile.phoneNumber ?? 'Phone not provided',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSubtle,
            ),
          ),

          const SizedBox(height: 20),

          CustomButton(
            text: 'Edit Profile',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfileScreen(),
                ),
              );
            },
            type: ButtonType.secondary,
            size: ButtonSize.medium,
            fullWidth: false,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Consumer<FavoritesProvider>(
      builder: (context, favoritesProvider, child) {
        final totalFavorites =
            favoritesProvider.favoriteArtisanIds.length +
            favoritesProvider.favoriteProductIds.length;

        return Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Bookings',
                value:
                    '3', // Mock data - in real app would come from BookingsProvider
                icon: Icons.book_online,
                color: AppColors.primary,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyBookingsScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                title: 'Favorites',
                value: totalFavorites.toString(),
                icon: Icons.favorite,
                color: Colors.red,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SavedItemsScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                title: 'Reviews',
                value:
                    '2', // Mock data - in real app would come from ReviewsProvider
                icon: Icons.star,
                color: Colors.orange,
                onTap: () {
                  // TODO: Implement reviews screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Reviews screen coming soon!'),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
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
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.textLight,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSubtle,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account',
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.textLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        // Account menu items
        _buildMenuItem(
          icon: Icons.book_online_outlined,
          title: 'My Bookings',
          subtitle: 'View and manage your bookings',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyBookingsScreen()),
            );
          },
        ),

        _buildMenuItem(
          icon: Icons.favorite_outline,
          title: 'Saved Items',
          subtitle: 'Your favorite artisans and products',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SavedItemsScreen()),
            );
          },
        ),

        _buildMenuItem(
          icon: Icons.history,
          title: 'Order History',
          subtitle: 'View your past orders',
          onTap: () {
            // TODO: Navigate to order history
          },
        ),

        _buildMenuItem(
          icon: Icons.payment_outlined,
          title: 'Payment Methods',
          subtitle: 'Manage your payment options',
          onTap: () {
            // TODO: Navigate to payment methods
          },
        ),

        const SizedBox(height: 24),

        Text(
          'App Settings',
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.textLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        // App settings menu items
        _buildMenuItem(
          icon: Icons.notifications_outlined,
          title: 'Notifications',
          subtitle: 'Configure your notification preferences',
          onTap: () {
            // TODO: Navigate to notification settings
          },
        ),

        _buildMenuItem(
          icon: Icons.language_outlined,
          title: 'Language',
          subtitle: 'English',
          onTap: () {
            // TODO: Show language selection
          },
        ),

        _buildMenuItem(
          icon: Icons.dark_mode_outlined,
          title: 'Dark Mode',
          subtitle: 'System default',
          onTap: () {
            // TODO: Show theme selection
          },
        ),

        _buildMenuItem(
          icon: Icons.privacy_tip_outlined,
          title: 'Privacy Policy',
          subtitle: 'Read our privacy policy',
          onTap: () {
            // TODO: Navigate to privacy policy
          },
        ),

        _buildMenuItem(
          icon: Icons.help_outline,
          title: 'Help & Support',
          subtitle: 'Get help or contact support',
          onTap: () {
            // TODO: Navigate to help
          },
        ),

        const SizedBox(height: 24),

        // Sign out button
        CustomButton(
          text: 'Sign Out',
          onPressed: () {
            _showSignOutDialog(context);
          },
          type: ButtonType.secondary,
          size: ButtonSize.medium,
          fullWidth: true,
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha((255 * 0.1).round()),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.titleSmall.copyWith(
                          color: AppColors.textLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSubtle,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.textSubtle),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'Sign Out',
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.textLight,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to sign out?',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textLight,
            ),
          ),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                'Cancel',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSubtle,
                ),
              ),
            ),
            CustomButton(
              text: 'Sign Out',
              onPressed: () async {
                Navigator.of(dialogContext).pop();

                // Sign out using AuthProvider
                final authProvider = Provider.of<AuthProvider>(
                  context,
                  listen: false,
                );
                await authProvider.signOut();

                // Navigate to welcome screen
                if (!context.mounted) return;
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false,
                );
              },
              type: ButtonType.primary,
              size: ButtonSize.small,
            ),
          ],
        );
      },
    );
  }
}
