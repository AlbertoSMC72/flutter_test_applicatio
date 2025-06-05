import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/storage_service.dart';
import '../../domain/entities/genre_entity.dart';
import '../../domain/usecases/books_usecases.dart';
import 'books_state.dart';

class BooksCubit extends Cubit<BooksState> {
  final GetUserBooksUseCase getUserBooksUseCase;
  final CreateBookUseCase createBookUseCase;
  final GetAllGenresUseCase getAllGenresUseCase;
  final CreateGenreUseCase createGenreUseCase;
  final StorageService storageService;

  BooksCubit({
    required this.getUserBooksUseCase,
    required this.createBookUseCase,
    required this.getAllGenresUseCase,
    required this.createGenreUseCase,
    required this.storageService,
  }) : super(const BooksInitial());

  // Variables para el formulario
  List<GenreEntity> _availableGenres = [];
  List<int> _selectedGenreIds = [];
  
  // Getters
  List<GenreEntity> get availableGenres => _availableGenres;
  List<int> get selectedGenreIds => _selectedGenreIds;

  // Obtener libros del usuario
  Future<void> getUserBooks() async {
    emit(const BooksLoading());

    try {
      final userId = await storageService.getUserId();
      
      if (userId == null || userId.isEmpty) {
        emit(const BooksError(message: 'Usuario no encontrado. Inicia sesión nuevamente.'));
        return;
      }

      final userBooks = await getUserBooksUseCase.call(userId);
      emit(BooksLoaded(userBooks: userBooks));
    } catch (e) {
      emit(BooksError(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  // Cargar géneros disponibles
  Future<void> loadGenres() async {
    try {
      print('[DEBUG_CUBIT] Iniciando loadGenres()');
      
      emit(BooksFormState(
        genres: _availableGenres,
        isLoadingGenres: true,
        isCreatingBook: false,
      ));
      
      await Future.delayed(const Duration(milliseconds: 100));
      
      final genres = await getAllGenresUseCase.call();
      _availableGenres = genres;
      print('[DEBUG_CUBIT] Géneros cargados: ${genres.length}');
      
      await Future.delayed(const Duration(milliseconds: 100));
      
      emit(BooksFormState(
        genres: _availableGenres,
        isLoadingGenres: false,
        isCreatingBook: false,
      ));
      
    } catch (e) {
      print('[DEBUG_CUBIT] Error: $e');
      emit(BooksFormState(
        genres: _availableGenres,
        isLoadingGenres: false,
        isCreatingBook: false,
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
    ));
  }

  // Crear nuevo libro
  Future<void> createBook({
    required String title,
    required String description,
  }) async {
    if (_selectedGenreIds.isEmpty) {
      emit(BooksFormState(
        genres: _availableGenres,
        isLoadingGenres: false,
        isCreatingBook: false,
        formError: 'Debe seleccionar al menos un género',
      ));
      return;
    }

    emit(BooksFormState(
      genres: _availableGenres,
      isLoadingGenres: false,
      isCreatingBook: true,
    ));

    try {
      final userData = await storageService.getUserData();
      final userId = userData['userId'];
      
      if (userId == null || userId.isEmpty) {
        emit(BooksFormState(
          genres: _availableGenres,
          isLoadingGenres: false,
          isCreatingBook: false,
          formError: 'Usuario no encontrado. Inicia sesión nuevamente.',
        ));
        return;
      }

      final book = await createBookUseCase.call(
        title: title,
        description: description,
        authorId: int.parse(userId),
        genreIds: _selectedGenreIds,
      );

      emit(BookCreated(book: book));
      
      _selectedGenreIds.clear();
      await Future.delayed(const Duration(milliseconds: 500));
      await getUserBooks();
    } catch (e) {
      emit(BooksFormState(
        genres: _availableGenres,
        isLoadingGenres: false,
        isCreatingBook: false,
        formError: e.toString().replaceFirst('Exception: ', ''),
      ));
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
      ));

      emit(GenreCreated(genre: newGenre));
      
      emit(BooksFormState(
        genres: _availableGenres,
        isLoadingGenres: false,
        isCreatingBook: false,
      ));
    } catch (e) {
      emit(BooksFormState(
        genres: _availableGenres,
        isLoadingGenres: false,
        isCreatingBook: false,
        formError: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  // Resetear formulario
  void resetForm() {
    _selectedGenreIds.clear();
    emit(BooksFormState(
      genres: _availableGenres,
      isLoadingGenres: false,
      isCreatingBook: false,
    ));
  }

  // Resetear a estado inicial
  void resetToInitial() {
    _selectedGenreIds.clear();
    _availableGenres.clear();
    emit(const BooksInitial());
  }
}