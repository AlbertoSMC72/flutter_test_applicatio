class BookSearchEntity {
  final String id;
  final String title;
  final String description;
  final String coverImage;
  final List<GenreEntity> genres;
  final bool isFav;

  BookSearchEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.coverImage,
    required this.genres,
    required this.isFav,
  });
}

class GenreEntity {
  final String id;
  final String name;

  GenreEntity({required this.id, required this.name});
} 