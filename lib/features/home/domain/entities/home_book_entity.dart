// features/home/domain/entities/home_book_entity.dart
class HomeBookEntity {
  final int id;
  final String title;
  final String description;
  final String createdAt;
  final int authorId;
  final List<String> genres;

  const HomeBookEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.authorId,
    required this.genres,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HomeBookEntity &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.createdAt == createdAt &&
        other.authorId == authorId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        createdAt.hashCode ^
        authorId.hashCode;
  }

  @override
  String toString() {
    return 'HomeBookEntity(id: $id, title: $title, genres: $genres)';
  }
}