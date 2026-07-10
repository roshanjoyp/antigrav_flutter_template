// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'first_run_redirect.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Resolves where a fresh launch should be redirected, or `null` to
/// proceed to home.
///
/// Defaults to no redirect. Features that want to intercept the first
/// run (e.g. onboarding) override this provider in `main.dart` — see
/// `lib/app/config/onboarding_overrides.dart`. Startup stays ignorant
/// of who is redirecting and why.

@ProviderFor(firstRunRedirect)
final firstRunRedirectProvider = FirstRunRedirectProvider._();

/// Resolves where a fresh launch should be redirected, or `null` to
/// proceed to home.
///
/// Defaults to no redirect. Features that want to intercept the first
/// run (e.g. onboarding) override this provider in `main.dart` — see
/// `lib/app/config/onboarding_overrides.dart`. Startup stays ignorant
/// of who is redirecting and why.

final class FirstRunRedirectProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, FutureOr<String?>>
    with $FutureModifier<String?>, $FutureProvider<String?> {
  /// Resolves where a fresh launch should be redirected, or `null` to
  /// proceed to home.
  ///
  /// Defaults to no redirect. Features that want to intercept the first
  /// run (e.g. onboarding) override this provider in `main.dart` — see
  /// `lib/app/config/onboarding_overrides.dart`. Startup stays ignorant
  /// of who is redirecting and why.
  FirstRunRedirectProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firstRunRedirectProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firstRunRedirectHash();

  @$internal
  @override
  $FutureProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String?> create(Ref ref) {
    return firstRunRedirect(ref);
  }
}

String _$firstRunRedirectHash() => r'a8ddf945d5c36cff0a54ac5ded2c0f951c0f110c';
