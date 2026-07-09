import 'package:antigrav_flutter_template/core/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('AppText', () {
    testWidgets('every variant renders its text', (tester) async {
      await tester.pumpApp(
        Column(
          children: [
            AppText.headingLarge('heading large'),
            AppText.headingMedium('heading medium'),
            AppText.headingSmall('heading small'),
            AppText.bodyLarge('body large'),
            AppText.bodyMedium('body medium'),
            AppText.bodySmall('body small'),
            AppText.caption('caption'),
            AppText.label('label'),
          ],
        ),
      );

      for (final String text in <String>[
        'heading large',
        'heading medium',
        'heading small',
        'body large',
        'body medium',
        'body small',
        'caption',
        'label',
      ]) {
        expect(find.text(text), findsOneWidget);
      }
    });

    testWidgets('headings are larger than captions', (tester) async {
      await tester.pumpApp(
        Column(
          children: [AppText.headingLarge('big'), AppText.caption('small')],
        ),
      );

      final Text big = tester.widget<Text>(find.text('big'));
      final Text small = tester.widget<Text>(find.text('small'));
      expect(big.style!.fontSize!, greaterThan(small.style!.fontSize!));
    });
  });
}
