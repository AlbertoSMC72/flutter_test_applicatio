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
    String? firebaseToken, // NUEVO
  }) async {
    try {
      final result = await apiService.loginUser(
        email: email,
        password: password,
        firebaseToken: firebaseToken, // NUEVO
      );

      return result.toEntity();
    } catch (e) {
      rethrow;
    }
  }
}