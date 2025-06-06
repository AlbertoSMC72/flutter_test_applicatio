import '../../domain/entities/home_book_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_api_service.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeApiService apiService;

  HomeRepositoryImpl({required this.apiService});

  @override
  Future<List<HomeBookEntity>> getAllBooks() async {
    try {
      final result = await apiService.getAllBooks();
      return result.map((book) => book.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }
}