import 'dart:async';

import 'package:craft_flutter_template/app/app.dart';
import 'package:craft_flutter_template/app/config/firebase_overrides.dart'; // MODULE(firebase)
import 'package:craft_flutter_template/app/config/onboarding_overrides.dart'; // MODULE(onboarding)
import 'package:craft_flutter_template/app/config/revenuecat_overrides.dart'; // MODULE(revenuecat)
import 'package:craft_flutter_template/core/core.dart';
import 'package:craft_flutter_template/core/services/crash_service/crash_service_impl.dart';
import 'package:craft_flutter_template/core/services/push_service/firebase_push_service_impl.dart'; // MODULE(push)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Application entry point.
///
/// Initialises [AppFlavor], sets up global error handlers, and launches
/// the app inside a [ProviderScope] via [UncontrolledProviderScope].
void main() async {
  // ---------------------------------------------------------------------------
  // Flavor initialization — must happen before everything else.
  //
  // To target a different environment per build, change the AppEnv passed here.
  // In CI/CD, the recommended approach is to have separate entry points per
  // flavor (e.g. main_dev.dart, main_staging.dart, main_prod.dart) that each
  // call AppFlavor.initialize with the appropriate AppEnv, then pass them via
  // --target on the flutter build / flutter run command:
  //
  //   flutter run --target lib/main_dev.dart
  //   flutter build apk --target lib/main_prod.dart
  //
  // Those entry-point files do not exist yet — this single main.dart defaults
  // to AppEnv.development until flavor-specific entry points are introduced.
  // ---------------------------------------------------------------------------
  AppFlavor.initialize(AppEnv.development);

  // Create a container to read providers before the app starts
  // and to use it for error reporting in the zone.
  //
  // When a backend module is enabled, its stub services/repositories are
  // swapped for real implementations here — this is the single switch
  // point per module (see lib/app/config/firebase_overrides.dart and
  // lib/app/config/revenuecat_overrides.dart).
  final container = ProviderContainer(
    overrides: [
      // MODULE(firebase): begin
      if (FirebaseConfig.enabled) ...firebaseServiceOverrides(),
      // MODULE(firebase): end
      // MODULE(revenuecat): begin
      if (RevenueCatConfig.enabled && RevenueCatConfig.isPlatformSupported)
        ...revenueCatServiceOverrides(),
      // MODULE(revenuecat): end
      ...onboardingOverrides(), // MODULE(onboarding)
    ],
  );

  runZonedGuarded(
    () async {
      // Ensure Flutter binding is initialized inside the guarded zone so that
      // runApp() and ensureInitialized() share the same zone, avoiding the
      // "Zone mismatch" warning Flutter emits when they are in different zones.
      WidgetsFlutterBinding.ensureInitialized();

      // Initialize DotEnv if needed
      // await dotenv.load(fileName: ".env");

      // MODULE(firebase): begin
      // Initializes Firebase for the active flavor. No-op while
      // FirebaseConfig.enabled is false (the template's stub-only default);
      // see docs/setup/FIREBASE_SETUP.md to enable it.
      await FirebaseConfig.initialize();
      // MODULE(firebase): end

      // MODULE(push): begin
      // Background/terminated-state push messages need their handler
      // registered before any message can arrive.
      if (FirebaseConfig.enabled) {
        FirebasePushServiceImpl.registerBackgroundHandler();
      }
      // MODULE(push): end

      // MODULE(revenuecat): begin
      // Configures the RevenueCat SDK. No-op while RevenueCatConfig.enabled
      // is false or the platform has no store; see
      // docs/setup/REVENUECAT_SETUP.md to enable it.
      await RevenueCatConfig.initialize();
      // MODULE(revenuecat): end

      // Flutter Error Handling
      FlutterError.onError = (details) {
        FlutterError.presentError(details);
        container
            .read(crashServiceProvider)
            .recordError(
              details.exception,
              details.stack,
              reason: 'Flutter Error',
              fatal: true,
            );
      };

      runApp(
        UncontrolledProviderScope(container: container, child: const App()),
      );
    },
    (error, stack) {
      // Async/Zone Error Handling
      container
          .read(crashServiceProvider)
          .recordError(error, stack, reason: 'Zoned Error', fatal: true);
    },
  );
}
