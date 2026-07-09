import 'package:antigrav_flutter_template/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('AppButton', () {
    testWidgets('renders its label and handles taps', (tester) async {
      int taps = 0;
      await tester.pumpApp(
        AppButton(label: 'Continue', onPressed: () => taps++),
      );

      expect(find.text('Continue'), findsOneWidget);
      await tester.tap(find.byType(AppButton));
      expect(taps, 1);
    });

    testWidgets('is disabled when onPressed is null', (tester) async {
      await tester.pumpApp(const AppButton(label: 'Continue', onPressed: null));

      final FilledButton button = tester.widget<FilledButton>(
        find.byType(FilledButton),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('shows a spinner and blocks taps while loading', (
      tester,
    ) async {
      int taps = 0;
      await tester.pumpApp(
        AppButton(label: 'Continue', onPressed: () => taps++, isLoading: true),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Continue'), findsNothing);
      await tester.tap(find.byType(AppButton), warnIfMissed: false);
      expect(taps, 0);
    });

    testWidgets('stretches to full width when isFullWidth', (tester) async {
      await tester.pumpApp(
        AppButton(label: 'Wide', onPressed: () {}, isFullWidth: true),
      );

      final Size buttonSize = tester.getSize(find.byType(FilledButton));
      final Size bodySize = tester.getSize(find.byType(Scaffold));
      expect(buttonSize.width, bodySize.width);
    });
  });
}
