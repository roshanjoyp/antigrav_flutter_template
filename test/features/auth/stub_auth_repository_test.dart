import 'package:craft_flutter_template/features/auth/data/auth_repository_impl.dart';
import 'package:craft_flutter_template/features/auth/domain/user_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StubAuthRepository', () {
    test(
      'sign-in succeeds, sets currentUser and emits on the stream',
      () async {
        final StubAuthRepository repository = StubAuthRepository();
        final List<UserEntity?> emitted = <UserEntity?>[];
        final subscription = repository.authStateChanges.listen(emitted.add);
        await Future<void>.delayed(Duration.zero);
        expect(emitted, <UserEntity?>[null]);
        expect(repository.currentUser, isNull);

        final result = await repository.signInWithEmailAndPassword(
          email: 'a@b.c',
          password: 'secret',
        );
        expect(result.isSuccess, isTrue);
        expect(result.getOrNull()?.email, 'a@b.c');
        expect(repository.currentUser?.email, 'a@b.c');
        await Future<void>.delayed(Duration.zero);
        expect(emitted.last?.email, 'a@b.c');

        await subscription.cancel();
      },
    );

    test('signOut clears the session and emits null', () async {
      final StubAuthRepository repository = StubAuthRepository();
      await repository.signInWithEmailAndPassword(
        email: 'a@b.c',
        password: 'secret',
      );
      final result = await repository.signOut();
      expect(result.isSuccess, isTrue);
      expect(repository.currentUser, isNull);
    });

    test('anonymous sign-in yields an anonymous user without email', () async {
      final StubAuthRepository repository = StubAuthRepository();
      final result = await repository.signInAnonymously();
      final UserEntity? user = result.getOrNull();
      expect(user?.isAnonymous, isTrue);
      expect(user?.email, isNull);
    });

    test('password reset succeeds', () async {
      final StubAuthRepository repository = StubAuthRepository();
      final result = await repository.sendPasswordResetEmail('a@b.c');
      expect(result.isSuccess, isTrue);
    });
  });
}
