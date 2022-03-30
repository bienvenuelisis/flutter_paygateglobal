<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

# Integrate easily the Paygate Global Platform into your Flutter app

<!--<div style="width: 260px; height: 32px; padding: 6px; background: #FFFFFF">
    <img src="https://storage.googleapis.com/cms-storage-bucket/c823e53b3a1a7b0d36a9.png" />
    <img src="https://paygateglobal.com/assets/logo-99cc62bdc693bd28b9f95fee64e71ed3ed266fa4e9dfdb196515f8a7251cc54e.png"/>
    <img src="example/assets/moov_money.png" />
    <img src="example/assets/tmoney.png" />
</div>-->

## Features

- Implement payment with the Paygate Global Platform.
- Support for two payment providers : T-Money and Moov Money.

## Defining terms uses

- Transaction identifier : identifier you generate yourself (or let this plugin generate) and with which you will be able to identify the transaction and check it's status.
- Transaction amount : amount of money you want to take from user mobile money account.
- Transaction callbackUrl : url you want to be called when the transaction is completed.
- Transaction provider : providers are (at this instant) MoovAfrica (MoovMoney) and Togocom (TMoney).
- Transaction Reference : reference generated by Paygate Global itself. You can also use it to check transaction status.

## Getting started

Before you start to use this package, you need to have a Paygate API Key. Create an account on the [Paygate Website](https://paygateglobal.com/), fill your E-Commerce platform informations and you will receive your account APi Key.

## Usage

First of all you need to initialize the plugin. Just call the Paygate.init() method. This method require your production Paygate API Key.
You can also configure the API version you want to use per default when you call the _pay_ method without specifying the version to use (if not specified the second method is used per default).

```dart
Paygate.init(
  apiKey: 'XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX',
  apiVersion: PaygateVersion.v1, // default PaygateVersion.v2
  apiKeyDebug: 'XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX', // optional
  identifierLength: 20, // optional, default 20
);
```

You can initialize with a additionnal API key used when you are in debug.
You can also specify the default length of the identifiers generated by the plugin (default = 20).

### Init a new transaction

Paygate has two API versions. Depends on when you want to make a request post, or use the preconfigured payment page with a get request.

1. You make a post request and Paygate return the payment transaction reference with which you can check later the transaction status.

```dart
NewTransactionResponse response = await Paygate.payV1(
    amount: 1000,
    provider: PaygateProvider.moovMoney, // required : PaygateProvider.moovMoney or PaygateProvider.tMoney
    identifier: 'TR000000010', // optional : if empty, the transaction identifier will be generated by the plugin.
    description: 'My awesome transaction', // optional : description of the transaction
    phoneNumber: '90010203', // required : phone number of the user
);
```

2. You make a get request to a payment page provided and secured by Paygate.

```dart
NewTransactionResponse response = await Paygate.payV2(
    amount: 1000,
    callbackUrl: 'https://myapp.com/callback',
    provider: PaygateProvider.moovMoney, // required : PaygateProvider.moovMoney or PaygateProvider.tMoney
    identifier: 'TR000000010', // optional : if empty, the transaction identifier will be generated by the plugin.
    description: 'My awesome transaction', // optional : description of the transaction
    phoneNumber: '90010203', // required : phone number of the user
);
```

Once payment is made by the customer, PayGateGlobal will send a confirmation message to the e-commerce return URL (If previously provided). 
The message is HTTP Post Method, served with JSON payload, structured as follows: 

| Property        |    Description                                                           |
| -------------   | :------------------:                                                     |
| tx_reference    |  Unique identifier generated by PayGateGlobal for the transaction        |
| identifier      |        Internal identifier of the e-commerce transaction.                |
| payment_reference       |    Payment reference code generated by Flooz.                    |
| amount          | Amount paid by customer                                                  |
| datetime        | Payment Date and Time                                                    |
| phone_number    | Telephone number of the customer who made the payment.                   |
| payment_method  |   Payment method used by the customer. Possible values: FLOOZ, T-Money.  |

With either method 1 or 2, user never quit the application. This package use the [custom_tabs package](https://pub.dev/packages/flutter_custom_tabs) to open the Paygate Global payment page, when you the API version 2.

### Check the transaction status

After you have initialized a transaction, you can check the status of the transaction with the _verify_ method, called on the response (NewTransactionResponse) object. Or either juste the static method _verifyTransaction_, which require the transaction reference or the identifier.

```dart

if (response.ok) {
    saveReference(response.txReference); // or save the identifier in your database saveIdentifier(response.identifier);
} else {
    // Retry or debug (a message will be displayed in the console).
    /// You can access the exception with response.exception .
}

// After a delay, you can check the transaction status.
Transaction transaction = await response.verify(); 

// or 

Transaction transaction = await Paygate.verifyTransaction(response.txReference); // or Paygate.verifyTransaction(response.identifier);
```

_Please check the example directory for a complete example with suitable UI implementations._

## Additional information

I have wrote a article about this package on [my blog](https://blog.theresilient.dev/) which contains more detailled informations.

File free to contribute or fill issues when you use this package.
