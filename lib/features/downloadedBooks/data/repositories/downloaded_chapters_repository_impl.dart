import '../../domain/entities/downloaded_chapter_entity.dart';
import '../../domain/repositories/downloaded_chapters_repository.dart';
import '../../../../core/services/download_service.dart';

class DownloadedChaptersRepositoryImpl implements DownloadedChaptersRepository {
  final DownloadService downloadService;
  DownloadedChaptersRepositoryImpl(this.downloadService);

  @override
  Future<List<DownloadedChapterEntity>> getDownloadedChaptersByBookId(String bookId) async {
    final db = await downloadService.database;
    final result = await db.query('chapters', where: 'bookId = ?', whereArgs: [bookId]);
    return result.map((row) => DownloadedChapterEntity(
      id: row['id'] as String,
      bookId: row['bookId'] as String,
      title: row['title'] as String,
      content: row['content'] as String,
    )).toList();
  }

  @override
  Future<DownloadedChapterEntity?> getDownloadedChapterById(String chapterId) async {
    final db = await downloadService.database;
    final result = await db.query('chapters', where: 'id = ?', whereArgs: [chapterId]);
    if (result.isNotEmpty) {
      final row = result.first;
      return DownloadedChapterEntity(
        id: row['id'] as String,
        bookId: row['bookId'] as String,
        title: row['title'] as String,
        content: row['content'] as String,
      );
    }
    return null;
  }
} 