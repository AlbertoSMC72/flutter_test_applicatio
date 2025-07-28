import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '/../../core/consts/api_urls.dart';
import '/../../features/profile/data/models/follow_user_model.dart';
import '/../../features/profile/data/models/profile_model.dart';

abstract class ProfileApiService {
  Future<Profile> getProfile(String userId);
  Future<Profile> getUserProfile(String userId, String requesterId);
  Future<Profile> updateProfile(String userId, Map<String, dynamic> updates);
  Future<Profile> updateProfilePicture(String userId, String profilePicture);
  Future<Profile> updateBanner(String userId, String banner);
  Future<FollowResponse> followUser(int userId, int targetUserId);
}

class ProfileApiServiceImpl implements ProfileApiService {
  final Dio dio;

  ProfileApiServiceImpl({required this.dio});
  
  @override
  Future<Profile> getProfile(String userId) async {
    try {
      final response = await dio.get(ApiUrls.profile.replaceAll('{userId}', userId));
      if (response.statusCode == 200) {
        return Profile.fromJson(response.data['data']);
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

  @override
  Future<Profile> getUserProfile(String userId, String requesterId) async {
    debugPrint('[DEBUG_PROFILE] DataSource: userId: $userId (${userId.runtimeType}), requesterId: $requesterId (${requesterId.runtimeType})');
    if (userId.isEmpty || requesterId.isEmpty || 
        int.tryParse(userId) == null || int.tryParse(requesterId) == null) {
      debugPrint('[DEBUG_PROFILE] DataSource: Error con los datos recibidos');
      throw Exception('ID de usuario inválido');
    }
    try {
      final url = ApiUrls.externalUserProfile
      .replaceAll('{userId}', requesterId)
      .replaceAll('{requesterId}', userId);
      debugPrint('[DEBUG_PROFILE] URL final: $url');

      final response = await dio.get(ApiUrls.externalUserProfile
      .replaceAll('{userId}', requesterId)
      .replaceAll('{requesterId}', userId),
      );

      if (response.statusCode == 200) {
        return Profile.fromJson(response.data['data']);
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

  @override
  Future<Profile> updateProfile(String userId, Map<String, dynamic> updates) async {
    try {
      final response = await dio.patch(
        ApiUrls.profileInfo.replaceAll('{userId}', userId), 
        data: updates
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        return Profile.fromJson(data);
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

  @override
  Future<Profile> updateProfilePicture(String userId, String base64Image) async {
    try {
      // Construir la URL completa correctamente
      final url = '${ApiUrls.apiUrlProfile}${ApiUrls.profilePicture}'.replaceAll('{userId}', userId);

      final response = await dio.patch(
        url,
        data: jsonEncode({
          'profilePicture': base64Image,
        }),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        return Profile.fromJson(data);
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

  @override
  Future<Profile> updateBanner(String userId, String base64Image) async {
    try {
      // Construir la URL completa correctamente
      final url = '${ApiUrls.apiUrlProfile}${ApiUrls.banner}'.replaceAll('{userId}', userId);

      final response = await dio.patch(
        url,
        data: jsonEncode({
          'banner': base64Image,
        }),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        return Profile.fromJson(data);
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

  @override
  Future<FollowResponse> followUser(int userId, int targetUserId) async {
    try {
      final response = await dio.post(
        ApiUrls.followUser
            .replaceAll('{userId}', userId.toString())
            .replaceAll('{targetUserId}', targetUserId.toString()),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        return FollowResponse.fromJson(data);
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
          case 404:
            return Exception('Recurso no encontrado');
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