import 'package:craft_flutter_template/core/widgets/app_info_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppInfoBanner', () {
    testWidgets('shows the message and default info icon', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppInfoBanner(message: 'A helpful hint.')),
        ),
      );
      expect(find.text('A helpful hint.'), findsOneWidget);
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
    });

    testWidgets('uses a custom icon when provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppInfoBanner(message: 'CLI hint.', icon: Icons.terminal),
          ),
        ),
      );
      expect(find.byIcon(Icons.terminal), findsOneWidget);
      expect(find.byIcon(Icons.info_outline), findsNothing);
    });
  });
}
