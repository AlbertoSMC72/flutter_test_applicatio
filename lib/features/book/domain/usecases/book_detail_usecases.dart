import '../entities/book_detail_entity.dart';
import '../repositories/book_detail_repository.dart';

class GetBookDetailUseCase {
  final BookDetailRepository repository;

  GetBookDetailUseCase({required this.repository});

  Future<BookDetailEntity> call(String bookId, String userId) async {
    return await repository.getBookDetail(bookId, userId);
  }
}

class AddChapterUseCase {
  final BookDetailRepository repository;

  AddChapterUseCase({required this.repository});

  Future<ChapterEntity> call(String bookId, String title) async {
    return await repository.addChapter(bookId, title);
  }
}

class ToggleChapterPublishUseCase {
  final BookDetailRepository repository;

  ToggleChapterPublishUseCase({required this.repository});

  Future<bool> call(String chapterId, bool published) async {
    return await repository.toggleChapterPublish(chapterId, published);
  }
}

class DeleteChapterUseCase {
  final BookDetailRepository repository;

  DeleteChapterUseCase({required this.repository});

  Future<bool> call(String chapterId) async {
    return await repository.deleteChapter(chapterId);
  }
}

class DeleteBookUseCase {
  final BookDetailRepository repository;

  DeleteBookUseCase({required this.repository});

  Future<bool> call(String bookId) async {
    return await repository.deleteBook(bookId);
  }
}

class AddCommentUseCase {
  final BookDetailRepository repository;

  AddCommentUseCase({required this.repository});

  Future<CommentEntity> call(String bookId, String userId, String comment) async {
    return await repository.addComment(bookId, userId, comment);
  }
} 