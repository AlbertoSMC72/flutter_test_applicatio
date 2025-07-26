import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/downloaded_book_entity.dart';
import '../../domain/usecases/get_downloaded_books_usecase.dart';

part 'downloaded_books_state.dart';

class DownloadedBooksCubit extends Cubit<DownloadedBooksState> {
  final GetDownloadedBooksUseCase getDownloadedBooksUseCase;

  DownloadedBooksCubit(this.getDownloadedBooksUseCase) : super(DownloadedBooksInitial());

  Future<void> loadDownloadedBooks() async {
    emit(DownloadedBooksLoading());
    try {
      final books = await getDownloadedBooksUseCase();
      emit(DownloadedBooksLoaded(books));
    } catch (e) {
      emit(DownloadedBooksError(e.toString()));
    }
  }
} 