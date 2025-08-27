/// A comprehensive Flutter package for integrating PayGate Global payment platform.
///
/// This library provides easy-to-use APIs for processing mobile money payments
/// through T-Money and Moov Money providers in Togo and other supported countries.
///
/// ## Features
///
/// - **Dual API Support**: Choose between direct API (v1) or hosted payment page (v2)
/// - **Mobile Money Integration**: Support for T-Money and Moov Money (Flooz)
/// - **Transaction Management**: Create, track, and verify payment transactions
/// - **Input Validation**: Built-in validation for phone numbers, amounts, and identifiers
/// - **Error Handling**: Comprehensive exception handling for different error scenarios
/// - **Type Safety**: Full null safety support with strong typing
///
/// ## Quick Start
///
/// ```dart
/// import 'package:flutter_paygateglobal/flutter_paygateglobal.dart';
///
/// // Initialize the plugin
/// Paygate.init(
///   apiKey: 'your-api-key',
///   apiVersion: PaygateVersion.v2,
/// );
///
/// // Process a payment
/// final response = await Paygate.payV2(
///   amount: 1000.0,
///   phoneNumber: '90123456',
///   provider: PaygateProvider.moovMoney,
///   description: 'Premium subscription',
/// );
///
/// // Verify transaction
/// if (response.ok) {
///   final transaction = await response.verify();
///   print('Status: ${transaction.status}');
/// }
/// ```
///
/// ## Supported Providers
///
/// - **T-Money**: Togocom's mobile money service
/// - **Moov Money (Flooz)**: Moov Africa's mobile money service
///
/// For more detailed documentation and examples, visit:
/// https://pub.dev/packages/flutter_paygateglobal
library flutter_paygateglobal;

export './paygate/paygate.dart';
export 'paygate/config/api_endpoints.dart';
export 'paygate/config/providers.dart';
export 'paygate/exceptions/paygate_exceptions.dart';
export 'paygate/models/index.dart';
export 'paygate/utils/logger.dart';
export 'paygate/utils/validator.dart';
