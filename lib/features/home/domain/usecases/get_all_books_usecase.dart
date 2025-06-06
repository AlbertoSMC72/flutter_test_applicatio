import '../entities/home_book_entity.dart';
import '../repositories/home_repository.dart';

class GetAllBooksUseCase {
  final HomeRepository repository;

  GetAllBooksUseCase(this.repository);

  Future<List<HomeBookEntity>> call() async {
    return await repository.getAllBooks();
  }
}