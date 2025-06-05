// features/writenBook/data/datasources/books_api_service.dart
import 'dart:io';
import 'package:dio/dio.dart';
import '../models/book_model.dart';
import '../models/genre_model.dart';
import '../models/user_books_model.dart';

abstract class BooksApiService {
  Future<UserBooksModel> getUserBooks(String userId);
  Future<BookModel> createBook({
    required String title,
    required String description,
    required int authorId,
    required List<int> genreIds,
  });
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
      baseUrl: 'https://393s0v9z-3000.usw3.devtunnels.ms',
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
        logPrint: (log) => print('[BOOKS_DIO] $log'),
      ),
    );
  }

  @override
  Future<UserBooksModel> getUserBooks(String userId) async {
    try {
      final response = await dio.get('/books/author/$userId');

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
  Future<BookModel> createBook({
    required String title,
    required String description,
    required int authorId,
    required List<int> genreIds,
  }) async {
    try {
      final response = await dio.post(
        '/books',
        data: BookModel.createBookRequest(
          title: title,
          description: description,
          authorId: authorId,
          genreIds: genreIds,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return BookModel.fromJson(response.data);
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
      print('[DEBUG_API] Iniciando llamada a /genres/all');
      
      final response = await dio.get('/genres/all');
      
      print('[DEBUG_API] Respuesta recibida: ${response.statusCode}');
      print('[DEBUG_API] Datos recibidos: ${response.data}');

      if (response.statusCode == 200) {
        final List<dynamic> genresJson = response.data;
        print('[DEBUG_API] Procesando ${genresJson.length} géneros');
        
        final genres = genresJson.map((genre) {
          print('[DEBUG_API] Procesando género: $genre');
          return GenreModel.fromJson(genre);
        }).toList();
        
        print('[DEBUG_API] Géneros procesados exitosamente: ${genres.length}');
        return genres;
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('[DEBUG_API] DioException: ${e.type} - ${e.message}');
      throw _handleDioError(e);
    } on SocketException catch (e) {
      print('[DEBUG_API] SocketException: $e');
      throw Exception('Sin conexión a internet');
    } catch (e) {
      print('[DEBUG_API] Exception general: $e');
      throw Exception('Error inesperado: $e');
    }
  }

  @override
  Future<GenreModel> createGenre(String name) async {
    try {
      final response = await dio.post(
        '/genres/',
        data: {'name': name},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return GenreModel.fromJson(response.data);
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