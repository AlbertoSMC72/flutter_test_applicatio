import 'dart:io';
import 'package:flutter_application_1/features/writenBook/domain/entities/genre_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/image_utils.dart';

import '../../domain/usecases/books_usecases.dart';
import 'books_state.dart';

class BooksCubit extends Cubit<BooksState> {
  final GetUserBooksUseCase getUserBooksUseCase;
  final GetUserWritingBooksUseCase getUserWritingBooksUseCase;
  final CreateBookUseCase createBookUseCase;
  final UpdateBookUseCase updateBookUseCase;
  final PublishBookUseCase publishBookUseCase;
  final DeleteBookUseCase deleteBookUseCase;
  final GetAllGenresUseCase getAllGenresUseCase;
  final CreateGenreUseCase createGenreUseCase;
  final StorageService storageService;

  BooksCubit({
    required this.getUserBooksUseCase,
    required this.getUserWritingBooksUseCase,
    required this.createBookUseCase,
    required this.updateBookUseCase,
    required this.publishBookUseCase,
    required this.deleteBookUseCase,
    required this.getAllGenresUseCase,
    required this.createGenreUseCase,
    required this.storageService,
  }) : super(const BooksInitial());

  // Variables para el formulario
  List<GenreEntity> _availableGenres = [];
  List<int> _selectedGenreIds = [];
  String? _selectedCoverImageBase64;
  
  // Getters
  List<GenreEntity> get availableGenres => _availableGenres;
  List<int> get selectedGenreIds => _selectedGenreIds;
  String? get selectedCoverImageBase64 => _selectedCoverImageBase64;

