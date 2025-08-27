import 'package:http/http.dart' as http;

import '../../config/api_endpoints.dart';
import '../../models/account_balance.dart';

class BalanceAPI {
  static Future<AccountBalance> check(String token) async {
    final post = await http.post(PaygateApiEndpoints.checkBalance, body: {
      'auth_token': token,
    });

    return AccountBalance.fromJson(post.body);
  }
}
