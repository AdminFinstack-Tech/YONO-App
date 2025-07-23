import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class LogUtils {
  static const String _defaultTag = 'YONOBusiness';
  static bool _enableLogging = kDebugMode;

  static void setLoggingEnabled(bool enabled) {
    _enableLogging = enabled;
  }

  static void d(String message, {String? tag}) {
    if (_enableLogging) {
      developer.log(
        message,
        name: tag ?? _defaultTag,
        level: 500,
      );
    }
  }

  static void i(String message, {String? tag}) {
    if (_enableLogging) {
      developer.log(
        message,
        name: tag ?? _defaultTag,
        level: 800,
      );
    }
  }

  static void w(String message, {String? tag}) {
    if (_enableLogging) {
      developer.log(
        message,
        name: tag ?? _defaultTag,
        level: 900,
      );
    }
  }

  static void e(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    if (_enableLogging) {
      developer.log(
        message,
        name: tag ?? _defaultTag,
        level: 1000,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  static void logInfo(String tag, String message) {
    i(message, tag: tag);
  }

  static void logDebug(String tag, String message) {
    d(message, tag: tag);
  }

  static void logWarning(String tag, String message) {
    w(message, tag: tag);
  }

  static void logError(String tag, String message, {Object? error, StackTrace? stackTrace}) {
    e(message, tag: tag, error: error, stackTrace: stackTrace);
  }

  static void logApi({
    required String method,
    required String url,
    Map<String, dynamic>? headers,
    dynamic requestBody,
    dynamic responseBody,
    int? statusCode,
    Duration? duration,
  }) {
    if (!_enableLogging) return;

    final buffer = StringBuffer();
    buffer.writeln('═══ API Call ═══');
    buffer.writeln('Method: $method');
    buffer.writeln('URL: $url');
    
    if (headers != null && headers.isNotEmpty) {
      buffer.writeln('Headers: $headers');
    }
    
    if (requestBody != null) {
      buffer.writeln('Request: $requestBody');
    }
    
    if (statusCode != null) {
      buffer.writeln('Status: $statusCode');
    }
    
    if (responseBody != null) {
      buffer.writeln('Response: $responseBody');
    }
    
    if (duration != null) {
      buffer.writeln('Duration: ${duration.inMilliseconds}ms');
    }
    
    buffer.writeln('═══════════════');
    
    d(buffer.toString(), tag: 'API');
  }

  static void logPerformance({
    required String operation,
    required Duration duration,
    Map<String, dynamic>? metadata,
  }) {
    if (!_enableLogging) return;

    final buffer = StringBuffer();
    buffer.writeln('⏱ Performance: $operation');
    buffer.writeln('Duration: ${duration.inMilliseconds}ms');
    
    if (metadata != null && metadata.isNotEmpty) {
      buffer.writeln('Metadata: $metadata');
    }
    
    i(buffer.toString(), tag: 'Performance');
  }

  static void logNavigation({
    required String from,
    required String to,
    Map<String, dynamic>? params,
  }) {
    if (!_enableLogging) return;

    final buffer = StringBuffer();
    buffer.writeln('🧭 Navigation');
    buffer.writeln('From: $from');
    buffer.writeln('To: $to');
    
    if (params != null && params.isNotEmpty) {
      buffer.writeln('Params: $params');
    }
    
    d(buffer.toString(), tag: 'Navigation');
  }

  static void logAnalytics({
    required String event,
    Map<String, dynamic>? parameters,
  }) {
    if (!_enableLogging) return;

    final buffer = StringBuffer();
    buffer.writeln('📊 Analytics Event: $event');
    
    if (parameters != null && parameters.isNotEmpty) {
      buffer.writeln('Parameters: $parameters');
    }
    
    i(buffer.toString(), tag: 'Analytics');
  }

  static void logCrash({
    required Object error,
    required StackTrace stackTrace,
    Map<String, dynamic>? additionalData,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('💥 CRASH DETECTED 💥');
    buffer.writeln('Error: $error');
    
    if (additionalData != null && additionalData.isNotEmpty) {
      buffer.writeln('Additional Data: $additionalData');
    }
    
    e(
      buffer.toString(),
      tag: 'Crash',
      error: error,
      stackTrace: stackTrace,
    );
  }
}