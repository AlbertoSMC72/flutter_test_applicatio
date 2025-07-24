import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/downloaded_chapter_entity.dart';
import '../../domain/usecases/get_downloaded_chapters_usecase.dart';

part 'downloaded_chapters_state.dart';

class DownloadedChaptersCubit extends Cubit<DownloadedChaptersState> {
  final GetDownloadedChaptersUseCase getDownloadedChaptersUseCase;

  DownloadedChaptersCubit(this.getDownloadedChaptersUseCase) : super(DownloadedChaptersInitial());

  Future<void> loadDownloadedChapters(String bookId) async {
    emit(DownloadedChaptersLoading());
    try {
      final chapters = await getDownloadedChaptersUseCase(bookId);
      emit(DownloadedChaptersLoaded(chapters));
    } catch (e) {
      emit(DownloadedChaptersError(e.toString()));
    }
  }
} 