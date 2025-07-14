import '../entities/book_detail_entity.dart';

abstract class BookDetailRepository {
  Future<BookDetailEntity> getBookDetail(String bookId, String userId);
  Future<BookDetailEntity> updateBook(String bookId, Map<String, dynamic> updates);
  Future<BookDetailEntity> publishBook(String bookId, bool published);
  Future<ChapterEntity> addChapter(String bookId, String title);
  Future<bool> toggleChapterPublish(String chapterId, bool published);
  Future<bool> deleteChapter(String chapterId);
  Future<bool> deleteBook(String bookId);
  Future<CommentEntity> addComment(String bookId, String userId, String comment);
} 