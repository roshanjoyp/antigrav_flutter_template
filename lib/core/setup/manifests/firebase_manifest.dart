import 'package:craft_flutter_template/core/setup/setup_step.dart';

/// Setup steps for the Firebase module (`FirebaseConfig.enabled`).
///
/// Skipped entirely while the module is disabled — the template runs on
/// stub services with no Firebase project.
const List<SetupStep> firebaseSetupSteps = [
  SetupStep(
    id: 'firebase.project',
    module: SetupModule.firebase,
    kind: SetupCheckKind.manual,
    title: 'Firebase project(s) created (one per environment)',
    remediation:
        'Create dev/staging/prod projects in the Firebase console, then '
        'run flutterfire configure against each.',
    docPath: 'docs/setup/FIREBASE_SETUP.md',
    link: 'https://console.firebase.google.com/',
  ),
  SetupStep(
    id: 'firebase.options_dev',
    module: SetupModule.firebase,
    kind: SetupCheckKind.staticCheck,
    title: 'Development firebase_options generated',
    remediation:
        'Run: flutterfire configure --project=<dev-project-id> '
        '--out=lib/core/config/firebase/firebase_options_dev.dart',
    docPath: 'docs/setup/FIREBASE_SETUP.md',
  ),
  SetupStep(
    id: 'firebase.options_staging',
    module: SetupModule.firebase,
    kind: SetupCheckKind.staticCheck,
    title: 'Staging firebase_options generated',
    remediation:
        'Run: flutterfire configure --project=<staging-project-id> '
        '--out=lib/core/config/firebase/firebase_options_staging.dart',
    docPath: 'docs/setup/FIREBASE_SETUP.md',
  ),
  SetupStep(
    id: 'firebase.options_prod',
    module: SetupModule.firebase,
    kind: SetupCheckKind.staticCheck,
    title: 'Production firebase_options generated',
    remediation:
        'Run: flutterfire configure --project=<prod-project-id> '
        '--out=lib/core/config/firebase/firebase_options_prod.dart',
    docPath: 'docs/setup/FIREBASE_SETUP.md',
  ),
  SetupStep(
    id: 'firebase.enabled',
    module: SetupModule.firebase,
    kind: SetupCheckKind.staticCheck,
    title: 'FirebaseConfig.enabled matches the configured options files',
    remediation:
        'Flip FirebaseConfig.enabled to true once every '
        'firebase_options_*.dart placeholder is replaced (never before).',
    docPath: 'docs/setup/FIREBASE_SETUP.md',
  ),
  SetupStep(
    id: 'firebase.initializes',
    module: SetupModule.firebase,
    kind: SetupCheckKind.runtimeCheck,
    title: 'Firebase initializes at app startup',
    remediation:
        'Run a debug build and open the Setup Status screen; check the '
        'startup logs if initialization fails.',
    docPath: 'docs/setup/FIREBASE_SETUP.md',
  ),
  SetupStep(
    id: 'firebase.anon_auth',
    module: SetupModule.firebase,
    kind: SetupCheckKind.runtimeCheck,
    title: 'Anonymous auth round-trips against the project',
    remediation:
        'Enable Anonymous sign-in: Firebase console → Authentication → '
        'Sign-in method.',
    docPath: 'docs/setup/FIREBASE_SETUP.md',
    link: 'https://console.firebase.google.com/',
  ),
];
