import '../entities/downloaded_book_entity.dart';

abstract class DownloadedBooksRepository {
  Future<List<DownloadedBookEntity>> getAllDownloadedBooks();
  Future<void> deleteDownloadedBook(String bookId);
} 