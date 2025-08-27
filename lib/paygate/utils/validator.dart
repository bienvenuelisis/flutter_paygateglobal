import '../exceptions/paygate_exceptions.dart';

/// Validation utilities for PayGate inputs
class PaygateValidator {
  /// Validates phone number format for supported providers
  static bool isValidPhoneNumber(String phoneNumber,
      {String? countryCode = '228'}) {
    if (phoneNumber.isEmpty) return false;

    // Remove country code if present
    var cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanPhone.startsWith(countryCode ?? '228')) {
      cleanPhone = cleanPhone.substring((countryCode ?? '228').length);
    }

    // Togo phone numbers: 8 digits starting with 9, or 7.
    return RegExp(r'^[97]\d{7}$').hasMatch(cleanPhone);
  }

  /// Validates transaction amount
  static bool isValidAmount(double amount) => amount > 0;

  /// Validates transaction identifier
  static bool isValidIdentifier(String identifier) =>
      identifier.isNotEmpty &&
      identifier.length <= 50 &&
      RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(identifier);

  /// Validates API key format
  static bool isValidApiKey(String apiKey) => RegExp(
          r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$')
      .hasMatch(apiKey);

  /// Validates callback URL
  static bool isValidCallbackUrl(String? url) {
    if (url == null || url.isEmpty) return true; // Optional parameter
    return Uri.tryParse(url)?.hasAbsolutePath == true;
  }

  /// Throws validation exception if phone number is invalid
  static void validatePhoneNumber(String phoneNumber) {
    if (!isValidPhoneNumber(phoneNumber)) {
      throw const PaygateValidationException(
          'Invalid phone number format. Must be a valid Togo phone number.',
          code: 'INVALID_PHONE');
    }
  }
}
