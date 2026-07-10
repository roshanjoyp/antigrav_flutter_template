/// How a [SetupStep] is verified.
enum SetupCheckKind {
  /// Verified by the doctor CLI (`dart run tool/doctor.dart`) by inspecting
  /// project files on disk. No app or emulator required.
  staticCheck,

  /// Verified inside a running debug build via the Setup Status screen —
  /// things static analysis can't prove (Firebase initializes, auth
  /// round-trips, an FCM token is issued).
  runtimeCheck,

  /// Cannot be machine-verified (console/dashboard work). The step carries
  /// instructions and a deep link; the developer confirms it by hand.
  manual,
}

/// The template module a [SetupStep] belongs to.
///
/// Modules map 1:1 to the template's optional integrations. Steps for a
/// disabled module are reported as skipped, not failed.
enum SetupModule {
  /// Always-on template plumbing: rename, dependencies, code generation.
  core,

  /// Firebase integration (auth, Firestore, Crashlytics, Analytics),
  /// gated by `FirebaseConfig.enabled`.
  firebase,

  /// RevenueCat paywall module, gated by `RevenueCatConfig.enabled`.
  revenuecat,

  /// FCM push notifications. Requires the Firebase module; enabled
  /// together with `FirebaseConfig.enabled`.
  push,
}

/// Human-readable names for [SetupModule] values, for section headers
/// and check output.
extension SetupModuleDisplay on SetupModule {
  /// The module's display name (e.g. `SetupModule.revenuecat` →
  /// "RevenueCat").
  String get displayName => switch (this) {
    SetupModule.core => 'Core',
    SetupModule.firebase => 'Firebase',
    SetupModule.revenuecat => 'RevenueCat',
    SetupModule.push => 'Push notifications',
  };
}

/// One declared post-download setup step.
///
/// The manifests in `lib/core/setup/manifests/` are the single source of
/// truth for setup steps. Every consumer — the doctor CLI, the in-app
/// Setup Status screen, and (later) the v2 generator — reads these
/// declarations rather than hardcoding its own list.
///
/// A step only *declares* how it is verified ([kind] + [id]); the check
/// implementation lives with its runner (static checks in
/// `tool/src/doctor_checks.dart`, runtime checks in the Setup Status
/// screen) so this file stays free of `dart:io` and Flutter imports.
class SetupStep {
  /// Creates a setup step declaration.
  const SetupStep({
    required this.id,
    required this.module,
    required this.kind,
    required this.title,
    required this.remediation,
    this.docPath,
    this.link,
  });

  /// Stable unique identifier, `<module>.<step>` by convention
  /// (e.g. `firebase.options_dev`). Check runners bind implementations
  /// to this id.
  final String id;

  /// The module this step belongs to.
  final SetupModule module;

  /// How this step is verified.
  final SetupCheckKind kind;

  /// One-line description shown in check output and UI.
  final String title;

  /// What to do when the step is incomplete — a command to run or a
  /// short instruction. Kept to one or two lines; details belong in the
  /// linked doc, not here.
  final String remediation;

  /// Repo-relative path to the authoritative doc for this step
  /// (e.g. `docs/setup/FIREBASE_SETUP.md`), if one exists.
  final String? docPath;

  /// External URL for manual console/dashboard work
  /// (e.g. the Firebase console), if applicable.
  final String? link;
}
