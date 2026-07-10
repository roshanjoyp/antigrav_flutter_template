import 'package:craft_flutter_template/core/setup/readiness_item.dart';
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

/// Production-readiness items every shipping app needs, regardless of
/// which optional modules are included.
const List<ReadinessItem> coreReadinessItems = [
  ReadinessItem(
    id: 'core.icon_replaced',
    module: SetupModule.core,
    title: 'Launcher icon replaced',
    why: 'Stores reject or bury apps shipping the default Flutter icon.',
    hasAutoCheck: true,
    link: 'https://pub.dev/packages/flutter_launcher_icons',
  ),
  ReadinessItem(
    id: 'core.splash_branded',
    module: SetupModule.core,
    title: 'Splash screen branded',
    why: 'The default white flash reads as unfinished to users.',
    link: 'https://pub.dev/packages/flutter_native_splash',
  ),
  ReadinessItem(
    id: 'core.pubspec_description',
    module: SetupModule.core,
    title: 'pubspec.yaml description replaced',
    why: 'The default "A new Flutter project." leaks into tooling output.',
    hasAutoCheck: true,
  ),
  ReadinessItem(
    id: 'core.release_signing',
    module: SetupModule.core,
    title: 'Android release signing configured',
    why: 'Debug-key-signed builds cannot be uploaded to the Play Store.',
    hasAutoCheck: true,
    link: 'https://docs.flutter.dev/deployment/android#sign-the-app',
  ),
  ReadinessItem(
    id: 'core.flavors_reviewed',
    module: SetupModule.core,
    title: 'Flavor setup reviewed (per-env app names and IDs)',
    why: 'Shipping with dev/staging config pointed at prod is a classic.',
    docPath: 'docs/architecture/SERVICES.md',
  ),
  ReadinessItem(
    id: 'core.store_metadata',
    module: SetupModule.core,
    title: 'Store listings prepared (screenshots, descriptions)',
    why: 'Both stores block release until metadata is complete.',
    link: 'https://play.google.com/console/',
  ),
  ReadinessItem(
    id: 'core.privacy_policy',
    module: SetupModule.core,
    title: 'Privacy policy published and linked',
    why: 'Required by both stores for any app collecting data.',
  ),
];
