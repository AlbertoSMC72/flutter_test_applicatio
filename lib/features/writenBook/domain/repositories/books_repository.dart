import '../entities/book_entity.dart';
import '../entities/genre_entity.dart';
import '../entities/user_books_entity.dart';

abstract class BooksRepository {
  Future<UserBooksEntity> getUserBooks(String userId);
  Future<BookEntity> createBook({
    required String title,
    required String description,
    required int authorId,
    required List<int> genreIds,
  });
  Future<List<GenreEntity>> getAllGenres();
  Future<GenreEntity> createGenre(String name);
}