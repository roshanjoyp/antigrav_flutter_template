import 'dart:io';

import 'package:craft_flutter_template/core/setup/checks/project_inspector.dart';
import 'package:craft_flutter_template/core/setup/checks/static_setup_checks.dart';
import 'package:craft_flutter_template/core/setup/setup_manifest.dart';
import 'package:flutter_test/flutter_test.dart';

/// Writes [content] to [relativePath] under [root], creating directories.
File _write(Directory root, String relativePath, String content) {
  final File file = File('${root.path}/$relativePath');
  file.parent.createSync(recursive: true);
  file.writeAsStringSync(content);
  return file;
}

/// Scaffolds the minimal renamed-project layout the rename check reads.
void _scaffoldRenamed(
  Directory root, {
  String dartPackage = 'my_app',
  String androidId = 'com.example.my_app',
  String iosId = 'com.example.my_app',
}) {
  _write(root, 'pubspec.yaml', 'name: $dartPackage\n');
  _write(
    root,
    'android/app/build.gradle.kts',
    'applicationId = "$androidId"\n',
  );
  _write(
    root,
    'ios/Runner.xcodeproj/project.pbxproj',
    'PRODUCT_BUNDLE_IDENTIFIER = $iosId;\n'
        'PRODUCT_BUNDLE_IDENTIFIER = $iosId.RunnerTests;\n',
  );
}

void main() {
  late Directory root;

  setUp(() {
    root = Directory.systemTemp.createTempSync('doctor_checks_test');
  });

  tearDown(() {
    root.deleteSync(recursive: true);
  });

  group('manifest ↔ implementation binding', () {
    test('every staticCheck step has an implementation', () {
      for (final SetupStep step in SetupManifest.stepsOfKind(
        SetupCheckKind.staticCheck,
      )) {
        expect(
          staticChecks,
          contains(step.id),
          reason: '${step.id} declared in the manifest but not implemented',
        );
      }
    });

    test('every implementation is declared in the manifest as static', () {
      for (final String id in staticChecks.keys) {
        final SetupStep? step = SetupManifest.byId(id);
        expect(step, isNotNull, reason: '$id implemented but not declared');
        expect(step!.kind, SetupCheckKind.staticCheck);
      }
    });

    test('step ids are unique across all module manifests', () {
      final Set<String> seen = <String>{};
      for (final SetupStep step in SetupManifest.allSteps) {
        expect(seen.add(step.id), isTrue, reason: 'duplicate id ${step.id}');
      }
    });
  });

  group('core.rename', () {
    test('passes for a consistently renamed project', () {
      _scaffoldRenamed(root);
      expect(staticChecks['core.rename']!(root).passed, isTrue);
    });

    test('fails while the template name is still in place', () {
      _scaffoldRenamed(
        root,
        dartPackage: templateDartPackage,
        androidId: templateApplicationId,
        iosId: templateApplicationId,
      );
      expect(staticChecks['core.rename']!(root).passed, isFalse);
    });

    test('fails when android and iOS bundle ids diverge', () {
      _scaffoldRenamed(root, iosId: 'com.other.my_app');
      final CheckResult result = staticChecks['core.rename']!(root);
      expect(result.passed, isFalse);
      expect(result.detail, contains('inconsistent'));
    });
  });

  // MODULE(firebase): begin
  group('firebase options placeholders', () {
    const String path = 'lib/core/config/firebase/firebase_options_dev.dart';

    test('fails on the placeholder marker', () {
      _write(root, path, '// FIREBASE_OPTIONS_PLACEHOLDER\n');
      expect(staticChecks['firebase.options_dev']!(root).passed, isFalse);
    });

    test('passes once flutterfire configure replaced the file', () {
      _write(root, path, 'class DefaultFirebaseOptions {}\n');
      expect(staticChecks['firebase.options_dev']!(root).passed, isTrue);
    });

    test('fails when the file is missing entirely', () {
      final CheckResult result = staticChecks['firebase.options_dev']!(root);
      expect(result.passed, isFalse);
      expect(result.detail, contains('missing'));
    });
  });
  // MODULE(firebase): end

  // MODULE(revenuecat): begin
  group('revenuecat.keys', () {
    const String path = 'lib/core/config/revenuecat/revenuecat_config.dart';

    test('fails while placeholder keys are in place', () {
      _write(root, path, "const k = 'PASTE_REVENUECAT_APPLE_API_KEY';\n");
      expect(staticChecks['revenuecat.keys']!(root).passed, isFalse);
    });

    test('passes with real keys and no marker', () {
      _write(root, path, "const k = 'appl_abc123';\n");
      expect(staticChecks['revenuecat.keys']!(root).passed, isTrue);
    });
  });
  // MODULE(revenuecat): end

  group('core.build_runner_fresh', () {
    test('fails when a declared part file is missing', () {
      _write(root, 'lib/a_controller.dart', "part 'a_controller.g.dart';\n");
      final CheckResult result = staticChecks['core.build_runner_fresh']!(root);
      expect(result.passed, isFalse);
      expect(result.detail, contains('a_controller.g.dart'));
    });

    test('passes when generated output is present and current', () {
      _write(root, 'lib/a_controller.dart', "part 'a_controller.g.dart';\n");
      _write(root, 'lib/a_controller.g.dart', '// generated\n');
      expect(staticChecks['core.build_runner_fresh']!(root).passed, isTrue);
    });
  });

  group('module enablement parsing', () {
    test('reads the enabled flag from a config file', () {
      _write(
        root,
        'lib/x.dart',
        'class C { static const bool enabled = true; }\n',
      );
      expect(configEnabledFlag(root, 'lib/x.dart'), isTrue);
    });

    test('returns null for a missing file', () {
      expect(configEnabledFlag(root, 'lib/x.dart'), isNull);
    });
  });
}
