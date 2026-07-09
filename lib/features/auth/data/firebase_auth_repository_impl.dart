import 'package:antigrav_flutter_template/core/utils/result.dart';
import 'package:antigrav_flutter_template/features/auth/data/firebase_auth_error_mapper.dart';
import 'package:antigrav_flutter_template/features/auth/data/firebase_federated_sign_in.dart';
import 'package:antigrav_flutter_template/features/auth/domain/auth_repository.dart';
import 'package:antigrav_flutter_template/features/auth/domain/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Firebase implementation of [AuthRepository].
///
/// Wraps Firebase Auth and maps its `User` and errors into the domain's
/// [UserEntity] / [AppException], so no Firebase type leaks past this
/// layer. Requires `FirebaseConfig.initialize()` to have run (see
/// FIREBASE_SETUP.md).
///
/// Not bound by default — `authRepositoryProvider` returns the stub. To
/// activate, override the provider:
///
/// ```dart
/// authRepositoryProvider.overrideWith((ref) => FirebaseAuthRepositoryImpl())
/// ```
class FirebaseAuthRepositoryImpl implements AuthRepository {
  /// Creates the repository.
  ///
  /// [auth] and [federated] default to production instances; inject fakes
  /// in tests.
  FirebaseAuthRepositoryImpl({
    FirebaseAuth? auth,
    FirebaseFederatedSignIn? federated,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _federated = federated ?? FirebaseFederatedSignIn();

  final FirebaseAuth _auth;
  final FirebaseFederatedSignIn _federated;

  @override
  Stream<UserEntity?> get authStateChanges =>
      _auth.authStateChanges().map(_toEntityOrNull);

  @override
  UserEntity? get currentUser => _toEntityOrNull(_auth.currentUser);

  @override
  Future<Result<UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) =>
      _guardUser(() async {
        final UserCredential credential = await _auth
            .signInWithEmailAndPassword(email: email, password: password);
        return credential.user;
      });

  @override
  Future<Result<UserEntity>> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) =>
      _guardUser(() async {
        final UserCredential credential = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);
        return credential.user;
      });

  @override
  Future<Result<UserEntity>> signInWithGoogle() =>
      _guardUser(() async => (await _federated.signInWithGoogle()).user);

  @override
  Future<Result<UserEntity>> signInWithApple() =>
      _guardUser(() async => (await _federated.signInWithApple()).user);

  @override
  Future<Result<UserEntity>> signInAnonymously() =>
      _guardUser(() async => (await _auth.signInAnonymously()).user);

  @override
  Future<Result<void>> sendPasswordResetEmail(String email) =>
      _guardVoid(() => _auth.sendPasswordResetEmail(email: email));

  @override
  Future<Result<void>> signOut() => _guardVoid(() async {
        await _federated.signOutProviders();
        await _auth.signOut();
      });

  /// Maps a Firebase [User] to the domain [UserEntity] (`null` → `null`).
  UserEntity? _toEntityOrNull(User? user) => user == null
      ? null
      : UserEntity(
          id: user.uid,
          email: user.email,
          displayName: user.displayName,
          photoUrl: user.photoURL,
          isAnonymous: user.isAnonymous,
        );

  /// Runs [run] and wraps its [User] result, mapping every thrown error
  /// into a [Failure] via [mapAuthError].
  Future<Result<UserEntity>> _guardUser(Future<User?> Function() run) async {
    try {
      final UserEntity? entity = _toEntityOrNull(await run());
      if (entity == null) {
        return const Failure<UserEntity>(
          AppException(
            message: 'Authentication succeeded but no user was returned.',
            code: 'auth/no-user',
          ),
        );
      }
      return Success<UserEntity>(entity);
    } catch (error, stackTrace) {
      return Failure<UserEntity>(mapAuthError(error, stackTrace));
    }
  }

  /// Runs [run], mapping every thrown error into a [Failure] via
  /// [mapAuthError].
  Future<Result<void>> _guardVoid(Future<void> Function() run) async {
    try {
      await run();
      return const Success<void>(null);
    } catch (error, stackTrace) {
      return Failure<void>(mapAuthError(error, stackTrace));
    }
  }
}
