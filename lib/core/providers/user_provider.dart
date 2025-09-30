import 'package:flutter/foundation.dart';
import '../../shared/models/user_profile.dart';

class UserProvider extends ChangeNotifier {
  UserProfile? _currentUser;
  bool _isAuthenticated = false;
  bool _isLoading = false;

  UserProfile? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;

  Future<void> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Implement actual Supabase authentication
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call

      // Mock user data for now
      _currentUser = UserProfile(
        id: 'user_123',
        email: email,
        fullName: 'John Doe',
        phoneNumber: '+91 98765 43210',
        avatarUrl:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=300&q=80',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      _isAuthenticated = true;
    } catch (e) {
      // Handle sign in error
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password, String fullName) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Implement actual Supabase authentication
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call

      // Mock user data for now
      _currentUser = UserProfile(
        id: 'user_123',
        email: email,
        fullName: fullName,
        avatarUrl: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      _isAuthenticated = true;
    } catch (e) {
      // Handle sign up error
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Implement actual Supabase sign out
      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Simulate API call

      _currentUser = null;
      _isAuthenticated = false;
    } catch (e) {
      // Handle sign out error
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? avatarUrl,
  }) async {
    if (_currentUser == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Implement actual profile update
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call

      _currentUser = _currentUser!.copyWith(
        fullName: fullName ?? _currentUser!.fullName,
        phoneNumber: phoneNumber ?? _currentUser!.phoneNumber,
        avatarUrl: avatarUrl ?? _currentUser!.avatarUrl,
        updatedAt: DateTime.now(),
      );
    } catch (e) {
      // Handle update error
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Check actual authentication status from Supabase
      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Simulate API call

      // For now, assume user is not authenticated
      _isAuthenticated = false;
      _currentUser = null;
    } catch (e) {
      _isAuthenticated = false;
      _currentUser = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
