import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book_search_model.dart';

class BookSearchApiService {
  static const String _baseUrl = 'https://bookservicewatpato-production.up.railway.app/api/books/search';

  Future<List<BookSearchModel>> searchBooks(String query, String userId) async {
    if (query.length < 2) {
      throw Exception('La búsqueda debe tener al menos 2 caracteres');
    }
    final url = Uri.parse('$_baseUrl?q=$query&userId=$userId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] == true && data['data'] is List) {
        return (data['data'] as List)
            .map((item) => BookSearchModel.fromJson(item))
            .toList();
      } else {
        throw Exception(data['message'] ?? 'Error en la búsqueda');
      }
    } else {
      throw Exception('Error de red: ${response.statusCode}');
    }
  }
} 