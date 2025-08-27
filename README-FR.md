# Flutter PayGate Global

Intégrez la plateforme de paiement **PayGate Global** de manière transparente dans vos applications Flutter avec le support des fournisseurs de paiement **T-Money** et **Moov Money** (Flooz).

<div style="width: 260px; height: 32px; padding: 6px; background: #FFFFFF">
    <img src="https://paygateglobal.com/assets/logo-99cc62bdc693bd28b9f95fee64e71ed3ed266fa4e9dfdb196515f8a7251cc54e.png"/>
    <img src="example/assets/moov_money.png" />
    <img src="example/assets/tmoney.png" />
</div>

[![pub package](https://img.shields.io/pub/v/flutter_paygateglobal.svg)](https://pub.dev/packages/flutter_paygateglobal)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![GitHub issues](https://img.shields.io/github/issues/bienvenuelisis/flutter_paygateglobal)](https://github.com/bienvenuelisis/flutter_paygateglobal/issues)

## Fonctionnalités

- 🔄 **Support Double API** : Choisissez entre l'API v1 (directe) et v2 (page hébergée)
- 📱 **Intégration Mobile Money** : Support pour T-Money et Moov Money
- 🔒 **Paiements Sécurisés** : Toutes les transactions sont sécurisées par PayGate Global
- ✅ **Vérification des Transactions** : Vérification de statut intégrée

## Installation

Ajoutez à votre `pubspec.yaml` :

```yaml
dependencies:
  flutter_paygateglobal: ^0.1.5
```

Exécutez :

```bash
flutter pub get
```

## Définition des termes utilisés

- **Identifiant de transaction** : identifiant que vous générez vous-même (ou laissez ce plugin générer) et avec lequel vous pourrez identifier la transaction et vérifier son statut.
- **Montant de transaction** : montant d'argent que vous voulez prélever du compte mobile money de l'utilisateur.
- **URL de callback de transaction** : url que vous voulez voir appelée lorsque la transaction est terminée.
- **Fournisseur de transaction** : les fournisseurs sont (à cet instant) MoovAfrica (MoovMoney) et Togocom (TMoney).
- **Référence de transaction** : référence générée par Paygate Global lui-même. Vous pouvez également l'utiliser pour vérifier le statut de la transaction.

## Commencer

Avant de commencer à utiliser ce package, vous devez avoir une clé API Paygate. Créez un compte sur le [site web Paygate](https://paygateglobal.com/), remplissez les informations de votre plateforme E-Commerce et vous recevrez votre clé API de compte.

## Utilisation

Tout d'abord, vous devez initialiser le plugin. Appelez simplement la méthode Paygate.init(). Cette méthode nécessite votre clé API Paygate de production.
Vous pouvez également configurer la version API que vous voulez utiliser par défaut lorsque vous appelez la méthode _pay_ sans spécifier la version à utiliser (si non spécifiée, la seconde méthode est utilisée par défaut).

```dart
Paygate.init(
  apiKey: 'XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX',
  apiVersion: PaygateVersion.v1, // défaut PaygateVersion.v2
  apiKeyDebug: 'XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX', // optionnel
  identifierLength: 20, // optionnel, défaut 20
);
```

Vous pouvez initialiser avec une clé API additionnelle utilisée quand vous êtes en débogage.
Vous pouvez également spécifier la longueur par défaut des identifiants générés par le plugin (défaut = 20).

### Initier une nouvelle transaction

Paygate a deux versions d'API. Cela dépend de quand vous voulez faire une requête post, ou utiliser la page de paiement préconfigurée avec une requête get.

1. Vous faites une requête post et Paygate retourne la référence de transaction de paiement avec laquelle vous pouvez vérifier plus tard le statut de la transaction.

```dart
NewTransactionResponse response = await Paygate.payV1(
    amount: 1000,
    provider: PaygateProvider.moovMoney, // requis : PaygateProvider.moovMoney ou PaygateProvider.tMoney
    identifier: 'TR000000010', // optionnel : si vide, l'identifiant de transaction sera généré par le plugin.
    description: 'Ma transaction fantastique', // optionnel : description de la transaction
    phoneNumber: '90010203', // requis : numéro de téléphone de l'utilisateur
);

if (response.ok) {
    print('Transaction initiée : ${response.txReference}');
    // Sauvegarder la référence pour vérification ultérieure
} else {
    print('Transaction échouée : ${response.exception}');
}
```

2. Vous faites une requête get vers une page de paiement fournie et sécurisée par Paygate.

```dart
NewTransactionResponse response = await Paygate.payV2(
    amount: 1000,
    callbackUrl: 'https://myapp.com/callback',
    provider: PaygateProvider.moovMoney, // requis : PaygateProvider.moovMoney ou PaygateProvider.tMoney
    identifier: 'TR000000010', // optionnel : si vide, l'identifiant de transaction sera généré par le plugin.
    description: 'Ma transaction fantastique', // optionnel : description de la transaction
    phoneNumber: '90010203', // requis : numéro de téléphone de l'utilisateur
);

if (response.ok) {
    print('Page de paiement ouverte : ${response.txReference}');
}
```

Une fois le paiement effectué par le client, PayGateGlobal enverra un message de confirmation à l'URL de retour de l'e-commerce (si fournie précédemment).
Le message est une méthode HTTP Post, servie avec une charge utile JSON, structurée comme suit :

| Propriété         |                            Description                             |
| ----------------- | :----------------------------------------------------------------: |
| tx_reference      | Identifiant unique généré par PayGateGlobal pour la transaction   |
| identifier        |        Identifiant interne de la transaction e-commerce.          |
| payment_reference |          Référence de paiement générée par Flooz.                 |
| amount            |                    Montant payé par le client                     |
| datetime          |                      Date et heure du paiement                    |
| phone_number      |    Numéro de téléphone du client qui a effectué le paiement.      |
| payment_method    | Méthode de paiement utilisée par le client. Valeurs possibles : FLOOZ, T-Money. |

Avec la méthode 1 ou 2, l'utilisateur ne quitte jamais l'application. Ce package utilise le [package custom_tabs](https://pub.dev/packages/flutter_custom_tabs) pour ouvrir la page de paiement Paygate Global, lorsque vous utilisez la version 2 de l'API.

### Vérifier le statut de la transaction

Après avoir initialisé une transaction, vous pouvez vérifier le statut de la transaction avec la méthode _verify_, appelée sur l'objet réponse (NewTransactionResponse). Ou bien juste la méthode statique _verifyTransaction_, qui nécessite la référence de transaction ou l'identifiant.

```dart

if (response.ok) {
    saveReference(response.txReference); // ou sauvegarder l'identifiant dans votre base de données saveIdentifier(response.identifier);
} else {
    // Réessayer ou déboguer (un message sera affiché dans la console).
    /// Vous pouvez accéder à l'exception avec response.exception .
}

// Après un délai, vous pouvez vérifier le statut de la transaction.
Transaction transaction = await response.verify();

// Ou en utilisant la méthode statique
Transaction transaction = await Paygate.verifyTransaction(
  txReference: 'votre-tx-reference', // De PayGate
  // OU
  trxIdentifier: 'votre-identifiant', // Votre identifiant personnalisé
);

switch (transaction.status) {
  case TransactionStatus.success:
    print('Paiement réussi !');
    break;
  case TransactionStatus.pending:
    print('Paiement en attente...');
    break;
  case TransactionStatus.failed:
    print('Paiement échoué');
    break;
  default:
    print('Statut inconnu');
}
```

_Veuillez consulter le répertoire example pour un exemple complet avec des implémentations d'interface utilisateur appropriées._

## 📱 Fournisseurs de Paiement Supportés

| Fournisseur | Code | Réseau | Pays |
|-------------|------|--------|------|
| T-Money | `PaygateProvider.tmoney` | Togocom | Togo |
| Moov Money (Flooz) | `PaygateProvider.moovMoney` | Moov Africa | Togo |

## 🔄 Cycle de Vie des Transactions

1. **Initier** : Appeler `payV1()` ou `payV2()`
2. **Traiter** : L'utilisateur complète le paiement via mobile money
3. **Callback** : PayGate envoie une confirmation à votre URL de callback (v2 seulement)
4. **Vérifier** : Vérifier le statut de la transaction par programmation
5. **Terminer** : Gérer les paiements réussis/échoués dans votre app

## 📊 Charge Utile de Callback (API v2)

Lors de l'utilisation de l'API v2, PayGate envoie ce JSON à votre URL de callback :

```json
{
  "tx_reference": "PG_12345_67890",
  "identifier": "votre_identifiant_personnalise",
  "payment_reference": "TM_98765_43210",
  "amount": "1000",
  "datetime": "2024-01-15T10:30:00Z",
  "phone_number": "90123456",
  "payment_method": "T-Money"
}
```

La requête renvoie des données au format JSON, structurées comme suit :

| Property          |    Description                                                                |
| ----------------- | ----------------------------------------------------------------------------- |
| tx_reference      | Identifiant Unique générée par PayGateGlobal pour la transaction              |
| identifier        | Identifiant interne de la transaction de l’e-commerce. ex: Numero de commande Cet identifiant doit etre unique |
| payment_reference | Code de référence de paiement généré par Flooz. Ce code peut être utilisé en cas de résolution de problèmes ou de plaintes                    |
| amount            | Montant payé par le client                                                    |
| datetime          | Date and Heure de paiement                                                    |
| phone_number      | Numéro de téléphone du client qui a effectué le paiement                      |
| payment_method    | Méthode de paiement utilisée par le client. Valeurs possibles: FLOOZ, T-Money |

Avec la méthode 1 ou 2, l'utilisateur ne quitte jamais l'application. Ce package utilise le [url_launcher package](https://pub.dev/packages/url_launcher) (une sorte de webview) pour ouvrir la page de paiement de Paygate Global, lorsque vous utilisez la version 2 de l'API.

_Veuillez consulter le répertoire des exemples pour obtenir un exemple complet avec des implémentations d'interface utilisateur appropriées._

## 🧪 Tests

Exécuter les tests :

```bash
flutter test
```

Tester avec des données fictives :

```dart
void initTestEnvironment() {
  Paygate.init(
    apiKey: 'test-api-key-12345678-1234-1234-1234-123456789012',
    apiVersion: PaygateVersion.v2,
  );
}
```

## 🐛 Dépannage

### Problèmes Courants

#### Numéro de Téléphone Invalide

- Assurez-vous du format : 8 chiffres commençant par 9, 7, ou 2
- Exemples : `90123456`, `70123456`, `22890123456`

#### Transaction Échouée

- Vérifiez la validité de votre clé API
- Vérifiez que le numéro de téléphone a un solde suffisant
- Assurez-vous que le montant est entre 1 et 1 000 000 CFA

#### Erreurs Réseau

- Vérifiez la connectivité internet
- Vérifiez le statut du service PayGate Global
- Testez d'abord avec la clé API de débogage

## Référence API

### Classes

- **`Paygate`** : Classe principale pour les opérations de paiement
- **`NewTransactionResponse`** : Réponse de l'initiation de paiement
- **`Transaction`** : Statut et détails de la transaction
- **`PaygateProvider`** : Énumération pour les fournisseurs de paiement
- **`PaygateVersion`** : Énumération pour les versions d'API

### Exceptions

- **`PaygateValidationException`** : Paramètres d'entrée invalides
- **`PaygateNetworkException`** : Problèmes de connectivité réseau
- **`PaygateApiException`** : Erreurs liées à l'API
- **`PaygateConfigurationException`** : Problèmes de configuration/installation

## 🤝 Contribution

1. Forker le dépôt
2. Créer une branche de fonctionnalité : `git checkout -b feature/fonctionnalite-incroyable`
3. Commiter les changements : `git commit -m 'Ajouter une fonctionnalité incroyable'`
4. Pousser vers la branche : `git push origin feature/fonctionnalite-incroyable`
5. Ouvrir une Pull Request

## Licence

Ce projet est sous licence MIT - voir le fichier [LICENSE](LICENSE)

## Support

- **Email** : [agbavonbienvenu@gmail.com](mailto:agbavonbienvenu@gmail.com)
- **Issues** : [GitHub Issues](https://github.com/bienvenuelisis/flutter_paygateglobal/issues)

## Journal des Modifications

Voir [CHANGELOG.md](CHANGELOG.md) pour l'historique des versions.

---

Fait avec ❤️ pour la communauté Flutter, par The Authentic Dev (<https://00auth.dev>).
