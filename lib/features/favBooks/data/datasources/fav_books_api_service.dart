import 'package:dio/dio.dart';
import '../models/fav_book_model.dart';
import '../models/like_status_model.dart';

abstract class FavBooksApiService {
  Future<List<FavBookModel>> getUserFavBooks(String userId);
  Future<LikeStatusModel> getBookLikeStatus(String bookId, String userId);
  Future<LikeStatusModel> toggleBookLike(String userId, String bookId);
  Future<Map<String, dynamic>> getBookDetails(String bookId);
}

class FavBooksApiServiceImpl implements FavBooksApiService {
  final Dio dio;

  FavBooksApiServiceImpl({required this.dio});

  @override
  Future<List<FavBookModel>> getUserFavBooks(String userId) async {
    try {
      final response = await dio.get('/likes/user/$userId/books');

      final Map<String, dynamic> jsonResponse = response.data;
      
      if (jsonResponse['success'] == true) {
        final List<dynamic> data = jsonResponse['data'] ?? [];
        final List<FavBookModel> favBooks = data.map((json) => FavBookModel.fromJson(json)).toList();
        
        // Obtener detalles completos y estado de like para cada libro
        for (int i = 0; i < favBooks.length; i++) {
          try {
            // Obtener detalles completos del libro
            final bookDetails = await getBookDetails(favBooks[i].book.id);
            final likeStatus = await getBookLikeStatus(favBooks[i].book.id, userId);
            
            // Actualizar el modelo con todos los datos
            favBooks[i] = favBooks[i].copyWith(
              book: (favBooks[i].book as BookModel).copyWith(
                coverImage: bookDetails['coverImage'] ?? favBooks[i].book.coverImage,
                likesCount: likeStatus.likesCount,
                isLiked: likeStatus.isLiked,
              ),
            );
          } catch (e) {
            // Si no se puede obtener los detalles, mantener los datos básicos
            try {
              final likeStatus = await getBookLikeStatus(favBooks[i].book.id, userId);
              favBooks[i] = favBooks[i].copyWith(
                book: (favBooks[i].book as BookModel).copyWith(
                  likesCount: likeStatus.likesCount,
                  isLiked: likeStatus.isLiked,
                ),
              );
            } catch (e) {
              // Si tampoco se puede obtener el estado, asumir que está liked
              favBooks[i] = favBooks[i].copyWith(
                book: (favBooks[i].book as BookModel).copyWith(
                  isLiked: true,
                  likesCount: 0,
                ),
              );
            }
          }
        }
        
        return favBooks;
      } else {
        throw Exception('Error en la respuesta del servidor');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Usuario no encontrado');
      } else if (e.response?.statusCode == 500) {
        throw Exception('Error interno del servidor');
      } else {
        throw Exception('Error de conexión: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error al obtener libros favoritos: $e');
    }
  }

  @override
  Future<LikeStatusModel> getBookLikeStatus(String bookId, String userId) async {
    try {
      final response = await dio.get('/likes/books/$bookId/status', 
        queryParameters: {'userId': int.parse(userId)} // Convertir a número
      );

      final Map<String, dynamic> jsonResponse = response.data;
      
      if (jsonResponse['success'] == true) {
        return LikeStatusModel.fromJson(jsonResponse['data']);
      } else {
        throw Exception('Error en la respuesta del servidor');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Libro o usuario no encontrado');
      } else if (e.response?.statusCode == 500) {
        throw Exception('Error interno del servidor');
      } else {
        throw Exception('Error de conexión: ${e.message}');
      }
    } on FormatException catch (e) {
      throw Exception('Error: userId no es un número válido');
    } catch (e) {
      throw Exception('Error al obtener estado de like: $e');
    }
  }

  @override
  Future<LikeStatusModel> toggleBookLike(String userId, String bookId) async {
    try {
      final response = await dio.post('/likes/books/toggle',
        data: {
          'userId': int.parse(userId), // Convertir a número
          'bookId': int.parse(bookId), // Convertir a número
        },
      );

      final Map<String, dynamic> jsonResponse = response.data;
      
      if (jsonResponse['success'] == true) {
        return LikeStatusModel.fromJson(jsonResponse['data']);
      } else {
        throw Exception('Error en la respuesta del servidor');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception('Datos inválidos');
      } else if (e.response?.statusCode == 404) {
        throw Exception('Libro o usuario no encontrado');
      } else if (e.response?.statusCode == 500) {
        throw Exception('Error interno del servidor');
      } else {
        throw Exception('Error de conexión: ${e.message}');
      }
    } on FormatException catch (e) {
      throw Exception('Error: userId o bookId no son números válidos');
    } catch (e) {
      throw Exception('Error al cambiar estado de like: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getBookDetails(String bookId) async {
    try {
      // Usar el servicio de libros para obtener detalles completos
      final response = await dio.get('/books/$bookId');
      
      final Map<String, dynamic> jsonResponse = response.data;
      
      if (jsonResponse['success'] == true) {
        return jsonResponse['data'] ?? {};
      } else {
        throw Exception('Error en la respuesta del servidor');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Libro no encontrado');
      } else if (e.response?.statusCode == 500) {
        throw Exception('Error interno del servidor');
      } else {
        throw Exception('Error de conexión: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error al obtener detalles del libro: $e');
    }
  }
} 