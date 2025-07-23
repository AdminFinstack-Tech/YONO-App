import 'package:shared_preferences/shared_preferences.dart';
import 'app_constants.dart';

class AppSharedPreferences {
  static SharedPreferences? _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static SharedPreferences? get instance => _preferences;

  // Generic methods
  static Future<bool> setStringValue({required String key, required String value}) async {
    _preferences ??= await SharedPreferences.getInstance();
    return await _preferences!.setString(key, value);
  }

  static String? getStringValue(String key) {
    return _preferences?.getString(key);
  }

  static Future<bool> setBoolValue({required String key, required bool value}) async {
    _preferences ??= await SharedPreferences.getInstance();
    return await _preferences!.setBool(key, value);
  }

  static bool? getBoolValue(String key) {
    return _preferences?.getBool(key);
  }

  static Future<bool> setIntValue({required String key, required int value}) async {
    _preferences ??= await SharedPreferences.getInstance();
    return await _preferences!.setInt(key, value);
  }

  static int? getIntValue(String key) {
    return _preferences?.getInt(key);
  }

  static Future<bool> setDoubleValue({required String key, required double value}) async {
    _preferences ??= await SharedPreferences.getInstance();
    return await _preferences!.setDouble(key, value);
  }

  static double? getDoubleValue(String key) {
    return _preferences?.getDouble(key);
  }

  static Future<bool> setStringList({required String key, required List<String> value}) async {
    _preferences ??= await SharedPreferences.getInstance();
    return await _preferences!.setStringList(key, value);
  }

  static List<String>? getStringList(String key) {
    return _preferences?.getStringList(key);
  }

  static Future<bool> remove(String key) async {
    _preferences ??= await SharedPreferences.getInstance();
    return await _preferences!.remove(key);
  }

  static Future<bool> clear() async {
    _preferences ??= await SharedPreferences.getInstance();
    return await _preferences!.clear();
  }

  static bool containsKey(String key) {
    return _preferences?.containsKey(key) ?? false;
  }

  // App specific methods
  static Future<bool> setAccessToken(String token) async {
    return await setStringValue(key: AppConstants.ACCESS_TOKEN, value: token);
  }

  static String? getAccessToken() {
    return getStringValue(AppConstants.ACCESS_TOKEN);
  }

  static Future<bool> setRefreshToken(String token) async {
    return await setStringValue(key: AppConstants.REFRESH_TOKEN_KEY, value: token);
  }

  static String? getRefreshToken() {
    return getStringValue(AppConstants.REFRESH_TOKEN_KEY);
  }

  static Future<bool> setUserId(String userId) async {
    return await setStringValue(key: AppConstants.USER_ID, value: userId);
  }

  static String? getUserId() {
    return getStringValue(AppConstants.USER_ID);
  }

  static Future<bool> setUserName(String userName) async {
    return await setStringValue(key: AppConstants.USER_NAME, value: userName);
  }

  static String? getUserName() {
    return getStringValue(AppConstants.USER_NAME);
  }

  static Future<bool> setBusinessId(String businessId) async {
    return await setStringValue(key: AppConstants.BUSINESS_ID, value: businessId);
  }

  static String? getBusinessId() {
    return getStringValue(AppConstants.BUSINESS_ID);
  }

  static Future<bool> setBusinessName(String businessName) async {
    return await setStringValue(key: AppConstants.BUSINESS_NAME, value: businessName);
  }

  static String? getBusinessName() {
    return getStringValue(AppConstants.BUSINESS_NAME);
  }

  static Future<bool> setLanguageCode(String langCode) async {
    return await setStringValue(key: AppConstants.LANGUAGE_CODE, value: langCode);
  }

  static String? getLanguageCode() {
    return getStringValue(AppConstants.LANGUAGE_CODE) ?? 'en';
  }

  static Future<bool> setThemeMode(String themeMode) async {
    return await setStringValue(key: AppConstants.THEME_MODE, value: themeMode);
  }

  static String? getThemeMode() {
    return getStringValue(AppConstants.THEME_MODE);
  }

  static Future<bool> setBiometricEnabled(bool enabled) async {
    return await setBoolValue(key: AppConstants.BIOMETRIC_ENABLED, value: enabled);
  }

  static bool isBiometricEnabled() {
    return getBoolValue(AppConstants.BIOMETRIC_ENABLED) ?? false;
  }

  static Future<bool> setRememberMe(bool remember) async {
    return await setBoolValue(key: AppConstants.REMEMBER_ME, value: remember);
  }

  static bool isRememberMe() {
    return getBoolValue(AppConstants.REMEMBER_ME) ?? false;
  }

  static Future<bool> setFirstTime(bool isFirst) async {
    return await setBoolValue(key: AppConstants.IS_FIRST_TIME, value: isFirst);
  }

  static bool isFirstTime() {
    return getBoolValue(AppConstants.IS_FIRST_TIME) ?? true;
  }

  static Future<bool> setLastLogin(String dateTime) async {
    return await setStringValue(key: AppConstants.LAST_LOGIN, value: dateTime);
  }

  static String? getLastLogin() {
    return getStringValue(AppConstants.LAST_LOGIN);
  }

  static Future<bool> setFirebaseToken(String token) async {
    return await setStringValue(key: AppConstants.FIREBASE_TOKEN, value: token);
  }

  static String? getFirebaseToken() {
    return getStringValue(AppConstants.FIREBASE_TOKEN);
  }

  static Future<bool> setDeviceId(String deviceId) async {
    return await setStringValue(key: AppConstants.DEVICE_ID, value: deviceId);
  }

  static String? getDeviceId() {
    return getStringValue(AppConstants.DEVICE_ID);
  }

  // Clear user session
  static Future<void> clearUserSession() async {
    await remove(AppConstants.ACCESS_TOKEN);
    await remove(AppConstants.REFRESH_TOKEN_KEY);
    await remove(AppConstants.USER_ID);
    await remove(AppConstants.USER_NAME);
    await remove(AppConstants.BUSINESS_ID);
    await remove(AppConstants.BUSINESS_NAME);
  }

  // Check if user is logged in
  static bool isLoggedIn() {
    return getAccessToken() != null && getAccessToken()!.isNotEmpty;
  }
}