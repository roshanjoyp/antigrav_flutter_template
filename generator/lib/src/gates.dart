/// Post-generation verification gates run inside the staging project.
library;

import 'dart:io';

/// How much verification to run on the generated project.
enum GateLevel {
  /// No verification (fastest; for trusted repeat runs).
  none,

  /// `flutter pub get` + `flutter analyze` (default).
  analyze,

  /// [analyze] plus `flutter test`.
  test,
}

/// Result of one external command.
class GateStep {
  /// Creates a step record.
  const GateStep(this.label, this.ok, this.output);

  /// Human-readable command label.
  final String label;

  /// Whether the command exited 0.
  final bool ok;

  /// Combined stdout+stderr (only surfaced on failure).
  final String output;
}

/// Runs the gates for [level] inside [staging]; stops at first failure.
List<GateStep> runGates(Directory staging, GateLevel level) {
  final steps = <GateStep>[];
  GateStep run(String label, List<String> args) {
    final result = Process.runSync(
      'flutter',
      args,
      workingDirectory: staging.path,
    );
    return GateStep(
      label,
      result.exitCode == 0,
      '${result.stdout}\n${result.stderr}',
    );
  }

  if (level == GateLevel.none) return steps;
  steps.add(run('flutter pub get', ['pub', 'get']));
  if (!steps.last.ok) return steps;
  steps.add(run('flutter analyze', ['analyze']));
  if (!steps.last.ok || level != GateLevel.test) return steps;
  steps.add(run('flutter test', ['test']));
  return steps;
}
