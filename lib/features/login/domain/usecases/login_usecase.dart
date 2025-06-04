import '../entities/login_entity.dart';
import '../repositories/login_repository.dart';

class LoginUseCase {
  final LoginRepository repository;

  LoginUseCase(this.repository);

  Future<LoginEntity> call({
    required String email,
    required String password,
  }) async {
    // Validaciones de negocio
    if (email.trim().isEmpty) {
      throw Exception('El correo electrónico es requerido');
    }

    if (!_isValidEmail(email)) {
      throw Exception('El correo electrónico no es válido');
    }

    if (password.isEmpty) {
      throw Exception('La contraseña es requerida');
    }

    if (password.length < 4) {
      throw Exception('La contraseña debe tener al menos 4 caracteres');
    }

    return await repository.loginUser(
      email: email.trim().toLowerCase(),
      password: password,
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}