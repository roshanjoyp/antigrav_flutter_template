import 'package:craft_flutter_template/core/constants/app_colors.dart';
import 'package:craft_flutter_template/core/widgets/app_icon_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget child) {
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: Center(child: child)),
      ),
    );
  }

  group('AppIconBadge', () {
    testWidgets('renders the icon in the given color', (
      WidgetTester tester,
    ) async {
      await pump(
        tester,
        const AppIconBadge(
          icon: Icons.check_rounded,
          color: AppColors.success,
          background: AppColors.successLight,
        ),
      );
      final Icon icon = tester.widget(find.byIcon(Icons.check_rounded));
      expect(icon.color, AppColors.success);
    });

    testWidgets('renders a custom child instead of the icon', (
      WidgetTester tester,
    ) async {
      await pump(
        tester,
        const AppIconBadge(
          icon: Icons.sync,
          color: AppColors.info,
          background: AppColors.infoLight,
          child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byIcon(Icons.sync), findsNothing);
    });
  });
}
