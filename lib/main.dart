import 'dart:async';

import 'package:antigrav_flutter_template/app/app.dart';
import 'package:antigrav_flutter_template/core/services/crash_service/crash_service_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  // Create a container to read providers before the app starts
  // and to use it for error reporting in the zone.
  final container = ProviderContainer();

  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

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
