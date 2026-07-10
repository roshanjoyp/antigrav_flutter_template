/// RevenueCat module's static check implementations for the doctor CLI.
///
/// CLI-only tooling code (`dart:io`): never import from app code.
library;

import 'dart:io';

import 'package:craft_flutter_template/core/setup/checks/check_result.dart';
import 'package:craft_flutter_template/core/setup/checks/project_inspector.dart';

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

/// RevenueCat's static check implementations, keyed by manifest step id.
final Map<String, DoctorCheck> revenuecatStaticChecks = <String, DoctorCheck>{
  'revenuecat.keys': _revenuecatKeysCheck,
};
