/// Shared contract for doctor CLI checks (setup and readiness).
///
/// Uses `dart:io` types in [DoctorCheck], so this is CLI-only tooling
/// code: never import it from app code.
library;

import 'dart:io';

/// Outcome of one static check.
class CheckResult {
  /// Creates a check outcome; [detail] explains a failure.
  const CheckResult(this.passed, [this.detail]);

  /// Convenience passing result.
  static const CheckResult ok = CheckResult(true);

  /// Whether the check passed.
  final bool passed;

  /// Failure explanation appended to the step's remediation, if any.
  final String? detail;
}

/// Signature of a static check: inspects files under [root].
typedef DoctorCheck = CheckResult Function(Directory root);
