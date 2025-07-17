import 'dart:io';
import 'package:dio/dio.dart';
import '../models/login_model.dart';

abstract class LoginApiService {
  Future<LoginModel> loginUser({
    required String email,
    required String password,
    String? firebaseToken,
  });
}

class LoginApiServiceImpl implements LoginApiService {
  final Dio dio;

  LoginApiServiceImpl({required this.dio});

  @override
  Future<LoginModel> loginUser({
    required String email,
    required String password,
    String? firebaseToken, // NUEVO
  }) async {
    try {
      print('[DEBUG_LOGIN_API] Enviando login con firebaseToken: ${firebaseToken != null}');
      
      final response = await dio.post(
        '/api/auth/login', // Endpoint actualizado
        data: LoginModel.loginRequest(
          email: email,
          password: password,
          firebaseToken: firebaseToken, // NUEVO
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('[DEBUG_LOGIN_API] Respuesta exitosa: ${response.data}');
        return LoginModel.fromJson(response.data);
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
          case 401:
            return Exception('Credenciales incorrectas');
          case 404:
            return Exception('Usuario no encontrado');
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