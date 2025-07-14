part of 'chapter_cubit.dart';

abstract class ChapterState {}

class ChapterInitial extends ChapterState {}
class ChapterLoading extends ChapterState {}
class ChapterLoaded extends ChapterState {
  final ChapterDetailEntity chapter;
  ChapterLoaded(this.chapter);
}
class ChapterError extends ChapterState {
  final String message;
  ChapterError(this.message);
}
class ChapterAddingParagraph extends ChapterState {}
class ParagraphAdded extends ChapterState {
  final List<ParagraphEntity> paragraphs;
  ParagraphAdded(this.paragraphs);
} 