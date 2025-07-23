import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../utils/log_utils.dart';

class ConnectivityProvider extends ChangeNotifier {
  bool _isConnected = true;
  bool _isChecking = false;
  Timer? _checkTimer;
  
  bool get isConnected => _isConnected;
  bool get isChecking => _isChecking;
  
  ConnectivityProvider() {
    _startPeriodicCheck();
  }
  
  void _startPeriodicCheck() {
    _checkConnectivity();
    _checkTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _checkConnectivity();
    });
  }
  
  Future<void> _checkConnectivity() async {
    if (_isChecking) return;
    
    _isChecking = true;
    try {
      final dio = Dio();
      dio.options.connectTimeout = const Duration(seconds: 5);
      dio.options.receiveTimeout = const Duration(seconds: 5);
      
      // Try to reach Google's DNS
      await dio.get('https://8.8.8.8');
      
      _updateConnectionStatus(true);
    } catch (e) {
      _updateConnectionStatus(false);
      LogUtils.logWarning('ConnectivityProvider', 'No internet connection');
    } finally {
      _isChecking = false;
    }
  }
  
  void _updateConnectionStatus(bool isConnected) {
    if (_isConnected != isConnected) {
      _isConnected = isConnected;
      notifyListeners();
      
      if (isConnected) {
        LogUtils.logInfo('ConnectivityProvider', 'Internet connection restored');
      } else {
        LogUtils.logWarning('ConnectivityProvider', 'Internet connection lost');
      }
    }
  }
  
  Future<bool> checkConnectivity() async {
    await _checkConnectivity();
    return _isConnected;
  }
  
  @override
  void dispose() {
    _checkTimer?.cancel();
    super.dispose();
  }
}