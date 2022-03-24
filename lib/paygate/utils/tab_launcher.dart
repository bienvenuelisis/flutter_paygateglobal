import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

///Cette deuxième méthode permet de rediriger le client vers une page de
///paiement mise à votre disposition. Cette page est accessible via le lien
/// ci dessous.
/// Flooz & TMoney
Future<bool> launchPageCustomTab(String link, [Color? color,]) async {
  try {
    await launch(
      link,
      customTabsOption: CustomTabsOption(
        toolbarColor: color,
        enableDefaultShare: true,
        enableUrlBarHiding: true,
        showPageTitle: true,
        enableInstantApps: true,
        //headers: {},
        extraCustomTabs: const <String>[
          // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
          'org.mozilla.firefox',
          // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
          'com.microsoft.emmx',
        ],
      ),
    );
    return true;
  } catch (e) {
    // An exception is thrown if browser app is not installed on
    //Android device.
    debugPrint(e.toString());
    return false;
  }
}