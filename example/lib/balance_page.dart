import 'package:flutter/material.dart';
import 'package:flutter_paygateglobal/paygate/models/account_balance.dart';

class BalancePage extends StatefulWidget {
  const BalancePage({Key? key}) : super(key: key);

  @override
  State<BalancePage> createState() => _BalancePageState();
}

class _BalancePageState extends State<BalancePage> {
  @override
  void initState() {
    //_checkBalance();
    super.initState();
  }

  AccountBalance? _balance;

  /* void _checkBalance() {
    Paygate.checkBalance().then((value) => setState(() => {_balance = value}));
  } */

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Account Balance"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _balance == null
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: const Color(0xFFE20206),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: size.height * 0.25,
                            width: size.width,
                            child: const Padding(
                              padding: EdgeInsets.all(15),
                              child: Image(
                                image: AssetImage("assets/tmoney.png"),
                                alignment: Alignment.center,
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Text(
                            "Total Balance : " + 1000.toString() + " FCFA",
                            style: const TextStyle(
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(height: 45),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.1),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: const Color(0xFFF86A0E),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: size.height * 0.25,
                            width: size.width,
                            child: const Padding(
                              padding: EdgeInsets.all(15),
                              child: Image(
                                image: AssetImage("assets/moov_money.png"),
                                alignment: Alignment.center,
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Text(
                            "Total Balance : " + 1000.toString() + " FCFA",
                            style: const TextStyle(
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(height: 45),
                        ],
                      ),
                    )
                  ],
                )),
        ),
      ),
    );
  }
}
