import 'dart:developer' as developer;

/// Logging levels for PayGate operations
enum PaygateLogLevel {
  /// Verbose debugging information
  debug,

  /// General information
  info,

  /// Warning messages
  warning,

  /// Error messages
  error,

  /// No logging
  none,
}

/// Logger utility for PayGate operations
class PaygateLogger {
  static PaygateLogLevel _level = PaygateLogLevel.warning;
  static const String _prefix = 'PayGate';

  /// Set the minimum log level
  static void setLevel(PaygateLogLevel level) {
    _level = level;
  }

  /// Log debug message
  static void debug(String message, [Object? error, StackTrace? stackTrace]) {
    if (_level.index <= PaygateLogLevel.debug.index) {
      developer.log(
        message,
        name: '$_prefix.DEBUG',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Log info message
  static void info(String message, [Object? error, StackTrace? stackTrace]) {
    if (_level.index <= PaygateLogLevel.info.index) {
      developer.log(
        message,
        name: '$_prefix.INFO',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Log warning message
  static void warning(String message, [Object? error, StackTrace? stackTrace]) {
    if (_level.index <= PaygateLogLevel.warning.index) {
      developer.log(
        message,
        name: '$_prefix.WARNING',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Log error message
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    if (_level.index <= PaygateLogLevel.error.index) {
      developer.log(
        message,
        name: '$_prefix.ERROR',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Log transaction started
  static void transactionStarted(
      String identifier, double amount, String provider) {
    info(
        'Transaction started - ID: $identifier, Amount: $amount, Provider: $provider');
  }

  /// Log transaction completed
  static void transactionCompleted(String identifier, String status) {
    info('Transaction completed - ID: $identifier, Status: $status');
  }

  /// Log transaction failed
  static void transactionFailed(String identifier, String reason) {
    error('Transaction failed - ID: $identifier, Reason: $reason');
  }

  /// Log API request
  static void apiRequest(
      String method, String url, Map<String, dynamic>? params) {
    debug(
        'API Request - $method $url ${params != null ? 'with params' : 'no params'}');
  }

  /// Log API response
  static void apiResponse(String url, int statusCode, String? response) {
    debug(
        'API Response - $url returned $statusCode ${response != null ? 'with body' : 'no body'}');
  }
}
