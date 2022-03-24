import 'package:flutter/rendering.dart';

import '../../config/providers.dart';

import '../../models/index.dart';
import '../../utils/http_get_params.dart';
import '../../utils/tab_launcher.dart';

const String linkV2PageGet = "https://paygateglobal.com/v1/page";

Future<NewTransactionResponse> payViaPaygateV2(
  String token,
  double amount,
  String identifier, {
  String? description,
  String? callbackUrl,
  String? phoneNumber,
  PaygateProvider? provider,
  Color? color,
}) async {
  try {
    await launchPageCustomTab(
      _ParamsNewTransactionV2(
        token,
        amount,
        identifier,
        description: description,
        callbackUrl: callbackUrl,
        phoneNumber: phoneNumber,
        provider: provider,
      ).paygateLink,
      color,
    );

    return NewTransactionResponse(
      null,
      status: NewTransactionResponseStatus.success,
      identifier: identifier,
    );
  } catch (e) {
    return NewTransactionResponse(
      null,
      status: NewTransactionResponseStatus.cantLaunchPage,
      identifier: identifier,
    );
  }
}

class _ParamsNewTransactionV2 {
  ///Jeton d’authentification de l’e-commerce (Clé API)
  final String token;

  ///Montant de la transaction sans la devise (Devise par défaut: FCFA)
  final double amount;

  ///Détails de la transaction
  final String? description;

  ///Identifiant interne de la transaction de l’e-commerce. ex:
  ///Numero de commande. Cet identifiant doit etre unique.
  final String identifier;

  ///Lien de la page vers laquelle le client sera redirigé après le paiement
  final String? callbackUrl;

  ///Numéro de téléphone du client
  final String? phoneNumber;

  final PaygateProvider? provider;

  _ParamsNewTransactionV2(
    this.token,
    this.amount,
    this.identifier, {
    this.description,
    this.callbackUrl,
    this.phoneNumber,
    this.provider,
  });

  ///Réseau du numéro de téléphone (ex: MOOV, TOGOCEL).
  ///Si ce parametre n'est pas fourni, le client devra manuellement choisir son réseau.
  String? get network => networkFromProviderApiV2(provider);

  Map<String, dynamic> get body => {
        "token": token,
        "amount": amount.toString(),
        "description": description,
        "identifier": identifier,
        "url": callbackUrl,
        "phone": phoneNumber,
        "network": network,
      };

  ///Le client sera redirigé vers une page de paygate global.
  ///eg: https://paygateglobal.com/v1/page?token=1234&amount=300&description=test&identifier=10
  String get paygateLink => getUrl(linkV2PageGet, body);
}
