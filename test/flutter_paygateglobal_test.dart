import 'package:flutter_paygateglobal/flutter_paygateglobal.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PayGate Initialization Tests', () {
    test('should initialize with valid API key', () {
      expect(() {
        Paygate.init(
          apiKey: '12345678-1234-1234-1234-123456789012',
          apiVersion: PaygateVersion.v2,
        );
      }, returnsNormally);
    });

    test('should throw exception with invalid API key format', () {
      expect(() {
        Paygate.init(apiKey: 'invalid-key');
      }, throwsA(isA<PaygateConfigurationException>()));
    });
  });

  group('Validation Tests', () {
    test('should validate correct Togo phone numbers', () {
      expect(PaygateValidator.isValidPhoneNumber('90123456'), isTrue);
      expect(PaygateValidator.isValidPhoneNumber('70123456'), isTrue);
      expect(PaygateValidator.isValidPhoneNumber('22890123456'), isTrue);
    });

    test('should reject invalid phone numbers', () {
      expect(PaygateValidator.isValidPhoneNumber('12345'), isFalse);
      expect(PaygateValidator.isValidPhoneNumber('80123456'), isFalse);
      expect(PaygateValidator.isValidPhoneNumber(''), isFalse);
    });

    test('should validate transaction amounts', () {
      expect(PaygateValidator.isValidAmount(100.0), isTrue);
      expect(PaygateValidator.isValidAmount(1000000.0), isTrue);
      expect(PaygateValidator.isValidAmount(0.0), isFalse);
      expect(PaygateValidator.isValidAmount(-100.0), isFalse);
      expect(PaygateValidator.isValidAmount(1000001.0), isFalse);
    });

    test('should validate transaction identifiers', () {
      expect(PaygateValidator.isValidIdentifier('TR_001'), isTrue);
      expect(PaygateValidator.isValidIdentifier('transaction-123'), isTrue);
      expect(PaygateValidator.isValidIdentifier(''), isFalse);
      expect(PaygateValidator.isValidIdentifier('tr with spaces'), isFalse);
    });

    test('should validate API key format', () {
      expect(
          PaygateValidator.isValidApiKey(
              '12345678-1234-1234-1234-123456789012'),
          isTrue);
      expect(PaygateValidator.isValidApiKey('invalid-format'), isFalse);
      expect(PaygateValidator.isValidApiKey(''), isFalse);
    });
  });

  group('Transaction Response Tests', () {
    test('should create successful transaction response', () {
      final response = NewTransactionResponse(
        'tx_ref_123',
        status: NewTransactionResponseStatus.success,
        identifier: 'TR_001',
      );

      expect(response.ok, isTrue);
      expect(response.txReference, equals('tx_ref_123'));
      expect(response.identifier, equals('TR_001'));
    });

    test('should create failed transaction response', () {
      final response = NewTransactionResponse(
        null,
        status: NewTransactionResponseStatus.invalidParameters,
        exception: 'Network error',
      );

      expect(response.ok, isFalse);
      expect(response.exception, equals('Network error'));
    });
  });

  group('Provider Tests', () {
    test('should have correct provider values', () {
      expect(PaygateProvider.moovMoney.toString(), contains('moovMoney'));
      expect(PaygateProvider.tmoney.toString(), contains('tmoney'));
    });
  });
}
