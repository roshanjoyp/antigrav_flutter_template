import 'package:antigrav_flutter_template/core/utils/result.dart';
import 'package:antigrav_flutter_template/features/auth/data/firebase_auth_repository_impl.dart';
import 'package:antigrav_flutter_template/features/auth/data/firebase_federated_sign_in.dart';
import 'package:antigrav_flutter_template/features/auth/domain/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';

/// Mocktail mock of the Firebase Auth SDK entry point.
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

/// Mocktail mock of a Firebase sign-in result.
class MockUserCredential extends Mock implements UserCredential {}

/// Mocktail mock of a signed-in Firebase user.
class MockUser extends Mock implements User {}

/// Mocktail mock of the native Google sign-in flow.
class MockGoogleSignIn extends Mock implements GoogleSignIn {}

void main() {
  late MockFirebaseAuth auth;
  late FirebaseAuthRepositoryImpl repository;

  MockUser buildUser() {
    final MockUser user = MockUser();
    when(() => user.uid).thenReturn('uid-1');
    when(() => user.email).thenReturn('a@b.c');
    when(() => user.displayName).thenReturn('Alice');
    when(() => user.photoURL).thenReturn(null);
    when(() => user.isAnonymous).thenReturn(false);
    return user;
  }

  setUp(() {
    auth = MockFirebaseAuth();
    repository = FirebaseAuthRepositoryImpl(
      auth: auth,
      federated: FirebaseFederatedSignIn(
        auth: auth,
        googleSignIn: MockGoogleSignIn(),
      ),
    );
  });

  group('FirebaseAuthRepositoryImpl', () {
    test('maps a Firebase user to UserEntity on successful sign-in',
        () async {
      // Note: build the mock user *before* stubbing `credential.user` —
      // mocktail forbids calling `when` while another stub is being set up.
      final MockUser firebaseUser = buildUser();
      final MockUserCredential credential = MockUserCredential();
      when(() => credential.user).thenReturn(firebaseUser);
      when(
        () => auth.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => credential);

      final result = await repository.signInWithEmailAndPassword(
        email: 'a@b.c',
        password: 'secret',
      );

      final UserEntity? user = result.getOrNull();
      expect(user?.id, 'uid-1');
      expect(user?.email, 'a@b.c');
      expect(user?.displayName, 'Alice');
      expect(user?.isAnonymous, isFalse);
    });

    test('maps FirebaseAuthException into a Failure with auth/* code',
        () async {
      when(
        () => auth.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(FirebaseAuthException(code: 'user-disabled'));

      final result = await repository.signInWithEmailAndPassword(
        email: 'a@b.c',
        password: 'secret',
      );

      expect(result.isFailure, isTrue);
      final AppException exception =
          (result as Failure<UserEntity>).exception;
      expect(exception.code, 'auth/user-disabled');
      expect(exception.message, 'This account has been disabled.');
    });

    test('fails with auth/no-user when Firebase returns no user', () async {
      final MockUserCredential credential = MockUserCredential();
      when(() => credential.user).thenReturn(null);
      when(() => auth.signInAnonymously())
          .thenAnswer((_) async => credential);

      final result = await repository.signInAnonymously();

      expect(result.isFailure, isTrue);
      expect(
        (result as Failure<UserEntity>).exception.code,
        'auth/no-user',
      );
    });

    test('authStateChanges maps Firebase users and nulls', () async {
      final MockUser firebaseUser = buildUser();
      when(() => auth.authStateChanges()).thenAnswer(
        (_) => Stream<User?>.fromIterable(<User?>[null, firebaseUser]),
      );

      final List<UserEntity?> emitted =
          await repository.authStateChanges.toList();

      expect(emitted.length, 2);
      expect(emitted.first, isNull);
      expect(emitted.last?.id, 'uid-1');
    });

    test('signOut signs out of Firebase and succeeds', () async {
      when(() => auth.signOut()).thenAnswer((_) async {});

      final result = await repository.signOut();

      expect(result.isSuccess, isTrue);
      verify(() => auth.signOut()).called(1);
    });

    test('sendPasswordResetEmail maps failures', () async {
      when(() => auth.sendPasswordResetEmail(email: any(named: 'email')))
          .thenThrow(FirebaseAuthException(code: 'invalid-email'));

      final result = await repository.sendPasswordResetEmail('bad');

      expect(result.isFailure, isTrue);
      expect(
        (result as Failure<void>).exception.code,
        'auth/invalid-email',
      );
    });
  });
}
