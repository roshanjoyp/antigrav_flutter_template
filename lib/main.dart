import 'dart:async';

import 'package:antigrav_flutter_template/app/app.dart';
import 'package:antigrav_flutter_template/core/config/app_env.dart';
import 'package:antigrav_flutter_template/core/config/app_flavor.dart';
import 'package:antigrav_flutter_template/core/services/crash_service/crash_service_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  // Ensure Flutter binding is initialized first — some initialization paths
  // (e.g. platform channels, plugin setup) require the binding to be ready
  // before any other startup code runs.
  WidgetsFlutterBinding.ensureInitialized();

  AppFlavor.initialize(AppEnv.development);

  // Create a container to read providers before the app starts
  // and to use it for error reporting in the zone.
  final container = ProviderContainer();

  runZonedGuarded(
    () async {

      // Initialize DotEnv if needed
      // await dotenv.load(fileName: ".env");

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
