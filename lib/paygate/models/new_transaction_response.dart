import '../paygate.dart';
import 'new_transaction_response_status.dart';
import 'transaction.dart';

class NewTransactionResponse {
  final String? txReference;

  final NewTransactionResponseStatus? status;

  final String? identifier;

  final dynamic exception;

  bool get ok =>
      status != null && status == NewTransactionResponseStatus.success;

  NewTransactionResponse(
    this.txReference, {
    this.status = NewTransactionResponseStatus.none,
    this.identifier,
    this.exception,
  });

  Future<Transaction> verify() async {
    return Paygate.verifyTransaction(
      trxIdentifier: identifier,
      txReference: txReference,
    );
  }
}
