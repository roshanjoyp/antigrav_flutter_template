import 'package:craft_flutter_template/core/setup/setup_manifest.dart';
import 'package:craft_flutter_template/features/setup_status/presentation/setup_status_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpScreen(WidgetTester tester) {
    // Tall viewport so the lazy ListView materializes every tile.
    tester.view.physicalSize = const Size(800, 3000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    return tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: SetupStatusScreen())),
    );
  }

  group('SetupStatusScreen', () {
    testWidgets('shows a section per module with in-app steps', (
      WidgetTester tester,
    ) async {
      await pumpScreen(tester);
      // core has only static steps, so it must not render a section.
      expect(find.text('core'), findsNothing);
      expect(find.text('firebase'), findsOneWidget);
      expect(find.text('revenuecat'), findsOneWidget);
      expect(find.text('push'), findsOneWidget);
    });

    testWidgets('renders every runtime and manual step title', (
      WidgetTester tester,
    ) async {
      await pumpScreen(tester);
      final Iterable<SetupStep> steps = SetupManifest.allSteps.where(
        (SetupStep step) => step.kind != SetupCheckKind.staticCheck,
      );
      for (final SetupStep step in steps) {
        expect(find.text(step.title), findsOneWidget);
      }
    });

    testWidgets('points to the doctor CLI for static checks', (
      WidgetTester tester,
    ) async {
      await pumpScreen(tester);
      expect(find.textContaining('dart run tool/doctor.dart'), findsOneWidget);
    });

    testWidgets('has a run-all action', (WidgetTester tester) async {
      await pumpScreen(tester);
      expect(find.byTooltip('Run all checks'), findsOneWidget);
    });
  });
}
