import 'package:antigrav_flutter_template/core/utils/result.dart';

/// Contract for the onboarding "seen" state.
///
/// Backs the first-run redirect: startup sends users who have never
/// completed onboarding to `/onboarding` and everyone else straight to
/// the app. Access it via the `onboardingRepositoryProvider` Riverpod
/// provider.
abstract class OnboardingRepository {
  /// Whether the user has completed (or skipped) onboarding before.
  Future<Result<bool>> hasSeenOnboarding();

  /// Marks onboarding as completed so it never auto-shows again.
  Future<Result<void>> markOnboardingSeen();

  /// Clears the flag so onboarding auto-shows on next startup.
  ///
  /// Development convenience for re-testing the first-run flow.
  Future<Result<void>> resetOnboarding();
}
