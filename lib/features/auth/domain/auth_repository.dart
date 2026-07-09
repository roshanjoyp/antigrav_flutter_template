import 'package:antigrav_flutter_template/core/utils/result.dart';
import 'package:antigrav_flutter_template/features/auth/domain/user_entity.dart';

/// Contract for authentication operations.
///
/// Implementations handle communication with the auth backend (stub,
/// Firebase Auth, or any future adapter). The domain and presentation
/// layers depend only on this interface, never on a concrete
/// implementation or an auth SDK type.
///
/// All methods return [Result] — implementations must map backend errors
/// into [AppException] and never throw.
///
/// Access via the `authRepositoryProvider` Riverpod provider.
abstract class AuthRepository {
  /// A stream that emits the currently authenticated [UserEntity], or
  /// `null` when no user is signed in.
  ///
  /// Emits immediately with the current state on subscription, then again
  /// whenever the auth state changes.
  Stream<UserEntity?> get authStateChanges;

  /// The currently authenticated user, or `null` when signed out.
  ///
  /// Synchronous snapshot — prefer [authStateChanges] for anything
  /// reactive (router redirects, UI state).
  UserEntity? get currentUser;

  /// Signs in an existing user with [email] and [password].
  ///
  /// Fails with codes such as `auth/invalid-credential` or
  /// `auth/too-many-requests`.
  Future<Result<UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Creates a new account with [email] and [password] and signs it in.
  ///
  /// Fails with codes such as `auth/email-already-in-use` or
  /// `auth/weak-password`.
  Future<Result<UserEntity>> createUserWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Signs in with the user's Google account.
  ///
  /// Fails with `auth/cancelled` when the user dismisses the account
  /// picker or popup.
  Future<Result<UserEntity>> signInWithGoogle();

  /// Signs in with the user's Apple ID.
  ///
  /// Fails with `auth/cancelled` when the user dismisses the flow.
  Future<Result<UserEntity>> signInWithApple();

  /// Signs in anonymously, creating a guest session.
  ///
  /// The resulting [UserEntity.isAnonymous] is `true` and
  /// [UserEntity.email] is `null`.
  Future<Result<UserEntity>> signInAnonymously();

  /// Sends a password-reset email to [email].
  ///
  /// Succeeds without revealing whether an account exists for [email]
  /// (implementations should not leak account existence).
  Future<Result<void>> sendPasswordResetEmail(String email);

  /// Signs out the currently authenticated user.
  ///
  /// Also clears any provider-side session (e.g. the Google account
  /// picker) so the next sign-in prompts for an account again.
  Future<Result<void>> signOut();
}
