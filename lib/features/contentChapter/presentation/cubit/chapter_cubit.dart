import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/chapter_entity.dart';
import '../../domain/usecases/chapter_usecases.dart';

part 'chapter_state.dart';

class ParagraphAddedSuccess extends ChapterState {}

class ChapterCubit extends Cubit<ChapterState> {
  final GetChapterDetailUseCase getChapterDetailUseCase;
  final AddParagraphsUseCase addParagraphsUseCase;
  final AddCommentUseCase addCommentUseCase;

  ChapterCubit({
    required this.getChapterDetailUseCase,
    required this.addParagraphsUseCase,
    required this.addCommentUseCase,
  }) : super(ChapterInitial());

  Future<void> loadChapter(String chapterId) async {
    emit(ChapterLoading());
    try {
      final chapter = await getChapterDetailUseCase(chapterId);
      emit(ChapterLoaded(chapter));
    } catch (e) {
      emit(ChapterError(e.toString()));
    }
  }

  Future<void> addParagraph(String chapterId, List<String> paragraphs) async {
    emit(ChapterAddingParagraph());
    try {
      final result = await addParagraphsUseCase(chapterId, paragraphs);
      emit(ParagraphAdded(result));
      emit(ParagraphAddedSuccess());
      // Recargar capítulo para reflejar el nuevo párrafo
      try {
        final chapter = await getChapterDetailUseCase(chapterId);
        emit(ChapterLoaded(chapter));
      } catch (e) {
        // Si la recarga falla, mostrar error pero NO borrar el contenido anterior
        emit(ChapterError('Párrafos agregados, pero error al recargar el capítulo: ' + e.toString()));
      }
    } catch (e) {
      emit(ChapterError(e.toString()));
    }
  }

  Future<void> addComment(String chapterId, String userId, String comment) async {
    emit(ChapterAddingParagraph()); // Puedes crear un estado específico si lo prefieres
    try {
      final success = await addCommentUseCase(chapterId, userId, comment);
      if (success) {
        // Recargar capítulo para mostrar el nuevo comentario
        final chapter = await getChapterDetailUseCase(chapterId);
        emit(ChapterLoaded(chapter));
        emit(ParagraphAddedSuccess()); // Reutilizamos el estado de éxito
      } else {
        emit(ChapterError('No se pudo agregar el comentario.'));
      }
    } catch (e) {
      emit(ChapterError('Error al agregar comentario: $e'));
    }
  }
} 