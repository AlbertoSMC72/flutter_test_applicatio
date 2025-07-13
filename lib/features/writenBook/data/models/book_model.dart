import 'package:flutter_application_1/features/writenBook/domain/entities/genre_entity.dart';

import '../../domain/entities/book_entity.dart';
import 'genre_model.dart';

class BookModel extends BookEntity {
  const BookModel({
    super.id,
    required super.title,
    required super.description,
    super.coverImage,
    super.published,
    super.createdAt,
    required super.authorId,
    super.genreIds,
    super.author,
    super.genres,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      coverImage: json['cover_image'],
      published: json['published'] ?? false,
      createdAt: json['created_at'],
      authorId: json['author_id'] ?? 0,
    );
  }

  // Factory para el nuevo formato de API
  factory BookModel.fromApiJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      coverImage: json['coverImage'],
      published: json['published'] ?? false,
      createdAt: json['createdAt'],
      authorId: json['authorId'] != null ? int.tryParse(json['authorId'].toString()) ?? 0 : 0,
      author: json['author'] != null ? AuthorEntity(
        username: json['author']['username'] ?? '',
        profilePicture: json['author']['profilePicture'],
      ) : null,
      genres: json['genres'] != null 
        ? (json['genres'] as List).map((g) => GenreEntity(
          id: g['id'] != null ? int.tryParse(g['id'].toString()) : null,
          name: g['name'] ?? '',
        )).toList()
        : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'coverImage': coverImage,
      'authorId': authorId,
      'genreIds': genreIds,
    };
  }

  static Map<String, dynamic> createBookRequest({
    required String title,
    required String description,
    required int authorId,
    required List<int> genreIds,
    List<String>? newGenres,
    String? coverImage,
  }) {
    final Map<String, dynamic> data = {
      'title': title,
      'description': description,
      'authorId': authorId,
      'genreIds': genreIds,
    };

    if (newGenres != null && newGenres.isNotEmpty) {
      data['newGenres'] = newGenres;
    }

    if (coverImage != null && coverImage.isNotEmpty) {
      data['coverImage'] = coverImage;
    }

    return data;
  }

  factory BookModel.fromEntity(BookEntity entity) {
    return BookModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      coverImage: entity.coverImage,
      published: entity.published,
      createdAt: entity.createdAt,
      authorId: entity.authorId,
      genreIds: entity.genreIds,
      author: entity.author,
      genres: entity.genres,
    );
  }

  BookEntity toEntity() {
    return BookEntity(
      id: id,
      title: title,
      description: description,
      coverImage: coverImage,
      published: published,
      createdAt: createdAt,
      authorId: authorId,
      genreIds: genreIds,
      author: author,
      genres: genres,
    );
  }
}



