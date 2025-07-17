import 'dart:io';
import 'package:dio/dio.dart';
import '../models/user_model.dart';

abstract class RegisterApiService {
  Future<UserModel> registerUser(UserModel user);
}

class RegisterApiServiceImpl implements RegisterApiService {
  final Dio dio;

  RegisterApiServiceImpl({required this.dio});

  @override
  Future<UserModel> registerUser(UserModel user) async {
    try {
      final response = await dio.post(
        '/api/auth/register',
        data: user.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserModel.fromJson(response.data);
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } on SocketException {
      throw Exception('Sin conexión a internet');
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Tiempo de conexión agotado');
      
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final responseData = error.response?.data;
        
        switch (statusCode) {
          case 400:
            final message = responseData is Map && responseData['message'] != null
                ? responseData['message']
                : 'Datos inválidos';
            return Exception(message);
          case 409:
            return Exception('El usuario o correo ya existe');
          case 500:
            return Exception('Error interno del servidor');
          default:
            return Exception('Error del servidor: $statusCode');
        }
      
      case DioExceptionType.connectionError:
        return Exception('Error de conexión. Verifica tu internet');
      
      case DioExceptionType.cancel:
        return Exception('Petición cancelada');
      
      default:
        return Exception('Error de red: ${error.message}');
    }
  }
}