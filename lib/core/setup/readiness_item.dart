import 'package:craft_flutter_template/core/setup/setup_step.dart';

/// One production-readiness checklist item.
///
/// Declared per module in `lib/core/setup/manifests/` alongside the
/// setup steps; consumed by the doctor CLI and the Readiness tab of the
/// Setup Status screen. Item *state* (done/skipped, reasons, owners)
/// never lives here — it lives in the git-tracked `checklist.yaml` at
/// the project root, so it is diffable and PR-reviewable.
///
/// Items are link-don't-restate: [title] and [why] are one line each and
/// the authoritative instructions live behind [docPath]/[link], so the
/// checklist can't rot into stale step-by-step prose.
class ReadinessItem {
  /// Creates a readiness item declaration.
  const ReadinessItem({
    required this.id,
    required this.module,
    required this.title,
    required this.why,
    this.hasAutoCheck = false,
    this.docPath,
    this.link,
  });

  /// Stable unique identifier, `<module>.<item>` by convention
  /// (e.g. `core.icon_replaced`). Keys the entry in `checklist.yaml`
  /// and, when [hasAutoCheck] is true, the check implementation.
  final String id;

  /// The module this item applies to. Items for disabled modules are
  /// excluded from the checklist entirely.
  final SetupModule module;

  /// One-line statement of what must be true before shipping.
  final String title;

  /// One-line reason this matters (shown as the subtitle).
  final String why;

  /// Whether the doctor CLI can verify this item automatically.
  /// Auto-checked items are verifiable-first: the check result wins over
  /// whatever status `checklist.yaml` claims.
  final bool hasAutoCheck;

  /// Repo-relative path to the authoritative doc, if one exists.
  final String? docPath;

  /// External URL (store console, service dashboard), if applicable.
  final String? link;
}
