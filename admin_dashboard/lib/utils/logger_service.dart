import 'package:flutter/foundation.dart';

/// Log levels for different types of messages
enum LogLevel {
  debug,
  info,
  warning,
  error,
  critical,
}

/// Professional logging service for the application
/// 
/// Provides structured logging with different log levels,
/// timestamps, and context information.
class LoggerService {
  /// Private constructor for singleton pattern
  LoggerService._();

  /// Singleton instance
  static final LoggerService instance = LoggerService._();

  /// Factory constructor to return singleton instance
  factory LoggerService() => instance;

  /// Whether to enable logging (disabled in release mode)
  bool get _isLoggingEnabled => kDebugMode;

  /// Log a debug message
  /// 
  /// Use for detailed debugging information
  void debug(String message, [String? tag, Object? data]) {
    _log(LogLevel.debug, message, tag, data);
  }

  /// Log an info message
  /// 
  /// Use for general informational messages
  void info(String message, [String? tag, Object? data]) {
    _log(LogLevel.info, message, tag, data);
  }

  /// Log a warning message
  /// 
  /// Use for potentially harmful situations
  void warning(String message, [String? tag, Object? data]) {
    _log(LogLevel.warning, message, tag, data);
  }

  /// Log an error message
  /// 
  /// Use for error events that might still allow the app to continue
  void error(String message, [String? tag, Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.error, message, tag, error);
    if (stackTrace != null && _isLoggingEnabled) {
      debugPrint('StackTrace: $stackTrace');
    }
  }

  /// Log a critical message
  /// 
  /// Use for severe error events that might cause the app to abort
  void critical(String message, [String? tag, Object? error, StackTrace? stackTrace]) {
    _log(LogLevel.critical, message, tag, error);
    if (stackTrace != null && _isLoggingEnabled) {
      debugPrint('StackTrace: $stackTrace');
    }
  }

  /// Log an API request
  void apiRequest(String method, String url, [Map<String, dynamic>? params]) {
    if (!_isLoggingEnabled) return;
    
    final buffer = StringBuffer();
    buffer.writeln('┌─────────────────────────────────────────');
    buffer.writeln('│ API REQUEST');
    buffer.writeln('├─────────────────────────────────────────');
    buffer.writeln('│ Method: $method');
    buffer.writeln('│ URL: $url');
    if (params != null && params.isNotEmpty) {
      buffer.writeln('│ Params: $params');
    }
    buffer.writeln('└─────────────────────────────────────────');
    debugPrint(buffer.toString());
  }

  /// Log an API response
  void apiResponse(int statusCode, String url, [dynamic data]) {
    if (!_isLoggingEnabled) return;
    
    final buffer = StringBuffer();
    buffer.writeln('┌─────────────────────────────────────────');
    buffer.writeln('│ API RESPONSE');
    buffer.writeln('├─────────────────────────────────────────');
    buffer.writeln('│ Status: $statusCode');
    buffer.writeln('│ URL: $url');
    if (data != null) {
      buffer.writeln('│ Data: $data');
    }
    buffer.writeln('└─────────────────────────────────────────');
    debugPrint(buffer.toString());
  }

  /// Log an API error
  void apiError(String url, Object error, [StackTrace? stackTrace]) {
    if (!_isLoggingEnabled) return;
    
    final buffer = StringBuffer();
    buffer.writeln('┌─────────────────────────────────────────');
    buffer.writeln('│ API ERROR');
    buffer.writeln('├─────────────────────────────────────────');
    buffer.writeln('│ URL: $url');
    buffer.writeln('│ Error: $error');
    buffer.writeln('└─────────────────────────────────────────');
    debugPrint(buffer.toString());
    
    if (stackTrace != null) {
      debugPrint('StackTrace: $stackTrace');
    }
  }

  /// Internal logging method
  void _log(LogLevel level, String message, String? tag, Object? data) {
    if (!_isLoggingEnabled) return;

    final timestamp = DateTime.now().toIso8601String();
    final levelStr = _getLevelString(level);
    final emoji = _getLevelEmoji(level);
    final tagStr = tag != null ? '[$tag]' : '';
    final dataStr = data != null ? '\nData: $data' : '';

    debugPrint('$emoji $timestamp $levelStr $tagStr: $message$dataStr');
  }

  /// Get string representation of log level
  String _getLevelString(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return 'DEBUG';
      case LogLevel.info:
        return 'INFO';
      case LogLevel.warning:
        return 'WARN';
      case LogLevel.error:
        return 'ERROR';
      case LogLevel.critical:
        return 'CRITICAL';
    }
  }

  /// Get emoji representation of log level
  String _getLevelEmoji(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return '🔍';
      case LogLevel.info:
        return 'ℹ️';
      case LogLevel.warning:
        return '⚠️';
      case LogLevel.error:
        return '❌';
      case LogLevel.critical:
        return '🔥';
    }
  }
}
