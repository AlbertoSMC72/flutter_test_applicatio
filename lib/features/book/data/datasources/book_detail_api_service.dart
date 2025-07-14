import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/book_detail_model.dart';

abstract class BookDetailApiService {
  Future<BookDetailModel> getBookDetail(String bookId, String userId);
  Future<BookDetailModel> updateBook(String bookId, Map<String, dynamic> updates);
  Future<BookDetailModel> publishBook(String bookId, bool published);
  Future<ChapterModel> addChapter(String bookId, String title);
  Future<bool> toggleChapterPublish(String chapterId, bool published);
  Future<bool> deleteChapter(String chapterId);
  Future<bool> deleteBook(String bookId);
  Future<CommentModel> addComment(String bookId, String userId, String comment);
}

class BookDetailApiServiceImpl implements BookDetailApiService {
  final Dio dio;

  BookDetailApiServiceImpl({Dio? dio}) : dio = dio ?? Dio() {
    _setupDio();
  }

  void _setupDio() {
    dio.options = BaseOptions(
      baseUrl: 'https://bookservicewatpato-production.up.railway.app',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  @override
  Future<BookDetailModel> getBookDetail(String bookId, String userId) async {
    try {
      debugPrint('[DEBUG_BOOK_DETAIL] Obteniendo detalles del libro: $bookId para usuario: $userId');
      
      final response = await dio.get('/api/books/$bookId?userId=$userId');
      
      debugPrint('[DEBUG_BOOK_DETAIL] Respuesta: ${response.statusCode}');
      debugPrint('[DEBUG_BOOK_DETAIL] Datos: ${response.data}');

      if (response.statusCode == 200) {
        final responseData = response.data;
        
        if (responseData['success'] == true && responseData['data'] != null) {
          return BookDetailModel.fromJson(responseData['data']);
        } else {
          throw Exception('Respuesta inválida del servidor');
        }
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint('[DEBUG_BOOK_DETAIL] DioException: $e');
      throw _handleDioError(e);
    } on SocketException {
      throw Exception('Sin conexión a internet');
    } catch (e) {
      debugPrint('[DEBUG_BOOK_DETAIL] Error inesperado: $e');
      throw Exception('Error inesperado: $e');
    }
  }

  @override
  Future<ChapterModel> addChapter(String bookId, String title) async {
    try {
      debugPrint('[DEBUG_BOOK_DETAIL] Agregando capítulo al libro: $bookId');
      
      final response = await dio.post(
        '/api/books/$bookId/chapters',
        data: {'title': title},
      );
      
      debugPrint('[DEBUG_BOOK_DETAIL] Respuesta addChapter: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        
        if (responseData['success'] == true && responseData['data'] != null) {
          return ChapterModel.fromJson(responseData['data']);
        } else {
          return ChapterModel.fromJson(responseData);
        }
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
  Future<bool> toggleChapterPublish(String chapterId, bool published) async {
    try {
      debugPrint('[DEBUG_BOOK_DETAIL] Cambiando estado de publicación del capítulo: $chapterId a $published');
      
      final response = await dio.patch(
        '/api/books/chapters/$chapterId/publish',
        data: {'published': published},
      );
      
      debugPrint('[DEBUG_BOOK_DETAIL] Respuesta toggleChapterPublish: ${response.statusCode}');

      if (response.statusCode == 200) {
        return true;
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
  Future<bool> deleteChapter(String chapterId) async {
    try {
      debugPrint('[DEBUG_BOOK_DETAIL] Eliminando capítulo: $chapterId');
      
      final response = await dio.delete('/api/books/chapters/$chapterId');
      
      debugPrint('[DEBUG_BOOK_DETAIL] Respuesta deleteChapter: ${response.statusCode}');

      if (response.statusCode == 200) {
        return true;
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
  Future<bool> deleteBook(String bookId) async {
    try {
      debugPrint('[DEBUG_BOOK_DETAIL] Eliminando libro: $bookId');
      
      final response = await dio.delete('/api/books/$bookId');
      
      debugPrint('[DEBUG_BOOK_DETAIL] Respuesta deleteBook: ${response.statusCode}');

      if (response.statusCode == 200) {
        return true;
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
  Future<BookDetailModel> updateBook(String bookId, Map<String, dynamic> updates) async {
    try {
      debugPrint('[DEBUG_BOOK_DETAIL] Actualizando libro: $bookId');
      
      final response = await dio.patch(
        '/api/books/$bookId',
        data: updates,
      );
      
      debugPrint('[DEBUG_BOOK_DETAIL] Respuesta updateBook: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = response.data;
        
        if (responseData['success'] == true && responseData['data'] != null) {
          return BookDetailModel.fromJson(responseData['data']);
        } else {
          return BookDetailModel.fromJson(responseData);
        }
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
  Future<BookDetailModel> publishBook(String bookId, bool published) async {
    try {
      debugPrint('[DEBUG_BOOK_DETAIL] Publicando libro: $bookId');
      
      final response = await dio.patch(
        '/api/books/$bookId/publish',
        data: {'published': published},
      );
      
      debugPrint('[DEBUG_BOOK_DETAIL] Respuesta publishBook: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = response.data;
        
        if (responseData['success'] == true && responseData['data'] != null) {
          return BookDetailModel.fromJson(responseData['data']);
        } else {
          return BookDetailModel.fromJson(responseData);
        }
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
  Future<CommentModel> addComment(String bookId, String userId, String comment) async {
    try {
      debugPrint('[DEBUG_BOOK_DETAIL] Agregando comentario al libro: $bookId');
      
      final response = await dio.post(
        '/api/books/$bookId/comments',
        data: {
          'userId': userId,
          'comment': comment,
        },
      );
      
      debugPrint('[DEBUG_BOOK_DETAIL] Respuesta addComment: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        
        if (responseData['success'] == true && responseData['data'] != null) {
          return CommentModel.fromJson(responseData['data']);
        } else {
          return CommentModel.fromJson(responseData);
        }
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