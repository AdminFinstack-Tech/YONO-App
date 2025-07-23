import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'app_constants.dart';
import 'app_shared_preferences.dart';
import '../utils/log_utils.dart';

class HttpUtil {
  static Dio? _dio;
  static final HttpUtil _instance = HttpUtil._internal();

  factory HttpUtil() => _instance;

  HttpUtil._internal() {
    _initDio();
  }

  static void _initDio() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.BASE_URL,
      connectTimeout: const Duration(milliseconds: AppConstants.CONNECTION_TIMEOUT),
      receiveTimeout: const Duration(milliseconds: AppConstants.RECEIVE_TIMEOUT),
      headers: {
        AppConstants.HEADER_CONTENT_TYPE: 'application/json',
        AppConstants.HEADER_ACCEPT: 'application/json',
      },
    ));

    // Add interceptors
    _dio!.interceptors.add(AuthInterceptor());
    _dio!.interceptors.add(LoggingInterceptor());
    _dio!.interceptors.add(ErrorInterceptor());
  }

  static Dio get dio {
    _dio ??= Dio();
    return _dio!;
  }

  // GET request
  static Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // POST request
  static Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // PUT request
  static Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // DELETE request
  static Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // File upload
  static Future<Response> uploadFile(
    String path,
    File file, {
    Map<String, dynamic>? data,
    String fileKey = 'file',
    Options? options,
    CancelToken? cancelToken,
    Function(int, int)? onSendProgress,
  }) async {
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        fileKey: await MultipartFile.fromFile(file.path, filename: fileName),
        ...?data,
      });

      final response = await dio.post(
        path,
        data: formData,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Multiple file upload
  static Future<Response> uploadMultipleFiles(
    String path,
    List<File> files, {
    Map<String, dynamic>? data,
    String fileKey = 'files',
    Options? options,
    CancelToken? cancelToken,
    Function(int, int)? onSendProgress,
  }) async {
    try {
      Map<String, dynamic> formDataMap = {...?data};
      
      for (int i = 0; i < files.length; i++) {
        String fileName = files[i].path.split('/').last;
        formDataMap['$fileKey[$i]'] = await MultipartFile.fromFile(
          files[i].path,
          filename: fileName,
        );
      }

      FormData formData = FormData.fromMap(formDataMap);

      final response = await dio.post(
        path,
        data: formData,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Download file
  static Future<Response> downloadFile(
    String urlPath,
    String savePath, {
    Function(int, int)? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.download(
        urlPath,
        savePath,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}

// Auth Interceptor
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = AppSharedPreferences.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers[AppConstants.HEADER_AUTH] = 'Bearer $token';
    }

    final deviceId = AppSharedPreferences.getDeviceId();
    if (deviceId != null && deviceId.isNotEmpty) {
      options.headers[AppConstants.HEADER_DEVICE_ID] = deviceId;
    }

    options.headers[AppConstants.HEADER_PLATFORM] = Platform.isAndroid ? 'Android' : 'iOS';
    
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == AppConstants.UNAUTHORIZED) {
      // Token expired, try to refresh
      try {
        await _refreshToken();
        // Retry the request
        final response = await _retry(err.requestOptions);
        handler.resolve(response);
        return;
      } catch (e) {
        // Refresh failed, logout user
        await AppSharedPreferences.clearUserSession();
        handler.reject(err);
        return;
      }
    }
    super.onError(err, handler);
  }

  Future<void> _refreshToken() async {
    final refreshToken = AppSharedPreferences.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      throw Exception('No refresh token available');
    }

    final response = await HttpUtil.dio.post(
      AppConstants.REFRESH_TOKEN,
      data: {'refresh_token': refreshToken},
    );

    if (response.statusCode == AppConstants.SUCCESS) {
      final newAccessToken = response.data['access_token'];
      final newRefreshToken = response.data['refresh_token'];
      
      await AppSharedPreferences.setAccessToken(newAccessToken);
      if (newRefreshToken != null) {
        await AppSharedPreferences.setRefreshToken(newRefreshToken);
      }
    } else {
      throw Exception('Token refresh failed');
    }
  }

  Future<Response> _retry(RequestOptions requestOptions) async {
    final token = AppSharedPreferences.getAccessToken();
    requestOptions.headers[AppConstants.HEADER_AUTH] = 'Bearer $token';
    
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );

    return HttpUtil.dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}

// Logging Interceptor
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      LogUtils.d('REQUEST[${options.method}] => PATH: ${options.path}');
      LogUtils.d('Headers: ${options.headers}');
      if (options.data != null) {
        LogUtils.d('Data: ${options.data}');
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      LogUtils.d('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
      LogUtils.d('Data: ${response.data}');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      LogUtils.e('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
      LogUtils.e('Error: ${err.message}');
      if (err.response?.data != null) {
        LogUtils.e('Error Data: ${err.response?.data}');
      }
    }
    super.onError(err, handler);
  }
}

// Error Interceptor
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String errorMessage = AppConstants.ERROR_GENERIC;
    
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorMessage = AppConstants.ERROR_TIMEOUT;
        break;
      case DioExceptionType.connectionError:
        errorMessage = AppConstants.ERROR_NETWORK;
        break;
      case DioExceptionType.badResponse:
        if (err.response != null) {
          switch (err.response!.statusCode) {
            case AppConstants.UNAUTHORIZED:
              errorMessage = AppConstants.ERROR_UNAUTHORIZED;
              break;
            case AppConstants.SERVER_ERROR:
            case AppConstants.SERVICE_UNAVAILABLE:
              errorMessage = AppConstants.ERROR_SERVER;
              break;
            default:
              if (err.response!.data is Map && err.response!.data['message'] != null) {
                errorMessage = err.response!.data['message'];
              }
          }
        }
        break;
      default:
        errorMessage = AppConstants.ERROR_GENERIC;
    }

    // err.error = errorMessage; // DioException doesn't have error setter
    super.onError(err, handler);
  }
}