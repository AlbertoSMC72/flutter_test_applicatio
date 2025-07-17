import 'package:dio/dio.dart';

class BookLikesApiService {
  final Dio dio;
  BookLikesApiService(this.dio);

  Future<Map<String, dynamic>> getBookLikeStatus(String userId, String bookId) async {
    final response = await dio.get('/likes/books/$bookId/status', queryParameters: {'userId': userId});
    return response.data['data'];
  }

  Future<Map<String, dynamic>> toggleBookLike(String userId, String bookId) async {
    final response = await dio.post('/likes/books/toggle', data: {'userId': int.parse(userId), 'bookId': int.parse(bookId)});
    return response.data['data'];
  }

  Future<Map<int, Map<String, dynamic>>> getChaptersLikeStatus(String userId, List<int> chapterIds) async {
    final response = await dio.post(
      '/likes/chapters/status/multiple',
      data: {
        'userId': int.parse(userId),
        'chapterIds': chapterIds,
      },
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return data.map((k, v) => MapEntry(int.parse(k), v as Map<String, dynamic>));
  }

  Future<void> toggleChapterLike(String userId, int chapterId) async {
    await dio.post(
      '/likes/chapters/toggle',
      data: {
        'userId': int.parse(userId),
        'chapterId': chapterId,
      },
    );
  }
} 