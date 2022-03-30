# Intégrez facilement [Paygate](https://paygateglobal.com) à votre application Flutter.

<!--<div style="padding: 6px; background: #FFFFFF">
    <img width="64" src="https://storage.googleapis.com/cms-storage-bucket/c823e53b3a1a7b0d36a9.png" />
    <img width="64" src="https://paygateglobal.com/assets/logo-99cc62bdc693bd28b9f95fee64e71ed3ed266fa4e9dfdb196515f8a7251cc54e.png"/>
    <img width="64" src="example/assets/moov_money.png" />
    <img width="64" src="example/assets/tmoney.png" />
</div>-->

## Fonctionnalités

- Implémenter le paiement avec la plateforme Paygate Globale
- Support de deux fournisseurs de paiement : [T-Money](https://togocom.tg/tmoney) et [Moov Money (Flooz)](https://moov-africa.tg/flooz/)

## Termes utilisés

- **Identifiant de la transaction** : identifiant que vous générez (ou que vous laissez ce plugin générer) et avec lequel vous pourrez identifier la transaction et vérifier son statut
- **Montant de la transaction** : la somme d'argent que vous voulez demander du compte mobile money de l'utilisateur
- **L'URL de callback** : url à appeler par paygate lorsque la transaction est terminée
- **Fournisseur de transactions** : les fournisseurs sont (à ce jour) MoovAfrica (MoovMoney) et Togocom (TMoney)
- **Référence de la transaction** : référence générée par Paygate. Vous pouvez également l'utiliser pour vérifier le statut de la transaction

## Prérequis

* Vous devez créer un compte sur [Paygate](https://paygateglobal.com/nouveau-compte)
* Remplir les informations relatives à votre plateforme de commerce électronique et vous pourriez commencer l'API
* Vous devez disposer d'une clé API Paygate (semblable à un [UUID](https://fr.wikipedia.org/wiki/Universally_unique_identifier))

## Utilisation

Tout d'abord, vous devez initialiser le plugin. Appelez simplement la méthode `Paygate.init()`. Cette méthode requiert votre clé API Paygate de production.
Vous pouvez également configurer la version de l'API que vous souhaitez utiliser. Mais par défaut lorsque vous appelez la méthode `pay()` sans spécifier la version à utiliser (si elle n'est pas spécifiée) la deuxième méthode est utilisée par défaut.

```dart
Paygate.init(
  apiKey: 'XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX',
  apiVersion: PaygateVersion.v1, // par défaut : PaygateVersion.v2
  apiKeyDebug: 'XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX', // optionel
  identifierLength: 20, // optionel, par défaut : 20
);
```

Vous pouvez l'initialiser avec une clé d'API additionnelle utilisée lorsque vous êtes en debug.
Vous pouvez également spécifier la taille par défaut des identifiants générés par le plugin (20 caractères par défaut).

### Initier une nouvelle transaction

Paygate dispose de deux méthodes permettant de demander un paiement chez un utilisateur :
* La méthode POST (en faisant une requête http de type POST avec des paramètres)
* La méthode GET (en redirigent l'utilisateur vers le portail de paiement de Paygate)

1. Vous faites une demande de paiement et Paygate vous renvoie la référence de la transaction avec laquelle vous pouvez vérifier ultérieurement le statut de la transaction

```dart
NewTransactionResponse response = await Paygate.payV1(
    amount: 1000,// devise : FCFA
    provider: PaygateProvider.moovMoney, // obligatoire : PaygateProvider.moovMoney ou PaygateProvider.tmoney
    identifier: 'TR000000010', // optional : Si vide, l'identifiant de la transaction sera généré par le plugin.
    description: 'Ma superbe transaction', // optional : Détails de la transaction
    phoneNumber: '90010203', // obligatoire : Numéro de téléphone mobile du Client
);
```

2. Vous faites une demande d'accès à la page de paiement (sécurisée) fournie par Paygate

```dart
NewTransactionResponse response = await Paygate.payV2(
    amount: 1000,
    callbackUrl: 'https://myapp.com/callback',
    provider: PaygateProvider.moovMoney, // obligatoire : PaygateProvider.moovMoney or PaygateProvider.tmoney
    identifier: 'TR000000010', // optional : si vide, l'identifiant de la transaction sera généré par le plugin.
    description: 'Ma superbe transaction', // optional : Détails de la transaction
    phoneNumber: '90010203', // obligatoire : Numéro de téléphone mobile du Client
);
```

Une fois le paiement effectué par le client, PayGateGlobal envoie un message de confirmation à l'URL de retour (si elle a été fournie précédemment). 
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

Avec la méthode 1 ou 2, l'utilisateur ne quitte jamais l'application. Ce package utilise le [custom_tabs package](https://pub.dev/packages/flutter_custom_tabs) (une sorte de webview) pour ouvrir la page de paiement de Paygate Global, lorsque vous utilisez la version 2 de l'API.

### Vérifier l'état d'un Paiement

Après avoir initialisé une transaction, vous pouvez vérifier le statut de la transaction avec la méthode `verify()`, appelée sur l'objet response (NewTransactionResponse). Vous pouvez également utiliser la méthode statique `verifyTransaction()`, qui requiert la référence de la transaction ou l'identifiant.

```dart

if (response.ok) {
    saveReference(response.txReference); // ou enregistrer l'identifiant dans votre base de données saveIdentifier(response.identifier);
} else {
    // Réessayer ou déboguer (un message sera affiché dans la console).
    /// Vous pouvez accéder à l'exception avec response.exception.
}

// Après un délai, vous pouvez vérifier le statut d'un paiement.
Transaction transaction = await response.verify(); 

// ou 

Transaction transaction = await Paygate.verifyTransaction(response.txReference); // ou Paygate.verifyTransaction(response.identifier);
```

_Veuillez consulter le répertoire des exemples pour obtenir un exemple complet avec des implémentations d'interface utilisateur appropriées._

## Informations supplémentaires

J'ai rédigé un article sur ce paquet sur [mon blog](https://blog.theresilient.dev/) qui contient des informations plus détaillées.

N'hésitez pas à contribuer ou à remplir les questions lorsque vous utilisez ce paquet.
