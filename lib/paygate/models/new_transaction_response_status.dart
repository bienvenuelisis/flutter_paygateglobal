NewTransactionResponseStatus statusFromInt(int? status) {
  if (status == null) return NewTransactionResponseStatus.none;

  switch (status) {
    case 0:
      return NewTransactionResponseStatus.success;

    case 2:
      return NewTransactionResponseStatus.invalidToken;

    case 4:
      return NewTransactionResponseStatus.invalidParameters;

    case 6:
      return NewTransactionResponseStatus.identierExists;

    default:
      return NewTransactionResponseStatus.none;
  }
}

enum NewTransactionResponseStatus {
  /// 0 : Transaction enregistrée avec succès.
  success,

  /// 2 : Jeton d’authentification invalide.
  invalidToken,

  /// 4 : Paramètres Invalides.
  invalidParameters,

  /// 6 : Doublons détectées. Une transaction avec le même identifiant existe déja.
  identierExists,

  /// If using Payment method 2, this mean the payment page launch in the custom tab failed. Network error, unsupported features etc.
  cantLaunchPage,

  /// Unknown code.
  none,
}
