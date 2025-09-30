import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../../features/auth/presentation/screens/welcome_screen.dart';
import '../../shared/widgets/main_navigation_wrapper.dart';
import '../utils/debug_utils.dart';
import '../../features/auth/presentation/screens/user_details_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // print('AuthWrapper: isAuthenticated = ${authProvider.isAuthenticated}');
        // print(
        //   'AuthWrapper: currentUser = ${authProvider.currentUserProfile?.id ?? "null"}',
        // );

        // Show loading while checking authentication
        if (authProvider.isLoading) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // If authenticated, check profile status
        if (authProvider.isAuthenticated) {
          final user = authProvider.currentUser;

          // If no profile exists, show user details screen to collect information
          if (authProvider.currentUserProfile == null) {
            return UserDetailsScreen(
              email: user?.email ?? '',
              userId: user?.id ?? '',
              fullName: user?.userMetadata?['full_name'] ?? '',
            );
          }

          // User is fully authenticated with profile
          safePrint('AuthWrapper: User fully authenticated - showing main app');
          return const MainNavigationWrapper();
        }

        // Not authenticated, show welcome screen
        return const WelcomeScreen();
      },
    );
  }
}
