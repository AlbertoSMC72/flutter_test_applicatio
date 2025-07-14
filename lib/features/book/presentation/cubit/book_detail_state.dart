import 'package:equatable/equatable.dart';
import '../../domain/entities/book_detail_entity.dart';

abstract class BookDetailState extends Equatable {
  const BookDetailState();

  @override
  List<Object?> get props => [];
}

class BookDetailInitial extends BookDetailState {}

class BookDetailLoading extends BookDetailState {}

class BookDetailLoaded extends BookDetailState {
  final BookDetailEntity bookDetail;
  final bool isAuthor;

  const BookDetailLoaded({
    required this.bookDetail,
    required this.isAuthor,
  });

  @override
  List<Object?> get props => [bookDetail, isAuthor];
}

class BookDetailError extends BookDetailState {
  final String message;

  const BookDetailError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ChapterAdded extends BookDetailState {
  final ChapterEntity chapter;

  const ChapterAdded({required this.chapter});

  @override
  List<Object?> get props => [chapter];
}

class ChapterPublished extends BookDetailState {
  final String chapterId;
  final bool published;

  const ChapterPublished({
    required this.chapterId,
    required this.published,
  });

  @override
  List<Object?> get props => [chapterId, published];
}

class ChapterDeleted extends BookDetailState {
  final String chapterId;

  const ChapterDeleted({required this.chapterId});

  @override
  List<Object?> get props => [chapterId];
}

class BookDeleted extends BookDetailState {
  final String bookId;

  const BookDeleted({required this.bookId});

  @override
  List<Object?> get props => [bookId];
}

class CommentAdded extends BookDetailState {
  final CommentEntity comment;

  const CommentAdded({required this.comment});

  @override
  List<Object?> get props => [comment];
} 