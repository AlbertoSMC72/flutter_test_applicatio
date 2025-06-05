class BookEntity {
  final int? id;
  final String title;
  final String description;
  final String? createdAt;
  final int authorId;
  final List<int>? genreIds;

  const BookEntity({
    this.id,
    required this.title,
    required this.description,
    this.createdAt,
    required this.authorId,
    this.genreIds,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BookEntity &&
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
    return 'BookEntity(id: $id, title: $title, description: $description, authorId: $authorId)';
  }
}