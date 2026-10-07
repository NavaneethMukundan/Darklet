// PLACEHOLDER - replace by running the FlutterFire CLI in the project root:
//
//   dart pub global activate flutterfire_cli
//   flutterfire configure --project=<your-project-id> \
//     --platforms=android,ios \
//     --android-package-name=<your.bundle.id> --ios-bundle-id=<your.bundle.id> \
//     --out=lib/firebase_options.dart
//
// Mock mode (the default) never reads this file. See docs/FIREBASE_SETUP.md.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static const String _placeholder = 'REPLACE_ME';

  /// `false` until `flutterfire configure` has generated real values.
  static bool get isConfigured => currentPlatform.apiKey != _placeholder;

  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return ios;
      default:
        return android;
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: _placeholder,
    appId: _placeholder,
    messagingSenderId: _placeholder,
    projectId: _placeholder,
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: _placeholder,
    appId: _placeholder,
    messagingSenderId: _placeholder,
    projectId: _placeholder,
    iosBundleId: 'com.darklet.app',
  );
}
