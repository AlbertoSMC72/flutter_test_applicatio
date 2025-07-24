import '../../domain/entities/book_search_entity.dart';
import '../datasources/book_search_api_service.dart';
import '../models/book_search_model.dart';
import '../../domain/repositories/book_search_repository.dart';

class BookSearchRepositoryImpl implements BookSearchRepository {
  final BookSearchApiService apiService;
  BookSearchRepositoryImpl(this.apiService);

  @override
  Future<List<BookSearchEntity>> searchBooks(String query, String userId) async {
    final results = await apiService.searchBooks(query, userId);
    return results.map((m) => m.toEntity()).toList();
  }
} 