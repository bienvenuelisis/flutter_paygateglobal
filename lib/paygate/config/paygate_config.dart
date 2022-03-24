import 'dart:math';

import 'package:flutter/material.dart';

import '../../flutter_paygateglobal.dart';
import '../api/v2/verify_transaction.dart';
import '../utils/identifier_generator.dart';

class PaygateConfig {
  /// Length of the transaction identifier generated.
  static late int transactionIdentifierLength;

  static final Random _rnd = Random();

  static Color? customTabColor;

  /// Return a new identifier (randomly generated) for a transaction.
  static String get _newTransactionIdentifier => generateIdentifier(
        transactionIdentifierLength,
        _rnd.nextInt,
      );

  /// Version of the Paygate API to use per default.
  static PaygateVersion version = PaygateVersion.v2;

  /// Your Paygate API Key used in application production mode.
  static late String paygateAPIKeyProd;

  /// Your Paygate API Key used in application development mode. If not set, equals to [paygateAPIKeyProd].
  static late String paygateAPIKeyDebug;

  static String get token =>
      kDebugMode ? paygateAPIKeyDebug : paygateAPIKeyProd;

  static Future<String> get newUniqIdentifier async {
    String identifier = _newTransactionIdentifier;

    bool identifierExists = (await verifyPaymentViaPaygateV2(
      token,
      identifier: identifier,
    ))
        .exists;

    while (identifierExists) {
      identifier = PaygateConfig._newTransactionIdentifier;

      identifierExists = (await verifyPaymentViaPaygateV2(
        token,
        identifier: identifier,
      ))
          .exists;
    }

    return identifier;
  }

  static get kDebugMode => null;
}
