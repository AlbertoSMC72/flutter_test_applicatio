import '../entities/downloaded_book_entity.dart';
import '../repositories/downloaded_books_repository.dart';

class GetDownloadedBooksUseCase {
  final DownloadedBooksRepository repository;
  GetDownloadedBooksUseCase(this.repository);

  Future<List<DownloadedBookEntity>> call() async {
    return await repository.getAllDownloadedBooks();
  }
} 