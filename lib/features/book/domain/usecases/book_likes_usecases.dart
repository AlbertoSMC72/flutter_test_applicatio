import '../repositories/book_likes_repository.dart';

class GetBookLikeStatusUseCase {
  final BookLikesRepository repo;
  GetBookLikeStatusUseCase(this.repo);
  Future<(bool, int)> call(String userId, String bookId) => repo.getBookLikeStatus(userId, bookId);
}

class ToggleBookLikeUseCase {
  final BookLikesRepository repo;
  ToggleBookLikeUseCase(this.repo);
  Future<(bool, int)> call(String userId, String bookId) => repo.toggleBookLike(userId, bookId);
}

class GetChaptersLikeStatusUseCase {
  final BookLikesRepository repo;
  GetChaptersLikeStatusUseCase(this.repo);
  Future<Map<int, Map<String, dynamic>>> call(String userId, List<int> chapterIds) => repo.getChaptersLikeStatus(userId, chapterIds);
}

class ToggleChapterLikeUseCase {
  final BookLikesRepository repo;
  ToggleChapterLikeUseCase(this.repo);
  Future<void> call(String userId, int chapterId) => repo.toggleChapterLike(userId, chapterId);
} 