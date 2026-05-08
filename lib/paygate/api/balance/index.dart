import '../../config/api_endpoints.dart';
import '../../models/account_balance.dart';
import '../../utils/http_client.dart';

class BalanceAPI {
  static Future<AccountBalance> check(String token) async {
    final post =
        await PaygateHttpClient().post(PaygateApiEndpoints.checkBalance, body: {
      'auth_token': token,
    });

    return AccountBalance.fromJson(post.body);
  }
}
