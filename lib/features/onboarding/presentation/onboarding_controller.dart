import 'package:craft_flutter_template/core/utils/result.dart';
import 'package:craft_flutter_template/features/onboarding/data/onboarding_repository_impl.dart';
import 'package:craft_flutter_template/features/onboarding/domain/onboarding_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_controller.g.dart';

/// Controller for the onboarding flow.
///
/// Exposes whether onboarding has been seen and persists completion.
/// Page-position state stays in the screen (pure UI); everything that
/// touches storage goes through here.
@riverpod
class OnboardingController extends _$OnboardingController {
  @override
  Future<bool> build() async {
    final OnboardingRepository repository = ref.watch(
      onboardingRepositoryProvider,
    );
    final Result<bool> seen = await repository.hasSeenOnboarding();
    // A broken storage layer must not trap the user in onboarding —
    // treat it as seen and let startup proceed normally.
    return seen.getOrElse(true);
  }

  /// Persists that onboarding is done (completed or skipped).
  ///
  /// Returns the [Result] so callers can log failures; navigation
  /// should proceed regardless — the worst case is onboarding showing
  /// once more on next launch.
  Future<Result<void>> complete() async {
    final Result<void> result = await ref
        .read(onboardingRepositoryProvider)
        .markOnboardingSeen();
    if (result.isSuccess) state = const AsyncData<bool>(true);
    return result;
  }
}
