// REVENUECAT_KEYS_PLACEHOLDER
// The marker above is read by tooling (future doctor CLI) to detect an
// unconfigured RevenueCat setup. Remove it when you paste real API keys.

import 'package:antigrav_flutter_template/core/config/app_env.dart';
import 'package:antigrav_flutter_template/core/config/app_flavor.dart';
import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// RevenueCat configuration and initialization.
///
/// The template ships with RevenueCat **disabled** ([enabled] is `false`)
/// and placeholder API keys, so it compiles and runs against the stub
/// subscription repository out of the box. To turn RevenueCat on:
///
/// 1. Create a RevenueCat project and paste its public SDK keys into
///    [appleApiKey] / [googleApiKey] (see docs/setup/REVENUECAT_SETUP.md).
/// 2. Flip [enabled] to `true`.
///
/// RevenueCat separates sandbox from production by *store environment*
/// (TestFlight/sandbox testers vs. live store), not by API key, so one
/// project — and one pair of keys — serves all app flavors. If you do
/// want separate projects per environment, switch on
/// `AppFlavor.instance.env` inside [initialize].
class RevenueCatConfig {
  /// Not instantiable — all members are static.
  const RevenueCatConfig._();

  /// Whether RevenueCat is enabled for this app.
  ///
  /// Ships as `false` so the template runs with the stub paywall and no
  /// store setup. Set to `true` only after replacing the placeholder
  /// API keys below.
  static const bool enabled = false;

  /// Public Apple SDK key from the RevenueCat dashboard (starts with
  /// `appl_`). Used on iOS and macOS.
  static const String appleApiKey = 'PASTE_REVENUECAT_APPLE_API_KEY';

  /// Public Google SDK key from the RevenueCat dashboard (starts with
  /// `goog_`). Used on Android.
  static const String googleApiKey = 'PASTE_REVENUECAT_GOOGLE_API_KEY';

  /// The entitlement identifier that gates premium content, as
  /// configured in the RevenueCat dashboard.
  static const String premiumEntitlementId = 'premium';

  /// Whether the current platform has a RevenueCat store integration in
  /// this template (iOS, macOS, Android).
  ///
  /// `main.dart` only applies the RevenueCat provider overrides when
  /// this is `true`, so desktop/web debug runs keep the stub paywall
  /// even with [enabled] on.
  static bool get isPlatformSupported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS ||
          defaultTargetPlatform == TargetPlatform.android);

  /// Configures the `Purchases` SDK for the current platform.
  ///
  /// No-op when [enabled] is `false` or the platform is unsupported.
  /// Must be called after `WidgetsFlutterBinding.ensureInitialized()`
  /// and before any RevenueCat-backed repository is used. Debug log
  /// level is enabled outside production to aid sandbox testing.
  static Future<void> initialize() async {
    if (!enabled || !isPlatformSupported) return;
    await Purchases.setLogLevel(
      AppFlavor.instance.env == AppEnv.production
          ? LogLevel.info
          : LogLevel.debug,
    );
    final String apiKey = defaultTargetPlatform == TargetPlatform.android
        ? googleApiKey
        : appleApiKey;
    await Purchases.configure(PurchasesConfiguration(apiKey));
  }
}
