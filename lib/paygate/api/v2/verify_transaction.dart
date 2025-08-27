import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../config/api_endpoints.dart';
import '../../models/index.dart';

///@param txReference : Identifiant Unique précédemment généré par PayGateGlobal pour la transaction
Future<Transaction> verifyPaymentViaPaygateV2(
  String token, {
  required String identifier,
}) async {
  Transaction response;

  try {
    final post = await http.post(PaygateApiEndpoints.verifyV2, body: {
      'auth_token': token,
      'identifier': identifier,
    });

    final dynamic json = jsonDecode(post.body);

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
