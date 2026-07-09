// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the app-wide [AuthRepository] binding.
///
/// Defaults to [StubAuthRepository]. To use Firebase, override this
/// provider with a `FirebaseAuthRepositoryImpl` instance (flavor-based
/// selection is planned; see docs/planning/PRODUCTION_ROADMAP.md Phase 1).

@ProviderFor(authRepository)
final authRepositoryProvider = AuthRepositoryProvider._();

/// Provides the app-wide [AuthRepository] binding.
///
/// Defaults to [StubAuthRepository]. To use Firebase, override this
/// provider with a `FirebaseAuthRepositoryImpl` instance (flavor-based
/// selection is planned; see docs/planning/PRODUCTION_ROADMAP.md Phase 1).

final class AuthRepositoryProvider
    extends $FunctionalProvider<AuthRepository, AuthRepository, AuthRepository>
    with $Provider<AuthRepository> {
  /// Provides the app-wide [AuthRepository] binding.
  ///
  /// Defaults to [StubAuthRepository]. To use Firebase, override this
  /// provider with a `FirebaseAuthRepositoryImpl` instance (flavor-based
  /// selection is planned; see docs/planning/PRODUCTION_ROADMAP.md Phase 1).
  AuthRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authRepositoryHash();

  @$internal
  @override
  $ProviderElement<AuthRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthRepository create(Ref ref) {
    return authRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRepository>(value),
    );
  }
}

String _$authRepositoryHash() => r'79645b2298b0903121bfde5dc5463d7be2e12bfb';
