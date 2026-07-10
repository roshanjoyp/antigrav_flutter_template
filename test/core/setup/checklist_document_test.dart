import 'dart:io';

import 'package:craft_flutter_template/core/setup/checklist/checklist_document.dart';
import 'package:craft_flutter_template/core/setup/setup_manifest.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChecklistDocument.parse', () {
    test('reads item statuses, reasons, and owners', () {
      const String source = '''
version: 1
items:
  core.icon_replaced:
    status: done
  core.privacy_policy:
    status: skipped
    reason: internal tool, no data collected
    owner: roshan
''';
      final ChecklistDocument doc = ChecklistDocument.parse(source);
      expect(doc.entryFor('core.icon_replaced').status, ChecklistStatus.done);
      final ChecklistEntry skipped = doc.entryFor('core.privacy_policy');
      expect(skipped.status, ChecklistStatus.skipped);
      expect(skipped.reason, 'internal tool, no data collected');
      expect(skipped.owner, 'roshan');
    });

    test('reads custom tasks with owners', () {
      const String source = '''
custom:
  - title: Rotate staging keys
    status: done
    owner: sam
  - title: Load-test the backend
    status: pending
''';
      final ChecklistDocument doc = ChecklistDocument.parse(source);
      expect(doc.custom, hasLength(2));
      expect(doc.custom.first.title, 'Rotate staging keys');
      expect(doc.custom.first.status, ChecklistStatus.done);
      expect(doc.custom.first.owner, 'sam');
      expect(doc.custom.last.status, ChecklistStatus.pending);
    });

    test('ignores comments and treats unknown statuses as pending', () {
      const String source = '''
# top comment
items:
  core.icon_replaced:
    status: banana # trailing comment
''';
      final ChecklistDocument doc = ChecklistDocument.parse(source);
      expect(
        doc.entryFor('core.icon_replaced').status,
        ChecklistStatus.pending,
      );
    });

    test('defaults to pending for unlisted items and empty input', () {
      final ChecklistDocument doc = ChecklistDocument.parse('');
      expect(doc.entries, isEmpty);
      expect(doc.custom, isEmpty);
      expect(doc.entryFor('anything').status, ChecklistStatus.pending);
    });
  });

  group('shipped checklist.yaml', () {
    test('every key is a declared readiness item, and vice versa', () {
      final ChecklistDocument doc = ChecklistDocument.parse(
        File('checklist.yaml').readAsStringSync(),
      );
      final Set<String> declared = SetupManifest.allReadinessItems
          .map((ReadinessItem item) => item.id)
          .toSet();
      expect(doc.entries.keys.toSet(), declared);
    });
  });
}
