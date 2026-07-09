import 'package:craft_flutter_template/core/utils/result.dart';
import 'package:craft_flutter_template/features/profile/domain/profile_entity.dart';

/// Contract for reading and writing user profiles.
///
/// Implementations handle the storage backend (stub, Firestore, or any
/// future adapter). Layers above depend only on this interface.
///
/// All request/response methods return [Result]; the watch stream
/// reports failures as stream errors carrying [AppException].
///
/// Access via the `profileRepositoryProvider` Riverpod provider.
abstract class ProfileRepository {
  /// Watches the profile of the user with [uid].
  ///
  /// Emits the current profile immediately (or `null` if none exists
  /// yet), then again on every change. Backend failures surface as
  /// stream errors carrying [AppException].
  Stream<ProfileEntity?> watchProfile(String uid);

  /// Fetches the profile of the user with [uid] once.
  ///
  /// Succeeds with `null` when the user has no profile document yet —
  /// that is a normal state, not a failure.
  Future<Result<ProfileEntity?>> fetchProfile(String uid);

  /// Creates or updates [profile], keyed by [ProfileEntity.uid].
  ///
  /// Performs a merge write: fields that are `null` on [profile] do not
  /// overwrite existing values. The backend sets
  /// [ProfileEntity.updatedAt] on every save.
  Future<Result<void>> saveProfile(ProfileEntity profile);
}
