import 'dart:async';

import 'package:antigrav_flutter_template/core/constants/app_constants.dart';
import 'package:antigrav_flutter_template/core/utils/result.dart';
import 'package:antigrav_flutter_template/features/profile/domain/profile_entity.dart';
import 'package:antigrav_flutter_template/features/profile/domain/profile_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_repository_impl.g.dart';

/// Stub [ProfileRepository] used while no real backend is configured.
///
/// Keeps profiles in an in-memory map so the full watch → edit → save
/// loop is demonstrable offline. Nothing is persisted across restarts.
///
/// Template note: this stub is the default binding of
/// `profileRepositoryProvider`. Do not replace it — when Firebase is
/// enabled, `FirestoreProfileRepositoryImpl` is bound instead (see
/// docs/setup/FIREBASE_SETUP.md).
class StubProfileRepository implements ProfileRepository {
  final Map<String, ProfileEntity> _profiles = <String, ProfileEntity>{};

  /// Emits the uid of every profile that changes.
  final StreamController<String> _changes = StreamController<String>.broadcast();

  @override
  Stream<ProfileEntity?> watchProfile(String uid) async* {
    yield _profiles[uid];
    // yield* (not `await for`) so subscription cancellation propagates
    // to the inner stream immediately instead of leaking the generator.
    yield* _changes.stream
        .where((String changedUid) => changedUid == uid)
        .map((String _) => _profiles[uid]);
  }

  @override
  Future<Result<ProfileEntity?>> fetchProfile(String uid) async {
    await Future<void>.delayed(AppConstants.durationStubNetwork);
    return Success<ProfileEntity?>(_profiles[uid]);
  }

  @override
  Future<Result<void>> saveProfile(ProfileEntity profile) async {
    await Future<void>.delayed(AppConstants.durationStubNetwork);
    final ProfileEntity? existing = _profiles[profile.uid];
    // Mirror the contract's merge semantics: nulls keep existing values.
    _profiles[profile.uid] = ProfileEntity(
      uid: profile.uid,
      displayName: profile.displayName ?? existing?.displayName,
      bio: profile.bio ?? existing?.bio,
      photoUrl: profile.photoUrl ?? existing?.photoUrl,
      updatedAt: DateTime.now(),
    );
    _changes.add(profile.uid);
    return const Success<void>(null);
  }
}

/// Provides the app-wide [ProfileRepository] binding.
///
/// Defaults to [StubProfileRepository]; when Firebase is enabled the
/// override list in `lib/app/config/firebase_overrides.dart` binds
/// `FirestoreProfileRepositoryImpl` instead.
@Riverpod(keepAlive: true)
ProfileRepository profileRepository(Ref ref) {
  return StubProfileRepository();
}
