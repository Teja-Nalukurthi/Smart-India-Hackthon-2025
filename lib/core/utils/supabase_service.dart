import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/app_constants.dart';
import '../models/user_profile.dart';
import '../models/artisan.dart';
import '../models/product.dart';
import 'debug_utils.dart';

class SupabaseService {
  static SupabaseService? _instance;
  static SupabaseService get instance => _instance ??= SupabaseService._();

  SupabaseService._();

  SupabaseClient get client => Supabase.instance.client;

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: AppConstants.supabaseUrl,
      anonKey: AppConstants.supabaseAnonKey,
    );
  }

  // Auth methods
  User? get currentUser => client.auth.currentUser;

  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? metadata,
  }) async {
    return await client.auth.signUp(
      email: email,
      password: password,
      data: metadata,
    );
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }

  // User Profile methods
  Future<UserProfile?> getCurrentUserProfile() async {
    final user = currentUser;
    if (user == null) return null;

    final response = await client
        .from('user_profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    return response != null ? UserProfile.fromJson(response) : null;
  }

  Future<void> createUserProfile(UserProfile profile) async {
    final jsonData = profile.toJson();

    try {
      // print('SupabaseService: Inserting profile data: $jsonData');

      // Remove any null values that might cause issues
      jsonData.removeWhere((key, value) => value == null);
      // print('SupabaseService: Cleaned profile data: $jsonData');

      // Use upsert instead of insert to handle RLS issues better
      // Upsert will either insert or update, which can bypass some RLS constraints
      await client.from('user_profiles').upsert(jsonData).select();

      // print('SupabaseService: Insert response: ${response.toString()}');
      // print('SupabaseService: Profile inserted successfully');
    } catch (e) {
      // print('SupabaseService: Error creating user profile: $e');
      // print('SupabaseService: Error type: ${e.runtimeType}');

      // Try alternative approach with direct RPC call if available
      if (e.toString().contains('row-level security')) {
        // print(
        //   'SupabaseService: RLS issue detected, trying alternative approach...',
        // );
        try {
          // Alternative: Call a custom Supabase function that bypasses RLS
          await _createProfileWithRPC(jsonData);
          // print('SupabaseService: Profile created via RPC call');
        } catch (rpcError) {
          // print('SupabaseService: RPC approach also failed: $rpcError');
          throw Exception(
            'Unable to create profile due to database permissions. Please check your Supabase RLS policies.',
          );
        }
      } else if (e.toString().contains('duplicate key value')) {
        throw Exception('Profile already exists for this user');
      } else if (e.toString().contains('violates foreign key constraint')) {
        throw Exception('Invalid user ID - user not found in authentication');
      } else {
        throw Exception('Database error: $e');
      }
    }
  }

  Future<void> _createProfileWithRPC(Map<String, dynamic> profileData) async {
    // Try to call a custom function that can bypass RLS
    // This is a fallback approach
    try {
      await client.rpc(
        'create_user_profile_admin',
        params: {'profile_data': profileData},
      );
    } catch (e) {
      // If RPC doesn't exist, try one more direct approach
      safePrint(
        'SupabaseService: RPC not available, trying direct insert with retry...',
      );

      // Wait a moment for auth to fully settle
      await Future.delayed(const Duration(milliseconds: 500));

      // Try one more time with a fresh client call
      final response = await client
          .from('user_profiles')
          .insert(profileData)
          .select();

      if (response.isEmpty) {
        throw Exception('Profile creation returned empty response');
      }
    }
  }

  Future<void> updateUserProfile(UserProfile profile) async {
    await client
        .from('user_profiles')
        .update(profile.toJson())
        .eq('id', profile.id);
  }

  // Artisan methods
  Future<List<Artisan>> getArtisans({
    String? category,
    String? location,
    double? minRating,
    int limit = 20,
  }) async {
    var query = client.from('artisans').select();

    if (category != null) {
      query = query.eq('category', category);
    }
    if (location != null) {
      query = query.ilike('location', '%$location%');
    }
    if (minRating != null) {
      query = query.gte('rating', minRating);
    }

    final response = await query.order('rating', ascending: false).limit(limit);

    return response.map((json) => Artisan.fromJson(json)).toList();
  }

  Future<Artisan?> getArtisanById(String id) async {
    final response = await client
        .from('artisans')
        .select()
        .eq('id', id)
        .maybeSingle();

    return response != null ? Artisan.fromJson(response) : null;
  }

  Future<List<Artisan>> searchNearbyArtisans({
    required double latitude,
    required double longitude,
    double radiusKm = 10,
    String? category,
    int limit = 20,
  }) async {
    final response = await client.rpc(
      'find_nearby_artisans',
      params: {
        'user_lat': latitude,
        'user_lng': longitude,
        'radius_km': radiusKm,
        'category_filter': category,
        'limit_count': limit,
      },
    );

    return response.map((json) => Artisan.fromJson(json)).toList();
  }

  // Product methods
  Future<List<Product>> getProducts({
    String? artisanId,
    String? category,
    bool? isAvailable,
    int limit = 20,
  }) async {
    var query = client.from('products').select();

    if (artisanId != null) {
      query = query.eq('artisan_id', artisanId);
    }
    if (category != null) {
      query = query.eq('category', category);
    }
    if (isAvailable != null) {
      query = query.eq('is_available', isAvailable);
    }

    final response = await query
        .order('created_at', ascending: false)
        .limit(limit);

    return response.map((json) => Product.fromJson(json)).toList();
  }

  Future<Product?> getProductById(String id) async {
    final response = await client
        .from('products')
        .select()
        .eq('id', id)
        .maybeSingle();

    return response != null ? Product.fromJson(response) : null;
  }

  // Storage methods
  SupabaseStorageClient get storage => client.storage;

  Future<String> uploadFile({
    required String bucketName,
    required String filePath,
    required Uint8List fileBytes,
    Map<String, String>? metadata,
  }) async {
    await client.storage
        .from(bucketName)
        .uploadBinary(
          filePath,
          fileBytes,
          fileOptions: FileOptions(
            upsert: true,
            contentType: metadata?['contentType'],
          ),
        );

    return client.storage.from(bucketName).getPublicUrl(filePath);
  }

  String getPublicUrl(String bucketName, String filePath) {
    return client.storage.from(bucketName).getPublicUrl(filePath);
  }

  // Database table getters for direct access if needed
  SupabaseQueryBuilder get artisans => client.from('artisans');
  SupabaseQueryBuilder get products => client.from('products');
  SupabaseQueryBuilder get reviews => client.from('reviews');
  SupabaseQueryBuilder get bookings => client.from('bookings');
  SupabaseQueryBuilder get userProfiles => client.from('user_profiles');
  SupabaseQueryBuilder get chatSessions => client.from('chat_sessions');
  SupabaseQueryBuilder get chatMessages => client.from('chat_messages');
  SupabaseQueryBuilder get folkloreContent => client.from('folklore_content');
}
