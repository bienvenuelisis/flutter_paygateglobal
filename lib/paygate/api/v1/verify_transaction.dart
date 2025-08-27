import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../config/api_endpoints.dart';
import '../../models/index.dart';

///@param txReference : Identifiant Unique précédemment généré par PayGateGlobal pour la transaction
Future<Transaction> verifyPaymentViaPaygateV1(
  String token, {
  required String txReference,
}) async {
  Transaction response;

  try {
    final post = await http.post(PaygateApiEndpoints.verifyV1, body: {
      'auth_token': token,
      'tx_reference': txReference,
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
