import '/../../features/book/domain/entities/book_detail_entity.dart';

class BookDetailModel extends BookDetailEntity {
  const BookDetailModel({
    required super.id,
    required super.title,
    required super.description,
    super.coverImage,
    super.published,
    super.createdAt,
    required super.authorId,
    super.author,
    super.genres,
    super.chapters,
    super.comments,
  });

  factory BookDetailModel.fromJson(Map<String, dynamic> json) {
    return BookDetailModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      coverImage: json['coverImage'],
      published: json['published'],
      createdAt: json['createdAt'],
      authorId: json['authorId']?.toString() ?? '',
      author: json['author'] != null ? AuthorModel.fromJson(json['author']) : null,
      genres: json['genres'] != null 
        ? (json['genres'] as List).map((g) => GenreModel.fromJson(g)).toList()
        : [],
      chapters: json['chapters'] != null 
        ? (json['chapters'] as List).map((c) => ChapterModel.fromJson(c)).toList()
        : [],
      comments: json['comments'] != null 
        ? (json['comments'] as List).map((c) => CommentModel.fromJson(c)).toList()
        : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'coverImage': coverImage,
      'published': published,
      'createdAt': createdAt,
      'authorId': authorId,
      'author': author?.toJson(),
      'genres': genres?.map((g) => g.toJson()).toList(),
      'chapters': chapters?.map((c) => c.toJson()).toList(),
      'comments': comments?.map((c) => c.toJson()).toList(),
    };
  }

  BookDetailEntity toEntity() {
    return BookDetailEntity(
      id: id,
      title: title,
      description: description,
      coverImage: coverImage,
      published: published,
      createdAt: createdAt,
      authorId: authorId,
      author: author,
      genres: genres,
      chapters: chapters,
      comments: comments,
    );
  }
}

class AuthorModel extends AuthorEntity {
  const AuthorModel({
    required super.username,
    super.profilePicture,
  });

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(
      username: json['username'] ?? '',
      profilePicture: json['profilePicture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'profilePicture': profilePicture,
    };
  }
}

class GenreModel extends GenreEntity {
  const GenreModel({
    required super.id,
    required super.name,
  });

  factory GenreModel.fromJson(Map<String, dynamic> json) {
    return GenreModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class ChapterModel extends ChapterEntity {
  const ChapterModel({
    required super.id,
    required super.title,
    super.published,
    super.createdAt,
    super.isLiked,
  });

  factory ChapterModel.fromJson(Map<String, dynamic> json) {
    return ChapterModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      published: json['published'],
      createdAt: json['createdAt'],
      isLiked: json['isLiked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'published': published,
      'createdAt': createdAt,
      'isLiked': isLiked,
    };
  }
}

class CommentModel extends CommentEntity {
  const CommentModel({
    required super.id,
    required super.comment,
    super.createdAt,
    super.user,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id']?.toString() ?? '',
      comment: json['comment'] ?? '',
      createdAt: json['createdAt'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'comment': comment,
      'createdAt': createdAt,
      'user': user?.toJson(),
    };
  }
}

class UserModel extends UserEntity {
  const UserModel({
    required super.username,
    super.profilePicture,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'] ?? '',
      profilePicture: json['profilePicture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'profilePicture': profilePicture,
    };
  }
} 