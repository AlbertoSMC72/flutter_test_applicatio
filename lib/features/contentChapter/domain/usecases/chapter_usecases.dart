import '../entities/chapter_entity.dart';
import '../repositories/chapter_repository.dart';

class GetChapterDetailUseCase {
  final ChapterRepository repository;
  GetChapterDetailUseCase({required this.repository});
  Future<ChapterDetailEntity> call(String chapterId) async {
    return await repository.getChapterDetail(chapterId);
  }
}

class AddParagraphsUseCase {
  final ChapterRepository repository;
  AddParagraphsUseCase({required this.repository});
  Future<List<ParagraphEntity>> call(String chapterId, List<String> paragraphs) async {
    return await repository.addParagraphs(chapterId, paragraphs);
  }
}

class AddCommentUseCase {
  final ChapterRepository repository;
  AddCommentUseCase({required this.repository});
  Future<bool> call(String chapterId, String userId, String comment) async {
    return await repository.addComment(chapterId, userId, comment);
  }
} 