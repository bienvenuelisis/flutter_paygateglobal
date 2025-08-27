/// Custom exceptions for PayGate operations
abstract class PaygateException implements Exception {
  const PaygateException(this.message, {this.code, this.originalError});
  final String message;
  final String? code;
  final dynamic originalError;

  @override
  String toString() =>
      'PaygateException: $message ${code != null ? '(Code: $code)' : ''}';
}

/// Network-related errors
class PaygateNetworkException extends PaygateException {
  const PaygateNetworkException(String message,
      {String? code, dynamic originalError})
      : super(message, code: code, originalError: originalError);
}

/// API-related errors
class PaygateApiException extends PaygateException {
  const PaygateApiException(String message,
      {this.statusCode, String? code, dynamic originalError})
      : super(message, code: code, originalError: originalError);
  final int? statusCode;
}

/// Validation errors
class PaygateValidationException extends PaygateException {
  const PaygateValidationException(String message, {String? code})
      : super(message, code: code);
}

/// Configuration errors
class PaygateConfigurationException extends PaygateException {
  const PaygateConfigurationException(String message, {String? code})
      : super(message, code: code);
}

/// Transaction-specific errors
class PaygateTransactionException extends PaygateException {
  const PaygateTransactionException(String message,
      {this.transactionId, String? code, dynamic originalError})
      : super(message, code: code, originalError: originalError);
  final String? transactionId;
}
