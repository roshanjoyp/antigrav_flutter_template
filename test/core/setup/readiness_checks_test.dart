import 'dart:io';

import 'package:craft_flutter_template/core/setup/checks/readiness_checks.dart';
import 'package:craft_flutter_template/core/setup/checks/static_setup_checks.dart';
import 'package:craft_flutter_template/core/setup/setup_manifest.dart';
import 'package:flutter_test/flutter_test.dart';

/// Writes [content] to [relativePath] under [root], creating directories.
void _write(Directory root, String relativePath, String content) {
  final File file = File('${root.path}/$relativePath');
  file.parent.createSync(recursive: true);
  file.writeAsStringSync(content);
}

void main() {
  late Directory root;

  setUp(() {
    root = Directory.systemTemp.createTempSync('readiness_checks_test');
  });

  tearDown(() {
    root.deleteSync(recursive: true);
  });

  group('manifest ↔ auto-check binding', () {
    test('every hasAutoCheck item has an implementation, and only those', () {
      final Set<String> declared = SetupManifest.allReadinessItems
          .where((ReadinessItem item) => item.hasAutoCheck)
          .map((ReadinessItem item) => item.id)
          .toSet();
      expect(readinessAutoChecks.keys.toSet(), declared);
    });

    test('readiness item ids are unique', () {
      final Set<String> seen = <String>{};
      for (final ReadinessItem item in SetupManifest.allReadinessItems) {
        expect(seen.add(item.id), isTrue, reason: 'duplicate id ${item.id}');
      }
    });
  });

  group('core.icon_replaced', () {
    const String iconPath =
        'android/app/src/main/res/mipmap-mdpi/ic_launcher.png';

    test('fails while the icon is byte-identical to the Flutter default', () {
      // The default mdpi icon is exactly 442 bytes.
      _write(root, iconPath, 'x' * 442);
      expect(readinessAutoChecks['core.icon_replaced']!(root).passed, isFalse);
    });

    test('passes once any density diverges from the default size', () {
      _write(root, iconPath, 'a real replaced icon, different size');
      expect(readinessAutoChecks['core.icon_replaced']!(root).passed, isTrue);
    });

    test('fails with no icons at all', () {
      final CheckResult result = readinessAutoChecks['core.icon_replaced']!(
        root,
      );
      expect(result.passed, isFalse);
      expect(result.detail, contains('No Android launcher icons'));
    });
  });

  group('core.pubspec_description', () {
    test('fails on the default description', () {
      _write(root, 'pubspec.yaml', 'description: "A new Flutter project."\n');
      expect(
        readinessAutoChecks['core.pubspec_description']!(root).passed,
        isFalse,
      );
    });

    test('fails on the template\'s own shipped description', () {
      _write(
        root,
        'pubspec.yaml',
        'description: >-\n'
            '  CRAFT — production-ready Flutter starter. Run setup/setup.dart,\n'
            '  then replace this description with your app\'s.\n',
      );
      expect(
        readinessAutoChecks['core.pubspec_description']!(root).passed,
        isFalse,
      );
    });

    test('passes on a real description', () {
      _write(root, 'pubspec.yaml', 'description: Habit tracker for teams.\n');
      expect(
        readinessAutoChecks['core.pubspec_description']!(root).passed,
        isTrue,
      );
    });
  });

  group('core.release_signing', () {
    test('fails while release is signed with the debug keystore', () {
      _write(
        root,
        'android/app/build.gradle.kts',
        'signingConfig = signingConfigs.getByName("debug")\n',
      );
      expect(
        readinessAutoChecks['core.release_signing']!(root).passed,
        isFalse,
      );
    });

    test('passes with a dedicated release signing config', () {
      _write(
        root,
        'android/app/build.gradle.kts',
        'signingConfig = signingConfigs.getByName("release")\n',
      );
      expect(readinessAutoChecks['core.release_signing']!(root).passed, isTrue);
    });
  });
}
