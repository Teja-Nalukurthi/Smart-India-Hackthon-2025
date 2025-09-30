import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/user_provider.dart';
import 'core/providers/favorites_provider.dart';
import 'core/providers/app_state_provider.dart';
import 'core/providers/auth_provider.dart';
import 'core/widgets/auth_wrapper.dart';
import 'core/utils/supabase_service.dart';
import 'features/auth/presentation/screens/welcome_screen.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/chat/presentation/screens/chat_screen.dart';
import 'features/artisan/presentation/screens/artisan_detail_screen.dart';
import 'features/auth/presentation/screens/signup_screen.dart';
import 'features/test/database_test_screen.dart';
import 'features/debug/database_test_screen.dart' as debug;
import 'shared/widgets/main_navigation_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Supabase
  await SupabaseService.initialize();

  runApp(const GoLocalApp());
}

class GoLocalApp extends StatelessWidget {
  const GoLocalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => AppStateProvider()),
      ],
      child: MaterialApp(
        title: 'GoLocal',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        initialRoute: '/',
        routes: {
          '/': (context) => const AuthWrapper(),
          '/welcome': (context) => const WelcomeScreen(),
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignupScreen(),
          '/main': (context) => const MainNavigationWrapper(),
          '/home': (context) => const MainNavigationWrapper(initialIndex: 0),
          '/search': (context) => const MainNavigationWrapper(initialIndex: 1),
          '/favorites': (context) =>
              const MainNavigationWrapper(initialIndex: 2),
          '/profile': (context) => const MainNavigationWrapper(initialIndex: 3),
          '/chat': (context) => const ChatScreen(),
          '/artisan-detail': (context) => const ArtisanDetailScreen(),
          '/database-test': (context) =>
              const DatabaseTestScreen(), // Test screen
          '/debug-db': (context) =>
              const debug.DatabaseTestScreen(), // Debug screen
          // Add more routes here
        },
      ),
    );
  }
}
