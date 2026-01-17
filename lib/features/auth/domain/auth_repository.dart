import 'package:antigrav_flutter_template/features/auth/domain/user_entity.dart';

abstract class AuthRepository {
  Stream<UserEntity?> get authStateChanges;
  Future<UserEntity> signInWithEmailAndPassword(String email, String password);
  Future<void> signOut();
}
