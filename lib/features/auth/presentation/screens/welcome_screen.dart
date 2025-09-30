import 'package:flutter/material.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../core/theme/app_text_styles.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1524492412937-b28074a5d7da?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1171&q=80',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Gradient Overlay
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Color(0x80000000),
                  Color(0xCC000000),
                ],
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),
                  // Title
                  Text(
                    'Go Beyond The Map',
                    style: AppTextStyles.displaySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  // Subtitle
                  Text(
                    'Discover India\'s hidden heartbeat: authentic artisans, food, events, and culture.',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: Colors.white.withAlpha((255 * 0.9).round()),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  // Explore Now Button (Sign Up)
                  CustomButton(
                    text: 'Get Started',
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    type: ButtonType.primary,
                    size: ButtonSize.large,
                    fullWidth: true,
                  ),
                  const SizedBox(height: 16),
                  // Login Button
                  CustomButton(
                    text: 'Sign In',
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    type: ButtonType.secondary,
                    size: ButtonSize.large,
                    fullWidth: true,
                  ),
                  const SizedBox(height: 16),
                  // Database Test Link (Development only)
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/database-test');
                    },
                    child: Text(
                      'Test Database Connection',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white.withAlpha((255 * 0.6).round()),
                        decoration: TextDecoration.underline,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
