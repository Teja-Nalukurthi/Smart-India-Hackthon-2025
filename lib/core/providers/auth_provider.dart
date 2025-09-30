import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/supabase_service.dart';
import '../models/user_profile.dart';
import '../utils/debug_utils.dart';

class AuthProvider extends ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService.instance;
  UserProfile? _currentUserProfile;
  bool _isLoading = false;
  String? _errorMessage;

  UserProfile? get currentUserProfile => _currentUserProfile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _supabaseService.currentUser != null;
  User? get currentUser => _supabaseService.currentUser;
  bool get isEmailConfirmed =>
      _supabaseService.currentUser?.emailConfirmedAt != null;

  AuthProvider() {
    _init();
  }

  void _init() {
    // Listen to auth state changes
    _supabaseService.authStateChanges.listen((event) {
      _handleAuthStateChange(event);
    });

    // Load current user if already authenticated
    _loadCurrentUser();
  }

  void _handleAuthStateChange(AuthState authState) {
    if (authState.event == AuthChangeEvent.signedIn) {
      _loadCurrentUser();
    } else if (authState.event == AuthChangeEvent.signedOut) {
      _currentUserProfile = null;
      _clearError();
      notifyListeners();
    }
  }

  Future<void> _loadCurrentUser() async {
    if (_supabaseService.currentUser == null) return;

    try {
      _setLoading(true);
      _currentUserProfile = await _supabaseService.getCurrentUserProfile();

      // If user is authenticated but has no profile, they might be a new user
      if (_currentUserProfile == null) {
        safePrint(
          'AuthProvider: User authenticated but no profile found. New user?',
        );
      }

      _clearError();
    } catch (e) {
      // Don't set error for missing profiles - this is normal for new users
      if (!e.toString().contains('Profile not found')) {
        _setError('Failed to load user profile: $e');
      }
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _setLoading(true);
      _clearError();

      final response = await _supabaseService.signIn(
        email: email,
        password: password,
      );

      if (response.user != null) {
        await _loadCurrentUser();
        return true;
      }
      return false;
    } catch (e) {
      _setError(_getAuthErrorMessage(e.toString()));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signUp(String email, String password, String fullName) async {
    try {
      _setLoading(true);
      _clearError();

      final response = await _supabaseService.signUp(
        email: email,
        password: password,
        metadata: {'full_name': fullName},
      );

      if (response.user != null) {
        return true; // User will need to verify email
      }
      return false;
    } catch (e) {
      _setError(_getAuthErrorMessage(e.toString()));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    try {
      _setLoading(true);
      await _supabaseService.signOut();
      _currentUserProfile = null;
      _clearError();
    } catch (e) {
      _setError('Failed to sign out: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> createUserProfile(UserProfile profile) async {
    try {
      _setLoading(true);
      _clearError();

      // print('AuthProvider: Creating profile for ${profile.id}');
      await _supabaseService.createUserProfile(profile);
      // print('AuthProvider: Profile created successfully');
      _currentUserProfile = profile;
      notifyListeners();
      return true;
    } catch (e) {
      // print('AuthProvider: Error creating profile: $e');
      _setError('Failed to create profile: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateProfile(UserProfile updatedProfile) async {
    try {
      _setLoading(true);
      _clearError();

      await _supabaseService.updateUserProfile(updatedProfile);
      _currentUserProfile = updatedProfile;
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to update profile: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _getAuthErrorMessage(String error) {
    if (error.contains('Invalid login credentials')) {
      return 'Invalid email or password';
    } else if (error.contains('User already registered')) {
      return 'An account with this email already exists';
    } else if (error.contains('Email not confirmed')) {
      return 'Please verify your email address';
    } else if (error.contains('Password should be at least')) {
      return 'Password must be at least 6 characters';
    } else {
      return error;
    }
  }

  void clearError() {
    _clearError();
  }
}
