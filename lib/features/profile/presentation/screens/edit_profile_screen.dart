import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/models/user_profile.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_form_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;
  late TextEditingController _bioController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with current user data
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userProfile = authProvider.currentUserProfile;

    _fullNameController = TextEditingController(
      text: userProfile?.fullName ?? '',
    );
    _phoneController = TextEditingController(
      text: userProfile?.phoneNumber ?? '',
    );
    _locationController = TextEditingController(
      text: userProfile?.location ?? '',
    );
    _bioController = TextEditingController(text: userProfile?.bio ?? '');
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.textLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textLight),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final userProfile = authProvider.currentUserProfile;

          if (userProfile == null) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Picture Section
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: userProfile.avatarUrl != null
                              ? NetworkImage(userProfile.avatarUrl!)
                              : null,
                          child: userProfile.avatarUrl == null
                              ? const Icon(
                                  Icons.person,
                                  size: 70,
                                  color: Colors.white,
                                )
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
                                // TODO: Implement image picker
                                _showImagePickerDialog();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Full Name Field
                  Text(
                    'Full Name',
                    style: AppTextStyles.titleSmall.copyWith(
                      color: AppColors.textLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomTextFormField(
                    controller: _fullNameController,
                    labelText: 'Full Name',
                    hintText: 'Enter your full name',
                    prefixIcon: Icons.person_outline,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Phone Number Field
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

                  // Location Field
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
                    hintText: 'Enter your location',
                    prefixIcon: Icons.location_on_outlined,
                  ),

                  const SizedBox(height: 20),

                  // Bio Field
                  Text(
                    'Bio',
                    style: AppTextStyles.titleSmall.copyWith(
                      color: AppColors.textLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomTextFormField(
                    controller: _bioController,
                    labelText: 'Bio',
                    hintText: 'Tell us about yourself',
                    prefixIcon: Icons.edit_outlined,
                    maxLines: 4,
                    maxLength: 200,
                  ),

                  const SizedBox(height: 32),

                  // Save Button
                  CustomButton(
                    text: 'Save Changes',
                    onPressed: _isLoading ? null : _handleSaveProfile,
                    isLoading: _isLoading,
                    type: ButtonType.primary,
                    size: ButtonSize.large,
                    fullWidth: true,
                  ),

                  const SizedBox(height: 16),

                  // Cancel Button
                  CustomButton(
                    text: 'Cancel',
                    onPressed: _isLoading
                        ? null
                        : () {
                            Navigator.pop(context);
                          },
                    type: ButtonType.secondary,
                    size: ButtonSize.large,
                    fullWidth: true,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleSaveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final currentProfile = authProvider.currentUserProfile!;

      // Create updated profile
      final updatedProfile = UserProfile(
        id: currentProfile.id,
        email: currentProfile.email,
        fullName: _fullNameController.text.trim(),
        avatarUrl: currentProfile.avatarUrl,
        phoneNumber: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
        location: _locationController.text.trim().isEmpty
            ? null
            : _locationController.text.trim(),
        bio: _bioController.text.trim().isEmpty
            ? null
            : _bioController.text.trim(),
        role: currentProfile.role,
        isVerified: currentProfile.isVerified,
        latitude: currentProfile.latitude,
        longitude: currentProfile.longitude,
        createdAt: currentProfile.createdAt,
        updatedAt: DateTime.now(),
      );

      // Update profile using AuthProvider
      final success = await authProvider.updateProfile(updatedProfile);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              authProvider.errorMessage ?? 'Failed to update profile',
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating profile: $e'),
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

  void _showImagePickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Change Profile Picture',
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.textLight,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Profile picture upload functionality will be implemented soon.',
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
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
