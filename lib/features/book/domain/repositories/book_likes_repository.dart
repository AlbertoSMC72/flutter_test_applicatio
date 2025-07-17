abstract class BookLikesRepository {
  Future<(bool isLiked, int likesCount)> getBookLikeStatus(String userId, String bookId);
  Future<(bool isLiked, int likesCount)> toggleBookLike(String userId, String bookId);
  Future<Map<int, Map<String, dynamic>>> getChaptersLikeStatus(String userId, List<int> chapterIds);
  Future<void> toggleChapterLike(String userId, int chapterId);
} 