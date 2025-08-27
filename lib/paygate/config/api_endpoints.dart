/// Centralized API endpoints configuration
class PaygateApiEndpoints {
  static const String _baseUrl = 'paygateglobal.com';

  // API Version 1 endpoints
  static final Uri payV1 = Uri.https(_baseUrl, '/api/v1/pay');
  static final Uri verifyV1 = Uri.https(_baseUrl, '/api/v1/status');
  static final Uri checkBalance = Uri.https(_baseUrl, '/api/v1/check-balance');

  // API Version 2 endpoints
  static final Uri payV2 = Uri.https(_baseUrl, '/api/v2/pay');
  static final Uri verifyV2 = Uri.https(_baseUrl, '/api/v2/status');
  static final Uri pageV2 = Uri.https(_baseUrl, '/v1/page');

  // For development/testing
  static const String _testBaseUrl = 'sandbox.paygateglobal.com';

  static Uri getEndpoint(String path, {bool isProduction = true}) =>
      Uri.https(isProduction ? _baseUrl : _testBaseUrl, path);

  /// Get payment page URL with query parameters for API v2
  static Uri getPaymentPageUrl(Map<String, dynamic> params,
          {bool isProduction = true}) =>
      Uri.https(isProduction ? _baseUrl : _testBaseUrl, '/v1/page', params);
}
