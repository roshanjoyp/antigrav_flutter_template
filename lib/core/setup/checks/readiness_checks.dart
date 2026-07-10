/// Auto-check implementations for production-readiness items, keyed by
/// [ReadinessItem.id].
///
/// Same contract as the setup static checks: CLI-only (`dart:io`), run
/// by `dart run tool/doctor.dart`. Items with an implementation here are
/// verifiable-first — the check result wins over whatever status
/// `checklist.yaml` records.
library;

import 'dart:io';

import 'package:craft_flutter_template/core/setup/checks/project_inspector.dart';
import 'package:craft_flutter_template/core/setup/checks/static_setup_checks.dart';
import 'package:craft_flutter_template/core/setup/setup_manifest.dart';

/// Byte sizes of the stock Flutter launcher icon per Android density.
///
/// A hash would need a crypto dependency; byte size is enough to tell
/// "still the default icon" from "replaced" — a real icon matching the
/// default's exact byte count per density is vanishingly unlikely.
const Map<String, int> _defaultIconSizes = <String, int>{
  'mipmap-mdpi': 442,
  'mipmap-hdpi': 544,
  'mipmap-xhdpi': 721,
  'mipmap-xxhdpi': 1031,
  'mipmap-xxxhdpi': 1443,
};

CheckResult _iconReplacedCheck(Directory root) {
  bool anyFound = false;
  for (final MapEntry<String, int> entry in _defaultIconSizes.entries) {
    final File icon = File(
      '${root.path}/android/app/src/main/res/${entry.key}/ic_launcher.png',
    );
    if (!icon.existsSync()) continue;
    anyFound = true;
    if (icon.lengthSync() != entry.value) return CheckResult.ok;
  }
  return anyFound
      ? const CheckResult(false, 'Launcher icons are the Flutter defaults.')
      : const CheckResult(false, 'No Android launcher icons found.');
}

CheckResult _pubspecDescriptionCheck(Directory root) {
  final String? pubspec = readProjectFile(root, 'pubspec.yaml');
  if (pubspec == null) return const CheckResult(false, 'No pubspec.yaml.');
  // Both the Flutter default and the template's own shipped description
  // count as "not yours yet" — setup/setup.dart prompts for a real one.
  // Whitespace is collapsed first: the folded (`>-`) description wraps
  // marker phrases across lines.
  final String flattened = pubspec.replaceAll(RegExp(r'\s+'), ' ');
  if (flattened.contains('A new Flutter project.') ||
      flattened.contains('replace this description with your app')) {
    return const CheckResult(
      false,
      'pubspec description is still the template\'s, not your app\'s.',
    );
  }
  return !pubspec.contains(RegExp(r'^description:', multiLine: true))
      ? const CheckResult(false, 'pubspec.yaml has no description field.')
      : CheckResult.ok;
}

CheckResult _releaseSigningCheck(Directory root) {
  final String? gradle =
      readProjectFile(root, 'android/app/build.gradle.kts') ??
      readProjectFile(root, 'android/app/build.gradle');
  if (gradle == null) {
    return const CheckResult(false, 'No android/app/build.gradle(.kts).');
  }
  return gradle.contains('signingConfigs.getByName("debug")')
      ? const CheckResult(
          false,
          'Release build type is still signed with the debug keystore.',
        )
      : CheckResult.ok;
}

/// Auto-check implementations bound to readiness item ids.
///
/// Every [ReadinessItem] with `hasAutoCheck: true` must have an entry
/// here — a drift-guard unit test enforces it.
final Map<String, DoctorCheck> readinessAutoChecks = <String, DoctorCheck>{
  'core.icon_replaced': _iconReplacedCheck,
  'core.pubspec_description': _pubspecDescriptionCheck,
  'core.release_signing': _releaseSigningCheck,
};
