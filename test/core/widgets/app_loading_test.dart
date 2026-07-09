import 'package:antigrav_flutter_template/core/widgets/app_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('AppLoading', () {
    testWidgets('shows a spinner without a message by default',
        (tester) async {
      await tester.pumpApp(const AppLoading());
      // One pump frame only — the spinner animates forever, so
      // pumpAndSettle would never return.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(Text), findsNothing);
    });

    testWidgets('shows the message when provided', (tester) async {
      await tester.pumpApp(const AppLoading(message: 'Loading profile...'));
      expect(find.text('Loading profile...'), findsOneWidget);
    });
  });
}
