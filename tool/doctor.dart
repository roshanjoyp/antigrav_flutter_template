/// craft_flutter_template setup doctor
///
/// Verifies post-download setup by running every static check declared
/// in the setup manifest (lib/core/setup/) and reporting
/// `✓ x/y steps complete` with exact next-step instructions per failure.
///
/// Usage (from the project root):
///   dart run tool/doctor.dart
///
/// Runtime checks (Firebase init, auth ping, FCM token) can't run here —
/// launch a debug build and open the Setup Status screen for those.
/// Manual console/dashboard steps are listed with links.
library;

// ignore_for_file: avoid_print

import 'dart:io';

import 'package:craft_flutter_template/core/setup/checks/project_inspector.dart';
import 'package:craft_flutter_template/core/setup/checks/static_setup_checks.dart';
import 'package:craft_flutter_template/core/setup/setup_manifest.dart';

/// Detects which optional modules are enabled, keyed by module.
///
/// Push rides on the Firebase flag. `core` is always enabled. A missing
/// or unparsable flag counts as enabled so its checks run (and fail
/// loudly) instead of being skipped silently.
Map<SetupModule, bool> _detectEnabledModules(Directory root) {
  final bool firebase =
      configEnabledFlag(
        root,
        'lib/core/config/firebase/firebase_config.dart',
      ) ??
      true;
  final bool revenuecat =
      configEnabledFlag(
        root,
        'lib/core/config/revenuecat/revenuecat_config.dart',
      ) ??
      true;
  return <SetupModule, bool>{
    SetupModule.core: true,
    SetupModule.firebase: firebase,
    SetupModule.push: firebase,
    SetupModule.revenuecat: revenuecat,
  };
}

/// Prints one step's outcome line and, on failure, its remediation.
void _report(SetupStep step, CheckResult result) {
  print('  ${result.passed ? '✓' : '✗'} ${step.title}');
  if (result.passed) return;
  if (result.detail != null) print('      ${result.detail}');
  print('      → ${step.remediation}');
  if (step.docPath != null) print('      → See ${step.docPath}');
}

void main() {
  final Directory root = Directory.current;
  if (!File('${root.path}/pubspec.yaml').existsSync()) {
    stderr.writeln('✗ Run from the project root (pubspec.yaml not found).');
    exitCode = 2;
    return;
  }

  final Map<SetupModule, bool> enabled = _detectEnabledModules(root);
  int passed = 0;
  int total = 0;

  for (final SetupModule module in SetupModule.values) {
    final List<SetupStep> steps = SetupManifest.stepsForModule(module);
    if (steps.isEmpty) continue;
    print('\n${module.name}:');
    if (!enabled[module]!) {
      print('  - module disabled — ${steps.length} steps skipped');
      continue;
    }
    for (final SetupStep step in steps) {
      switch (step.kind) {
        case SetupCheckKind.staticCheck:
          final DoctorCheck? check = staticChecks[step.id];
          if (check == null) {
            throw StateError('No static check bound for ${step.id}');
          }
          final CheckResult result = check(root);
          total += 1;
          if (result.passed) passed += 1;
          _report(step, result);
        case SetupCheckKind.runtimeCheck:
          print('  ~ ${step.title} — verify in-app (Setup Status screen)');
        case SetupCheckKind.manual:
          print('  ! ${step.title} — manual step');
          print('      → ${step.remediation}');
          if (step.link != null) print('      → ${step.link}');
      }
    }
  }

  print(
    '\n${passed == total ? '✓' : '✗'} $passed/$total static checks '
    'complete.',
  );
  print('  ~ runtime checks: run a debug build → Setup Status screen.');
  print('  ! manual steps: confirm the items marked above yourself.');
  if (passed != total) exitCode = 1;
}
