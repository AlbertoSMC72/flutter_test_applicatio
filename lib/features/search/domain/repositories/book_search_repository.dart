import '../entities/book_search_entity.dart';

abstract class BookSearchRepository {
  Future<List<BookSearchEntity>> searchBooks(String query, String userId);
} 