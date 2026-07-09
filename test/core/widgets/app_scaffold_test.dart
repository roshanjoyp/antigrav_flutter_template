import 'package:antigrav_flutter_template/core/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) =>
      ProviderScope(child: MaterialApp(home: child));

  group('AppScaffold', () {
    testWidgets('renders its body', (tester) async {
      await tester.pumpWidget(
        wrap(const AppScaffold(body: Text('content'))),
      );
      expect(find.text('content'), findsOneWidget);
    });

    testWidgets('renders the app bar when provided', (tester) async {
      await tester.pumpWidget(
        wrap(
          AppScaffold(
            appBar: AppBar(title: const Text('Title')),
            body: const SizedBox(),
          ),
        ),
      );
      expect(find.text('Title'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('wraps the body in a SafeArea by default', (tester) async {
      await tester.pumpWidget(
        wrap(const AppScaffold(body: Text('content'))),
      );
      expect(
        find.ancestor(
          of: find.text('content'),
          matching: find.byType(SafeArea),
        ),
        findsWidgets,
      );
    });

    testWidgets('skips the SafeArea when useSafeArea is false',
        (tester) async {
      await tester.pumpWidget(
        wrap(
          const AppScaffold(useSafeArea: false, body: Text('content')),
        ),
      );
      expect(
        find.ancestor(
          of: find.text('content'),
          matching: find.byType(SafeArea),
        ),
        findsNothing,
      );
    });
  });
}
