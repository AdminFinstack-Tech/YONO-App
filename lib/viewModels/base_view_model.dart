import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../networking/http_util.dart';
import '../utils/log_utils.dart';

enum ViewState { idle, loading, success, error }

abstract class BaseViewModel extends ChangeNotifier {
  ViewState _state = ViewState.idle;
  String? _errorMessage;
  bool _disposed = false;
  CancelToken? _cancelToken;

  ViewState get state => _state;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == ViewState.loading;
  bool get hasError => _state == ViewState.error;
  bool get isSuccess => _state == ViewState.success;

  void setState(ViewState state) {
    _state = state;
    notifyListeners();
  }

  void setError(String message) {
    _errorMessage = message;
    setState(ViewState.error);
  }

  void clearError() {
    _errorMessage = null;
    if (_state == ViewState.error) {
      setState(ViewState.idle);
    }
  }

  void setLoading(bool loading) {
    setState(loading ? ViewState.loading : ViewState.idle);
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _cancelToken?.cancel();
    super.dispose();
  }

  // Generic API call wrapper
  Future<T?> makeApiCall<T>(
    Future<T> Function() apiCall, {
    bool showLoading = true,
    Function(T)? onSuccess,
    Function(String)? onError,
  }) async {
    try {
      if (showLoading) {
        setLoading(true);
      }
      
      _cancelToken = CancelToken();
      final result = await apiCall();
      
      if (!_disposed) {
        setState(ViewState.success);
        onSuccess?.call(result);
      }
      
      return result;
    } on DioException catch (e) {
      if (!_disposed && !e.type.name.contains('cancel')) {
        final errorMessage = e.error?.toString() ?? 'Something went wrong';
        setError(errorMessage);
        onError?.call(errorMessage);
        LogUtils.e('API Error: $errorMessage');
      }
      return null;
    } catch (e) {
      if (!_disposed) {
        final errorMessage = e.toString();
        setError(errorMessage);
        onError?.call(errorMessage);
        LogUtils.e('Error: $errorMessage');
      }
      return null;
    } finally {
      if (!_disposed && showLoading) {
        setLoading(false);
      }
    }
  }

  // Cancel ongoing API calls
  void cancelRequests() {
    _cancelToken?.cancel();
  }
}