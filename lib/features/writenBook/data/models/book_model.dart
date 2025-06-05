import '../../domain/entities/book_entity.dart';

class BookModel extends BookEntity {
  const BookModel({
    super.id,
    required super.title,
    required super.description,
    super.createdAt,
    required super.authorId,
    super.genreIds,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      createdAt: json['created_at'],
      authorId: json['author_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'authorId': authorId,
      'genreIds': genreIds,
    };
  }

  static Map<String, dynamic> createBookRequest({
    required String title,
    required String description,
    required int authorId,
    required List<int> genreIds,
  }) {
    return {
      'title': title,
      'description': description,
      'authorId': authorId,
      'genreIds': genreIds,
    };
  }

  factory BookModel.fromEntity(BookEntity entity) {
    return BookModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      createdAt: entity.createdAt,
      authorId: entity.authorId,
      genreIds: entity.genreIds,
    );
  }

  BookEntity toEntity() {
    return BookEntity(
      id: id,
      title: title,
      description: description,
      createdAt: createdAt,
      authorId: authorId,
      genreIds: genreIds,
    );
  }
}