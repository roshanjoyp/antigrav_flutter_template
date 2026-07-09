// FIREBASE_OPTIONS_PLACEHOLDER
//
// This file is a placeholder. Replace it by running the FlutterFire CLI
// against your *staging* Firebase project:
//
//   flutterfire configure \
//     --project=<your-staging-project-id> \
//     --out=lib/core/config/firebase/firebase_options_staging.dart
//
// The CLI overwrites this entire file with real credentials.
// See FIREBASE_SETUP.md for the full workflow.

import 'package:firebase_core/firebase_core.dart';

/// Firebase options for the **staging** environment.
///
/// Placeholder shape matches the FlutterFire CLI output so `flutterfire
/// configure --out` replaces this file without any manual wiring.
class DefaultFirebaseOptions {
  /// Returns the [FirebaseOptions] for the current platform.
  ///
  /// Throws [UnsupportedError] until the placeholder has been replaced by
  /// running `flutterfire configure` (see file header and FIREBASE_SETUP.md).
  static FirebaseOptions get currentPlatform {
    throw UnsupportedError(
      'Firebase is not configured for the staging environment. '
      'Run flutterfire configure with '
      '--out=lib/core/config/firebase/firebase_options_staging.dart '
      '(see FIREBASE_SETUP.md).',
    );
  }
}
