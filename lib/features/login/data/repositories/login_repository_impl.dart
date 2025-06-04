import '../../domain/entities/login_entity.dart';
import '../../domain/repositories/login_repository.dart';
import '../datasources/login_api_service.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginApiService apiService;

  LoginRepositoryImpl({required this.apiService});

  @override
  Future<LoginEntity> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      // Llamar al API
      final result = await apiService.loginUser(
        email: email,
        password: password,
      );

      // Convertir el resultado a Entity
      return result.toEntity();
    } catch (e) {
      // Re-lanzar la excepción para que sea manejada por el Cubit
      rethrow;
    }
  }
}