import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/book_likes_usecases.dart';

class BookLikesState {
  final bool isBookLiked;
  final int bookLikesCount;
  final Map<int, Map<String, dynamic>> chaptersLikeStatus;
  final bool loading;
  BookLikesState({
    required this.isBookLiked,
    required this.bookLikesCount,
    required this.chaptersLikeStatus,
    this.loading = false,
  });

  BookLikesState copyWith({
    bool? isBookLiked,
    int? bookLikesCount,
    Map<int, Map<String, dynamic>>? chaptersLikeStatus,
    bool? loading,
  }) => BookLikesState(
    isBookLiked: isBookLiked ?? this.isBookLiked,
    bookLikesCount: bookLikesCount ?? this.bookLikesCount,
    chaptersLikeStatus: chaptersLikeStatus ?? this.chaptersLikeStatus,
    loading: loading ?? this.loading,
  );
}

class BookLikesCubit extends Cubit<BookLikesState> {
  final GetBookLikeStatusUseCase getBookLikeStatus;
  final ToggleBookLikeUseCase toggleBookLike;
  final GetChaptersLikeStatusUseCase getChaptersLikeStatus;
  final ToggleChapterLikeUseCase toggleChapterLike;

  BookLikesCubit({
    required this.getBookLikeStatus,
    required this.toggleBookLike,
    required this.getChaptersLikeStatus,
    required this.toggleChapterLike,
  }) : super(BookLikesState(isBookLiked: false, bookLikesCount: 0, chaptersLikeStatus: {}));

  Future<void> loadLikes(String userId, String bookId, List<int> chapterIds) async {
    emit(state.copyWith(loading: true));
    final (isLiked, likesCount) = await getBookLikeStatus(userId, bookId);
    final chaptersLikeStatus = await getChaptersLikeStatus(userId, chapterIds);
    emit(state.copyWith(
      isBookLiked: isLiked,
      bookLikesCount: likesCount,
      chaptersLikeStatus: chaptersLikeStatus,
      loading: false,
    ));
  }

  Future<void> toggleBook(String userId, String bookId) async {
    emit(state.copyWith(loading: true));
    final (isLiked, likesCount) = await toggleBookLike(userId, bookId);
    emit(state.copyWith(isBookLiked: isLiked, bookLikesCount: likesCount, loading: false));
  }

  Future<void> toggleChapter(String userId, int chapterId) async {
    await toggleChapterLike(userId, chapterId);
    // Recargar el estado de likes del capítulo
    final updated = Map<int, Map<String, dynamic>>.from(state.chaptersLikeStatus);
    if (updated.containsKey(chapterId)) {
      final prev = updated[chapterId]!;
      updated[chapterId] = {
        ...prev,
        'isLiked': !(prev['isLiked'] as bool),
        'likesCount': (prev['likesCount'] as int) + ((prev['isLiked'] as bool) ? -1 : 1),
      };
    }
    emit(state.copyWith(chaptersLikeStatus: updated));
  }
} 