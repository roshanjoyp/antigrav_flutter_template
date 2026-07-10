/// Lifecycle of one runtime setup check on the Setup Status screen.
enum RuntimeCheckStatus {
  /// Not run yet in this session.
  notRun,

  /// Currently executing.
  running,

  /// The check verified successfully.
  passed,

  /// The check ran and failed; see [RuntimeCheckEntity.detail].
  failed,

  /// Not applicable because the step's module is disabled.
  skipped,
}

/// The current state of one runtime setup check, keyed by its manifest
/// [stepId].
///
/// Produced by the Setup Status controller; the view renders these
/// without any check logic of its own.
class RuntimeCheckEntity {
  /// Creates a runtime check state.
  const RuntimeCheckEntity({
    required this.stepId,
    required this.status,
    this.detail,
  });

  /// The [stepId] of the manifest step this state belongs to.
  final String stepId;

  /// Where the check is in its lifecycle.
  final RuntimeCheckStatus status;

  /// Human-readable outcome detail (token value, error message), if any.
  final String? detail;

  /// A copy of this state with the given fields replaced.
  RuntimeCheckEntity copyWith({RuntimeCheckStatus? status, String? detail}) =>
      RuntimeCheckEntity(
        stepId: stepId,
        status: status ?? this.status,
        detail: detail ?? this.detail,
      );
}
