import 'package:flutter/foundation.dart';
import 'base_view_model.dart';
import '../models/user_model.dart';
import '../models/business_model.dart';
import '../networking/http_util.dart';
import '../networking/app_constants.dart';
import '../networking/app_shared_preferences.dart';
import '../networking/base_response.dart';

class UserViewModel extends BaseViewModel {
  UserModel? _currentUser;
  BusinessModel? _businessProfile;
  bool _isAuthenticated = false;

  UserModel? get currentUser => _currentUser;
  BusinessModel? get businessProfile => _businessProfile;
  bool get isAuthenticated => _isAuthenticated;

  UserViewModel() {
    _checkAuthStatus();
  }

  void _checkAuthStatus() {
    _isAuthenticated = AppSharedPreferences.isLoggedIn();
    if (_isAuthenticated) {
      loadUserData();
    }
  }

  Future<void> loadUserData() async {
    final userId = AppSharedPreferences.getUserId();
    final userName = AppSharedPreferences.getUserName();
    final businessId = AppSharedPreferences.getBusinessId();
    final businessName = AppSharedPreferences.getBusinessName();

    if (userId != null && userName != null) {
      _currentUser = UserModel(
        userId: userId,
        userName: userName,
        email: '', // Load from API if needed
        mobileNumber: '', // Load from API if needed
      );
    }

    if (businessId != null && businessName != null) {
      _businessProfile = BusinessModel(
        businessId: businessId,
        businessName: businessName,
        registrationNumber: '', // Load from API if needed
        taxId: '', // Load from API if needed
      );
    }

    notifyListeners();
  }

  Future<bool> login({
    required String username,
    required String password,
    bool rememberMe = false,
  }) async {
    final result = await makeApiCall<BaseResponse<LoginResponse>>(
      () async {
        final response = await HttpUtil.post(
          AppConstants.LOGIN,
          data: {
            'username': username,
            'password': password,
            'device_id': AppSharedPreferences.getDeviceId(),
            'firebase_token': AppSharedPreferences.getFirebaseToken(),
          },
        );
        
        return BaseResponse.fromJson(
          response.data,
          (json) => LoginResponse.fromJson(json as Map<String, dynamic>),
        );
      },
      onSuccess: (response) async {
        if (response.success && response.data != null) {
          final loginData = response.data!;
          
          // Save tokens
          await AppSharedPreferences.setAccessToken(loginData.accessToken);
          await AppSharedPreferences.setRefreshToken(loginData.refreshToken);
          
          // Save user info
          await AppSharedPreferences.setUserId(loginData.user.userId);
          await AppSharedPreferences.setUserName(loginData.user.userName);
          
          // Save business info
          await AppSharedPreferences.setBusinessId(loginData.business.businessId);
          await AppSharedPreferences.setBusinessName(loginData.business.businessName);
          
          // Save remember me preference
          await AppSharedPreferences.setRememberMe(rememberMe);
          
          // Update local state
          _currentUser = loginData.user;
          _businessProfile = loginData.business;
          _isAuthenticated = true;
          
          // Save last login time
          await AppSharedPreferences.setLastLogin(DateTime.now().toIso8601String());
        }
      },
    );

    return result?.success ?? false;
  }

  Future<bool> logout() async {
    final result = await makeApiCall<BaseResponse<dynamic>>(
      () async {
        final response = await HttpUtil.post(AppConstants.LOGOUT);
        return BaseResponse.fromJson(
          response.data,
          (json) => json,
        );
      },
      showLoading: false,
    );

    // Clear local data regardless of API response
    await _clearUserData();
    
    return true;
  }

  Future<void> _clearUserData() async {
    await AppSharedPreferences.clearUserSession();
    _currentUser = null;
    _businessProfile = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<bool> updateProfile({
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
          _currentUser = response.data;
        }
      },
    );

    return result?.success ?? false;
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final result = await makeApiCall<BaseResponse<dynamic>>(
      () async {
        final response = await HttpUtil.post(
          AppConstants.CHANGE_PIN,
          data: {
            'current_password': currentPassword,
            'new_password': newPassword,
          },
        );
        
        return BaseResponse.fromJson(
          response.data,
          (json) => json,
        );
      },
    );

    return result?.success ?? false;
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
          _currentUser = response.data;
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

  void updateAuthStatus(bool isAuthenticated) {
    _isAuthenticated = isAuthenticated;
    notifyListeners();
  }
}

// Response model for login
class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final UserModel user;
  final BusinessModel business;

  LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
    required this.business,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      user: UserModel.fromJson(json['user']),
      business: BusinessModel.fromJson(json['business']),
    );
  }
}