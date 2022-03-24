import 'dart:convert';

import 'package:http/http.dart' as http;


import '../../models/index.dart';

final Uri uriVerifyV1Post = Uri.https("paygateglobal.com", "/api/v1/status");

///@param txReference : Identifiant Unique précédemment généré par PayGateGlobal pour la transaction
Future<Transaction> verifyPaymentViaPaygateV1(
  String token, {
  required String txReference,
}) async {
  Transaction response;

  try {
    http.Response post = await http.post(uriVerifyV1Post, body: {
      "auth_token": token,
      "tx_reference": txReference,
    });

    response = Transaction.fromV1(jsonDecode(post.body));
  } catch (e) {
    response = Transaction.fail(
      exception: e.toString(),
      txReference: txReference,
    );
  }

  return response;
}
