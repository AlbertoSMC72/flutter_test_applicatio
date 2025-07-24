import '../../domain/entities/book_search_entity.dart';

abstract class BookSearchState {}

class BookSearchInitial extends BookSearchState {}
class BookSearchLoading extends BookSearchState {}
class BookSearchLoaded extends BookSearchState {
  final List<BookSearchEntity> books;
  BookSearchLoaded(this.books);
}
class BookSearchError extends BookSearchState {
  final String message;
  BookSearchError(this.message);
} 