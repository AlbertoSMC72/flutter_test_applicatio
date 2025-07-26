part of 'downloaded_books_cubit.dart';

abstract class DownloadedBooksState {}

class DownloadedBooksInitial extends DownloadedBooksState {}
class DownloadedBooksLoading extends DownloadedBooksState {}
class DownloadedBooksLoaded extends DownloadedBooksState {
  final List<DownloadedBookEntity> books;
  DownloadedBooksLoaded(this.books);
}
class DownloadedBooksError extends DownloadedBooksState {
  final String message;
  DownloadedBooksError(this.message);
} 