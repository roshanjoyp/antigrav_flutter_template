import 'package:craft_flutter_template/core/setup/checklist/checklist_document.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'readiness_controller.g.dart';

/// Loads and parses the bundled `checklist.yaml` readiness state.
///
/// The app reads the checklist as a read-only asset: state changes are
/// made by editing the git-tracked file itself (that's the point — the
/// checklist is diffable and PR-reviewable, not per-device), then hot
/// restarting. Throws if the asset is missing so a broken bundle shows
/// up as an error state instead of an empty checklist.
@riverpod
Future<ChecklistDocument> readinessChecklist(Ref ref) async {
  final String source = await rootBundle.loadString('checklist.yaml');
  return ChecklistDocument.parse(source);
}

/// Whether the Readiness tab also shows skipped items.
///
/// Skipped items stay auditable — hidden by default, one toggle away.
@riverpod
class ShowSkippedReadiness extends _$ShowSkippedReadiness {
  @override
  bool build() => false;

  /// Flips the toggle.
  void toggle() => state = !state;
}
