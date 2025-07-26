import '../entities/downloaded_chapter_entity.dart';
import '../repositories/downloaded_chapters_repository.dart';

class GetDownloadedChaptersUseCase {
  final DownloadedChaptersRepository repository;
  GetDownloadedChaptersUseCase(this.repository);

  Future<List<DownloadedChapterEntity>> call(String bookId) async {
    return await repository.getDownloadedChaptersByBookId(bookId);
  }
} 