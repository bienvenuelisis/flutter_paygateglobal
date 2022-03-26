import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/index.dart';
import '../../paygate.dart';

final Uri uriPayV1Post = Uri.https("paygateglobal.com", "/api/v1/pay");

///Pour initier une transaction, faites un simple appel HTTP de type Post vers
///le service web de PayGateGlobal et passer les paramètres requis.
/// Uniquement pour le service Flooz.
Future<NewTransactionResponse> payViaPaygateV1({
  required String authToken,
  required String phoneNumber,
  required PaygateProvider provider,
  required double amount,
  required String identifier,
  String? description,
}) async {
  _NewTransactionResponseV1 response;

  try {
    http.Response post = await http.post(
      uriPayV1Post,
      body: _ParamsNewTransactionV1(
        authToken,
        phoneNumber,
        provider,
        amount,
        identifier,
        description: description,
      ).body,
    );

    response = _NewTransactionResponseV1.fromJson(jsonDecode(post.body));
  } catch (e) {
    response = _NewTransactionResponseV1(
      null,
      status: NewTransactionResponseStatus.none,
      exception: e.toString(),
    );
  }

  return response.bridge(identifier);
}

class _ParamsNewTransactionV1 {
  /// Jeton d’authentification de l’e-commerce (Clé API)
  final String authToken;

  /// Numéro de téléphone mobile du Client. Moov Uniquement.
  final String phoneNumber;

  ///Montant de la transaction sans la devise (Devise par défaut: FCFA).
  final double amount;

  ///Détails de la transaction.
  final String? description;

  ///Identifiant interne de la transaction de l’e-commerce. Cet identifiant doit etre unique.
  final String identifier;

  final PaygateProvider? provider;

  _ParamsNewTransactionV1(
    this.authToken,
    this.phoneNumber,
    this.provider,
    this.amount,
    this.identifier, {
    this.description,
  });

  Map<String, dynamic> get body => {
        "auth_token": authToken,
        "phone_number": phoneNumber,
        "amount": amount.toString(),
        "description": description,
        "identifier": identifier,
        "network": networkFromProviderApiV1(provider),
      };
}

class _NewTransactionResponseV1 {
  ///Identifiant Unique générée par PayGateGlobal pour la transaction
  final String? txReference;

  ///Code d’état de la transaction.
  final NewTransactionResponseStatus? status;

  final String? exception;

  _NewTransactionResponseV1(
    this.txReference, {
    this.status = NewTransactionResponseStatus.none,
    this.exception,
  });

  factory _NewTransactionResponseV1.fromJson(dynamic json) {
    try {
      return _NewTransactionResponseV1(
        json['tx_reference'].toString(),
        status: statusFromInt(int.tryParse(json['status'].toString())),
      );
    } catch (e) {
      return _NewTransactionResponseV1(
        null,
        status: null,
        exception: e.toString(),
      );
    }
  }

  NewTransactionResponse bridge(String identifier) {
    return NewTransactionResponse(
      txReference,
      status: status,
      identifier: identifier,
      exception: exception,
    );
  }
}
