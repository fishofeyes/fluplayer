# fluplayer

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


```bash
flutter build ipa --obfuscate --split-debug-info=build/app/outputs/symbols
xcrun altool --upload-app --type ios -f build/ios/ipa/*.ipa --apiKey keyId --apiIssuer your_issuer_id
```