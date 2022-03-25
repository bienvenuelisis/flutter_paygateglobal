const String paramInit = '?';
const String equalsParam = '=';
const String andParam = '&';
const String token = "";
const String apiKeyParam = 'token';

String getUrl(String baseUrl, Map<String, dynamic>? paramsAndValues) {
  if (paramsAndValues == null || paramsAndValues.isEmpty) return baseUrl;

  String url = baseUrl + paramInit;
  for (int i = 0; i < paramsAndValues.length; i++) {
    if (paramsAndValues.values.elementAt(i) != null) {
      url += (paramsAndValues.keys.elementAt(i) +
          equalsParam +
          paramsAndValues.values.elementAt(i).toString() +
          andParam);
    }
  }
  return url.substring(0, url.length - 1);
}
