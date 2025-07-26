import '../entities/downloaded_chapter_entity.dart';

abstract class DownloadedChaptersRepository {
  Future<List<DownloadedChapterEntity>> getDownloadedChaptersByBookId(String bookId);
  Future<DownloadedChapterEntity?> getDownloadedChapterById(String chapterId);
} 