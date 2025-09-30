import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/supabase_service.dart';
import '../../../../core/models/user_profile.dart';
import '../../../../core/utils/debug_utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textLight),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                // Login Animation
                SizedBox(
                  height: 200,
                  child: Lottie.asset(
                    'assets/animations/login.json',
                    fit: BoxFit.contain,
                    repeat: true,
                    animate: true,
                  ),
                ),
                const SizedBox(height: 16),
                // Title
                Text(
                  'Welcome Back',
                  style: AppTextStyles.displaySmall.copyWith(
                    color: AppColors.textLight,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to continue exploring',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textSubtle,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                // Email Field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textLight,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSubtle,
                    ),
                    hintText: 'Enter your email',
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSubtle,
                    ),
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: AppColors.textSubtle,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: AppColors.grey300,
                        width: 1.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: AppColors.grey300,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 2.0,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: AppColors.error,
                        width: 1.0,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textLight,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSubtle,
                    ),
                    hintText: 'Enter your password',
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSubtle,
                    ),
                    prefixIcon: Icon(
                      Icons.lock_outlined,
                      color: AppColors.textSubtle,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.textSubtle,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: AppColors.grey300,
                        width: 1.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: AppColors.grey300,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 2.0,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: AppColors.error,
                        width: 1.0,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Login Button
                CustomButton(
                  text: 'Sign In',
                  onPressed: _isLoading ? null : _handleLogin,
                  isLoading: _isLoading,
                  type: ButtonType.primary,
                  size: ButtonSize.large,
                  fullWidth: true,
                ),
                const SizedBox(height: 16),

                // Forgot Password
                TextButton(
                  onPressed: () {
                    // TODO: Implement forgot password
                  },
                  child: Text(
                    'Forgot Password?',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),

                const SizedBox(height: 48),

                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account? ',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSubtle,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: Text(
                        'Sign Up',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final supabaseService = SupabaseService.instance;

      // Sign in with Supabase
      final response = await supabaseService.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (response.user != null && mounted) {
        // Try to get or create user profile
        try {
          var userProfile = await supabaseService.getCurrentUserProfile();

          // If no profile exists, create one
          if (userProfile == null && response.user != null) {
            userProfile = UserProfile(
              id: response.user!.id,
              email: response.user!.email!,
              fullName: response.user!.userMetadata?['full_name'] ?? 'User',
              role: UserRole.customer,
              isVerified: false,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );

            await supabaseService.createUserProfile(userProfile);
          }
        } catch (profileError) {
          // Profile creation failed, but login succeeded
          safePrint('Profile error: $profileError');
        }

        // Navigate to main screen
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/main');
        }
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'Login failed';

        // Handle specific Supabase errors
        if (e.toString().contains('Invalid login credentials')) {
          errorMessage = 'Invalid email or password';
        } else if (e.toString().contains('Email not confirmed')) {
          errorMessage = 'Please verify your email address';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
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
