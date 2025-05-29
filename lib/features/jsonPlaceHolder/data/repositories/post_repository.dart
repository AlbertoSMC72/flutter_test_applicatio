import 'package:dio/dio.dart';
import '../models/post_model.dart';

class PostRepository {
  final Dio _dio;

  PostRepository({Dio? dio}) : _dio = dio ?? Dio();

  Future<List<PostModel>> getPosts() async {
    try {
      final response = await _dio.get('https://jsonplaceholder.typicode.com/posts');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => PostModel.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar los posts: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Timeout de conexión');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Timeout de recepción');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('Error de conexión');
      } else {
        throw Exception('Error de red: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  Future<PostModel> getPostById(int id) async {
    try {
      final response = await _dio.get('https://jsonplaceholder.typicode.com/posts/$id');
      
      if (response.statusCode == 200) {
        return PostModel.fromJson(response.data);
      } else {
        throw Exception('Error al cargar el post: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error de red: ${e.message}');
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }
}