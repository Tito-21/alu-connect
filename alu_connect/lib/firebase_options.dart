// ⚠️ THIS FILE IS A PLACEHOLDER.
//
// You cannot use these fake values — Firebase will reject them.
// Generate the real version by running this in your project folder:
//
//   dart pub global activate flutterfire_cli
//   flutterfire configure
//
// That command connects to YOUR Firebase project (the one you create in
// the Firebase Console) and overwrites this file automatically with your
// real API keys. Do this before running the app. See README.md.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'Run `flutterfire configure` to generate real options for web.',
      );
    }
    switch (Platform.operatingSystem) {
      case 'android':
      case 'ios':
        throw UnsupportedError(
          'This is a placeholder. Run `flutterfire configure` first — see README.md.',
        );
      default:
        throw UnsupportedError('Platform not supported yet.');
    }
  }
}
