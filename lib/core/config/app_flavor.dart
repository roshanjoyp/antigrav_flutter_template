import 'package:antigrav_flutter_template/core/config/app_env.dart';
import 'package:flutter/foundation.dart';

/// Holds the active environment for the entire application lifetime.
///
/// [AppFlavor] is a singleton that must be initialized exactly once, before
/// [runApp] is called in `main.dart`. After initialization, the active
/// environment is available anywhere via [AppFlavor.instance].
///
/// Initialization:
/// ```dart
/// AppFlavor.initialize(AppEnv.development);
/// ```
///
/// Access:
/// ```dart
/// final env = AppFlavor.instance.env;
/// if (env.isDevelopment) { ... }
/// ```
///
/// Accessing [instance] before calling [initialize] throws a [StateError]
/// with a clear message to prevent silent misconfiguration.
class AppFlavor {
  /// Internal constructor — use [initialize] to create the singleton.
  const AppFlavor._({required this.env});

  /// The current [AppEnv] this build is configured for.
  final AppEnv env;

  static AppFlavor? _instance;

  // ---------------------------------------------------------------------------
  // Initialization
  // ---------------------------------------------------------------------------

  /// Initializes the [AppFlavor] singleton with the given [env].
  ///
  /// Must be called exactly once, before [runApp], typically at the top of
  /// `main()`. Calling this more than once will throw a [StateError] to
  /// prevent accidental re-initialization after the app has started.
  ///
  /// Example:
  /// ```dart
  /// void main() async {
  ///   AppFlavor.initialize(AppEnv.development);
  ///   runApp(const App());
  /// }
  /// ```
  static void initialize(AppEnv env) {
    if (_instance != null) {
      throw StateError(
        'AppFlavor has already been initialized with '
        '${_instance!.env.displayName}. '
        'initialize() must only be called once.',
      );
    }
    _instance = AppFlavor._(env: env);
  }

  // ---------------------------------------------------------------------------
  // Access
  // ---------------------------------------------------------------------------

  /// The initialized [AppFlavor] singleton.
  ///
  /// Throws a [StateError] if accessed before [initialize] has been called.
  /// This is intentional — a missing initialization is a programming error
  /// and should fail loudly rather than silently defaulting.
  ///
  /// Example:
  /// ```dart
  /// final flavor = AppFlavor.instance;
  /// print(flavor.env.displayName); // 'Development'
  /// ```
  static AppFlavor get instance {
    if (_instance == null) {
      throw StateError(
        'AppFlavor has not been initialized. '
        'Call AppFlavor.initialize(AppEnv) before accessing AppFlavor.instance.',
      );
    }
    return _instance!;
  }

  // ---------------------------------------------------------------------------
  // Convenience pass-throughs
  // ---------------------------------------------------------------------------

  /// Shorthand for `AppFlavor.instance.env.isDevelopment`.
  static bool get isDevelopment => instance.env.isDevelopment;

  /// Shorthand for `AppFlavor.instance.env.isStaging`.
  static bool get isStaging => instance.env.isStaging;

  /// Shorthand for `AppFlavor.instance.env.isProduction`.
  static bool get isProduction => instance.env.isProduction;

  // ---------------------------------------------------------------------------
  // Testing support
  // ---------------------------------------------------------------------------

  /// Resets the singleton so a new [AppEnv] can be injected in tests.
  ///
  /// This method exists **exclusively for unit tests**. It must never be
  /// called in production code. Calling it outside of a test environment
  /// will leave the app in an uninitialized state, causing a [StateError]
  /// on the next access to [instance].
  ///
  /// Typical usage:
  /// ```dart
  /// setUp(() => AppFlavor.initialize(AppEnv.development));
  /// tearDown(() => AppFlavor.reset());
  /// ```
  @visibleForTesting
  static void reset() => _instance = null;
}
