// NETWORK_BASE_URL_PLACEHOLDER
// The marker above is read by tooling (doctor CLI, future) to detect an
// unconfigured API backend. Remove it when you paste real base URLs.

import 'package:craft_flutter_template/core/config/app_env.dart';
import 'package:craft_flutter_template/core/config/app_flavor.dart';

/// REST/HTTP API configuration for the app's own backend.
///
/// The template ships with the network layer **disabled** ([enabled] is
/// `false`) and placeholder base URLs, so it compiles and runs against
/// the stub `NetworkService` out of the box. To point the app at a real
/// backend:
///
/// 1. Replace the placeholder URLs below with your dev/staging/prod
///    API endpoints.
/// 2. Flip [enabled] to `true` — `bootstrap.dart` then rebinds
///    `networkServiceProvider` to the Dio-backed implementation.
///
/// The active URL follows the running flavor ([AppFlavor]), so a staging
/// build can never talk to production data. If the endpoint may ever move
/// after launch (e.g. a backend migration), fetch the base URL from a
/// remote source at startup and fall back to these compile-time values —
/// installed apps cannot be re-pointed by shipping new code.
class NetworkConfig {
  /// Not instantiable — all members are static.
  const NetworkConfig._();

  /// Whether the real HTTP network layer is enabled for this app.
  ///
  /// Ships as `false` so the template runs with the stub network service
  /// and no backend. Set to `true` only after replacing the placeholder
  /// base URLs below.
  static const bool enabled = false;

  /// API base URL for the development environment.
  static const String _developmentBaseUrl = 'https://api-dev.example.com';

  /// API base URL for the staging environment.
  static const String _stagingBaseUrl = 'https://api-staging.example.com';

  /// API base URL for the production environment.
  static const String _productionBaseUrl = 'https://api.example.com';

  /// The API base URL for the currently running environment.
  ///
  /// Resolved from [AppFlavor.instance], so it must not be read before
  /// `AppFlavor.initialize` has run (bootstrap does this first).
  static String get baseUrl => switch (AppFlavor.instance.env) {
    AppEnv.development => _developmentBaseUrl,
    AppEnv.staging => _stagingBaseUrl,
    AppEnv.production => _productionBaseUrl,
  };
}
