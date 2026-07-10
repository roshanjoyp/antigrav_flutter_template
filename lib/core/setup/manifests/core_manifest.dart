import 'package:craft_flutter_template/core/setup/setup_step.dart';

/// Setup steps for the always-on core module.
///
/// These apply to every generated/downloaded project regardless of which
/// optional modules are included.
const List<SetupStep> coreSetupSteps = [
  SetupStep(
    id: 'core.rename',
    module: SetupModule.core,
    kind: SetupCheckKind.staticCheck,
    title: 'Project renamed (app name + package/bundle IDs consistent)',
    remediation: 'Run: dart setup/setup.dart',
    docPath: 'README.md',
  ),
  SetupStep(
    id: 'core.pub_get',
    module: SetupModule.core,
    kind: SetupCheckKind.staticCheck,
    title: 'Dependencies resolved (pub get up to date)',
    remediation: 'Run: flutter pub get',
  ),
  SetupStep(
    id: 'core.build_runner_fresh',
    module: SetupModule.core,
    kind: SetupCheckKind.staticCheck,
    title: 'Generated files fresh (build_runner output matches sources)',
    remediation:
        'Run: dart run build_runner build --delete-conflicting-outputs',
    docPath: 'docs/architecture/RIVERPOD_GUIDE.md',
  ),
];
