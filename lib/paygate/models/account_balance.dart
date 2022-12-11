// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import '../config/providers.dart';

class AccountBalance {
  final double tmoney;

  final double moovMoney;

  AccountBalance({
    required this.tmoney,
    required this.moovMoney,
  });

  double byProvider(PaygateProvider provider) {
    switch (provider) {
      case PaygateProvider.tmoney:
        return tmoney;

      case PaygateProvider.moovMoney:
        return moovMoney;

      default:
        return 0;
    }
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tmoney': tmoney,
      'flooz': moovMoney,
    };
  }

  factory AccountBalance.fromMap(Map<String, dynamic> map) {
    return AccountBalance(
      tmoney: (double.tryParse(map['tmoney']?.toString() ?? "") ?? 0.0),
      moovMoney: (double.tryParse(map['flooz']?.toString() ?? "") as double),
    );
  }

  String toJson() => json.encode(toMap());

  factory AccountBalance.fromJson(String source) =>
      AccountBalance.fromMap(json.decode(source) as Map<String, dynamic>);
}
