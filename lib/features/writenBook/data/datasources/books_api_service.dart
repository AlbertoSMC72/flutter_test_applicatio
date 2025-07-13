// features/writenBook/data/datasources/books_api_service.dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../models/genre_model.dart';
import '../models/user_books_model.dart';

abstract class BooksApiService {
  Future<UserBooksModel> getUserBooks(String userId);
  Future<List<BookModel>> getUserWritingBooks(String userId);
  Future<BookModel> createBook({
    required String title,
    required String description,
    required int authorId,
    required List<int> genreIds,
    List<String>? newGenres,
    String? coverImage,
  });
  Future<BookModel> updateBook({
    required int bookId,
    String? title,
    String? description,
    List<int>? genreIds,
    List<String>? newGenres,
    String? coverImage,
  });
  Future<BookModel> publishBook({
    required int bookId,
    required bool published,
  });
  Future<bool> deleteBook(int bookId);
  Future<List<GenreModel>> getAllGenres();
  Future<GenreModel> createGenre(String name);
}

class BooksApiServiceImpl implements BooksApiService {
  final Dio dio;

  BooksApiServiceImpl({Dio? dio}) : dio = dio ?? Dio() {
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
  Future<UserBooksModel> getUserBooks(String userId) async {
    try {
      final response = await dio.get('/api/books/author/$userId');

      if (response.statusCode == 200) {
        return UserBooksModel.fromJson(response.data);
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
  Future<List<BookModel>> getUserWritingBooks(String userId) async {
    try {
      debugPrint('[DEBUG_API] Obteniendo libros del usuario: $userId');
      
      final response = await dio.get('/api/books/user/$userId/writing');
      
      debugPrint('[DEBUG_API] Respuesta getUserWritingBooks: ${response.statusCode}');
      debugPrint('[DEBUG_API] Datos: ${response.data}');

      if (response.statusCode == 200) {
        final responseData = response.data;
        
        if (responseData['success'] == true && responseData['data'] != null) {
          final List<dynamic> booksJson = responseData['data'];
          return booksJson.map((book) => BookModel.fromApiJson(book)).toList();
        } else {
          throw Exception('Respuesta inválida del servidor');
        }
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint('[DEBUG_API] DioException en getUserWritingBooks: $e');
      throw _handleDioError(e);
    } on SocketException {
      throw Exception('Sin conexión a internet');
    } catch (e) {
      debugPrint('[DEBUG_API] Error inesperado en getUserWritingBooks: $e');
      throw Exception('Error inesperado: $e');
    }
  }

  @override
  Future<BookModel> createBook({
    required String title,
    required String description,
    required int authorId,
    required List<int> genreIds,
    List<String>? newGenres,
    String? coverImage,
  }) async {
    try {
      debugPrint('[DEBUG_API] Creando libro con datos:');
      debugPrint('Title: $title');
      debugPrint('Description: $description');
      debugPrint('AuthorId: $authorId');
      debugPrint('GenreIds: $genreIds');
      debugPrint('NewGenres: $newGenres');
      debugPrint('CoverImage: ${coverImage != null ? "Sí (${coverImage.length} chars)" : "No"}');

      final requestData = {
        'title': title,
        'description': description,
        'authorId': authorId,
        'genreIds': genreIds,
        if (newGenres != null && newGenres.isNotEmpty) 'newGenres': newGenres,
        if (coverImage != null && coverImage.isNotEmpty) 'coverImage': coverImage,
      };

      final response = await dio.post(
        '/api/books',
        data: requestData,
      );

      debugPrint('[DEBUG_API] Respuesta createBook: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        
        if (responseData['success'] == true && responseData['data'] != null) {
          return BookModel.fromApiJson(responseData['data']);
        } else {
          return BookModel.fromApiJson(responseData);
        }
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint('[DEBUG_API] DioException en createBook: $e');
      throw _handleDioError(e);
    } on SocketException {
      throw Exception('Sin conexión a internet');
    } catch (e) {
      debugPrint('[DEBUG_API] Error inesperado en createBook: $e');
      throw Exception('Error inesperado: $e');
    }
  }

  @override
  Future<BookModel> updateBook({
    required int bookId,
    String? title,
    String? description,
    List<int>? genreIds,
    List<String>? newGenres,
    String? coverImage,
  }) async {
    try {
      final requestData = <String, dynamic>{};
      
      if (title != null) requestData['title'] = title;
      if (description != null) requestData['description'] = description;
      if (genreIds != null) requestData['genreIds'] = genreIds;
      if (newGenres != null && newGenres.isNotEmpty) requestData['newGenres'] = newGenres;
      if (coverImage != null) requestData['coverImage'] = coverImage;

      final response = await dio.patch(
        '/api/books/$bookId',
        data: requestData,
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        
        if (responseData['success'] == true && responseData['data'] != null) {
          return BookModel.fromApiJson(responseData['data']);
        } else {
          return BookModel.fromApiJson(responseData);
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
  Future<BookModel> publishBook({
    required int bookId,
    required bool published,
  }) async {
    try {
      final response = await dio.patch(
        '/api/books/$bookId/publish',
        data: {'published': published},
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        
        if (responseData['success'] == true && responseData['data'] != null) {
          return BookModel.fromApiJson(responseData['data']);
        } else {
          return BookModel.fromApiJson(responseData);
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
  Future<bool> deleteBook(int bookId) async {
    try {
      final response = await dio.delete('/api/books/$bookId');

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
  Future<List<GenreModel>> getAllGenres() async {
    try {
      debugPrint('[DEBUG_API] Iniciando llamada a /api/books/genres');
      
      final response = await dio.get('/api/books/genres');
      
      debugPrint('[DEBUG_API] Respuesta recibida: ${response.statusCode}');
      debugPrint('[DEBUG_API] Datos recibidos: ${response.data}');

      if (response.statusCode == 200) {
        final responseData = response.data;
        
        if (responseData['success'] == true && responseData['data'] != null) {
          final List<dynamic> genresJson = responseData['data'];
          debugPrint('[DEBUG_API] Procesando ${genresJson.length} géneros');
          
          final genres = genresJson.map((genre) {
            debugPrint('[DEBUG_API] Procesando género: $genre');
            return GenreModel.fromJson(genre);
          }).toList();
          
          debugPrint('[DEBUG_API] Géneros procesados exitosamente: ${genres.length}');
          return genres;
        } else {
          throw Exception('Respuesta inválida del servidor');
        }
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint('[DEBUG_API] DioException: ${e.type} - ${e.message}');
      throw _handleDioError(e);
    } on SocketException catch (e) {
      debugPrint('[DEBUG_API] SocketException: $e');
      throw Exception('Sin conexión a internet');
    } catch (e) {
      debugPrint('[DEBUG_API] Exception general: $e');
      throw Exception('Error inesperado: $e');
    }
  }

  @override
  Future<GenreModel> createGenre(String name) async {
    try {
      final response = await dio.post(
        '/api/books/genres',
        data: {'name': name},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        
        if (responseData['success'] == true && responseData['data'] != null) {
          return GenreModel.fromJson(responseData['data']);
        } else {
          return GenreModel.fromJson(responseData);
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