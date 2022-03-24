enum TransactionStatus {
  /// Waiting for transaction payment confirmation by the user.
  waiting,

  /// Transaction is done and found are provided to Paygate.
  done,

  /// Transaction have been canceled by the user.
  canceled,

  /// Time provided to the user to procedd the transaction payment confirmation is over.
  expired,

  /// Unresolved transaction status. Network error, server error or the provider does not recognize this transaction..
  none,
}

TransactionStatus transactionStatusFromInt(int? status) {
  switch (status) {
    case 0:
      return TransactionStatus.done;

    case 2:
      return TransactionStatus.waiting;

    case 4:
      return TransactionStatus.expired;

    case 6:
      return TransactionStatus.canceled;

    default:
      return TransactionStatus.none;
  }
}
