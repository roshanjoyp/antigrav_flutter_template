import 'package:antigrav_flutter_template/core/widgets/app_error.dart';
import 'package:antigrav_flutter_template/core/widgets/app_button.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('AppError', () {
    testWidgets('shows the message without a retry button by default', (
      tester,
    ) async {
      await tester.pumpApp(const AppError(message: 'It broke.'));

      expect(find.text('It broke.'), findsOneWidget);
      expect(find.byType(AppButton), findsNothing);
    });

    testWidgets('shows a retry button that invokes onRetry', (tester) async {
      int retries = 0;
      await tester.pumpApp(
        AppError(message: 'It broke.', onRetry: () => retries++),
      );

      expect(find.text('Retry'), findsOneWidget);
      await tester.tap(find.text('Retry'));
      expect(retries, 1);
    });
  });
}
