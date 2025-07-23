import 'package:flutter/material.dart';
import '../networking/app_shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  static const Map<String, LanguageData> supportedLanguages = {
    'en': LanguageData('English', 'EN', Locale('en')),
    'hi': LanguageData('हिंदी', 'HI', Locale('hi')),
    'ta': LanguageData('தமிழ்', 'TA', Locale('ta')),
    'te': LanguageData('తెలుగు', 'TE', Locale('te')),
    'kn': LanguageData('ಕನ್ನಡ', 'KN', Locale('kn')),
    'ml': LanguageData('മലയാളം', 'ML', Locale('ml')),
  };

  Locale _currentLocale = const Locale('en');
  String _currentLanguageCode = 'en';

  Locale get currentLocale => _currentLocale;
  String get currentLanguageCode => _currentLanguageCode;
  LanguageData get currentLanguage => supportedLanguages[_currentLanguageCode]!;

  LanguageProvider() {
    _loadSavedLanguage();
  }

  void _loadSavedLanguage() {
    final savedLanguageCode = AppSharedPreferences.getLanguageCode();
    if (savedLanguageCode != null && supportedLanguages.containsKey(savedLanguageCode)) {
      _currentLanguageCode = savedLanguageCode;
      _currentLocale = Locale(savedLanguageCode);
    }
    notifyListeners();
  }

  Future<void> changeLanguage(String languageCode) async {
    if (supportedLanguages.containsKey(languageCode)) {
      _currentLanguageCode = languageCode;
      _currentLocale = Locale(languageCode);
      await AppSharedPreferences.setLanguageCode(languageCode);
      notifyListeners();
    }
  }

  List<LanguageData> getAvailableLanguages() {
    return supportedLanguages.values.toList();
  }
}

class LanguageData {
  final String name;
  final String code;
  final Locale locale;

  const LanguageData(this.name, this.code, this.locale);
}