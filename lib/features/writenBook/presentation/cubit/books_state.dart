// features/writenBook/presentation/cubit/books_state.dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/book_entity.dart';
import '../../domain/entities/genre_entity.dart';
import '../../domain/entities/user_books_entity.dart';

abstract class BooksState extends Equatable {
  const BooksState();

  @override
  List<Object?> get props => [];
}

class BooksInitial extends BooksState {
  const BooksInitial();
}

class BooksLoading extends BooksState {
  const BooksLoading();
}

class BooksLoaded extends BooksState {
  final UserBooksEntity userBooks;

  const BooksLoaded({required this.userBooks});

  @override
  List<Object?> get props => [userBooks];
}

class BooksError extends BooksState {
  final String message;

  const BooksError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Estados para creación de libro
class BookCreating extends BooksState {
  const BookCreating();
}

class BookCreated extends BooksState {
  final BookEntity book;
  final String message;

  const BookCreated({
    required this.book,
    this.message = 'Libro creado exitosamente',
  });

  @override
  List<Object?> get props => [book, message];
}

class BookCreationError extends BooksState {
  final String message;

  const BookCreationError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Estados para géneros
class GenresLoading extends BooksState {
  const GenresLoading();
}

class GenresLoaded extends BooksState {
  final List<GenreEntity> genres;

  const GenresLoaded({required this.genres});

  @override
  List<Object?> get props => [genres];
}

class GenresError extends BooksState {
  final String message;

  const GenresError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Estados para creación de género
class GenreCreating extends BooksState {
  const GenreCreating();
}

class GenreCreated extends BooksState {
  final GenreEntity genre;
  final String message;

  const GenreCreated({
    required this.genre,
    this.message = 'Género creado exitosamente',
  });

  @override
  List<Object?> get props => [genre, message];
}

class GenreCreationError extends BooksState {
  final String message;

  const GenreCreationError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Estado combinado para el formulario de creación
class BooksFormState extends BooksState {
  final List<GenreEntity> genres;
  final bool isLoadingGenres;
  final bool isCreatingBook;
  final String? formError;

  const BooksFormState({
    this.genres = const [],
    this.isLoadingGenres = false,
    this.isCreatingBook = false,
    this.formError,
  });

  BooksFormState copyWith({
    List<GenreEntity>? genres,
    bool? isLoadingGenres,
    bool? isCreatingBook,
    String? formError,
  }) {
    return BooksFormState(
      genres: genres ?? this.genres,
      isLoadingGenres: isLoadingGenres ?? this.isLoadingGenres,
      isCreatingBook: isCreatingBook ?? this.isCreatingBook,
      formError: formError,
    );
  }

  @override
  List<Object?> get props => [genres, isLoadingGenres, isCreatingBook, formError];
}