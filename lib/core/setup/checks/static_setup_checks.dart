/// Static check implementations for the doctor CLI, keyed by
/// [SetupStep.id] from the setup manifest.
///
/// Core checks live here; each optional module contributes its own map
/// (`firebase_static_checks.dart`, `revenuecat_static_checks.dart`)
/// spread into [staticChecks] below.
///
/// Uses `dart:io` to inspect project files, so this is CLI-only tooling
/// code: never import it from app code (it would break web builds and is
/// meaningless inside an installed app).
library;

import 'dart:io';

import 'package:craft_flutter_template/core/setup/checks/check_result.dart';
import 'package:craft_flutter_template/core/setup/checks/firebase_static_checks.dart'; // MODULE(firebase)
import 'package:craft_flutter_template/core/setup/checks/project_inspector.dart';
import 'package:craft_flutter_template/core/setup/checks/revenuecat_static_checks.dart'; // MODULE(revenuecat)
import 'package:craft_flutter_template/core/setup/setup_manifest.dart';

export 'package:craft_flutter_template/core/setup/checks/check_result.dart';

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

/// Static check implementations bound to manifest step ids.
///
/// Every [SetupStep] with [SetupCheckKind.staticCheck] must have an entry
/// here; the doctor fails loudly on an unbound id so the manifest and the
/// implementations can't drift apart silently.
final Map<String, DoctorCheck> staticChecks = <String, DoctorCheck>{
  'core.rename': _renameCheck,
  'core.pub_get': _pubGetCheck,
  'core.build_runner_fresh': _buildRunnerFreshCheck,
  ...firebaseStaticChecks, // MODULE(firebase)
  ...revenuecatStaticChecks, // MODULE(revenuecat)
};
