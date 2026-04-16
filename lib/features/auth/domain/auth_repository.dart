import 'package:antigrav_flutter_template/features/auth/domain/user_entity.dart';

/// Contract for authentication operations.
///
/// Implementations handle the communication with the auth backend
/// (e.g. Firebase Auth). The domain layer depends on this interface,
/// never on the concrete implementation.
///
/// Use [AuthRepository] via the `authRepositoryProvider` Riverpod provider.
abstract class AuthRepository {
  /// A stream that emits the currently authenticated [UserEntity], or `null`
  /// when no user is signed in.
  ///
  /// Emits immediately with the current state on subscription, then again
  /// whenever the auth state changes.
  Stream<UserEntity?> get authStateChanges;

  /// Signs in a user with the given [email] and [password].
  ///
  /// Returns the authenticated [UserEntity] on success.
  /// Throws [AppException] on authentication failure (wrong credentials,
  /// network error, account disabled, etc.).
  Future<UserEntity> signInWithEmailAndPassword(String email, String password);

  /// Signs out the currently authenticated user.
  ///
  /// Throws [AppException] if sign-out fails unexpectedly.
  Future<void> signOut();
}
