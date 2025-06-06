import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/home_book_entity.dart';
import '../../domain/usecases/get_all_books_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetAllBooksUseCase getAllBooksUseCase;

  HomeCubit({
    required this.getAllBooksUseCase,
  }) : super(const HomeInitial());

  // Cargar todos los libros
  Future<void> loadBooks() async {
    emit(const HomeLoading());

    try {
      print('[DEBUG_HOME_CUBIT] Iniciando carga de libros...');
      
      final allBooks = await getAllBooksUseCase.call();
      print('[DEBUG_HOME_CUBIT] Libros obtenidos: ${allBooks.length}');

      // Organizar libros en categorías
      final categories = _organizeBooks(allBooks);
      
      emit(HomeLoaded(
        allBooks: allBooks,
        newPublications: categories['newPublications']!,
        recommended: categories['recommended']!,
        trending: categories['trending']!,
      ));
      
      print('[DEBUG_HOME_CUBIT] Estado cargado exitosamente');
    } catch (e) {
      print('[DEBUG_HOME_CUBIT] Error: $e');
      emit(HomeError(message: e.toString().replaceFirst('Exception: ', '')));
    }
  }

  // Organizar libros en diferentes categorías
  Map<String, List<HomeBookEntity>> _organizeBooks(List<HomeBookEntity> books) {
    // Ordenar por fecha de creación (más recientes primero)
    final sortedBooks = List<HomeBookEntity>.from(books);
    sortedBooks.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    // Nuevas publicaciones: Los más recientes
    final newPublications = sortedBooks.take(6).toList();

    // Recomendados: Libros con múltiples géneros (más diversos)
    final recommended = sortedBooks
        .where((book) => book.genres.length > 1)
        .take(5)
        .toList();

    // Tendencias: Libros populares (por ahora los que tienen géneros específicos)
    final trending = sortedBooks
        .where((book) => book.genres.any((genre) => 
            genre.toLowerCase().contains('genero') || 
            genre.toLowerCase().contains('test') ||
            genre.toLowerCase().contains('hola')))
        .take(5)
        .toList();

    // Si alguna categoría está vacía, llenarla con libros aleatorios
    if (recommended.isEmpty) {
      recommended.addAll(sortedBooks.take(5));
    }
    if (trending.isEmpty) {
      trending.addAll(sortedBooks.reversed.take(5));
    }

    return {
      'newPublications': newPublications,
      'recommended': recommended,
      'trending': trending,
    };
  }

  // Buscar libros por título o género
  List<HomeBookEntity> searchBooks(String query, List<HomeBookEntity> books) {
    if (query.isEmpty) return books;
    
    final lowercaseQuery = query.toLowerCase();
    return books.where((book) {
      return book.title.toLowerCase().contains(lowercaseQuery) ||
             book.description.toLowerCase().contains(lowercaseQuery) ||
             book.genres.any((genre) => genre.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

  // Obtener libros por género específico
  List<HomeBookEntity> getBooksByGenre(String genre, List<HomeBookEntity> books) {
    return books.where((book) => 
        book.genres.any((g) => g.toLowerCase() == genre.toLowerCase())
    ).toList();
  }

  // Recargar libros
  Future<void> refreshBooks() async {
    await loadBooks();
  }
}