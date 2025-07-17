class FavBookEntity {
  final String id;
  final String userId;
  final String bookId;
  final String createdAt;
  final BookEntity book;

  FavBookEntity({
    required this.id,
    required this.userId,
    required this.bookId,
    required this.createdAt,
    required this.book,
  });

  FavBookEntity copyWith({
    String? id,
    String? userId,
    String? bookId,
    String? createdAt,
    BookEntity? book,
  }) {
    return FavBookEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      bookId: bookId ?? this.bookId,
      createdAt: createdAt ?? this.createdAt,
      book: book ?? this.book,
    );
  }
}

class BookEntity {
  final String id;
  final String title;
  final AuthorEntity author;
  final String? coverImage;
  final int? likesCount;
  final bool? isLiked;

  BookEntity({
    required this.id,
    required this.title,
    required this.author,
    this.coverImage,
    this.likesCount,
    this.isLiked,
  });

  BookEntity copyWith({
    String? id,
    String? title,
    AuthorEntity? author,
    String? coverImage,
    int? likesCount,
    bool? isLiked,
  }) {
    return BookEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      coverImage: coverImage ?? this.coverImage,
      likesCount: likesCount ?? this.likesCount,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}

class AuthorEntity {
  final String username;
  final String? profilePicture;

  AuthorEntity({
    required this.username,
    this.profilePicture,
  });
} 