// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'readiness_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Loads and parses the bundled `checklist.yaml` readiness state.
///
/// The app reads the checklist as a read-only asset: state changes are
/// made by editing the git-tracked file itself (that's the point — the
/// checklist is diffable and PR-reviewable, not per-device), then hot
/// restarting. Throws if the asset is missing so a broken bundle shows
/// up as an error state instead of an empty checklist.

@ProviderFor(readinessChecklist)
final readinessChecklistProvider = ReadinessChecklistProvider._();

/// Loads and parses the bundled `checklist.yaml` readiness state.
///
/// The app reads the checklist as a read-only asset: state changes are
/// made by editing the git-tracked file itself (that's the point — the
/// checklist is diffable and PR-reviewable, not per-device), then hot
/// restarting. Throws if the asset is missing so a broken bundle shows
/// up as an error state instead of an empty checklist.

final class ReadinessChecklistProvider
    extends
        $FunctionalProvider<
          AsyncValue<ChecklistDocument>,
          ChecklistDocument,
          FutureOr<ChecklistDocument>
        >
    with
        $FutureModifier<ChecklistDocument>,
        $FutureProvider<ChecklistDocument> {
  /// Loads and parses the bundled `checklist.yaml` readiness state.
  ///
  /// The app reads the checklist as a read-only asset: state changes are
  /// made by editing the git-tracked file itself (that's the point — the
  /// checklist is diffable and PR-reviewable, not per-device), then hot
  /// restarting. Throws if the asset is missing so a broken bundle shows
  /// up as an error state instead of an empty checklist.
  ReadinessChecklistProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'readinessChecklistProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$readinessChecklistHash();

  @$internal
  @override
  $FutureProviderElement<ChecklistDocument> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ChecklistDocument> create(Ref ref) {
    return readinessChecklist(ref);
  }
}

String _$readinessChecklistHash() =>
    r'df23e265bd50d7f0d3f815a85aa11e1544a62058';

/// Whether the Readiness tab also shows skipped items.
///
/// Skipped items stay auditable — hidden by default, one toggle away.

@ProviderFor(ShowSkippedReadiness)
final showSkippedReadinessProvider = ShowSkippedReadinessProvider._();

/// Whether the Readiness tab also shows skipped items.
///
/// Skipped items stay auditable — hidden by default, one toggle away.
final class ShowSkippedReadinessProvider
    extends $NotifierProvider<ShowSkippedReadiness, bool> {
  /// Whether the Readiness tab also shows skipped items.
  ///
  /// Skipped items stay auditable — hidden by default, one toggle away.
  ShowSkippedReadinessProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'showSkippedReadinessProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$showSkippedReadinessHash();

  @$internal
  @override
  ShowSkippedReadiness create() => ShowSkippedReadiness();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$showSkippedReadinessHash() =>
    r'360b11681af3230e718b6b7e059a248c8b3ff3e7';

/// Whether the Readiness tab also shows skipped items.
///
/// Skipped items stay auditable — hidden by default, one toggle away.

abstract class _$ShowSkippedReadiness extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
