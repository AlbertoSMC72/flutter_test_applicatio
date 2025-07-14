import 'dart:io';
import 'package:dio/dio.dart';
import '../models/chapter_model.dart';

abstract class ChapterApiService {
  Future<ChapterDetailModel> getChapterDetail(String chapterId);
  Future<List<ParagraphModel>> addParagraphs(String chapterId, List<String> paragraphs);
  Future<bool> addComment(String chapterId, String userId, String comment);
}

class ChapterApiServiceImpl implements ChapterApiService {
  final Dio dio;

  ChapterApiServiceImpl({Dio? dio}) : dio = dio ?? Dio() {
    _setupDio();
  }

  void _setupDio() {
    dio.options = BaseOptions(
      baseUrl: 'https://bookservicewatpato-production.up.railway.app',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
  }

  @override
  Future<ChapterDetailModel> getChapterDetail(String chapterId) async {
    try {
      final response = await dio.get('/api/books/chapters/$chapterId');
      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        return ChapterDetailModel.fromJson(data);
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error de red: ${e.message}');
    } on SocketException {
      throw Exception('Sin conexión a internet');
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  @override
  Future<List<ParagraphModel>> addParagraphs(String chapterId, List<String> paragraphs) async {
    try {
      final response = await dio.post(
        '/api/books/chapters/$chapterId/content',
        data: {'paragraphs': paragraphs},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data['data'] ?? response.data;
        // Permitir que data sea una lista directamente o un objeto con 'paragraphs'
        final paraList = data is List
          ? data
          : (data['paragraphs'] ?? []);
        if (paraList is List) {
          return paraList.map((p) => ParagraphModel.fromJson(p)).toList();
        } else {
          throw Exception('No se recibieron párrafos nuevos');
        }
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error de red: ${e.message}');
    } on SocketException {
      throw Exception('Sin conexión a internet');
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  @override
  Future<bool> addComment(String chapterId, String userId, String comment) async {
    try {
      final response = await dio.post(
        '/api/books/chapters/$chapterId/comments',
        data: {
          'userId': userId,
          'comment': comment,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error de red: ${e.message}');
    } on SocketException {
      throw Exception('Sin conexión a internet');
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }
} 