import 'dart:io';
import 'package:dio/dio.dart';
import '../models/home_book_model.dart';

abstract class HomeApiService {
  Future<List<HomeBookModel>> getAllBooks();
}

class HomeApiServiceImpl implements HomeApiService {
  final Dio dio;

  HomeApiServiceImpl({required this.dio});

  @override
  Future<List<HomeBookModel>> getAllBooks() async {
    try {
      print('[DEBUG_HOME_API] Iniciando llamada a /books/');
      
      final response = await dio.get('/books/');
      
      print('[DEBUG_HOME_API] Respuesta recibida: ${response.statusCode}');
      print('[DEBUG_HOME_API] Datos recibidos: ${response.data}');

      if (response.statusCode == 200) {
        final List<dynamic> booksJson = response.data;
        print('[DEBUG_HOME_API] Procesando ${booksJson.length} libros');
        
        final books = booksJson.map((book) {
          print('[DEBUG_HOME_API] Procesando libro: $book');
          return HomeBookModel.fromJson(book);
        }).toList();
        
        print('[DEBUG_HOME_API] Libros procesados exitosamente: ${books.length}');
        return books;
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('[DEBUG_HOME_API] DioException: ${e.type} - ${e.message}');
      throw _handleDioError(e);
    } on SocketException catch (e) {
      print('[DEBUG_HOME_API] SocketException: $e');
      throw Exception('Sin conexión a internet');
    } catch (e) {
      print('[DEBUG_HOME_API] Exception general: $e');
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
            return Exception('Libros no encontrados');
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