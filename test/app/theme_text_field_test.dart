import 'package:craft_flutter_template/app/theme/app_theme.dart';
import 'package:craft_flutter_template/features/profile/presentation/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Regression tests for text fields under the real app themes.
///
/// The profile screen once crashed with "Unexpected null value" in
/// [InputDecorator] because the dark input decoration theme used
/// `TextStyle(inherit: false)` with incomplete styles. Plain widget
/// tests missed it — they pumped screens without [AppTheme], so these
/// tests always pump the real themes.
void main() {
  group('TextField under app themes', () {
    testWidgets('profile screen renders its form under the dark theme', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.darkTheme,
            home: const ProfileScreen(),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(TextField), findsNWidgets(2));
      expect(tester.takeException(), isNull);
    });

    testWidgets('profile screen renders its form under the light theme', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const ProfileScreen(),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(TextField), findsNWidgets(2));
      expect(tester.takeException(), isNull);
    });

    testWidgets('toggling between themes keeps text fields alive', (
      WidgetTester tester,
    ) async {
      // Guards the original theme-toggle crash (TextStyle.lerp between
      // asymmetric styles) alongside the noAnimation bypass in app.dart.
      Future<void> pumpWithMode(ThemeMode mode) {
        return tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: mode,
            home: const Scaffold(
              body: TextField(decoration: InputDecoration(labelText: 'Label')),
            ),
          ),
        );
      }

      await pumpWithMode(ThemeMode.dark);
      await pumpWithMode(ThemeMode.light);
      await tester.pumpAndSettle();
      await pumpWithMode(ThemeMode.dark);
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
