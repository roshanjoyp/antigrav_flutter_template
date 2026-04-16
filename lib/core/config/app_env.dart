import 'package:flutter/foundation.dart';

/// Represents the environment the app is currently running in.
///
/// The active environment is set once at startup via [AppFlavor.initialize]
/// and should never change at runtime.
///
/// Use the helper getters ([isDevelopment], [isStaging], [isProduction],
/// [isDebugBuild]) rather than comparing enum values directly.
enum AppEnv {
  /// Local development environment.
  ///
  /// Connects to local or dev-tier backends. Verbose logging enabled.
  /// Should never be shipped to end users.
  development,

  /// Staging / QA environment.
  ///
  /// Connects to staging-tier backends. Used for pre-release testing
  /// and internal distribution (e.g. TestFlight, Firebase App Distribution).
  staging,

  /// Production environment.
  ///
  /// Connects to live backends. Minimal logging. Shipped to end users.
  production;

  // ---------------------------------------------------------------------------
  // Convenience getters
  // ---------------------------------------------------------------------------

  /// Returns `true` when running in the [development] environment.
  bool get isDevelopment => this == AppEnv.development;

  /// Returns `true` when running in the [staging] environment.
  bool get isStaging => this == AppEnv.staging;

  /// Returns `true` when running in the [production] environment.
  bool get isProduction => this == AppEnv.production;

  /// Returns `true` when the app is compiled in debug mode, regardless of
  /// environment.
  ///
  /// This is determined by Dart's [kDebugMode] constant, not by [AppEnv].
  /// A staging build can be run in release mode, so always use this getter
  /// rather than [isDevelopment] when making debug-only decisions.
  bool get isDebugBuild => kDebugMode;

  // ---------------------------------------------------------------------------
  // Display
  // ---------------------------------------------------------------------------

  /// A human-readable label for this environment.
  ///
  /// Suitable for display in debug banners, internal build info screens,
  /// or log output.
  ///
  /// Returns `'Development'`, `'Staging'`, or `'Production'`.
  String get displayName => switch (this) {
        AppEnv.development => 'Development',
        AppEnv.staging => 'Staging',
        AppEnv.production => 'Production',
      };
}
