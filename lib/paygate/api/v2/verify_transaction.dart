import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/index.dart';

final Uri uriVerifyV2Post = Uri.https("paygateglobal.com", "/api/v2/status");

///@param txReference : Identifiant Unique précédemment généré par PayGateGlobal pour la transaction
Future<Transaction> verifyPaymentViaPaygateV2(
  String token, {
  required String identifier,
}) async {
  Transaction response;

  try {
    http.Response post = await http.post(uriVerifyV2Post, body: {
      "auth_token": token,
      "identifier": identifier,
    });

    dynamic json = jsonDecode(post.body);

    if (json['tx_reference'] == null) {
      response = Transaction.fail(
        identifier: identifier,
      );
    } else {
      response = Transaction.fromV2(jsonDecode(post.body));
    }
  } catch (e) {
    response = Transaction.fail(
      exception: e.toString(),
      identifier: identifier,
    );
  }

  return response;
}
