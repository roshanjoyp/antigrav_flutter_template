import 'dart:async';

import 'package:antigrav_flutter_template/core/constants/app_constants.dart';
import 'package:antigrav_flutter_template/core/utils/result.dart';
import 'package:antigrav_flutter_template/features/auth/domain/auth_repository.dart';
import 'package:antigrav_flutter_template/features/auth/domain/user_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository_impl.g.dart';

/// Stub [AuthRepository] used while no real backend is configured.
///
/// Keeps an in-memory session so the auth flow is fully demonstrable —
/// sign-in succeeds with a fake user after a simulated network delay,
/// [authStateChanges] emits accordingly, and sign-out clears the session.
/// Nothing is persisted; restarting the app signs the user out.
///
/// Template note: this stub is the default binding of
/// `authRepositoryProvider`. Do not replace it — to use Firebase instead,
/// override the provider with `FirebaseAuthRepositoryImpl` (see
/// docs/setup/FIREBASE_SETUP.md).
class StubAuthRepository implements AuthRepository {
  UserEntity? _currentUser;

  final StreamController<UserEntity?> _controller =
      StreamController<UserEntity?>.broadcast();

  @override
  Stream<UserEntity?> get authStateChanges async* {
    yield _currentUser;
    yield* _controller.stream;
  }

  @override
  UserEntity? get currentUser => _currentUser;

  @override
  Future<Result<UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) => _fakeSignIn(
    UserEntity(id: 'stub-email-user', email: email, displayName: 'Stub User'),
  );

  @override
  Future<Result<UserEntity>> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) => _fakeSignIn(
    UserEntity(id: 'stub-new-user', email: email, displayName: 'New Stub User'),
  );

  @override
  Future<Result<UserEntity>> signInWithGoogle() => _fakeSignIn(
    const UserEntity(
      id: 'stub-google-user',
      email: 'stub.google@example.com',
      displayName: 'Stub Google User',
    ),
  );

  @override
  Future<Result<UserEntity>> signInWithApple() => _fakeSignIn(
    const UserEntity(
      id: 'stub-apple-user',
      email: 'stub.apple@example.com',
      displayName: 'Stub Apple User',
    ),
  );

  @override
  Future<Result<UserEntity>> signInAnonymously() => _fakeSignIn(
    const UserEntity(id: 'stub-anonymous-user', isAnonymous: true),
  );

  @override
  Future<Result<void>> sendPasswordResetEmail(String email) async {
    await Future<void>.delayed(AppConstants.durationStubNetwork);
    return const Success<void>(null);
  }

  @override
  Future<Result<void>> signOut() async {
    _currentUser = null;
    _controller.add(null);
    return const Success<void>(null);
  }

  /// Simulates a network round-trip, then signs [user] in and emits it.
  Future<Result<UserEntity>> _fakeSignIn(UserEntity user) async {
    await Future<void>.delayed(AppConstants.durationStubNetwork);
    _currentUser = user;
    _controller.add(user);
    return Success(user);
  }
}

/// Provides the app-wide [AuthRepository] binding.
///
/// Defaults to [StubAuthRepository]. To use Firebase, override this
/// provider with a `FirebaseAuthRepositoryImpl` instance (flavor-based
/// selection is planned; see docs/planning/PRODUCTION_ROADMAP.md Phase 1).
@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  return StubAuthRepository();
}
