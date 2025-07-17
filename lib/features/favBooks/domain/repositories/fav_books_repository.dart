import '../entities/fav_book_entity.dart';
import '../entities/like_status_entity.dart';

abstract class FavBooksRepository {
  Future<List<FavBookEntity>> getUserFavBooks(String userId);
  Future<LikeStatusEntity> getBookLikeStatus(String bookId, String userId);
  Future<LikeStatusEntity> toggleBookLike(String userId, String bookId);
  Future<Map<String, dynamic>> getBookDetails(String bookId);
} 