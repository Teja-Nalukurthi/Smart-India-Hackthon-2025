import 'package:flutter/foundation.dart';

class AppStateProvider extends ChangeNotifier {
  bool _isOnboarded = false;
  String _selectedLanguage = 'en';
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;

  bool get isOnboarded => _isOnboarded;
  String get selectedLanguage => _selectedLanguage;
  bool get isDarkMode => _isDarkMode;
  bool get notificationsEnabled => _notificationsEnabled;

  void completeOnboarding() {
    _isOnboarded = true;
    notifyListeners();
    _savePreferences();
  }

  void setLanguage(String languageCode) {
    if (_selectedLanguage != languageCode) {
      _selectedLanguage = languageCode;
      notifyListeners();
      _savePreferences();
    }
  }

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    _savePreferences();
  }

  void setDarkMode(bool enabled) {
    if (_isDarkMode != enabled) {
      _isDarkMode = enabled;
      notifyListeners();
      _savePreferences();
    }
  }

  void toggleNotifications() {
    _notificationsEnabled = !_notificationsEnabled;
    notifyListeners();
    _savePreferences();
  }

  void setNotifications(bool enabled) {
    if (_notificationsEnabled != enabled) {
      _notificationsEnabled = enabled;
      notifyListeners();
      _savePreferences();
    }
  }

  Future<void> loadPreferences() async {
    // TODO: Load preferences from SharedPreferences or similar
    await Future.delayed(const Duration(milliseconds: 300));

    // Mock loading preferences
    _isOnboarded = false; // Force onboarding for demo
    _selectedLanguage = 'en';
    _isDarkMode = false;
    _notificationsEnabled = true;

    notifyListeners();
  }

  Future<void> _savePreferences() async {
    // TODO: Save preferences to SharedPreferences or similar
    await Future.delayed(const Duration(milliseconds: 100));
  }

  void reset() {
    _isOnboarded = false;
    _selectedLanguage = 'en';
    _isDarkMode = false;
    _notificationsEnabled = true;
    notifyListeners();
    _savePreferences();
  }
}
