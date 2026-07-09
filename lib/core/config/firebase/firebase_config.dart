import 'package:antigrav_flutter_template/core/config/app_env.dart';
import 'package:antigrav_flutter_template/core/config/app_flavor.dart';
import 'package:antigrav_flutter_template/core/config/firebase/firebase_options_dev.dart'
    as dev;
import 'package:antigrav_flutter_template/core/config/firebase/firebase_options_prod.dart'
    as prod;
import 'package:antigrav_flutter_template/core/config/firebase/firebase_options_staging.dart'
    as staging;
import 'package:firebase_core/firebase_core.dart';

/// Flavor-aware Firebase configuration and initialization.
///
/// Selects the correct `firebase_options_*.dart` file for the active
/// [AppEnv] (set via [AppFlavor.initialize]) and initializes Firebase
/// during app startup.
///
/// The template ships with Firebase **disabled** ([enabled] is `false`)
/// and placeholder option files, so it compiles and runs against the stub
/// services out of the box. To turn Firebase on:
///
/// 1. Run `flutterfire configure` once per environment, targeting the
///    matching `--out` file (see docs/setup/FIREBASE_SETUP.md for the exact commands).
/// 2. Flip [enabled] to `true`.
class FirebaseConfig {
  /// Not instantiable — all members are static.
  const FirebaseConfig._();

  /// Whether Firebase is enabled for this app.
  ///
  /// Ships as `false` so the template runs with stub services and no
  /// Firebase project. Set to `true` only after replacing the placeholder
  /// `firebase_options_*.dart` files via `flutterfire configure`; enabling
  /// it with placeholders in place throws [UnsupportedError] at startup.
  static const bool enabled = false;

  /// The [FirebaseOptions] for the active environment and current platform.
  ///
  /// Resolves the environment from [AppFlavor.instance], so [AppFlavor]
  /// must be initialized first. Throws [UnsupportedError] if the selected
  /// environment's options file is still the unconfigured placeholder.
  static FirebaseOptions get currentOptions => switch (AppFlavor.instance.env) {
        AppEnv.development => dev.DefaultFirebaseOptions.currentPlatform,
        AppEnv.staging => staging.DefaultFirebaseOptions.currentPlatform,
        AppEnv.production => prod.DefaultFirebaseOptions.currentPlatform,
      };

  /// Initializes Firebase for the active environment.
  ///
  /// No-op when [enabled] is `false`, keeping the stub-only template free
  /// of any Firebase project requirement. Must be called after
  /// `WidgetsFlutterBinding.ensureInitialized()` and after
  /// [AppFlavor.initialize], before any Firebase-backed service is used.
  ///
  /// Errors are deliberately not caught here: a misconfigured Firebase
  /// setup should fail loudly at startup, where the global error handlers
  /// in `main.dart` will surface it.
  static Future<void> initialize() async {
    if (!enabled) return;
    await Firebase.initializeApp(options: currentOptions);
  }
}
