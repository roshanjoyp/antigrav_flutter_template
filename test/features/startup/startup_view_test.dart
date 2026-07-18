import 'package:craft_flutter_template/core/config/app_env.dart';
import 'package:craft_flutter_template/core/config/app_flavor.dart';
import 'package:craft_flutter_template/core/constants/app_constants.dart';
import 'package:craft_flutter_template/features/startup/presentation/startup_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StartupView', () {
    // Startup logs via LogService, whose logger is configured from
    // AppFlavor — initialize it like main.dart does.
    setUp(() => AppFlavor.initialize(AppEnv.development));
    tearDown(AppFlavor.reset);

    testWidgets('renders identity, status line, and navigation tiles', (
      tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: StartupView())),
      );
      // Let the post-frame startup logic begin — the status line spins
      // while the splash delay runs.
      await tester.pump();
      expect(find.text(AppConstants.appName), findsOneWidget);
      expect(find.text('Starting services…'), findsOneWidget);

      // Advance past the splash delay; startup resolves to home (no
      // first-run redirect in the default test scope) and the hub is up.
      await tester.pump(AppConstants.durationSplash);
      await tester.pump();
      expect(find.text('Services ready'), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Paywall'), findsOneWidget);
      expect(find.text('Onboarding'), findsOneWidget);
      // Dev-only section — tests always run in debug mode.
      expect(find.text('Test services'), findsOneWidget);
      expect(find.text('Setup status'), findsOneWidget);
    });
  });
}
