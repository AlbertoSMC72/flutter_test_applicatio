import '../entities/user_entity.dart';

abstract class RegisterRepository {
  Future<UserEntity> registerUser({
    required String username,
    required String email,
    required String password,
  });
}