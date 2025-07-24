import '../../domain/entities/book_search_entity.dart';

class BookSearchModel {
  final String id;
  final String title;
  final String description;
  final String coverImage;
  final List<GenreModel> genres;
  final bool isFav;

  BookSearchModel({
    required this.id,
    required this.title,
    required this.description,
    required this.coverImage,
    required this.genres,
    required this.isFav,
  });

  factory BookSearchModel.fromJson(Map<String, dynamic> json) {
    return BookSearchModel(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      coverImage: json['coverImage'] ?? '',
      genres: (json['genres'] as List? ?? [])
          .map((g) => GenreModel.fromJson(g))
          .toList(),
      isFav: json['isFav'] ?? false,
    );
  }

  BookSearchEntity toEntity() {
    return BookSearchEntity(
      id: id,
      title: title,
      description: description,
      coverImage: coverImage,
      genres: genres.map((g) => GenreEntity(id: g.id, name: g.name)).toList(),
      isFav: isFav,
    );
  }
}

class GenreModel {
  final String id;
  final String name;

  GenreModel({required this.id, required this.name});

  factory GenreModel.fromJson(Map<String, dynamic> json) {
    return GenreModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
    );
  }
} 