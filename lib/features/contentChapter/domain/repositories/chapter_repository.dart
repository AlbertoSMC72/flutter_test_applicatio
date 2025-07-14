import '../entities/chapter_entity.dart';

abstract class ChapterRepository {
  Future<ChapterDetailEntity> getChapterDetail(String chapterId);
  Future<List<ParagraphEntity>> addParagraphs(String chapterId, List<String> paragraphs);
  Future<bool> addComment(String chapterId, String userId, String comment);
} 