import '../../domain/repositories/book_likes_repository.dart';
import '../datasources/book_likes_api_service.dart';

class BookLikesRepositoryImpl implements BookLikesRepository {
  final BookLikesApiService api;
  BookLikesRepositoryImpl(this.api);

  @override
  Future<(bool, int)> getBookLikeStatus(String userId, String bookId) async {
    final data = await api.getBookLikeStatus(userId, bookId);
    return (data['isLiked'] as bool, data['likesCount'] as int);
  }

  @override
  Future<(bool, int)> toggleBookLike(String userId, String bookId) async {
    final data = await api.toggleBookLike(userId, bookId);
    return (data['isLiked'] as bool, data['likesCount'] as int);
  }

  @override
  Future<Map<int, Map<String, dynamic>>> getChaptersLikeStatus(String userId, List<int> chapterIds) {
    return api.getChaptersLikeStatus(userId, chapterIds);
  }

  @override
  Future<void> toggleChapterLike(String userId, int chapterId) {
    return api.toggleChapterLike(userId, chapterId);
  }
} 