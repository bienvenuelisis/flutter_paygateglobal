# Changelog

## 0.1.6

* Fix SSL/TLS `HandshakeException` caused by self-signed certificates in some environments.
* Add `allowBadCertificates` parameter to `Paygate.init()` to optionally bypass certificate verification (intended for development only — defaults to `false`).
* Internally route all HTTP calls through `PaygateHttpClient` using `IOClient` for consistent SSL handling.

## 0.1.5

* Enhance documentation.
* Update app architecture.
* Made library more developer-friendly.

## 0.1.4

* Update dependencies.

## 0.1.3

* Update http package to 0.13.4 to 1.1.0.

## 0.1.2

* Update example project (replace RaisedButton by TextButton).

## 0.1.1

* Add example folders.
* Resolve issues.

## 0.1.0

* Initialize a transaction throw the API method 1 or 2.
* Check the transaction status.
