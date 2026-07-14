import 'package:craft_configurator/features/configurator/domain/configurator_module_entity.dart';
import 'package:craft_configurator/features/configurator/domain/setup_step_entity.dart';

/// The buyer-facing module catalogue.
///
/// Ids, requires-relations, and pubspec deps mirror
/// `generator/lib/src/module_registry.dart` exactly (drift-guard tested);
/// copy and file lists are curated for the preview panel.
const List<ConfiguratorModuleEntity> kModuleCatalogue = [
  ConfiguratorModuleEntity(
    id: 'firebase',
    group: 'Backend',
    name: 'Firebase suite',
    description:
        'Auth (email/password, Google, anonymous), a worked Firestore '
        'profile feature, Crashlytics, and Analytics — all behind the '
        'template\'s repository and service interfaces, errors mapped '
        'into Result.',
    pubspecDeps: [
      'firebase_core',
      'firebase_auth',
      'cloud_firestore',
      'firebase_crashlytics',
      'firebase_analytics',
      'google_sign_in',
    ],
    addedFiles: [
      'lib/features/auth/data/firebase_*',
      'lib/features/profile/data/firestore_*',
      'lib/core/services/*/firebase_*_impl.dart',
      'lib/core/config/firebase/',
      'docs/setup/FIREBASE_SETUP.md',
    ],
    steps: [
      SetupStepEntity(
        'Create Firebase project(s), one per environment',
        SetupStepKind.guided,
      ),
      SetupStepEntity(
        'Run flutterfire configure for dev/staging/prod',
        SetupStepKind.doctor,
      ),
      SetupStepEntity(
        'Firebase initializes + anonymous auth round-trips',
        SetupStepKind.doctor,
      ),
    ],
  ),
  ConfiguratorModuleEntity(
    id: 'revenuecat',
    group: 'Monetization',
    name: 'Paywall — RevenueCat',
    description:
        'Subscription entitlements behind SubscriptionRepository, a paywall '
        'screen built from the core widgets, and restore purchases. '
        'Stub-first: runs without keys until you add them.',
    pubspecDeps: ['purchases_flutter'],
    addedFiles: [
      'lib/features/paywall/',
      'lib/core/config/revenuecat/',
      'docs/setup/REVENUECAT_SETUP.md',
    ],
    steps: [
      SetupStepEntity(
        'RevenueCat SDK keys pasted into RevenueCatConfig',
        SetupStepKind.doctor,
      ),
      SetupStepEntity(
        'Store products created and attached to the entitlement',
        SetupStepKind.guided,
      ),
      SetupStepEntity(
        'Sandbox purchase tested end-to-end',
        SetupStepKind.guided,
      ),
    ],
  ),
  ConfiguratorModuleEntity(
    id: 'push',
    group: 'Engagement',
    name: 'Push notifications — FCM',
    description:
        'Token handling, foreground/background handlers, permission flow '
        'through PermissionService, and notification tap → deep link '
        'through go_router.',
    requires: {'firebase'},
    pubspecDeps: ['firebase_messaging'],
    addedFiles: [
      'lib/core/services/push_service/firebase_push_service_impl.dart',
      'docs/setup/PUSH_NOTIFICATIONS_SETUP.md',
    ],
    steps: [
      SetupStepEntity(
        'APNs auth key uploaded to Firebase',
        SetupStepKind.guided,
      ),
      SetupStepEntity(
        'FCM registration token issued on-device',
        SetupStepKind.doctor,
      ),
    ],
  ),
  ConfiguratorModuleEntity(
    id: 'onboarding',
    group: 'Engagement',
    name: 'Onboarding flow',
    description:
        'Three-page flow with persisted seen-state, wired into the startup '
        'redirect. First runs land here; the copy and artwork are yours to '
        'replace.',
    addedFiles: ['lib/features/onboarding/'],
    steps: [
      SetupStepEntity(
        'Replace onboarding copy and artwork',
        SetupStepKind.guided,
      ),
    ],
  ),
];

/// Dependencies every generated project ships regardless of selection
/// (headline entries from the template pubspec, shown dimmed in the
/// pubspec preview).
const List<String> kBaseDeps = [
  'flutter_riverpod',
  'riverpod_annotation',
  'go_router',
  'freezed_annotation',
  'json_annotation',
  'flutter_secure_storage',
];

/// File-tree lines every generated project contains (shown dimmed in the
/// files preview, with a short role note per line).
const List<String> kBaseTree = [
  'lib/app/            router · theme · config',
  'lib/core/           widgets · services · utils',
  'lib/features/startup/',
  'test/               unit · widget · golden',
  'guide/              docs for THIS config',
  'tool/doctor.dart    setup verifier',
];
