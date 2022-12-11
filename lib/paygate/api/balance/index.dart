import 'package:http/http.dart' as http;

import '../../models/account_balance.dart';

final Uri checkBalancePost =
    Uri.https("paygateglobal.com", "/api/v1/check-balance");

class BalanceAPI {
  static Future<AccountBalance> check(String token) async {
    http.Response post = await http.post(checkBalancePost, body: {
      "auth_token": token,
    });

    return AccountBalance.fromJson(post.body);
  }
}
