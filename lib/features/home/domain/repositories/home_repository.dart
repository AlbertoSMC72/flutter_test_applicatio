import '../entities/home_book_entity.dart';

abstract class HomeRepository {
  Future<List<HomeBookEntity>> getAllBooks();
}