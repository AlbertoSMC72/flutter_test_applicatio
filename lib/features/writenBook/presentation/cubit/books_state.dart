// features/writenBook/presentation/cubit/books_state.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/features/writenBook/domain/entities/genre_entity.dart';
import '../../domain/entities/book_entity.dart';
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

class BooksWritingLoaded extends BooksState {
  final List<BookEntity> books;

  const BooksWritingLoaded({required this.books});

  @override
  List<Object?> get props => [books];
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

class BookUpdated extends BooksState {
  final BookEntity book;
  final String message;

  const BookUpdated({
    required this.book,
    this.message = 'Libro actualizado exitosamente',
  });

  @override
  List<Object?> get props => [book, message];
}

class BookPublicationToggled extends BooksState {
  final BookEntity book;
  final String message;

  const BookPublicationToggled({
    required this.book,
    required this.message,
  });

  @override
  List<Object?> get props => [book, message];
}

class BookDeleted extends BooksState {
  final String message;

  const BookDeleted({required this.message});

  @override
  List<Object?> get props => [message];
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
  final bool isProcessingImage;
  final String? selectedCoverImage; // Base64 string
  final String? formError;

  const BooksFormState({
    this.genres = const [],
    this.isLoadingGenres = false,
    this.isCreatingBook = false,
    this.isProcessingImage = false,
    this.selectedCoverImage,
    this.formError,
  });

  BooksFormState copyWith({
    List<GenreEntity>? genres,
    bool? isLoadingGenres,
    bool? isCreatingBook,
    bool? isProcessingImage,
    String? selectedCoverImage,
    String? formError,
  }) {
    return BooksFormState(
      genres: genres ?? this.genres,
      isLoadingGenres: isLoadingGenres ?? this.isLoadingGenres,
      isCreatingBook: isCreatingBook ?? this.isCreatingBook,
      isProcessingImage: isProcessingImage ?? this.isProcessingImage,
      selectedCoverImage: selectedCoverImage ?? this.selectedCoverImage,
      formError: formError,
    );
  }

  @override
  List<Object?> get props => [
    genres, 
    isLoadingGenres, 
    isCreatingBook, 
    isProcessingImage,
    selectedCoverImage,
    formError
  ];
}