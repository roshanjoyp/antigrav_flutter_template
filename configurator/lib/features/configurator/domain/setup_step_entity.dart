/// How a setup step is verified after download.
enum SetupStepKind {
  /// Machine-verified by `dart run tool/doctor.dart` or the Setup Status
  /// screen — no honesty required.
  doctor,

  /// Console work the machine can't see: guided instructions, deep link,
  /// and a manual "I've done this" confirmation.
  guided,
}

/// One post-download setup step shown in the preview's Setup steps tab.
class SetupStepEntity {
  /// Creates a setup step.
  const SetupStepEntity(this.label, this.kind);

  /// Buyer-facing description of the step.
  final String label;

  /// How the step is verified.
  final SetupStepKind kind;
}
