export 'api/v1/new_transaction.dart';
export 'config/providers.dart';

import 'api/v1/new_transaction.dart';
import 'api/v1/verify_transaction.dart';
import 'api/v2/new_transaction.dart';
import 'api/v2/verify_transaction.dart';
import 'config/paygate_config.dart';
import 'config/providers.dart';
import 'models/index.dart';

enum PaygateVersion {
  v1,
  v2,
}

class Paygate {
  static void init({
    int identifierLength = 20,
    PaygateVersion? apiVersion,
    required String apiKey,
    String? apiKeyDebug,
  }) {
    PaygateConfig.version = apiVersion ?? PaygateVersion.v2;
    PaygateConfig.paygateAPIKeyProd = apiKey;
    PaygateConfig.paygateAPIKeyDebug = apiKeyDebug ?? apiKey;
    PaygateConfig.transactionIdentifierLength = identifierLength;
  }

  static String get _token => PaygateConfig.token;

  static Future<NewTransactionResponse> pay({
    PaygateVersion? version,
    String? identifier,
    String? description,
    String? callbackUrl,
    required double amount,
    required String phoneNumber,
    required PaygateProvider provider,
  }) {
    if ((version ?? PaygateConfig.version) == PaygateVersion.v1) {
      return payV1(
        identifier: identifier,
        description: description,
        provider: provider,
        amount: amount,
        phoneNumber: phoneNumber,
      );
    } else {
      return payV2(
        identifier: identifier,
        description: description,
        provider: provider,
        amount: amount,
        callbackUrl: callbackUrl,
        phoneNumber: phoneNumber,
      );
    }
  }

  static Future<NewTransactionResponse> payV1({
    String? identifier,
    String? description,
    required String phoneNumber,
    required PaygateProvider provider,
    required double amount,
  }) async {
    return payViaPaygateV1(
      authToken: _token,
      phoneNumber: phoneNumber,
      provider: provider,
      amount: amount,
      identifier: (identifier ?? "").isNotEmpty
          ? identifier!
          : (await PaygateConfig.newUniqIdentifier),
      description: description,
    );
  }

  static Future<NewTransactionResponse> payV2({
    String? identifier,
    String? description,
    String? callbackUrl,
    String? phoneNumber,
    PaygateProvider? provider,
    required double amount,
  }) async {
    return payViaPaygateV2(
      _token,
      amount,
      (identifier ?? "").isNotEmpty
          ? identifier!
          : (await PaygateConfig.newUniqIdentifier),
      description: description,
      callbackUrl: callbackUrl,
      phoneNumber: phoneNumber,
      provider: provider,
      color: PaygateConfig.customTabColor,
    );
  }

  static Future<NewTransactionResponse> payMoovMoney(
    double amount,
    PaygateVersion version, {
    required String phoneNumber,
    String? description,
    String? identifier,
    String? callbackUrl,
  }) {
    return version == PaygateVersion.v1
        ? payV1(
            phoneNumber: phoneNumber,
            provider: PaygateProvider.moovMoney,
            amount: amount,
            description: description,
            identifier: identifier,
          )
        : payV2(
            amount: amount,
            provider: PaygateProvider.moovMoney,
            description: description,
            callbackUrl: callbackUrl,
            identifier: identifier,
            phoneNumber: phoneNumber,
          );
  }

  static Future<void> payTMoney(
    double amount,
    PaygateVersion version, {
    required String phoneNumber,
    String? description,
    String? identifier,
    String? callbackUrl,
  }) {
    return version == PaygateVersion.v1
        ? payV1(
            phoneNumber: phoneNumber,
            provider: PaygateProvider.tmoney,
            amount: amount,
            description: description,
            identifier: identifier,
          )
        : payV2(
            amount: amount,
            provider: PaygateProvider.tmoney,
            description: description,
            callbackUrl: callbackUrl,
            identifier: identifier,
            phoneNumber: phoneNumber,
          );
  }

  /// Verify a transaction status via Paygate API.
  ///
  /// [trxIdentifier] is the identifier of the transaction to verify.
  /// [txReference] is the transaction reference provided by Paygate.
  /// Throws an [ArgumentError] if either the [trxIdentifier] and the [txReference] are null.
  static Future<Transaction> verifyTransaction({
    String? trxIdentifier,
    String? txReference,
  }) async {
    if (trxIdentifier == null && txReference == null) {
      throw ArgumentError(
        'Either trxIdentifier or txReference must be provided',
      );
    }

    if (trxIdentifier == null) {
      return await _verifyTransactionV1(txReference!);
    } else {
      return await _verifyTransactionV2(trxIdentifier);
    }
  }

  static Future<Transaction> _verifyTransactionV1(String txReference) async {
    try {
      return await verifyPaymentViaPaygateV1(
        Paygate._token,
        txReference: txReference,
      );
    } catch (e) {
      return Transaction(
        info: TransactionInfo(
          txReference: txReference,
        ),
        status: TransactionStatus.none,
      );
    }
  }

  static Future<Transaction> _verifyTransactionV2(String trxIdentifier) async {
    try {
      return await verifyPaymentViaPaygateV2(
        Paygate._token,
        identifier: trxIdentifier,
      );
    } catch (e) {
      return Transaction(
        info: TransactionInfo(
          identifier: trxIdentifier,
        ),
        status: TransactionStatus.none,
      );
    }
  }
}
