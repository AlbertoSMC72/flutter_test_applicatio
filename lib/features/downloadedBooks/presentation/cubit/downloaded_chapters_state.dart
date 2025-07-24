part of 'downloaded_chapters_cubit.dart';

abstract class DownloadedChaptersState {}

class DownloadedChaptersInitial extends DownloadedChaptersState {}
class DownloadedChaptersLoading extends DownloadedChaptersState {}
class DownloadedChaptersLoaded extends DownloadedChaptersState {
  final List<DownloadedChapterEntity> chapters;
  DownloadedChaptersLoaded(this.chapters);
}
class DownloadedChaptersError extends DownloadedChaptersState {
  final String message;
  DownloadedChaptersError(this.message);
} 