import '../../domain/entities/chapter_entity.dart';

class ChapterDetailModel extends ChapterDetailEntity {
  const ChapterDetailModel({
    required super.id,
    required super.title,
    required super.published,
    super.createdAt,
    required super.bookId,
    super.book,
    required super.paragraphs,
    required super.comments,
  });

  factory ChapterDetailModel.fromJson(Map<String, dynamic> json) {
    return ChapterDetailModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      published: json['published'] ?? false,
      createdAt: json['createdAt'],
      bookId: json['bookId']?.toString() ?? '',
      book: json['book'] != null ? BookInfoModel.fromJson(json['book']) : null,
      paragraphs: json['paragraphs'] != null
        ? (json['paragraphs'] as List).map((p) => ParagraphModel.fromJson(p)).toList()
        : [],
      comments: json['comments'] != null
        ? (json['comments'] as List).map((c) => ChapterCommentModel.fromJson(c)).toList()
        : [],
    );
  }
}

class BookInfoModel extends BookInfoEntity {
  const BookInfoModel({
    required super.title,
    super.author,
  });

  factory BookInfoModel.fromJson(Map<String, dynamic> json) {
    return BookInfoModel(
      title: json['title'] ?? '',
      author: json['author'] != null ? AuthorModel.fromJson(json['author']) : null,
    );
  }
}

class ParagraphModel extends ParagraphEntity {
  const ParagraphModel({
    required super.id,
    required super.paragraphNumber,
    required super.content,
  });

  factory ParagraphModel.fromJson(Map<String, dynamic> json) {
    return ParagraphModel(
      id: json['id']?.toString() ?? '',
      paragraphNumber: json['paragraphNumber'] ?? 0,
      content: json['content'] ?? '',
    );
  }
}

class ChapterCommentModel extends ChapterCommentEntity {
  const ChapterCommentModel({
    required super.id,
    required super.comment,
    super.createdAt,
    super.user,
  });

  factory ChapterCommentModel.fromJson(Map<String, dynamic> json) {
    return ChapterCommentModel(
      id: json['id']?.toString() ?? '',
      comment: json['comment'] ?? '',
      createdAt: json['createdAt'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
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
} 