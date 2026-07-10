/// Firebase module's static check implementations for the doctor CLI.
///
/// CLI-only tooling code (`dart:io`): never import from app code.
library;

import 'dart:io';

import 'package:craft_flutter_template/core/setup/checks/check_result.dart';
import 'package:craft_flutter_template/core/setup/checks/project_inspector.dart';

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

/// Firebase's static check implementations, keyed by manifest step id.
final Map<String, DoctorCheck> firebaseStaticChecks = <String, DoctorCheck>{
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
};
