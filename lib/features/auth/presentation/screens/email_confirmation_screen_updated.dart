import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../core/utils/supabase_service.dart';
import '../../../../core/utils/debug_utils.dart';
import 'profile_setup_screen.dart';
import 'login_screen.dart';

class EmailConfirmationScreen extends StatefulWidget {
  final String email;
  final String userId;
  final String fullName;

  const EmailConfirmationScreen({
    super.key,
    required this.email,
    required this.userId,
    required this.fullName,
  });

  @override
  State<EmailConfirmationScreen> createState() =>
      _EmailConfirmationScreenState();
}

class _EmailConfirmationScreenState extends State<EmailConfirmationScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _fadeController;
  late AnimationController _successController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  bool _isCheckingConfirmation = false;
  bool _isResending = false;
  bool _isEmailConfirmed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _successController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _successController, curve: Curves.elasticOut),
    );

    // Start the fade animation when screen loads
    _fadeController.forward();

    // Start checking for email confirmation periodically
    _startEmailConfirmationCheck();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fadeController.dispose();
    _successController.dispose();
    super.dispose();
  }

  void _startEmailConfirmationCheck() {
    // Check every 3 seconds if the email has been confirmed
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && !_isEmailConfirmed) {
        _checkEmailConfirmation();
      }
    });
  }

  Future<void> _checkEmailConfirmation() async {
    if (_isCheckingConfirmation || _isEmailConfirmed) return;

    setState(() {
      _isCheckingConfirmation = true;
    });

    try {
      // Refresh the user session to get latest confirmation status
      await SupabaseService.instance.client.auth.refreshSession();
      final refreshedUser = SupabaseService.instance.currentUser;

      if (refreshedUser != null && refreshedUser.emailConfirmedAt != null) {
        // Email is confirmed! Show success animation
        setState(() {
          _isEmailConfirmed = true;
        });

        // Start success animation
        _successController.forward();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Email confirmed successfully! 🎉'),
                ],
              ),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );

          // Wait for animation to complete, then navigate
          await Future.delayed(const Duration(seconds: 2));

          if (mounted) {
            // Force refresh the AuthProvider to pick up the new state
            context.read<AuthProvider>().clearError();

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileSetupScreen(
                  userId: widget.userId,
                  email: widget.email,
                  fullName: widget.fullName,
                ),
              ),
            );
          }
        }
        return;
      }
    } catch (e) {
      safePrint('Error checking email confirmation: $e');
    }

    setState(() {
      _isCheckingConfirmation = false;
    });

    // Continue checking if not confirmed yet
    if (mounted && !_isEmailConfirmed) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && !_isEmailConfirmed) {
          _checkEmailConfirmation();
        }
      });
    }
  }

  Future<void> _resendConfirmationEmail() async {
    if (_isResending) return;

    setState(() {
      _isResending = true;
    });

    try {
      await SupabaseService.instance.client.auth.resend(
        type: OtpType.signup,
        email: widget.email,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.email_outlined, color: Colors.white),
                SizedBox(width: 8),
                Text('Confirmation email sent! Check your inbox.'),
              ],
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 8),
                Expanded(
                  child: Text('Failed to resend email: ${e.toString()}'),
                ),
              ],
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isResending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Back button (hidden if email confirmed)
                if (!_isEmailConfirmed)
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.textLight,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  )
                else
                  const SizedBox(height: 56), // Keep space for layout
                // Animated content
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Success or Waiting Animation
                      if (_isEmailConfirmed)
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.green.withAlpha(
                                (255 * 0.1).round(),
                              ),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.green, width: 3),
                            ),
                            child: const Icon(
                              Icons.check_circle,
                              size: 80,
                              color: Colors.green,
                            ),
                          ),
                        )
                      else
                        // Email waiting animation
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: Lottie.asset(
                            'assets/animations/thankyou.json',
                            controller: _animationController,
                            fit: BoxFit.contain,
                            repeat: true,
                            // Fallback if animation file doesn't exist
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withAlpha(
                                    (255 * 0.1).round(),
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.email_outlined,
                                  size: 80,
                                  color: AppColors.primary,
                                ),
                              );
                            },
                          ),
                        ),

                      const SizedBox(height: 32),

                      // Title
                      Text(
                        _isEmailConfirmed
                            ? 'Email Confirmed!'
                            : 'Check Your Email',
                        style: AppTextStyles.displaySmall.copyWith(
                          color: _isEmailConfirmed
                              ? Colors.green
                              : AppColors.textLight,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 16),

                      // Description
                      if (_isEmailConfirmed)
                        Text(
                          'Your email has been verified successfully!\nSetting up your profile...',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.textSubtle,
                          ),
                          textAlign: TextAlign.center,
                        )
                      else ...[
                        Text(
                          'We sent a confirmation link to',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.textSubtle,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 8),

                        // Email
                        Text(
                          widget.email,
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],

                      if (!_isEmailConfirmed) ...[
                        const SizedBox(height: 24),

                        // Instructions
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withAlpha(
                              (255 * 0.05).round(),
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.primary.withAlpha(
                                (255 * 0.1).round(),
                              ),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: AppColors.primary,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Click the confirmation link in your email to activate your account',
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.textLight,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(
                                    Icons.refresh_outlined,
                                    color: AppColors.primary,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'This page will automatically redirect once confirmed',
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.textLight,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Checking status
                        if (_isCheckingConfirmation)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Checking confirmation status...',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textSubtle,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ],
                  ),
                ),

                // Bottom buttons (hidden when email is confirmed)
                if (!_isEmailConfirmed)
                  Column(
                    children: [
                      // Resend Email Button
                      CustomButton(
                        text: 'Resend Confirmation Email',
                        onPressed: _isResending
                            ? null
                            : _resendConfirmationEmail,
                        isLoading: _isResending,
                        type: ButtonType.secondary,
                        size: ButtonSize.large,
                        fullWidth: true,
                      ),

                      const SizedBox(height: 16),

                      // Sign In Instead Button
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Already confirmed? Sign In Instead',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Help text
                      Text(
                        'Didn\'t receive the email? Check your spam folder',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSubtle,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
