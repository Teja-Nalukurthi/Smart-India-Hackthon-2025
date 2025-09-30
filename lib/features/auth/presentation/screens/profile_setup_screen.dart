import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/models/user_profile.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_form_field.dart';

class ProfileSetupScreen extends StatefulWidget {
  final String userId;
  final String email;
  final String fullName;

  const ProfileSetupScreen({
    super.key,
    required this.userId,
    required this.email,
    required this.fullName,
  });

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _phoneController;
  late TextEditingController _locationController;
  late TextEditingController _bioController;

  UserRole _selectedRole = UserRole.customer;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
    _locationController = TextEditingController();
    _bioController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _locationController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Header
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withAlpha((255 * 0.1).round()),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person_add_outlined,
                          size: 40,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Complete Your Profile',
                        style: AppTextStyles.headlineMedium.copyWith(
                          color: AppColors.textLight,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tell us a bit more about yourself to personalize your experience',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSubtle,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Current Info Display
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.grey200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Account Information',
                        style: AppTextStyles.titleSmall.copyWith(
                          color: AppColors.textLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 16,
                            color: AppColors.textSubtle,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.fullName,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textLight,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.email_outlined,
                            size: 16,
                            color: AppColors.textSubtle,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.email,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textLight,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // User Role Selection
                Text(
                  'I am a...',
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.textLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: _buildRoleCard(
                        role: UserRole.customer,
                        title: 'Explorer',
                        description: 'Discover local experiences',
                        icon: Icons.explore_outlined,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildRoleCard(
                        role: UserRole.artisan,
                        title: 'Artisan',
                        description: 'Share your craft',
                        icon: Icons.palette_outlined,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Phone Number
                Text(
                  'Phone Number',
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.textLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                CustomTextFormField(
                  controller: _phoneController,
                  labelText: 'Phone Number',
                  hintText: 'Enter your phone number',
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      if (!RegExp(r'^\+?[\d\s\-\(\)]+$').hasMatch(value)) {
                        return 'Please enter a valid phone number';
                      }
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Location
                Text(
                  'Location',
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.textLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                CustomTextFormField(
                  controller: _locationController,
                  labelText: 'Location',
                  hintText: 'City, State',
                  prefixIcon: Icons.location_on_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your location';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Bio
                Text(
                  'Tell us about yourself',
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.textLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                CustomTextFormField(
                  controller: _bioController,
                  labelText: 'Bio',
                  hintText: _selectedRole == UserRole.artisan
                      ? 'Describe your craft and experience...'
                      : 'What interests you about local culture?',
                  prefixIcon: Icons.edit_outlined,
                  maxLines: 4,
                  maxLength: 200,
                ),

                const SizedBox(height: 32),

                // Complete Profile Button
                CustomButton(
                  text: 'Complete Profile',
                  onPressed: _isLoading ? null : _handleCompleteProfile,
                  isLoading: _isLoading,
                  type: ButtonType.primary,
                  size: ButtonSize.large,
                  fullWidth: true,
                ),

                const SizedBox(height: 16),

                // Skip Button
                TextButton(
                  onPressed: _isLoading ? null : _handleSkip,
                  child: Text(
                    'Skip for now',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSubtle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required UserRole role,
    required String title,
    required String description,
    required IconData icon,
  }) {
    final isSelected = _selectedRole == role;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRole = role;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withAlpha((255 * 0.1).round()) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.grey200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? AppColors.primary : AppColors.textSubtle,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTextStyles.titleSmall.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textLight,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
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

  Future<void> _handleCompleteProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Create user profile
      final userProfile = UserProfile(
        id: widget.userId,
        email: widget.email,
        fullName: widget.fullName,
        phoneNumber: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
        location: _locationController.text.trim().isEmpty
            ? null
            : _locationController.text.trim(),
        bio: _bioController.text.trim().isEmpty
            ? null
            : _bioController.text.trim(),
        role: _selectedRole,
        isVerified: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // print('Creating profile for user: ${widget.userId}');
      // print('Profile data: ${userProfile.toJson().toString()}');

      // Save profile using AuthProvider
      final success = await authProvider.createUserProfile(userProfile);

      // print('Profile creation success: $success');

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile created successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to main app
        Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              authProvider.errorMessage ?? 'Failed to create profile',
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating profile: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleSkip() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Create minimal profile
      final userProfile = UserProfile(
        id: widget.userId,
        email: widget.email,
        fullName: widget.fullName,
        role: UserRole.customer,
        isVerified: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Save minimal profile
      final success = await authProvider.createUserProfile(userProfile);

      if (success && mounted) {
        // Navigate to main app
        Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              authProvider.errorMessage ?? 'Failed to create profile',
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
