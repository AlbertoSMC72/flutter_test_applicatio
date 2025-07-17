import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/storage_service.dart';
import '../../domain/entities/book_detail_entity.dart';
import '../../domain/usecases/book_detail_usecases.dart';
import 'book_detail_state.dart';

class BookDetailCubit extends Cubit<BookDetailState> {
  final GetBookDetailUseCase getBookDetailUseCase;
  final UpdateBookUseCase updateBookUseCase;
  final PublishBookUseCase publishBookUseCase;
  final AddChapterUseCase addChapterUseCase;
  final ToggleChapterPublishUseCase toggleChapterPublishUseCase;
  final DeleteChapterUseCase deleteChapterUseCase;
  final DeleteBookUseCase deleteBookUseCase;
  final AddCommentUseCase addCommentUseCase;
  final StorageService storageService;

  BookDetailCubit({
    required this.getBookDetailUseCase,
    required this.updateBookUseCase,
    required this.publishBookUseCase,
    required this.addChapterUseCase,
    required this.toggleChapterPublishUseCase,
    required this.deleteChapterUseCase,
    required this.deleteBookUseCase,
    required this.addCommentUseCase,
    required this.storageService,
  }) : super(BookDetailInitial());

  BookDetailEntity? _currentBookDetail;
  bool _isAuthor = false;

  BookDetailEntity? get currentBookDetail => _currentBookDetail;
  bool get isAuthor => _isAuthor;

  Future<void> loadBookDetail(String bookId) async {
    emit(BookDetailLoading());

    try {
      final userId = await storageService.getUserId();
      
      if (userId == null || userId.isEmpty) {
        emit(BookDetailError(message: 'Usuario no encontrado. Inicia sesión nuevamente.'));
        return;
      }

      final bookDetail = await getBookDetailUseCase.call(bookId, userId);
      _currentBookDetail = bookDetail;
      _isAuthor = bookDetail.authorId == userId;

      emit(BookDetailLoaded(
        bookDetail: bookDetail,
        isAuthor: _isAuthor,
      ));
    } catch (e) {
      emit(BookDetailError(message: e.toString()));
    }
  }

  Future<void> addChapter(String title) async {
    if (_currentBookDetail == null) return;

    try {
      final chapter = await addChapterUseCase.call(_currentBookDetail!.id, title);
      
      // Actualizar la lista de capítulos
      final updatedChapters = List<ChapterEntity>.from(_currentBookDetail!.chapters ?? []);
      updatedChapters.add(chapter);
      
      _currentBookDetail = BookDetailEntity(
        id: _currentBookDetail!.id,
        title: _currentBookDetail!.title,
        description: _currentBookDetail!.description,
        coverImage: _currentBookDetail!.coverImage,
        published: _currentBookDetail!.published,
        createdAt: _currentBookDetail!.createdAt,
        authorId: _currentBookDetail!.authorId,
        author: _currentBookDetail!.author,
        genres: _currentBookDetail!.genres,
        chapters: updatedChapters,
        comments: _currentBookDetail!.comments,
      );

      emit(ChapterAdded(chapter: chapter));
      emit(BookDetailLoaded(
        bookDetail: _currentBookDetail!,
        isAuthor: _isAuthor,
      ));
    } catch (e) {
      emit(BookDetailError(message: e.toString()));
    }
  }

  Future<void> toggleChapterPublish(String chapterId, bool published) async {
    try {
      final success = await toggleChapterPublishUseCase.call(chapterId, published);
      
      if (success && _currentBookDetail != null) {
        // Actualizar el estado del capítulo en la lista
        final updatedChapters = _currentBookDetail!.chapters?.map((chapter) {
          if (chapter.id == chapterId) {
            return ChapterEntity(
              id: chapter.id,
              title: chapter.title,
              published: published,
              createdAt: chapter.createdAt,
              isLiked: chapter.isLiked,
            );
          }
          return chapter;
        }).toList();

        _currentBookDetail = BookDetailEntity(
          id: _currentBookDetail!.id,
          title: _currentBookDetail!.title,
          description: _currentBookDetail!.description,
          coverImage: _currentBookDetail!.coverImage,
          published: _currentBookDetail!.published,
          createdAt: _currentBookDetail!.createdAt,
          authorId: _currentBookDetail!.authorId,
          author: _currentBookDetail!.author,
          genres: _currentBookDetail!.genres,
          chapters: updatedChapters,
          comments: _currentBookDetail!.comments,
        );

        emit(ChapterPublished(chapterId: chapterId, published: published));
        emit(BookDetailLoaded(
          bookDetail: _currentBookDetail!,
          isAuthor: _isAuthor,
        ));
      }
    } catch (e) {
      emit(BookDetailError(message: e.toString()));
    }
  }

