import 'package:craft_flutter_template/core/constants/app_constants.dart';
import 'package:craft_flutter_template/features/startup/presentation/startup_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StartupView', () {
    testWidgets('renders title, loader, and navigation actions', (
      tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: StartupView())),
      );
      // Let the post-frame startup logic begin, then advance past the
      // splash delay. Discrete pumps — the spinner never settles.
      await tester.pump();
      await tester.pump(AppConstants.durationSplash);

      expect(find.text('Craft Template'), findsOneWidget);
      expect(find.text('Starting up...'), findsOneWidget);
      expect(find.text('Go to Home'), findsOneWidget);
      expect(find.text('Test Services'), findsOneWidget);
      expect(find.text('Profile Example'), findsOneWidget);
    });
  });
}
