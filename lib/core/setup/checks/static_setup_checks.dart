/// Static check implementations for the doctor CLI, keyed by
/// [SetupStep.id] from the setup manifest.
///
/// Uses `dart:io` to inspect project files, so this is CLI-only tooling
/// code: never import it from app code (it would break web builds and is
/// meaningless inside an installed app).
library;

import 'dart:io';

import 'package:craft_flutter_template/core/setup/checks/project_inspector.dart';
import 'package:craft_flutter_template/core/setup/setup_manifest.dart';

/// Outcome of one static check.
class CheckResult {
  /// Creates a check outcome; [detail] explains a failure.
  const CheckResult(this.passed, [this.detail]);

  /// Convenience passing result.
  static const CheckResult ok = CheckResult(true);

  /// Whether the check passed.
  final bool passed;

  /// Failure explanation appended to the step's remediation, if any.
  final String? detail;
}

/// Signature of a static check: inspects files under [root].
typedef DoctorCheck = CheckResult Function(Directory root);

/// Checks that a firebase_options file has been replaced by
/// `flutterfire configure` (placeholder marker gone).
DoctorCheck _firebaseOptionsCheck(String relativePath) {
  return (Directory root) {
    final bool? hasMarker = fileContainsMarker(
      root,
      relativePath,
      'FIREBASE_OPTIONS_PLACEHOLDER',
    );
    if (hasMarker == null) {
      return CheckResult(false, '$relativePath is missing.');
    }
    return hasMarker
        ? CheckResult(false, '$relativePath is still the placeholder.')
        : CheckResult.ok;
  };
}

CheckResult _renameCheck(Directory root) {
  final String? dartPackage = pubspecName(root);
  final String? androidId = androidApplicationId(root);
  final Set<String> iosIds = iosBundleIds(root);
  if (dartPackage == templateDartPackage ||
      androidId == templateApplicationId) {
    return const CheckResult(false, 'Project still uses the template name.');
  }
  if (androidId == null || iosIds.length != 1 || iosIds.single != androidId) {
    return CheckResult(
      false,
      'Bundle IDs inconsistent: android=$androidId ios=${iosIds.join(", ")}.',
    );
  }
  return CheckResult.ok;
}

CheckResult _pubGetCheck(Directory root) {
  final File packageConfig = File(
    '${root.path}/.dart_tool/package_config.json',
  );
  final File pubspec = File('${root.path}/pubspec.yaml');
  if (!packageConfig.existsSync()) {
    return const CheckResult(false, 'No .dart_tool/package_config.json.');
  }
  if (packageConfig.lastModifiedSync().isBefore(pubspec.lastModifiedSync())) {
    return const CheckResult(
      false,
      'pubspec.yaml changed after the last pub get.',
    );
  }
  return CheckResult.ok;
}

CheckResult _buildRunnerFreshCheck(Directory root) {
  final List<String> stale = <String>[];
  generatedPartDeclarations(root).forEach((File source, List<String> parts) {
    for (final String part in parts) {
      final File generated = File('${source.parent.path}/$part');
      if (!generated.existsSync() ||
          generated.lastModifiedSync().isBefore(source.lastModifiedSync())) {
        stale.add(part);
      }
    }
  });
  return stale.isEmpty
      ? CheckResult.ok
      : CheckResult(false, 'Missing or stale: ${stale.join(", ")}.');
}

CheckResult _firebaseEnabledCheck(Directory root) {
  const List<String> optionsFiles = <String>[
    'lib/core/config/firebase/firebase_options_dev.dart',
    'lib/core/config/firebase/firebase_options_staging.dart',
    'lib/core/config/firebase/firebase_options_prod.dart',
  ];
  final List<String> placeholders = optionsFiles
      .where(
        (String path) =>
            fileContainsMarker(root, path, 'FIREBASE_OPTIONS_PLACEHOLDER') !=
            false,
      )
      .toList();
  return placeholders.isEmpty
      ? CheckResult.ok
      : CheckResult(
          false,
          'Enabled with placeholder options: ${placeholders.join(", ")}.',
        );
}

CheckResult _revenuecatKeysCheck(Directory root) {
  const String configPath = 'lib/core/config/revenuecat/revenuecat_config.dart';
  final String? content = readProjectFile(root, configPath);
  if (content == null) return const CheckResult(false, '$configPath missing.');
  if (content.contains('REVENUECAT_KEYS_PLACEHOLDER') ||
      content.contains('PASTE_REVENUECAT')) {
    return const CheckResult(false, 'Placeholder keys still in place.');
  }
  return CheckResult.ok;
}

/// Static check implementations bound to manifest step ids.
///
/// Every [SetupStep] with [SetupCheckKind.staticCheck] must have an entry
/// here; the doctor fails loudly on an unbound id so the manifest and the
/// implementations can't drift apart silently.
final Map<String, DoctorCheck> staticChecks = <String, DoctorCheck>{
  'core.rename': _renameCheck,
  'core.pub_get': _pubGetCheck,
  'core.build_runner_fresh': _buildRunnerFreshCheck,
  'firebase.options_dev': _firebaseOptionsCheck(
    'lib/core/config/firebase/firebase_options_dev.dart',
  ),
  'firebase.options_staging': _firebaseOptionsCheck(
    'lib/core/config/firebase/firebase_options_staging.dart',
  ),
  'firebase.options_prod': _firebaseOptionsCheck(
    'lib/core/config/firebase/firebase_options_prod.dart',
  ),
  'firebase.enabled': _firebaseEnabledCheck,
  'revenuecat.keys': _revenuecatKeysCheck,
};
