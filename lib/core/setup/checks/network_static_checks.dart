/// Network layer's static check implementations for the doctor CLI.
///
/// CLI-only tooling code (`dart:io`): never import from app code.
library;

import 'dart:io';

import 'package:craft_flutter_template/core/setup/checks/check_result.dart';
import 'package:craft_flutter_template/core/setup/checks/project_inspector.dart';

CheckResult _networkBaseUrlCheck(Directory root) {
  const String configPath = 'lib/core/config/network/network_config.dart';
  final String? content = readProjectFile(root, configPath);
  if (content == null) return const CheckResult(false, '$configPath missing.');
  if (content.contains('NETWORK_BASE_URL_PLACEHOLDER') ||
      content.contains('.example.com')) {
    return const CheckResult(false, 'Placeholder base URLs still in place.');
  }
  return CheckResult.ok;
}

/// The network layer's static check implementations, keyed by manifest
/// step id.
final Map<String, DoctorCheck> networkStaticChecks = <String, DoctorCheck>{
  'network.base_url': _networkBaseUrlCheck,
};
