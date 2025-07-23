import '../../domain/entities/downloaded_book_entity.dart';
import '../../domain/repositories/downloaded_books_repository.dart';
import '../../../../core/services/download_service.dart';
import 'dart:convert';

class DownloadedBooksRepositoryImpl implements DownloadedBooksRepository {
  final DownloadService downloadService;
  DownloadedBooksRepositoryImpl(this.downloadService);

  @override
  Future<List<DownloadedBookEntity>> getAllDownloadedBooks() async {
    final db = await downloadService.database;
    final result = await db.query('books');
    return result.map((row) => DownloadedBookEntity(
      id: row['id'] as String,
      title: row['title'] as String,
      description: row['description'] as String,
      genres: (jsonDecode(row['genres'] as String) as List).map((e) => e.toString()).toList(),
      author: row['author'] as String,
      coverImageBase64: row['coverImage'] as String,
    )).toList();
  }

  @override
  Future<void> deleteDownloadedBook(String bookId) async {
    await downloadService.deleteBook(bookId);
  }
} 