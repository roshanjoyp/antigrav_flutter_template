// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Controller for the onboarding flow.
///
/// Exposes whether onboarding has been seen and persists completion.
/// Page-position state stays in the screen (pure UI); everything that
/// touches storage goes through here.

@ProviderFor(OnboardingController)
final onboardingControllerProvider = OnboardingControllerProvider._();

/// Controller for the onboarding flow.
///
/// Exposes whether onboarding has been seen and persists completion.
/// Page-position state stays in the screen (pure UI); everything that
/// touches storage goes through here.
final class OnboardingControllerProvider
    extends $AsyncNotifierProvider<OnboardingController, bool> {
  /// Controller for the onboarding flow.
  ///
  /// Exposes whether onboarding has been seen and persists completion.
  /// Page-position state stays in the screen (pure UI); everything that
  /// touches storage goes through here.
  OnboardingControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingControllerHash();

  @$internal
  @override
  OnboardingController create() => OnboardingController();
}

String _$onboardingControllerHash() =>
    r'd4301814b741f9fb9e06c0369e51267964e5a5c4';

/// Controller for the onboarding flow.
///
/// Exposes whether onboarding has been seen and persists completion.
/// Page-position state stays in the screen (pure UI); everything that
/// touches storage goes through here.

abstract class _$OnboardingController extends $AsyncNotifier<bool> {
  FutureOr<bool> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
