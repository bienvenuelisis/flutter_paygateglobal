import '../config/providers.dart';
import 'transaction_info.dart';
import 'transaction_status.dart';

class Transaction {
  Transaction({
    required this.info,
    this.status = TransactionStatus.none,
    this.exception,
  });

  factory Transaction.fail({
    String? exception,
    String? txReference,
    String? identifier,
  }) =>
      Transaction(
        info: TransactionInfo(
          txReference: txReference,
          identifier: identifier,
        ),
        exception: exception,
      );

  factory Transaction.fromV1(dynamic json) => Transaction(
        info: TransactionInfo(
          txReference: json['tx_reference'] as String?,
          identifier: json['identifier'] as String?,
          paymentReference: json['payment_reference'] as String?,
          dateTime: json['datetime'] as String?,
          provider: providerFromPaymentMethod(
              json['payment_method'] as String? ?? ''),
        ),
        status:
            transactionStatusFromInt(int.tryParse(json['status'].toString())),
      );

  factory Transaction.fromV2(dynamic json) => Transaction(
        info: TransactionInfo(
          txReference: json['tx_reference'].toString(),
          paymentReference: json['payment_reference'] as String?,
          dateTime: json['datetime'] as String?,
          provider: providerFromPaymentMethod(
              json['payment_method'] as String? ?? ''),
        ),
        status:
            transactionStatusFromInt(int.tryParse(json['status'].toString())),
      );
  final TransactionInfo info;

  final TransactionStatus status;

  bool get error =>
      status == TransactionStatus.canceled ||
      status == TransactionStatus.expired ||
      status == TransactionStatus.none;

  bool get canceled =>
      status == TransactionStatus.canceled || status == TransactionStatus.none;

  bool get done => status == TransactionStatus.done;

  bool get waiting => status == TransactionStatus.waiting;

  final String? exception;

  bool get exists => status != TransactionStatus.none;
}
