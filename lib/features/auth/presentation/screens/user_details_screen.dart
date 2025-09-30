import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/models/user_profile.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_form_field.dart';

class UserDetailsScreen extends StatefulWidget {
  final String userId;
  final String email;
  final String fullName;

  const UserDetailsScreen({
    super.key,
    required this.userId,
    required this.email,
    required this.fullName,
  });

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _bioController = TextEditingController();
  final _ageController = TextEditingController();

  // Location data
  String? _selectedAddress;
  double? _selectedLatitude;
  double? _selectedLongitude;
  String? _city;
  String? _state;
  String? _country;

  UserRole _selectedRole = UserRole.customer;
  String _selectedGender = 'Prefer not to say';
  bool _isLoading = false;
  bool _showThankYou = false;
  bool _isLocationLoading = false;

  // Animation controllers
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    _fadeController.forward();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _locationController.dispose();
    _bioController.dispose();
    _ageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: _showThankYou ? _buildThankYouPage() : _buildDetailsForm(),
      ),
    );
  }

  Widget _buildThankYouPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Thank you animation
          Lottie.asset(
            'assets/animations/thankyou.json',
            width: 200,
            height: 200,
            repeat: false,
            onLoaded: (composition) {
              // Navigate to main app after animation completes
              Future.delayed(composition.duration, () {
                if (mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/main',
                    (route) => false,
                  );
                }
              });
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Welcome to GoLocal!',
            style: AppTextStyles.headlineMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your profile has been created successfully.',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSubtle,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsForm() {
    return FadeTransition(
      opacity: _fadeAnimation,
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
                      'Tell us about yourself',
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: AppColors.textLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Help us personalize your GoLocal experience',
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

              // Age
              Text(
                'Age',
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.textLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              CustomTextFormField(
                controller: _ageController,
                labelText: 'Age',
                hintText: 'Enter your age',
                prefixIcon: Icons.cake_outlined,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  final age = int.tryParse(value);
                  if (age == null || age < 13 || age > 100) {
                    return 'Please enter a valid age (13-100)';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Gender
              Text(
                'Gender',
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.textLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.grey200),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedGender,
                    isExpanded: true,
                    items: ['Male', 'Female', 'Other', 'Prefer not to say']
                        .map(
                          (gender) => DropdownMenuItem(
                            value: gender,
                            child: Text(gender),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value ?? 'Prefer not to say';
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

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
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (!RegExp(r'^\+?[\d\s\-\(\)]+$').hasMatch(value)) {
                    return 'Please enter a valid phone number';
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
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      controller: _locationController,
                      labelText: 'Location',
                      hintText: 'Enter your city, state',
                      prefixIcon: Icons.location_on_outlined,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your location';
                        }
                        return null;
                      },
                      onChanged: (_) => _onLocationTextChanged(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: _isLocationLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.my_location, color: Colors.white),
                      onPressed: _isLocationLoading
                          ? null
                          : _getCurrentLocation,
                      tooltip: 'Get current location',
                    ),
                  ),
                ],
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

              // Submit Button
              CustomButton(
                text: 'Create My Profile',
                onPressed: _isLoading ? null : _handleSubmit,
                isLoading: _isLoading,
                type: ButtonType.primary,
                size: ButtonSize.large,
                fullWidth: true,
              ),

              const SizedBox(height: 32),
            ],
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
          color: isSelected
              ? AppColors.primary.withAlpha((255 * 0.1).round())
              : Colors.white,
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

  void _onLocationTextChanged() {
    // Simple location text change handler
    // In a real app, you could implement search suggestions here
    setState(() {
      _selectedAddress = _locationController.text;
    });
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLocationLoading = true;
    });

    try {
      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showErrorSnackBar('Location permissions are denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showErrorSnackBar('Location permissions are permanently denied');
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      // Get address from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address = '';

        if (place.subLocality != null && place.subLocality!.isNotEmpty) {
          address += '${place.subLocality}, ';
        }
        if (place.locality != null && place.locality!.isNotEmpty) {
          address += '${place.locality}, ';
        }
        if (place.administrativeArea != null &&
            place.administrativeArea!.isNotEmpty) {
          address += '${place.administrativeArea}, ';
        }
        if (place.country != null && place.country!.isNotEmpty) {
          address += place.country!;
        }

        setState(() {
          _locationController.text = address.replaceAll(RegExp(r', $'), '');
          _selectedAddress = _locationController.text;
          _selectedLatitude = position.latitude;
          _selectedLongitude = position.longitude;
          _city = place.locality;
          _state = place.administrativeArea;
          _country = place.country;
        });

        _showSuccessSnackBar('Location detected successfully!');
      }
    } catch (e) {
      _showErrorSnackBar('Failed to get current location: $e');
    } finally {
      setState(() {
        _isLocationLoading = false;
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // If location text exists but no coordinates, try to geocode it
      if (_locationController.text.isNotEmpty &&
          (_selectedLatitude == null || _selectedLongitude == null)) {
        await _geocodeLocation(_locationController.text);
      }

      // Create comprehensive user profile
      final userProfile = UserProfile(
        id: widget.userId,
        email: widget.email,
        fullName: widget.fullName,
        phoneNumber: _phoneController.text.trim(),
        location: _locationController.text.trim(),
        bio: _bioController.text.trim().isEmpty
            ? null
            : _bioController.text.trim(),
        role: _selectedRole,
        isVerified: false,
        latitude: _selectedLatitude,
        longitude: _selectedLongitude,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Save profile using AuthProvider
      final success = await authProvider.createUserProfile(userProfile);

      if (success && mounted) {
        // Show success and thank you animation
        setState(() {
          _showThankYou = true;
        });

        // Also save additional location data if needed
        await _saveLocationDetails();
      } else if (mounted) {
        _showErrorSnackBar(
          authProvider.errorMessage ?? 'Failed to create profile',
        );
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Error creating profile: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _geocodeLocation(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        setState(() {
          _selectedLatitude = locations[0].latitude;
          _selectedLongitude = locations[0].longitude;
        });

        // Get place details from coordinates
        List<Placemark> placemarks = await placemarkFromCoordinates(
          locations[0].latitude,
          locations[0].longitude,
        );

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          setState(() {
            _city = place.locality;
            _state = place.administrativeArea;
            _country = place.country;
          });
        }
      }
    } catch (e) {
      print('Error geocoding location: $e');
      // Don't show error to user as this is optional
    }
  }

  Future<void> _saveLocationDetails() async {
    // Here you can save additional location details to your database
    print('Location Details Saved:');
    print('Address: $_selectedAddress');
    print('Latitude: $_selectedLatitude');
    print('Longitude: $_selectedLongitude');
    print('City: $_city');
    print('State: $_state');
    print('Country: $_country');
    print('Age: ${_ageController.text}');
    print('Gender: $_selectedGender');
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.error,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
      ),
    );
  }
}
