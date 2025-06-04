import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/register_repository.dart';
import '../datasources/register_api_service.dart';
import '../models/user_model.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final RegisterApiService apiService;

  RegisterRepositoryImpl({required this.apiService});

  @override
  Future<UserEntity> registerUser({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      // Crear el modelo para enviar al API
      final userModel = UserModel(
        username: username,
        email: email,
        password: password,
      );

      // Llamar al API
      final result = await apiService.registerUser(userModel);

      // Convertir el resultado a Entity
      return result.toEntity();
    } catch (e) {
      // Re-lanzar la excepción para que sea manejada por el Cubit
      rethrow;
    }
  }
}