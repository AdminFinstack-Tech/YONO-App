import 'package:flutter/material.dart';
import 'base_view_model.dart';
import '../networking/app_shared_preferences.dart';

class PreferenceViewModel extends BaseViewModel {
  String? _langCode;
  bool _biometricEnabled = false;
  bool _notificationsEnabled = true;
  String _themeMode = 'light';
  
  String? get langCode => _langCode;
  bool get biometricEnabled => _biometricEnabled;
  bool get notificationsEnabled => _notificationsEnabled;
  String get themeMode => _themeMode;
  
  PreferenceViewModel() {
    loadPreferences();
  }
  
  Future<void> loadPreferences() async {
    _langCode = AppSharedPreferences.getLanguageCode() ?? 'en';
    _biometricEnabled = AppSharedPreferences.isBiometricEnabled();
    _themeMode = AppSharedPreferences.getThemeMode() ?? 'light';
    notifyListeners();
  }
  
  Future<void> setLanguage(String languageCode) async {
    await AppSharedPreferences.setLanguageCode(languageCode);
    _langCode = languageCode;
    notifyListeners();
  }
  
  Future<void> setBiometricEnabled(bool enabled) async {
    await AppSharedPreferences.setBiometricEnabled(enabled);
    _biometricEnabled = enabled;
    notifyListeners();
  }
  
  Future<void> setNotificationsEnabled(bool enabled) async {
    _notificationsEnabled = enabled;
    notifyListeners();
  }
  
  Future<void> setThemeMode(String mode) async {
    await AppSharedPreferences.setThemeMode(mode);
    _themeMode = mode;
    notifyListeners();
  }
  
  Future<void> setFirstTimeComplete() async {
    // Mark first time completion in SharedPreferences
    // This method can be implemented based on your app's requirements
    await Future.delayed(const Duration(milliseconds: 100)); // Simulate async operation
  }
}