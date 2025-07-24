import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/search_books_usecase.dart';
import 'book_search_state.dart';

class BookSearchCubit extends Cubit<BookSearchState> {
  final SearchBooksUseCase searchBooksUseCase;

  BookSearchCubit({required this.searchBooksUseCase}) : super(BookSearchInitial());

  Future<void> searchBooks(String query, String userId) async {
    if (query.length < 2) {
      emit(BookSearchError('La búsqueda debe tener al menos 2 caracteres.'));
      return;
    }
    emit(BookSearchLoading());
    try {
      final books = await searchBooksUseCase(query, userId);
      emit(BookSearchLoaded(books));
    } catch (e) {
      emit(BookSearchError(e.toString().replaceFirst('Exception: ', '')));
    }
  }
} 