  // Obtener libros que está escribiendo el usuario
  Future<void> getUserWritingBooks() async {
    emit(const BooksLoading());

    try {
      final userId = await storageService.getUserId();
      
      if (userId == null || userId.isEmpty) {
        emit(const BooksError(message: 'Usuario no encontrado. Inicia sesión nuevamente.'));
        return;
      }

      final books = await getUserWritingBooksUseCase.call(userId);
      emit(BooksWritingLoaded(books: books));
    } catch (e) {
      emit(BooksError(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  // Obtener libros del usuario (método legacy)
  Future<void> getUserBooks() async {
    await getUserWritingBooks();
  }

  // Cargar géneros disponibles
  Future<void> loadGenres() async {
    try {
      print('[DEBUG_CUBIT] Iniciando loadGenres()');
      
      emit(BooksFormState(
        genres: _availableGenres,
        isLoadingGenres: true,
        isCreatingBook: false,
        selectedCoverImage: _selectedCoverImageBase64,
      ));
      
      await Future.delayed(const Duration(milliseconds: 100));
      
      final genres = await getAllGenresUseCase.call();
      _availableGenres = genres as List<GenreEntity>;
      print('[DEBUG_CUBIT] Géneros cargados: ${genres.length}');
      
      await Future.delayed(const Duration(milliseconds: 100));
      
      emit(BooksFormState(
        genres: _availableGenres,
        isLoadingGenres: false,
        isCreatingBook: false,
        selectedCoverImage: _selectedCoverImageBase64,
      ));
      
    } catch (e) {
      print('[DEBUG_CUBIT] Error: $e');
      emit(BooksFormState(
        genres: _availableGenres,
        isLoadingGenres: false,
        isCreatingBook: false,
        selectedCoverImage: _selectedCoverImageBase64,
        formError: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  // Seleccionar/deseleccionar género
  void toggleGenreSelection(int genreId) {
    if (_selectedGenreIds.contains(genreId)) {
      _selectedGenreIds.remove(genreId);
    } else {
      _selectedGenreIds.add(genreId);
    }

    print('[DEBUG_CUBIT] Géneros seleccionados: $_selectedGenreIds');
    
    emit(BooksFormState(
      genres: _availableGenres,
      isLoadingGenres: false,
      isCreatingBook: false,
      selectedCoverImage: _selectedCoverImageBase64,
    ));
  }

  // Seleccionar imagen de portada
  Future<void> selectCoverImage(File imageFile) async {
    try {
      emit(BooksFormState(
        genres: _availableGenres,
        isLoadingGenres: false,
        isCreatingBook: false,
        selectedCoverImage: _selectedCoverImageBase64,
        isProcessingImage: true,
      ));

      final base64Image = await ImageUtils.fileToBase64(imageFile);
      
      if (base64Image != null) {
        _selectedCoverImageBase64 = base64Image;
        
        emit(BooksFormState(
          genres: _availableGenres,
          isLoadingGenres: false,
          isCreatingBook: false,
          selectedCoverImage: _selectedCoverImageBase64,
          isProcessingImage: false,
        ));
      } else {
        emit(BooksFormState(
          genres: _availableGenres,
          isLoadingGenres: false,
          isCreatingBook: false,
          selectedCoverImage: _selectedCoverImageBase64,
          isProcessingImage: false,
          formError: 'Error al procesar la imagen',
        ));
      }
    } catch (e) {
      emit(BooksFormState(
        genres: _availableGenres,
        isLoadingGenres: false,
        isCreatingBook: false,
        selectedCoverImage: _selectedCoverImageBase64,
        isProcessingImage: false,
        formError: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  // Remover imagen de portada
  void removeCoverImage() {
    _selectedCoverImageBase64 = null;
    
    emit(BooksFormState(
      genres: _availableGenres,
      isLoadingGenres: false,
      isCreatingBook: false,
      selectedCoverImage: _selectedCoverImageBase64,
    ));
  }

  // Crear nuevo libro
  Future<void> createBook({
    required String title,
    required String description,
    List<String>? newGenres,
  }) async {
    if (_selectedGenreIds.isEmpty && (newGenres == null || newGenres.isEmpty)) {
      emit(BooksFormState(
        genres: _availableGenres,
        isLoadingGenres: false,
        isCreatingBook: false,
        selectedCoverImage: _selectedCoverImageBase64,
        formError: 'Debe seleccionar al menos un género o crear uno nuevo',
      ));
      return;
    }

    emit(BooksFormState(
      genres: _availableGenres,
      isLoadingGenres: false,
      isCreatingBook: true,
      selectedCoverImage: _selectedCoverImageBase64,
    ));

    try {
      final userData = await storageService.getUserData();
      final userId = userData['userId'];
      
      if (userId == null || userId.isEmpty) {
        emit(BooksFormState(
          genres: _availableGenres,
          isLoadingGenres: false,
          isCreatingBook: false,
          selectedCoverImage: _selectedCoverImageBase64,
          formError: 'Usuario no encontrado. Inicia sesión nuevamente.',
        ));
        return;
      }

      final book = await createBookUseCase.call(
        title: title,
        description: description,
        authorId: int.parse(userId),
        genreIds: _selectedGenreIds,
        newGenres: newGenres,
        coverImage: _selectedCoverImageBase64,
      );

      emit(BookCreated(book: book));
      
      // Limpiar formulario
      _selectedGenreIds.clear();
      _selectedCoverImageBase64 = null;
      
      await Future.delayed(const Duration(milliseconds: 500));
      await getUserWritingBooks();
    } catch (e) {
      emit(BooksFormState(
        genres: _availableGenres,
        isLoadingGenres: false,
        isCreatingBook: false,
        selectedCoverImage: _selectedCoverImageBase64,
        formError: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  // Actualizar libro
  Future<void> updateBook({
    required int bookId,
    String? title,
    String? description,
    List<String>? newGenres,
    String? coverImageBase64,
  }) async {
    try {
      emit(const BooksLoading());

      final book = await updateBookUseCase.call(
        bookId: bookId,
        title: title,
        description: description,
        genreIds: _selectedGenreIds.isNotEmpty ? _selectedGenreIds : null,
        newGenres: newGenres,
        coverImage: coverImageBase64,
      );

      emit(BookUpdated(book: book));
      
      await Future.delayed(const Duration(milliseconds: 500));
      await getUserWritingBooks();
    } catch (e) {
      emit(BooksError(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  // Publicar/despublicar libro
  Future<void> toggleBookPublication(int bookId, bool publish) async {
    try {
      emit(const BooksLoading());

      final book = await publishBookUseCase.call(
        bookId: bookId,
        published: publish,
      );

      emit(BookPublicationToggled(
        book: book,
        message: publish ? 'Libro publicado exitosamente' : 'Libro despublicado exitosamente',
      ));
      
      await Future.delayed(const Duration(milliseconds: 500));
      await getUserWritingBooks();
    } catch (e) {
      emit(BooksError(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  // Eliminar libro
  Future<void> deleteBook(int bookId) async {
    try {
      emit(const BooksLoading());

      final success = await deleteBookUseCase.call(bookId);
      
      if (success) {
        emit(const BookDeleted(message: 'Libro eliminado exitosamente'));
        await Future.delayed(const Duration(milliseconds: 500));
        await getUserWritingBooks();
      } else {
        emit(const BooksError(message: 'Error al eliminar el libro'));
      }
    } catch (e) {
      emit(BooksError(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  // Crear nuevo género
  Future<void> createGenre(String name) async {
    try {
      final newGenre = await createGenreUseCase.call(name);
      _availableGenres.add(newGenre);
      
      emit(BooksFormState(
        genres: _availableGenres,
        isLoadingGenres: false,
        isCreatingBook: false,
        selectedCoverImage: _selectedCoverImageBase64,
      ));

      emit(GenreCreated(genre: newGenre));
      
      emit(BooksFormState(
        genres: _availableGenres,
        isLoadingGenres: false,
        isCreatingBook: false,
        selectedCoverImage: _selectedCoverImageBase64,
      ));
    } catch (e) {
      emit(BooksFormState(
        genres: _availableGenres,
        isLoadingGenres: false,
        isCreatingBook: false,
        selectedCoverImage: _selectedCoverImageBase64,
        formError: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  // Resetear formulario
  void resetForm() {
    _selectedGenreIds.clear();
    _selectedCoverImageBase64 = null;
    emit(BooksFormState(
      genres: _availableGenres,
      isLoadingGenres: false,
      isCreatingBook: false,
      selectedCoverImage: _selectedCoverImageBase64,
    ));
  }

  // Resetear a estado inicial
  void resetToInitial() {
    _selectedGenreIds.clear();
    _availableGenres.clear();
    _selectedCoverImageBase64 = null;
    emit(const BooksInitial());
  }
}