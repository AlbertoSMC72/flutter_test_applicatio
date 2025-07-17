import '../../domain/entities/home_book_entity.dart';

class HomeBookModel extends HomeBookEntity {
  final String coverImage;

  const HomeBookModel({
    required super.id,
    required super.title,
    required super.description,
    required super.createdAt,
    required super.authorId,
    required super.genres,
    this.coverImage = '',
  });

  factory HomeBookModel.fromJson(Map<String, dynamic> json) {
    return HomeBookModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      createdAt: json['created_at'] ?? '',
      authorId: json['author_id'] ?? 0,
      genres: List<String>.from(json['genres'] ?? []),
      coverImage: json['coverImage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'created_at': createdAt,
      'author_id': authorId,
      'genres': genres,
      'coverImage': coverImage,
    };
  }

  factory HomeBookModel.fromEntity(HomeBookEntity entity) {
    return HomeBookModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      createdAt: entity.createdAt,
      authorId: entity.authorId,
      genres: entity.genres,
      coverImage: entity.coverImage,
    );
  }

  HomeBookEntity toEntity() {
    return HomeBookEntity(
      id: id,
      title: title,
      description: description,
      createdAt: createdAt,
      authorId: authorId,
      genres: genres,
      coverImage: coverImage,
    );
  }
}