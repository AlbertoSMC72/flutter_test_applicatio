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

class GetUserWritingBooksUseCase {
  final BooksRepository repository;

  GetUserWritingBooksUseCase(this.repository);

  Future<List<BookEntity>> call(String userId) async {
    if (userId.trim().isEmpty) {
      throw Exception('ID de usuario requerido');
    }

    return await repository.getUserWritingBooks(userId);
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
    List<String>? newGenres,
    String? coverImage,
  }) async {
    // Validaciones de negocio
    if (title.trim().isEmpty) {
      throw Exception('El título es requerido');
    }

    if (title.trim().length < 3) {
      throw Exception('El título debe tener al menos 3 caracteres');
    }

    if (title.trim().length > 100) {
      throw Exception('El título no puede tener más de 100 caracteres');
    }

    if (description.trim().isEmpty) {
      throw Exception('La descripción es requerida');
    }

    if (description.trim().length < 10) {
      throw Exception('La descripción debe tener al menos 10 caracteres');
    }

    if (description.trim().length > 1000) {
      throw Exception('La descripción no puede tener más de 1000 caracteres');
    }

    if (authorId <= 0) {
      throw Exception('ID de autor inválido');
    }

    if (genreIds.isEmpty && (newGenres == null || newGenres.isEmpty)) {
      throw Exception('Debe seleccionar al menos un género o crear uno nuevo');
    }

    // Validar géneros nuevos
    if (newGenres != null) {
      for (String genre in newGenres) {
        if (genre.trim().isEmpty) {
          throw Exception('Los nombres de géneros no pueden estar vacíos');
        }
        if (genre.trim().length < 2) {
          throw Exception('Los nombres de géneros deben tener al menos 2 caracteres');
        }
        if (genre.trim().length > 50) {
          throw Exception('Los nombres de géneros no pueden tener más de 50 caracteres');
        }
      }
    }

    // Validar imagen base64 si se proporciona
    if (coverImage != null && coverImage.isNotEmpty) {
      if (!_isValidBase64Image(coverImage)) {
        throw Exception('Formato de imagen inválido');
      }
    }

    return await repository.createBook(
      title: title.trim(),
      description: description.trim(),
      authorId: authorId,
      genreIds: genreIds,
      newGenres: newGenres?.map((g) => g.trim()).toList(),
      coverImage: coverImage,
    );
  }

  bool _isValidBase64Image(String base64String) {
    try {
      // Remover prefijo data:image si existe
      String cleanBase64 = base64String;
      if (base64String.contains(',')) {
        cleanBase64 = base64String.split(',').last;
      }

      // Verificar que sea base64 válido
      final RegExp base64RegExp = RegExp(r'^[A-Za-z0-9+/]*={0,2}$');
      if (!base64RegExp.hasMatch(cleanBase64)) {
        return false;
      }

      // Verificar longitud mínima (imagen muy pequeña no es válida)
      if (cleanBase64.length < 100) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}

class UpdateBookUseCase {
  final BooksRepository repository;

  UpdateBookUseCase(this.repository);

  Future<BookEntity> call({
    required int bookId,
    String? title,
    String? description,
    List<int>? genreIds,
    List<String>? newGenres,
    String? coverImage,
  }) async {
    if (bookId <= 0) {
      throw Exception('ID de libro inválido');
    }

    // Validaciones opcionales
    if (title != null) {
      if (title.trim().isEmpty) {
        throw Exception('El título no puede estar vacío');
      }
      if (title.trim().length < 3) {
        throw Exception('El título debe tener al menos 3 caracteres');
      }
      if (title.trim().length > 100) {
        throw Exception('El título no puede tener más de 100 caracteres');
      }
    }

    if (description != null) {
      if (description.trim().isEmpty) {
        throw Exception('La descripción no puede estar vacía');
      }
      if (description.trim().length < 10) {
        throw Exception('La descripción debe tener al menos 10 caracteres');
      }
      if (description.trim().length > 1000) {
        throw Exception('La descripción no puede tener más de 1000 caracteres');
      }
    }

    // Validar géneros nuevos
    if (newGenres != null) {
      for (String genre in newGenres) {
        if (genre.trim().isEmpty) {
          throw Exception('Los nombres de géneros no pueden estar vacíos');
        }
        if (genre.trim().length < 2) {
          throw Exception('Los nombres de géneros deben tener al menos 2 caracteres');
        }
        if (genre.trim().length > 50) {
          throw Exception('Los nombres de géneros no pueden tener más de 50 caracteres');
        }
      }
    }

    return await repository.updateBook(
      bookId: bookId,
      title: title?.trim(),
      description: description?.trim(),
      genreIds: genreIds,
      newGenres: newGenres?.map((g) => g.trim()).toList(),
      coverImage: coverImage,
    );
  }
}

class PublishBookUseCase {
  final BooksRepository repository;

  PublishBookUseCase(this.repository);

  Future<BookEntity> call({
    required int bookId,
    required bool published,
  }) async {
    if (bookId <= 0) {
      throw Exception('ID de libro inválido');
    }

    return await repository.publishBook(
      bookId: bookId,
      published: published,
    );
  }
}

class DeleteBookUseCase {
  final BooksRepository repository;

  DeleteBookUseCase(this.repository);

  Future<bool> call(int bookId) async {
    if (bookId <= 0) {
      throw Exception('ID de libro inválido');
    }

    return await repository.deleteBook(bookId);
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

    if (name.trim().length > 50) {
      throw Exception('El nombre del género no puede tener más de 50 caracteres');
    }

    return await repository.createGenre(name.trim());
  }
}