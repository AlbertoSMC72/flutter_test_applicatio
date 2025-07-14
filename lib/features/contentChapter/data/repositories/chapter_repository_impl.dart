import '../../domain/entities/chapter_entity.dart';
import '../../domain/repositories/chapter_repository.dart';
import '../datasources/chapter_api_service.dart';

class ChapterRepositoryImpl implements ChapterRepository {
  final ChapterApiService apiService;

  ChapterRepositoryImpl({required this.apiService});

  @override
  Future<ChapterDetailEntity> getChapterDetail(String chapterId) async {
    final result = await apiService.getChapterDetail(chapterId);
    return result;
  }

  @override
  Future<List<ParagraphEntity>> addParagraphs(String chapterId, List<String> paragraphs) async {
    final result = await apiService.addParagraphs(chapterId, paragraphs);
    return result;
  }

  @override
  Future<bool> addComment(String chapterId, String userId, String comment) async {
    return await apiService.addComment(chapterId, userId, comment);
  }
} 