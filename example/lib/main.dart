import 'package:flutter/material.dart';
import 'package:flutter_paygateglobal/flutter_paygateglobal.dart';
import 'package:flutter_paygateglobal/paygate/config/paygate_config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paygate Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Paygate Global Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _phoneNumberController = TextEditingController();

  String get phoneNumber => _phoneNumberController.text;

  PaygateProvider _provider = PaygateProvider.tmoney;

  PaygateProvider get provider => _provider;

  set provider(PaygateProvider value) {
    setState(() {
      _provider = value;
    });
  }

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  String? _identifier;

  bool _generatingIdentifier = false;

  bool get generatingIdentifier => _generatingIdentifier;

  set generatingIdentifier(bool value) {
    setState(() {
      _generatingIdentifier = value;
    });
  }

  String get identifier => _identifier ?? "";

  set identifier(String? value) {
    setState(() {
      _identifier = value;
    });
  }

  NewTransactionResponse? _responseMethod1;

  bool _initializing1 = false;

  bool get initializing1 => _initializing1;

  set initializing1(bool value) {
    setState(() {
      _initializing1 = value;
    });
  }

  set responseMethod1(NewTransactionResponse? value) {
    setState(() {
      _responseMethod1 = value;
    });
  }

  NewTransactionResponse? _responseMethod2;

  bool _initializing2 = false;

  bool get initializing2 => _initializing2;

  set initializing2(bool value) {
    setState(() {
      _initializing2 = value;
    });
  }

  set responseMethod2(NewTransactionResponse? value) {
    setState(() {
      _responseMethod2 = value;
    });
  }

  Transaction? _transaction1;

  bool _verifying1 = false;

  bool get verifying1 => _verifying1;

  set verifying1(bool value) {
    setState(() {
      _verifying1 = value;
    });
  }

  set transaction1(Transaction value) {
    setState(() {
      _transaction1 = value;
    });
  }

  Transaction? _transaction2;

  bool _verifying2 = false;

  bool get verifying2 => _verifying2;

  set verifying2(bool value) {
    setState(() {
      _verifying2 = value;
    });
  }

  set transaction2(Transaction? value) {
    setState(() {
      _transaction2 = value;
    });
  }

  @override
  void initState() {
    Paygate.init(apiKey: "08b9094a-79af-48e1-9523-2eb21354d301");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        /* actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const BalancePage(),
                ),
              );
            },
            icon: const Icon(Icons.account_balance_wallet),
          )
        ], */
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Divider(height: 15),
                generatingIdentifier
                    ? const CircularLoader()
                    : TextButton(
                        child: const Text('Generate new uniq Identifier'),
                        onPressed: () {
                          generatingIdentifier = true;
                          PaygateConfig.newUniqIdentifier.then(
                            (value) {
                              identifier = value;
                              generatingIdentifier = false;
                            },
                          );
                        },
                      ),
                if ((identifier).isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      identifier,
                      style: const TextStyle(fontSize: 21),
                    ),
                  ),
                const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Divider(
                    height: 15,
                    thickness: 3,
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        PaymentProviderSelector(
                          color: Colors.white,
                          selectedColor: const Color(0xFFE20206),
                          icon: const Image(
                            image: AssetImage("assets/tmoney.png"),
                            alignment: Alignment.center,
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                          onTap: (value) {
                            provider = value;
                          },
                          provider: PaygateProvider.tmoney,
                          providerSelected: provider,
                        ),
                        const SizedBox(width: 4),
                        PaymentProviderSelector(
                          color: Colors.white,
                          selectedColor: const Color(0xFFF86A0E),
                          icon: const Image(
                            image: AssetImage("assets/moov_money.png"),
                            alignment: Alignment.center,
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                          onTap: (value) {
                            provider = value;
                          },
                          provider: PaygateProvider.moovMoney,
                          providerSelected: provider,
                        ),
                      ],
                    ),
                  ),
                  elevation: 5,
                ),
                const SizedBox(height: 20),
                Form(
                  key: _key,
                  child: TextFormField(
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: "Phone Number",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.phone),
                    ),
                    validator: (_) {
                      return (phoneNumber).isNotEmpty && phoneNumber.length >= 8
                          ? null
                          : "Please enter a phone number.";
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Divider(
                    height: 15,
                    thickness: 3,
                  ),
                ),
                initializing1
                    ? const CircularLoader()
                    : TextButton(
                        child: const Text('Pay Method 1'),
                        onPressed: () {
                          if (_key.currentState?.validate() ?? false) {
                            responseMethod1 = null;
                            _transaction1 = null;
                            initializing1 = true;
                            Paygate.payV1(
                              phoneNumber: phoneNumber,
                              provider: provider,
                              amount: 1,
                              description:
                                  "Test Payment Method 1 : flutter_paygateglobal",
                            ).then((response) {
                              responseMethod1 = response;
                              initializing1 = false;
                              toast(
                                context,
                                "You will receive a dial dialog confirmation on your mobile phone.",
                              );
                            });
                          }
                        },
                      ),
                _NewTransactionResponseResume(_responseMethod1),
                const Divider(height: 15),
                (_responseMethod1 == null)
                    ? const SizedBox.shrink()
                    : (verifying1
                        ? const CircularLoader()
                        : ElevatedButton(
                            onPressed: () async {
                              _transaction1 = null;
                              verifying1 = true;
                              transaction1 = await _responseMethod1!.verify();
                              verifying1 = false;
                            },
                            child: const Text('Verify Transaction 1'),
                          )),
                _TransactionResume(_transaction1),
                const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Divider(
                    height: 15,
                    thickness: 3,
                  ),
                ),
                initializing2
                    ? const CircularLoader()
                    : TextButton(
                        child: const Text('Pay Method 2'),
                        onPressed: () {
                          if (_key.currentState?.validate() ?? false) {
                            responseMethod2 = null;
                            _transaction2 = null;
                            initializing2 = true;
                            Paygate.payV2(
                              phoneNumber: phoneNumber,
                              provider: provider,
                              amount: 1,
                              description:
                                  "Test Payment Method 2 : flutter_paygateglobal",
                            ).then(
                              (response) {
                                responseMethod2 = response;
                                initializing2 = false;
                                toast(
                                  context,
                                  "You will receive a dial dialog confirmation on your mobile phone.",
                                );
                              },
                            );
                          }
                        },
                      ),
                _NewTransactionResponseResume(_responseMethod2),
                const Divider(height: 15),
                (_responseMethod2 == null)
                    ? const SizedBox.shrink()
                    : (verifying2
                        ? const CircularLoader()
                        : ElevatedButton(
                            onPressed: () async {
                              _transaction2 = null;
                              verifying2 = true;
                              transaction2 = await _responseMethod2!.verify();
                              verifying2 = false;
                            },
                            child: const Text('Verify Transaction 2'),
                          )),
                _TransactionResume(_transaction2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NewTransactionResponseResume extends StatelessWidget {
  const _NewTransactionResponseResume(
    this.transaction, {
    Key? key,
  }) : super(key: key);

  final NewTransactionResponse? transaction;

  @override
  Widget build(BuildContext context) {
    return transaction == null
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Text(
                  "Transaction Init Response",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const Divider(height: 18),
                if ((transaction?.identifier ?? "").isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      children: [
                        const Text('Status: '),
                        Text(
                          transaction!.status?.name ?? "none",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: transaction!.status ==
                                    NewTransactionResponseStatus.success
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (double.parse(transaction?.txReference ?? "-1") > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      children: [
                        const Text('TxReference: '),
                        Text(
                          transaction!.txReference ?? "",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: transaction!.status ==
                                    NewTransactionResponseStatus.success
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                const Divider(height: 15),
                Row(
                  children: [
                    const Text('Identifier: '),
                    Text(
                      transaction!.identifier ?? "",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: transaction!.status ==
                                NewTransactionResponseStatus.success
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}

class _TransactionResume extends StatelessWidget {
  const _TransactionResume(
    this.transaction, {
    Key? key,
  }) : super(key: key);

  final Transaction? transaction;

  @override
  Widget build(BuildContext context) {
    return transaction == null
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Text(
                  "Transaction Status",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const Divider(height: 18),
                if (transaction?.status != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      children: [
                        const Text('Status: '),
                        Text(
                          transaction!.status.name.toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: (transaction?.status ??
                                        TransactionStatus.none) ==
                                    TransactionStatus.done
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                if ((transaction?.info.dateTime ?? "").isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      children: [
                        const Text('DateTime: '),
                        Text(
                          transaction!.info.dateTime!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (transaction?.info.provider != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      children: [
                        const Text('Provider: '),
                        Text(
                          transaction!.info.provider!.name.toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: transaction!.status == TransactionStatus.done
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                const Divider(height: 15),
              ],
            ),
          );
  }
}

class CircularLoader extends StatelessWidget {
  const CircularLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 100,
      height: 100,
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      ),
    );
  }
}

class PaymentProviderSelector extends StatelessWidget {
  const PaymentProviderSelector({
    required this.provider,
    required this.providerSelected,
    Key? key,
    required this.color,
    required this.selectedColor,
    required this.onTap,
    required this.icon,
  }) : super(key: key);

  final PaygateProvider provider;

  final PaygateProvider providerSelected;

  final Color color;

  final Color selectedColor;

  final Function(PaygateProvider) onTap;

  bool get selected => provider == providerSelected;

  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        onTap(provider);
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: selected ? selectedColor : color,
            width: 2,
          ),
        ),
        height: size.height * 0.15,
        width: size.width * 0.3,
        child: Padding(
          padding: EdgeInsets.all(selected ? 15 : 2),
          child: icon,
        ),
      ),
    );
  }
}

void toast(
  BuildContext context,
  String message, {
  int duration = 3,
  SnackBarBehavior behavior = SnackBarBehavior.floating,
  void Function()? action,
  String actionText = "Ok",
  Widget? leading,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: behavior,
      content: leading == null
          ? Text(message)
          : Row(
              children: [
                leading,
                const SizedBox(width: 20),
                Expanded(child: Text(message)),
              ],
            ),
      duration: Duration(seconds: duration),
      action: action == null
          ? null
          : SnackBarAction(
              label: actionText,
              onPressed: action,
            ),
    ),
  );
}
