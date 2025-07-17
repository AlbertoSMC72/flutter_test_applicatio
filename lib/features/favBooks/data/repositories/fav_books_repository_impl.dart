import '../../domain/entities/fav_book_entity.dart';
import '../../domain/entities/like_status_entity.dart';
import '../../domain/repositories/fav_books_repository.dart';
import '../datasources/fav_books_api_service.dart';

class FavBooksRepositoryImpl implements FavBooksRepository {
  final FavBooksApiService apiService;

  FavBooksRepositoryImpl(this.apiService);

  @override
  Future<List<FavBookEntity>> getUserFavBooks(String userId) async {
    try {
      final favBooks = await apiService.getUserFavBooks(userId);
      return favBooks;
    } catch (e) {
      throw Exception('Error en el repositorio: $e');
    }
  }

  @override
  Future<LikeStatusEntity> getBookLikeStatus(String bookId, String userId) async {
    try {
      final likeStatus = await apiService.getBookLikeStatus(bookId, userId);
      return likeStatus;
    } catch (e) {
      throw Exception('Error en el repositorio: $e');
    }
  }

  @override
  Future<LikeStatusEntity> toggleBookLike(String userId, String bookId) async {
    try {
      final likeStatus = await apiService.toggleBookLike(userId, bookId);
      return likeStatus;
    } catch (e) {
      throw Exception('Error en el repositorio: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getBookDetails(String bookId) async {
    try {
      final bookDetails = await apiService.getBookDetails(bookId);
      return bookDetails;
    } catch (e) {
      throw Exception('Error en el repositorio: $e');
    }
  }
} 