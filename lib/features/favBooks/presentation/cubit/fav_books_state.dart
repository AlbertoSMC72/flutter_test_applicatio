import 'package:equatable/equatable.dart';
import '../../domain/entities/fav_book_entity.dart';
import '../../domain/entities/like_status_entity.dart';

abstract class FavBooksState extends Equatable {
  const FavBooksState();

  @override
  List<Object?> get props => [];
}

class FavBooksInitial extends FavBooksState {}

class FavBooksLoading extends FavBooksState {}

class FavBooksLoaded extends FavBooksState {
  final List<FavBookEntity> books;

  const FavBooksLoaded(this.books);

  @override
  List<Object?> get props => [books];
}

class FavBooksError extends FavBooksState {
  final String message;

  const FavBooksError(this.message);

  @override
  List<Object?> get props => [message];
}

class LikeStatusLoaded extends FavBooksState {
  final String bookId;
  final LikeStatusEntity likeStatus;

  const LikeStatusLoaded(this.bookId, this.likeStatus);

  @override
  List<Object?> get props => [bookId, likeStatus];
}

class LikeToggled extends FavBooksState {
  final String bookId;
  final LikeStatusEntity likeStatus;
  final String message;

  const LikeToggled(this.bookId, this.likeStatus, this.message);

  @override
  List<Object?> get props => [bookId, likeStatus, message];
} 