import '../entities/book_entity.dart';
import '../entities/genre_entity.dart';
import '../entities/user_books_entity.dart';

abstract class BooksRepository {
  Future<UserBooksEntity> getUserBooks(String userId);
  Future<List<BookEntity>> getUserWritingBooks(String userId);
  Future<BookEntity> createBook({
    required String title,
    required String description,
    required int authorId,
    required List<int> genreIds,
    List<String>? newGenres,
    String? coverImage,
  });
  Future<BookEntity> updateBook({
    required int bookId,
    String? title,
    String? description,
    List<int>? genreIds,
    List<String>? newGenres,
    String? coverImage,
  });
  Future<BookEntity> publishBook({
    required int bookId,
    required bool published,
  });
  Future<bool> deleteBook(int bookId);
  Future<List<GenreEntity>> getAllGenres();
  Future<GenreEntity> createGenre(String name);
}