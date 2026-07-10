/// The generator's view of the template's optional modules.
///
/// A parallel declaration to the template's own manifests
/// (`lib/core/setup/manifests/`), kept honest by the drift-guard tests
/// in `test/template_integrity_test.dart`: every glob must match files,
/// no file may be claimed twice, and imports of owned paths from shared
/// files must sit inside that module's `MODULE(id)` marker.
library;

/// One optional module: what it owns and what must be pruned with it.
class ModuleDefinition {
  /// Creates a module definition.
  const ModuleDefinition({
    required this.id,
    this.requires = const {},
    required this.ownedPaths,
    this.pubspecDeps = const [],
    this.checklistPrefixes = const [],
  });

  /// Stable id, also the `MODULE(<id>)` marker name.
  final String id;

  /// Module ids this module cannot exist without.
  final Set<String> requires;

  /// Template-root-relative paths/globs deleted when the module is
  /// excluded. A glob matching zero files is a generation error.
  final List<String> ownedPaths;

  /// pubspec.yaml dependency names pruned when excluded.
  final List<String> pubspecDeps;

  /// checklist.yaml item-id prefixes pruned when excluded.
  final List<String> checklistPrefixes;
}

/// Every optional module, keyed by id.
const Map<String, ModuleDefinition> kModules = {
  'firebase': ModuleDefinition(
    id: 'firebase',
    ownedPaths: [
      'lib/core/config/firebase/**',
      'lib/app/config/firebase_overrides.dart',
      'lib/core/services/crash_service/firebase_crash_service_impl.dart',
      'lib/core/services/analytics_service/firebase_analytics_service_impl.dart',
      'lib/features/auth/data/firebase_auth_repository_impl.dart',
      'lib/features/auth/data/firebase_auth_error_mapper.dart',
      'lib/features/auth/data/firebase_federated_sign_in.dart',
      'lib/features/profile/data/firestore_profile_repository_impl.dart',
      'lib/features/profile/data/profile_model.dart',
      'lib/features/profile/data/profile_model.freezed.dart',
      'lib/features/profile/data/profile_model.g.dart',
      'lib/core/setup/manifests/firebase_manifest.dart',
      'lib/core/setup/checks/firebase_static_checks.dart',
      'docs/setup/FIREBASE_SETUP.md',
      'test/core/services/firebase_services_test.dart',
      'test/features/auth/firebase_auth_repository_impl_test.dart',
      'test/features/auth/firebase_auth_error_mapper_test.dart',
      'test/features/profile/profile_model_test.dart',
    ],
    pubspecDeps: [
      'firebase_core',
      'firebase_auth',
      'cloud_firestore',
      'firebase_crashlytics',
      'firebase_analytics',
      'google_sign_in',
    ],
  ),
  'revenuecat': ModuleDefinition(
    id: 'revenuecat',
    ownedPaths: [
      'lib/features/paywall/**',
      'lib/core/config/revenuecat/**',
      'lib/app/config/revenuecat_overrides.dart',
      'lib/core/setup/manifests/revenuecat_manifest.dart',
      'lib/core/setup/checks/revenuecat_static_checks.dart',
      'docs/setup/REVENUECAT_SETUP.md',
      'test/features/paywall/**',
    ],
    pubspecDeps: ['purchases_flutter'],
    checklistPrefixes: ['revenuecat.'],
  ),
  'push': ModuleDefinition(
    id: 'push',
    requires: {'firebase'},
    ownedPaths: [
      'lib/core/services/push_service/firebase_push_service_impl.dart',
      'lib/core/setup/manifests/push_manifest.dart',
      'docs/setup/PUSH_NOTIFICATIONS_SETUP.md',
      'test/core/services/push_service_test.dart',
    ],
    pubspecDeps: ['firebase_messaging'],
    checklistPrefixes: ['push.'],
  ),
  'onboarding': ModuleDefinition(
    id: 'onboarding',
    ownedPaths: [
      'lib/features/onboarding/**',
      'lib/app/config/onboarding_overrides.dart',
      'test/features/onboarding/**',
    ],
  ),
};
