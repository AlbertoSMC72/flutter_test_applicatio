import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/fav_books_usecases.dart';
import '../../domain/entities/fav_book_entity.dart';
import '../../data/models/fav_book_model.dart';
import 'fav_books_state.dart';

class FavBooksCubit extends Cubit<FavBooksState> {
  final GetUserFavBooksUseCase getUserFavBooksUseCase;
  final GetBookLikeStatusUseCase getBookLikeStatusUseCase;
  final ToggleBookLikeUseCase toggleBookLikeUseCase;

  List<FavBookEntity> _currentBooks = [];

  FavBooksCubit({
    required this.getUserFavBooksUseCase,
    required this.getBookLikeStatusUseCase,
    required this.toggleBookLikeUseCase,
  }) : super(FavBooksInitial());

  Future<void> getUserFavBooks(String userId) async {
    emit(FavBooksLoading());
    try {
      final books = await getUserFavBooksUseCase.call(userId);
      _currentBooks = books;
      emit(FavBooksLoaded(books));
    } catch (e) {
      emit(FavBooksError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> getBookLikeStatus(String bookId, String userId) async {
    try {
      final likeStatus = await getBookLikeStatusUseCase.call(bookId, userId);
      emit(LikeStatusLoaded(bookId, likeStatus));
    } catch (e) {
      emit(FavBooksError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> toggleBookLike(String userId, String bookId) async {
    try {
      final likeStatus = await toggleBookLikeUseCase.call(userId, bookId);
      final message = likeStatus.isLiked 
          ? 'Libro agregado a favoritos' 
          : 'Libro removido de favoritos';
      
      // Si el libro fue removido de favoritos, actualizar la lista local
      if (!likeStatus.isLiked) {
        _currentBooks.removeWhere((book) => book.book.id == bookId);
        emit(FavBooksLoaded(_currentBooks));
      } else {
        // Si fue agregado, actualizar el contador en la lista local
        final index = _currentBooks.indexWhere((book) => book.book.id == bookId);
        if (index != -1) {
          final updatedBook = _currentBooks[index].copyWith(
            book: (_currentBooks[index].book as BookModel).copyWith(
              likesCount: likeStatus.likesCount,
              isLiked: likeStatus.isLiked,
            ),
          );
          _currentBooks[index] = updatedBook;
          emit(FavBooksLoaded(_currentBooks));
        }
      }
      
      emit(LikeToggled(bookId, likeStatus, message));
    } catch (e) {
      emit(FavBooksError(e.toString().replaceFirst('Exception: ', '')));
    }
  }
} 