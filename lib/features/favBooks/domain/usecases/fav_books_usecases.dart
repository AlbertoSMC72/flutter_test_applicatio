import '../entities/fav_book_entity.dart';
import '../entities/like_status_entity.dart';
import '../repositories/fav_books_repository.dart';

class GetUserFavBooksUseCase {
  final FavBooksRepository repository;

  GetUserFavBooksUseCase(this.repository);

  Future<List<FavBookEntity>> call(String userId) async {
    return await repository.getUserFavBooks(userId);
  }
}

class GetBookLikeStatusUseCase {
  final FavBooksRepository repository;

  GetBookLikeStatusUseCase(this.repository);

  Future<LikeStatusEntity> call(String bookId, String userId) async {
    return await repository.getBookLikeStatus(bookId, userId);
  }
}

class ToggleBookLikeUseCase {
  final FavBooksRepository repository;

  ToggleBookLikeUseCase(this.repository);

  Future<LikeStatusEntity> call(String userId, String bookId) async {
    return await repository.toggleBookLike(userId, bookId);
  }
}

class GetBookDetailsUseCase {
  final FavBooksRepository repository;

  GetBookDetailsUseCase(this.repository);

  Future<Map<String, dynamic>> call(String bookId) async {
    return await repository.getBookDetails(bookId);
  }
} 