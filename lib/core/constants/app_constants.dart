import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  // Supabase Configuration
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  // Google Maps API Key
  static String get googleMapsApiKey => dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';

  // App Information
  static String get appName => dotenv.env['APP_NAME'] ?? 'GoLocal';
  static String get appVersion => dotenv.env['APP_VERSION'] ?? '1.0.0';
  static const String appDescription = 'Discover India\'s hidden heartbeat';

  // API Endpoints
  static const String baseApiUrl = 'https://api.golocal.com';

  // Storage Buckets (matching your database schema)
  static const String avatarsBucket = 'avatars';
  static const String artisanImagesBucket = 'artisan-images';
  static const String productImagesBucket = 'product-images';
  static const String galleryImagesBucket = 'gallery-images';
  static const String folkloreMediaBucket = 'folklore-media';
  static const String chatAttachmentsBucket = 'chat-attachments';

  // Chat Configuration
  static const String naradhaAiEndpoint = '/api/naradha/chat';

  // Location Configuration
  static const double defaultLocationRadius = 50.0; // 50 km
}
