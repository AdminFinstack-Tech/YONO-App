import 'base_view_model.dart';
import '../networking/http_util.dart';
import '../networking/app_constants.dart';
import '../networking/base_response.dart';
import '../networking/app_shared_preferences.dart';

class AuthViewModel extends BaseViewModel {
  // OTP Verification
  Future<bool> verifyOTP({
    required String mobile,
    required String otp,
    required String requestId,
  }) async {
    final result = await makeApiCall<BaseResponse<OTPVerificationResponse>>(
      () async {
        final response = await HttpUtil.post(
          AppConstants.VERIFY_OTP,
          data: {
            'mobile_number': mobile,
            'otp': otp,
            'request_id': requestId,
          },
        );
        
        return BaseResponse.fromJson(
          response.data,
          (json) => OTPVerificationResponse.fromJson(json as Map<String, dynamic>),
        );
      },
    );

    return result?.success ?? false;
  }

  // Resend OTP
  Future<String?> resendOTP({
    required String mobile,
    required String requestId,
  }) async {
    final result = await makeApiCall<BaseResponse<ResendOTPResponse>>(
      () async {
        final response = await HttpUtil.post(
          AppConstants.RESEND_OTP,
          data: {
            'mobile_number': mobile,
            'request_id': requestId,
          },
        );
        
        return BaseResponse.fromJson(
          response.data,
          (json) => ResendOTPResponse.fromJson(json as Map<String, dynamic>),
        );
      },
    );

    return result?.data?.newRequestId;
  }

  // Forgot Password
  Future<String?> forgotPassword({
    required String username,
    required String mobile,
  }) async {
    final result = await makeApiCall<BaseResponse<ForgotPasswordResponse>>(
      () async {
        final response = await HttpUtil.post(
          AppConstants.FORGOT_PASSWORD,
          data: {
            'username': username,
            'mobile_number': mobile,
          },
        );
        
        return BaseResponse.fromJson(
          response.data,
          (json) => ForgotPasswordResponse.fromJson(json as Map<String, dynamic>),
        );
      },
    );

    return result?.data?.requestId;
  }

  // Reset Password
  Future<bool> resetPassword({
    required String requestId,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final result = await makeApiCall<BaseResponse<dynamic>>(
      () async {
        final response = await HttpUtil.post(
          AppConstants.RESET_PASSWORD,
          data: {
            'request_id': requestId,
            'new_password': newPassword,
            'confirm_password': confirmPassword,
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

  // Biometric Login
  Future<bool> biometricLogin({
    required String biometricToken,
  }) async {
    final result = await makeApiCall<BaseResponse<LoginResponse>>(
      () async {
        final response = await HttpUtil.post(
          AppConstants.LOGIN,
          data: {
            'biometric_token': biometricToken,
            'device_id': AppSharedPreferences.getDeviceId(),
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
          await AppSharedPreferences.setUserId(loginData.userId);
          await AppSharedPreferences.setUserName(loginData.userName);
        }
      },
    );

    return result?.success ?? false;
  }
}

// Response Models
class OTPVerificationResponse {
  final bool isVerified;
  final String? token;

  OTPVerificationResponse({
    required this.isVerified,
    this.token,
  });

  factory OTPVerificationResponse.fromJson(Map<String, dynamic> json) {
    return OTPVerificationResponse(
      isVerified: json['is_verified'] ?? false,
      token: json['token'],
    );
  }
}

class ResendOTPResponse {
  final String newRequestId;
  final int resendAfterSeconds;

  ResendOTPResponse({
    required this.newRequestId,
    required this.resendAfterSeconds,
  });

  factory ResendOTPResponse.fromJson(Map<String, dynamic> json) {
    return ResendOTPResponse(
      newRequestId: json['new_request_id'],
      resendAfterSeconds: json['resend_after_seconds'] ?? 30,
    );
  }
}

class ForgotPasswordResponse {
  final String requestId;
  final String maskedMobile;

  ForgotPasswordResponse({
    required this.requestId,
    required this.maskedMobile,
  });

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponse(
      requestId: json['request_id'],
      maskedMobile: json['masked_mobile'] ?? '',
    );
  }
}

class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final String userId;
  final String userName;

  LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.userName,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      userId: json['user_id'],
      userName: json['user_name'],
    );
  }
}