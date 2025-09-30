import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'login_screen.dart';

class ThankYouScreen extends StatefulWidget {
  final String email;
  final String fullName;

  const ThankYouScreen({
    super.key,
    required this.email,
    required this.fullName,
  });

  @override
  State<ThankYouScreen> createState() => _ThankYouScreenState();
}

class _ThankYouScreenState extends State<ThankYouScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    _fadeController.forward();

    // Start redirect timer immediately
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Common animation background colors to try:
    const Color animationBackgroundColor = Color(
      0xFFFFFFFF,
    ); // Pure white - most common for thank you animations
    // Alternative colors to try if white doesn't work:
    // const Color animationBackgroundColor = Color(0xFFF8F6F4); // Cream/off-white
    // const Color animationBackgroundColor = Color(0xFFE3F2FD); // Light blue
    // const Color animationBackgroundColor = Color(0xFFE8F5E8); // Light green
    // const Color animationBackgroundColor = Color(0xFFFFF8E1); // Light amber

    return Scaffold(
      backgroundColor: animationBackgroundColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: animationBackgroundColor,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Stack(
            children: [
              // Full screen background matching animation
              Container(
                width: double.infinity,
                height: double.infinity,
                color: animationBackgroundColor,
              ),
              // Animation full width, natural height, no stretching
              Center(
                child: SizedBox(
                  width: double.infinity, // Full width
                  child: Lottie.asset(
                    'assets/animations/thankyou.json',
                    fit: BoxFit.fitWidth, // Full width, maintain aspect ratio
                    repeat: true,
                    animate: true,
                  ),
                ),
              ),
              // Bottom message overlay
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  // Semi-transparent background to ensure text is readable
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        animationBackgroundColor.withOpacity(0.95),
                        animationBackgroundColor.withOpacity(0.8),
                        animationBackgroundColor.withOpacity(0.0),
                      ],
                      stops: const [0.0, 0.7, 1.0],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 20,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Redirecting to Login Page',
                                  style: AppTextStyles.titleLarge.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Please verify your email before logging in',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textSubtle,
                                    height: 1.4,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                // Loading indicator
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: AppColors.primary,
                                    strokeWidth: 2.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
