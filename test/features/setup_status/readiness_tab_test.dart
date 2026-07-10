import 'package:craft_flutter_template/core/setup/checklist/checklist_document.dart';
import 'package:craft_flutter_template/features/setup_status/presentation/readiness_controller.dart';
import 'package:craft_flutter_template/features/setup_status/presentation/widgets/readiness_tab_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpTab(WidgetTester tester, ChecklistDocument doc) async {
    tester.view.physicalSize = const Size(800, 3000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          readinessChecklistProvider.overrideWith((Ref ref) async => doc),
        ],
        child: const MaterialApp(home: Scaffold(body: ReadinessTabWidget())),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('ReadinessTabWidget', () {
    testWidgets('shows core items with recorded statuses', (
      WidgetTester tester,
    ) async {
      await pumpTab(tester, ChecklistDocument.empty);
      // Core module is always enabled; its items must render.
      expect(find.text('Launcher icon replaced'), findsOneWidget);
      expect(find.text('Privacy policy published and linked'), findsOneWidget);
      // Firebase/RevenueCat are disabled in the stub template: their
      // module-conditional items must not render.
      expect(find.text('APNs auth key uploaded to Firebase'), findsNothing);
    });

    testWidgets('hides skipped items until the toggle is flipped', (
      WidgetTester tester,
    ) async {
      const ChecklistDocument doc = ChecklistDocument(
        entries: <String, ChecklistEntry>{
          'core.privacy_policy': ChecklistEntry(
            status: ChecklistStatus.skipped,
            reason: 'no data collected',
          ),
        },
        custom: <CustomChecklistTask>[],
      );
      await pumpTab(tester, doc);
      expect(find.text('Privacy policy published and linked'), findsNothing);
      await tester.tap(find.text('Show skipped items'));
      await tester.pumpAndSettle();
      expect(find.text('Privacy policy published and linked'), findsOneWidget);
      expect(find.textContaining('no data collected'), findsOneWidget);
    });

    testWidgets('renders custom tasks with owners', (
      WidgetTester tester,
    ) async {
      const ChecklistDocument doc = ChecklistDocument(
        entries: <String, ChecklistEntry>{},
        custom: <CustomChecklistTask>[
          CustomChecklistTask(
            title: 'Rotate staging keys',
            status: ChecklistStatus.pending,
            owner: 'sam',
          ),
        ],
      );
      await pumpTab(tester, doc);
      expect(find.text('Custom tasks'), findsOneWidget);
      expect(find.text('Rotate staging keys'), findsOneWidget);
      expect(find.text('Owner: sam'), findsOneWidget);
    });
  });
}
