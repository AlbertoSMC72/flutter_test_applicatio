class ChapterDetailEntity {
  final String id;
  final String title;
  final bool published;
  final dynamic createdAt;
  final String bookId;
  final BookInfoEntity? book;
  final List<ParagraphEntity> paragraphs;
  final List<ChapterCommentEntity> comments;

  const ChapterDetailEntity({
    required this.id,
    required this.title,
    required this.published,
    this.createdAt,
    required this.bookId,
    this.book,
    required this.paragraphs,
    required this.comments,
  });
}

class BookInfoEntity {
  final String title;
  final AuthorEntity? author;

  const BookInfoEntity({
    required this.title,
    this.author,
  });
}

class ParagraphEntity {
  final String id;
  final int paragraphNumber;
  final String content;

  const ParagraphEntity({
    required this.id,
    required this.paragraphNumber,
    required this.content,
  });
}

class ChapterCommentEntity {
  final String id;
  final String comment;
  final dynamic createdAt;
  final UserEntity? user;

  const ChapterCommentEntity({
    required this.id,
    required this.comment,
    this.createdAt,
    this.user,
  });
}

class AuthorEntity {
  final String username;
  final String? profilePicture;

  const AuthorEntity({
    required this.username,
    this.profilePicture,
  });
}

class UserEntity {
  final String username;
  final String? profilePicture;

  const UserEntity({
    required this.username,
    this.profilePicture,
  });
} 