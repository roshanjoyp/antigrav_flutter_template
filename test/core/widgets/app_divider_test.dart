import 'package:antigrav_flutter_template/core/constants/app_constants.dart';
import 'package:antigrav_flutter_template/core/widgets/app_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('AppDivider', () {
    testWidgets('renders a Divider', (tester) async {
      await tester.pumpApp(const AppDivider());
      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('applies horizontal padding', (tester) async {
      await tester.pumpApp(
        const AppDivider(horizontalPadding: AppConstants.spaceLg),
      );

      final Padding padding = tester.widget<Padding>(
        find.ancestor(
          of: find.byType(Divider),
          matching: find.byType(Padding),
        ),
      );
      expect(
        padding.padding,
        const EdgeInsets.symmetric(horizontal: AppConstants.spaceLg),
      );
    });
  });
}
