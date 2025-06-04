// features/register/domain/usecases/register_usecase.dart
import '../entities/user_entity.dart';
import '../repositories/register_repository.dart';

class RegisterUseCase {
  final RegisterRepository repository;

  RegisterUseCase(this.repository);

  Future<UserEntity> call({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    // Validaciones de negocio
    if (username.trim().isEmpty) {
      throw Exception('El nombre de usuario es requerido');
    }

    if (!_isValidEmail(email)) {
      throw Exception('El correo electrónico no es válido');
    }

    if (password.length < 4) {
      throw Exception('La contraseña debe tener al menos 4 caracteres');
    }

    if (password != confirmPassword) {
      throw Exception('Las contraseñas no coinciden');
    }

    return await repository.registerUser(
      username: username.trim(),
      email: email.trim().toLowerCase(),
      password: password,
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}