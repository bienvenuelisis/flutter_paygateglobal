import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

///Cette deuxième méthode permet de rediriger le client vers une page de
///paiement mise à votre disposition. Cette page est accessible via le lien
/// ci dessous.
/// Flooz & TMoney
Future<bool> launchPageCustomTab(
  String link, [
  Color? color,
]) async {
  try {
    await launchUrl(
      Uri.parse(link),
      customTabsOptions: CustomTabsOptions(
        colorSchemes: CustomTabsColorSchemes.defaults(
          toolbarColor: color,
        ),
        browser: const CustomTabsBrowserConfiguration(
          fallbackCustomTabs: <String>[
            // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
            'org.mozilla.firefox',
            // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
            'com.microsoft.emmx',
          ],
        ),
        instantAppsEnabled: true,
        // toolbarColor: color,
        shareState: CustomTabsShareState.on,
        showTitle: true,
        urlBarHidingEnabled: true,
        //headers: {},
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
