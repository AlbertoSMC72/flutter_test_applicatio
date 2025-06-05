// features/writenBook/data/repositories/books_repository_impl.dart
import '../../domain/entities/book_entity.dart';
import '../../domain/entities/genre_entity.dart';
import '../../domain/entities/user_books_entity.dart';
import '../../domain/repositories/books_repository.dart';
import '../datasources/books_api_service.dart';

class BooksRepositoryImpl implements BooksRepository {
  final BooksApiService apiService;

  BooksRepositoryImpl({required this.apiService});

  @override
  Future<UserBooksEntity> getUserBooks(String userId) async {
    try {
      final result = await apiService.getUserBooks(userId);
      return result.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BookEntity> createBook({
    required String title,
    required String description,
    required int authorId,
    required List<int> genreIds,
  }) async {
    try {
      final result = await apiService.createBook(
        title: title,
        description: description,
        authorId: authorId,
        genreIds: genreIds,
      );
      return result.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<GenreEntity>> getAllGenres() async {
    try {
      final result = await apiService.getAllGenres();
      return result.map((genre) => genre.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<GenreEntity> createGenre(String name) async {
    try {
      final result = await apiService.createGenre(name);
      return result.toEntity();
    } catch (e) {
      rethrow;
    }
  }
}