import '../../domain/entities/book_detail_entity.dart';
import '../../domain/repositories/book_detail_repository.dart';
import '../datasources/book_detail_api_service.dart';

class BookDetailRepositoryImpl implements BookDetailRepository {
  final BookDetailApiService apiService;

  BookDetailRepositoryImpl({required this.apiService});

  @override
  Future<BookDetailEntity> getBookDetail(String bookId, String userId) async {
    try {
      final result = await apiService.getBookDetail(bookId, userId);
      return result.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ChapterEntity> addChapter(String bookId, String title) async {
    try {
      final result = await apiService.addChapter(bookId, title);
      return ChapterEntity(
        id: result.id,
        title: result.title,
        published: result.published,
        createdAt: result.createdAt,
        isLiked: result.isLiked,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> toggleChapterPublish(String chapterId, bool published) async {
    try {
      return await apiService.toggleChapterPublish(chapterId, published);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> deleteChapter(String chapterId) async {
    try {
      return await apiService.deleteChapter(chapterId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> deleteBook(String bookId) async {
    try {
      return await apiService.deleteBook(bookId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CommentEntity> addComment(String bookId, String userId, String comment) async {
    try {
      final result = await apiService.addComment(bookId, userId, comment);
      return CommentEntity(
        id: result.id,
        comment: result.comment,
        createdAt: result.createdAt,
        user: result.user != null ? UserEntity(
          username: result.user!.username,
          profilePicture: result.user!.profilePicture,
        ) : null,
      );
    } catch (e) {
      rethrow;
    }
  }
} 