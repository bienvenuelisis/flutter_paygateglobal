enum PaygateProvider {
  moovMoney,
  tmoney,
}

String? networkFromProviderApiV1(PaygateProvider? provider) {
  switch (provider) {
    case PaygateProvider.moovMoney:
      return "FLOOZ";
    case PaygateProvider.tmoney:
      return "TMONEY";

    default:
      return null;
  }
}

String? networkFromProviderApiV2(PaygateProvider? provider) {
  switch (provider) {
    case PaygateProvider.moovMoney:
      return "MOOV";
    case PaygateProvider.tmoney:
      return "TOGOCEL";

    default:
      return null;
  }
}

PaygateProvider? providerFromPaymentMethod(String paymentMethod) {
  switch (paymentMethod.toUpperCase()) {
    case "FLOOZ":
      return PaygateProvider.moovMoney;
    case "T-MONEY":
      return PaygateProvider.tmoney;

    default:
      return null;
  }
}
