class BookDetailEntity {
  final String id;
  final String title;
  final String description;
  final String? coverImage;
  final bool? published;
  final dynamic createdAt;
  final String authorId;
  final AuthorEntity? author;
  final List<GenreEntity>? genres;
  final List<ChapterEntity>? chapters;
  final List<CommentEntity>? comments;

  const BookDetailEntity({
    required this.id,
    required this.title,
    required this.description,
    this.coverImage,
    this.published,
    this.createdAt,
    required this.authorId,
    this.author,
    this.genres,
    this.chapters,
    this.comments,
  });
}

class AuthorEntity {
  final String username;
  final String? profilePicture;

  const AuthorEntity({
    required this.username,
    this.profilePicture,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'profilePicture': profilePicture,
    };
  }
}

class GenreEntity {
  final String id;
  final String name;

  const GenreEntity({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class ChapterEntity {
  final String id;
  final String title;
  final bool? published;
  final dynamic createdAt;
  final bool? isLiked;

  const ChapterEntity({
    required this.id,
    required this.title,
    this.published,
    this.createdAt,
    this.isLiked,
  });

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

class CommentEntity {
  final String id;
  final String comment;
  final dynamic createdAt;
  final UserEntity? user;

  const CommentEntity({
    required this.id,
    required this.comment,
    this.createdAt,
    this.user,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'comment': comment,
      'createdAt': createdAt,
      'user': user?.toJson(),
    };
  }
}

class UserEntity {
  final String username;
  final String? profilePicture;

  const UserEntity({
    required this.username,
    this.profilePicture,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'profilePicture': profilePicture,
    };
  }
} 