import 'package:antigrav_flutter_template/core/utils/result.dart';
import 'package:antigrav_flutter_template/features/auth/data/auth_repository_impl.dart';
import 'package:antigrav_flutter_template/features/auth/domain/auth_repository.dart';
import 'package:antigrav_flutter_template/features/profile/data/profile_repository_impl.dart';
import 'package:antigrav_flutter_template/features/profile/domain/profile_entity.dart';
import 'package:antigrav_flutter_template/features/profile/domain/profile_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_controller.g.dart';

/// Controller for the profile screen.
///
/// Exposes the current user's profile as a reactive stream and handles
/// saves. This is the template's reference example of a controller
/// binding a repository stream to the UI: `build()` returns the stream,
/// Riverpod wraps it in [AsyncValue], and the view renders
/// loading/error/data without any business logic of its own.
///
/// The profile belongs to the signed-in user; when nobody is signed in
/// (the stub template's default state) a fixed demo uid is used so the
/// feature is explorable out of the box.
@riverpod
class ProfileController extends _$ProfileController {
  /// Profile uid used when no user is signed in.
  static const String demoUid = 'demo-user';

  @override
  Stream<ProfileEntity?> build() {
    final ProfileRepository repository = ref.watch(profileRepositoryProvider);
    return repository.watchProfile(_currentUid());
  }

  /// Saves [displayName] and [bio] to the current user's profile.
  ///
  /// Returns the save [Result] so the view can show success/failure
  /// feedback. The watched stream emits the updated profile
  /// automatically on success — no manual state mutation needed.
  Future<Result<void>> save({
    required String displayName,
    required String bio,
  }) {
    final ProfileRepository repository = ref.read(profileRepositoryProvider);
    return repository.saveProfile(
      ProfileEntity(
        uid: _currentUid(),
        displayName: displayName.trim().isEmpty ? null : displayName.trim(),
        bio: bio.trim().isEmpty ? null : bio.trim(),
      ),
    );
  }

  /// The signed-in user's uid, or [demoUid] when signed out.
  String _currentUid() {
    final AuthRepository auth = ref.read(authRepositoryProvider);
    return auth.currentUser?.id ?? demoUid;
  }
}
