import 'dart:io';

import 'package:http/http.dart' as http;

import '../exceptions/paygate_exceptions.dart';
import '../utils/logger.dart';

/// Enhanced HTTP client for PayGate API calls
class PaygateHttpClient {
  factory PaygateHttpClient() => _instance;

  PaygateHttpClient._internal();

  static const Duration _defaultTimeout = Duration(seconds: 30);
  static final PaygateHttpClient _instance = PaygateHttpClient._internal();

  late final http.Client _client;

  /// Dispose the HTTP client
  void dispose() {
    _client.close();
  }

  /// Make a GET request with timeout and error handling
  Future<http.Response> get(
    Uri url, {
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    final effectiveTimeout = timeout ?? _defaultTimeout;

    try {
      PaygateLogger.apiRequest('GET', url.toString(), null);

      final response = await _client.get(
        url,
        headers: {
          'User-Agent': 'FlutterPayGateGlobal/0.1.5',
          ...?headers,
        },
      ).timeout(effectiveTimeout);

      PaygateLogger.apiResponse(url.toString(), response.statusCode,
          response.body.length > 1000 ? 'Large response body' : response.body);

      return response;
    } on SocketException catch (e) {
      PaygateLogger.error('Network error: ${e.message}', e);
      throw PaygateNetworkException(
        'Network connection failed: ${e.message}',
        originalError: e,
      );
    } on HttpException catch (e) {
      PaygateLogger.error('HTTP error: ${e.message}', e);
      throw PaygateNetworkException(
        'HTTP request failed: ${e.message}',
        originalError: e,
      );
    } on TimeoutException catch (e) {
      PaygateLogger.error('Request timeout: ${e.message}', e);
      throw PaygateNetworkException(
        'Request timed out after ${effectiveTimeout.inSeconds} seconds',
        originalError: e,
      );
    } catch (e) {
      PaygateLogger.error('Unexpected error during HTTP request', e);
      throw PaygateNetworkException(
        'Unexpected network error: $e',
        originalError: e,
      );
    }
  }

  /// Initialize the HTTP client with optimized settings
  void init() {
    _client = http.Client();
  }

  /// Make a POST request with timeout and error handling
  Future<http.Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Duration? timeout,
  }) async {
    final effectiveTimeout = timeout ?? _defaultTimeout;

    try {
      PaygateLogger.apiRequest('POST', url.toString(),
          body is Map ? body as Map<String, dynamic> : null);

      final response = await _client
          .post(
            url,
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded',
              'User-Agent': 'FlutterPayGateGlobal/0.1.5',
              ...?headers,
            },
            body: body,
          )
          .timeout(effectiveTimeout);

      PaygateLogger.apiResponse(url.toString(), response.statusCode,
          response.body.length > 1000 ? 'Large response body' : response.body);

      return response;
    } on SocketException catch (e) {
      PaygateLogger.error('Network error: ${e.message}', e);
      throw PaygateNetworkException(
        'Network connection failed: ${e.message}',
        originalError: e,
      );
    } on HttpException catch (e) {
      PaygateLogger.error('HTTP error: ${e.message}', e);
      throw PaygateNetworkException(
        'HTTP request failed: ${e.message}',
        originalError: e,
      );
    } on TimeoutException catch (e) {
      PaygateLogger.error('Request timeout: ${e.message}', e);
      throw PaygateNetworkException(
        'Request timed out after ${effectiveTimeout.inSeconds} seconds',
        originalError: e,
      );
    } catch (e) {
      PaygateLogger.error('Unexpected error during HTTP request', e);
      throw PaygateNetworkException(
        'Unexpected network error: $e',
        originalError: e,
      );
    }
  }
}

class TimeoutException implements Exception {
  const TimeoutException(this.message);

  final String message;

  @override
  String toString() => 'TimeoutException: $message';
}
