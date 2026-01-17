import 'package:antigrav_flutter_template/features/auth/domain/auth_repository.dart';
import 'package:antigrav_flutter_template/features/auth/domain/user_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository_impl.g.dart';

class FirebaseAuthRepository implements AuthRepository {
  // final FirebaseAuth _auth = FirebaseAuth.instance; // Uncomment when firebase is added

  @override
  Stream<UserEntity?> get authStateChanges => Stream.value(null); // Stub

  @override
  Future<UserEntity> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    return const UserEntity(
      id: '1',
      email: 'test@example.com',
      displayName: 'Test User',
    );
  }

  @override
  Future<void> signOut() async {
    // signOut logic
  }
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  return FirebaseAuthRepository();
}
