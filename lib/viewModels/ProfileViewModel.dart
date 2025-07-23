import 'base_view_model.dart';
import '../models/user_model.dart';
import '../models/business_model.dart';
import '../networking/http_util.dart';
import '../networking/app_constants.dart';
import '../networking/base_response.dart';
import '../networking/app_shared_preferences.dart';

class ProfileViewModel extends BaseViewModel {
  UserModel? _userProfile;
  BusinessModel? _businessProfile;
  Map<String, dynamic>? _preferences;
  
  UserModel? get userProfile => _userProfile;
  BusinessModel? get businessProfile => _businessProfile;
  Map<String, dynamic>? get preferences => _preferences;
  
  Future<void> loadProfile() async {
    await Future.wait([
      fetchUserProfile(),
      fetchBusinessProfile(),
      loadPreferences(),
    ]);
  }
  
  Future<UserModel?> fetchUserProfile() async {
    final result = await makeApiCall<BaseResponse<UserModel>>(
      () async {
        final response = await HttpUtil.get(AppConstants.USER_PROFILE);
        return BaseResponse.fromJson(
          response.data,
          (json) => UserModel.fromJson(json as Map<String, dynamic>),
        );
      },
      onSuccess: (response) {
        if (response.success && response.data != null) {
          _userProfile = response.data;
        }
      },
    );
    
    return result?.data;
  }
  
  Future<BusinessModel?> fetchBusinessProfile() async {
    final result = await makeApiCall<BaseResponse<BusinessModel>>(
      () async {
        final response = await HttpUtil.get(AppConstants.BUSINESS_PROFILE);
        return BaseResponse.fromJson(
          response.data,
          (json) => BusinessModel.fromJson(json as Map<String, dynamic>),
        );
      },
      onSuccess: (response) {
        if (response.success && response.data != null) {
          _businessProfile = response.data;
        }
      },
    );
    
    return result?.data;
  }
  
  Future<void> loadPreferences() async {
    _preferences = {
      'language': AppSharedPreferences.getLanguageCode(),
      'biometric_enabled': AppSharedPreferences.isBiometricEnabled(),
      'theme_mode': AppSharedPreferences.getThemeMode(),
    };
    notifyListeners();
  }
  
  Future<bool> updateUserProfile({
    required String firstName,
    required String lastName,
    required String email,
    required String mobileNumber,
  }) async {
    final result = await makeApiCall<BaseResponse<UserModel>>(
      () async {
        final response = await HttpUtil.put(
          AppConstants.UPDATE_PROFILE,
          data: {
            'first_name': firstName,
            'last_name': lastName,
            'email': email,
            'mobile_number': mobileNumber,
          },
        );
        
        return BaseResponse.fromJson(
          response.data,
          (json) => UserModel.fromJson(json as Map<String, dynamic>),
        );
      },
      onSuccess: (response) {
        if (response.success && response.data != null) {
          _userProfile = response.data;
        }
      },
    );
    
    return result?.success ?? false;
  }
  
  Future<bool> updateBusinessProfile({
    required Map<String, dynamic> businessData,
  }) async {
    final result = await makeApiCall<BaseResponse<BusinessModel>>(
      () async {
        final response = await HttpUtil.put(
          AppConstants.UPDATE_BUSINESS,
          data: businessData,
        );
        
        return BaseResponse.fromJson(
          response.data,
          (json) => BusinessModel.fromJson(json as Map<String, dynamic>),
        );
      },
      onSuccess: (response) {
        if (response.success && response.data != null) {
          _businessProfile = response.data;
        }
      },
    );
    
    return result?.success ?? false;
  }
  
  Future<bool> updateBiometricSetting(bool enabled) async {
    await AppSharedPreferences.setBiometricEnabled(enabled);
    _preferences?['biometric_enabled'] = enabled;
    notifyListeners();
    return true;
  }
  
  Future<bool> updateLanguage(String languageCode) async {
    await AppSharedPreferences.setLanguageCode(languageCode);
    _preferences?['language'] = languageCode;
    notifyListeners();
    return true;
  }
  
  Future<bool> uploadProfileImage(String imagePath) async {
    // Implement profile image upload
    return true;
  }
}