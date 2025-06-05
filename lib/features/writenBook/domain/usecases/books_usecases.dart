// features/writenBook/domain/usecases/books_usecases.dart
import '../entities/book_entity.dart';
import '../entities/genre_entity.dart';
import '../entities/user_books_entity.dart';
import '../repositories/books_repository.dart';

class GetUserBooksUseCase {
  final BooksRepository repository;

  GetUserBooksUseCase(this.repository);

  Future<UserBooksEntity> call(String userId) async {
    if (userId.trim().isEmpty) {
      throw Exception('ID de usuario requerido');
    }

    return await repository.getUserBooks(userId);
  }
}

class CreateBookUseCase {
  final BooksRepository repository;

  CreateBookUseCase(this.repository);

  Future<BookEntity> call({
    required String title,
    required String description,
    required int authorId,
    required List<int> genreIds,
  }) async {
    // Validaciones de negocio
    if (title.trim().isEmpty) {
      throw Exception('El título es requerido');
    }

    if (title.trim().length < 3) {
      throw Exception('El título debe tener al menos 3 caracteres');
    }

    if (description.trim().isEmpty) {
      throw Exception('La descripción es requerida');
    }

    if (description.trim().length < 10) {
      throw Exception('La descripción debe tener al menos 10 caracteres');
    }

    if (authorId <= 0) {
      throw Exception('ID de autor inválido');
    }

    if (genreIds.isEmpty) {
      throw Exception('Debe seleccionar al menos un género');
    }

    return await repository.createBook(
      title: title.trim(),
      description: description.trim(),
      authorId: authorId,
      genreIds: genreIds,
    );
  }
}

class GetAllGenresUseCase {
  final BooksRepository repository;

  GetAllGenresUseCase(this.repository);

  Future<List<GenreEntity>> call() async {
    return await repository.getAllGenres();
  }
}

class CreateGenreUseCase {
  final BooksRepository repository;

  CreateGenreUseCase(this.repository);

  Future<GenreEntity> call(String name) async {
    if (name.trim().isEmpty) {
      throw Exception('El nombre del género es requerido');
    }

    if (name.trim().length < 2) {
      throw Exception('El nombre del género debe tener al menos 2 caracteres');
    }

    return await repository.createGenre(name.trim());
  }
}