  Future<void> deleteChapter(String chapterId) async {
    try {
      final success = await deleteChapterUseCase.call(chapterId);
      
      if (success && _currentBookDetail != null) {
        // Remover el capítulo de la lista
        final updatedChapters = _currentBookDetail!.chapters
            ?.where((chapter) => chapter.id != chapterId)
            .toList();

        _currentBookDetail = BookDetailEntity(
          id: _currentBookDetail!.id,
          title: _currentBookDetail!.title,
          description: _currentBookDetail!.description,
          coverImage: _currentBookDetail!.coverImage,
          published: _currentBookDetail!.published,
          createdAt: _currentBookDetail!.createdAt,
          authorId: _currentBookDetail!.authorId,
          author: _currentBookDetail!.author,
          genres: _currentBookDetail!.genres,
          chapters: updatedChapters,
          comments: _currentBookDetail!.comments,
        );

        emit(ChapterDeleted(chapterId: chapterId));
        emit(BookDetailLoaded(
          bookDetail: _currentBookDetail!,
          isAuthor: _isAuthor,
        ));
      }
    } catch (e) {
      emit(BookDetailError(message: e.toString()));
    }
  }

  Future<void> deleteBook() async {
    if (_currentBookDetail == null) return;

    try {
      final success = await deleteBookUseCase.call(_currentBookDetail!.id);
      
      if (success) {
        emit(BookDeleted(bookId: _currentBookDetail!.id));
      }
    } catch (e) {
      emit(BookDetailError(message: e.toString()));
    }
  }

  Future<void> updateBook(Map<String, dynamic> updates) async {
    if (_currentBookDetail == null) return;

    try {
      final updatedBook = await updateBookUseCase.call(_currentBookDetail!.id, updates);
      _currentBookDetail = updatedBook;

      emit(BookUpdated(bookDetail: updatedBook));
      emit(BookDetailLoaded(
        bookDetail: _currentBookDetail!,
        isAuthor: _isAuthor,
      ));
    } catch (e) {
      emit(BookDetailError(message: e.toString()));
    }
  }

  Future<void> publishBook(bool published) async {
    if (_currentBookDetail == null) return;

    try {
      final updatedBook = await publishBookUseCase.call(_currentBookDetail!.id, published);
      _currentBookDetail = updatedBook;

      emit(BookPublished(bookId: _currentBookDetail!.id, published: published));
      emit(BookDetailLoaded(
        bookDetail: _currentBookDetail!,
        isAuthor: _isAuthor,
      ));
    } catch (e) {
      emit(BookDetailError(message: e.toString()));
    }
  }

  Future<void> addComment(String comment) async {
    if (_currentBookDetail == null) return;

    try {
      final userId = await storageService.getUserId();
      
      if (userId == null || userId.isEmpty) {
        emit(BookDetailError(message: 'Usuario no encontrado. Inicia sesión nuevamente.'));
        return;
      }

      final newComment = await addCommentUseCase.call(_currentBookDetail!.id, userId, comment);
      
      // Actualizar la lista de comentarios
      final updatedComments = List<CommentEntity>.from(_currentBookDetail!.comments ?? []);
      updatedComments.add(newComment);
      
      _currentBookDetail = BookDetailEntity(
        id: _currentBookDetail!.id,
        title: _currentBookDetail!.title,
        description: _currentBookDetail!.description,
        coverImage: _currentBookDetail!.coverImage,
        published: _currentBookDetail!.published,
        createdAt: _currentBookDetail!.createdAt,
        authorId: _currentBookDetail!.authorId,
        author: _currentBookDetail!.author,
        genres: _currentBookDetail!.genres,
        chapters: _currentBookDetail!.chapters,
        comments: updatedComments,
      );

      emit(CommentAdded(comment: newComment));
      emit(BookDetailLoaded(
        bookDetail: _currentBookDetail!,
        isAuthor: _isAuthor,
      ));
    } catch (e) {
      emit(BookDetailError(message: e.toString()));
    }
  }
} 