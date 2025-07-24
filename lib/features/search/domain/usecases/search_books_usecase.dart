import '../entities/book_search_entity.dart';
import '../repositories/book_search_repository.dart';

class SearchBooksUseCase {
  final BookSearchRepository repository;
  SearchBooksUseCase(this.repository);

  Future<List<BookSearchEntity>> call(String query, String userId) async {
    return await repository.searchBooks(query, userId);
  }
} 