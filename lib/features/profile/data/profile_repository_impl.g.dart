// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the app-wide [ProfileRepository] binding.
///
/// Defaults to [StubProfileRepository]; when Firebase is enabled the
/// override list in `lib/app/config/firebase_overrides.dart` binds
/// `FirestoreProfileRepositoryImpl` instead.

@ProviderFor(profileRepository)
final profileRepositoryProvider = ProfileRepositoryProvider._();

/// Provides the app-wide [ProfileRepository] binding.
///
/// Defaults to [StubProfileRepository]; when Firebase is enabled the
/// override list in `lib/app/config/firebase_overrides.dart` binds
/// `FirestoreProfileRepositoryImpl` instead.

final class ProfileRepositoryProvider
    extends
        $FunctionalProvider<
          ProfileRepository,
          ProfileRepository,
          ProfileRepository
        >
    with $Provider<ProfileRepository> {
  /// Provides the app-wide [ProfileRepository] binding.
  ///
  /// Defaults to [StubProfileRepository]; when Firebase is enabled the
  /// override list in `lib/app/config/firebase_overrides.dart` binds
  /// `FirestoreProfileRepositoryImpl` instead.
  ProfileRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProfileRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProfileRepository create(Ref ref) {
    return profileRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfileRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfileRepository>(value),
    );
  }
}

String _$profileRepositoryHash() => r'91182abc1a93b6f9a81dcd800f1b3a18c3ff46b1';
