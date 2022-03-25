import '../config/providers.dart';

class TransactionInfo {
  ///Identifiant Unique généré par PayGateGlobal pour la transaction
  final String? txReference;

  ///Code de référence de paiement généré par Flooz/TMoney.
  ///Ce code peut être utilisé en cas de résolution de problèmes ou de plaintes.
  final String? paymentReference;

  ///Date et Heure du paiement.
  final String? dateTime;

  ///Méthode de paiement utilisée par le client. Valeurs possibles: moovMoney, T-Money
  final PaygateProvider? provider;

  ///Identifiant interne de la transaction de l’e-commerce. ex:
  ///Numero de commande Cet identifiant doit etre unique.
  final String? identifier;

  ///Montant payé par le client
  final double? amount;

  ///Numéro de téléphone du client qui a effectué le paiement.
  final String? phone;

  ///Détails de la transaction
  final String? description;

  ///Lien de la page vers laquelle le client sera redirigé après le paiement
  final String? callbackUrl;

  TransactionInfo({
    this.txReference,
    this.paymentReference,
    this.dateTime,
    this.provider,
    this.identifier,
    this.amount,
    this.phone,
    this.description,
    this.callbackUrl,
  });
}
