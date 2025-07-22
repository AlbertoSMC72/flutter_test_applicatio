import '../../domain/entities/fav_book_entity.dart';

class FavBookModel extends FavBookEntity {
  FavBookModel({
    required super.id,
    required super.userId,
    required super.bookId,
    required super.createdAt,
    required super.book,
  });

  factory FavBookModel.fromJson(Map<String, dynamic> json) {
    return FavBookModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      bookId: json['bookId'] ?? '',
      createdAt: json['createdAt'] ?? '',
      book: BookModel.fromJson(json['book'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'bookId': bookId,
      'createdAt': createdAt,
      'book': (book as BookModel).toJson(),
    };
  }

  FavBookModel copyWith({
    String? id,
    String? userId,
    String? bookId,
    String? createdAt,
    BookEntity? book,
  }) {
    return FavBookModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      bookId: bookId ?? this.bookId,
      createdAt: createdAt ?? this.createdAt,
      book: book ?? this.book,
    );
  }
}

class BookModel extends BookEntity {
  BookModel({
    required super.id,
    required super.title,
    required super.author,
    super.description,
    super.genres,
    super.coverImage,
    super.likesCount,
    super.isLiked,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      author: AuthorModel.fromJson(json['author'] ?? {}),
      description: json['description'],
      genres: (json['genres'] as List?)?.map((e) => e.toString()).toList(),
      coverImage: json['coverImage'],
      likesCount: json['likesCount'],
      isLiked: json['isLiked'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': (author as AuthorModel).toJson(),
      'description': description,
      'genres': genres,
      'coverImage': coverImage,
      'likesCount': likesCount,
      'isLiked': isLiked,
    };
  }

  BookModel copyWith({
    String? id,
    String? title,
    AuthorEntity? author,
    String? description,
    List<String>? genres,
    String? coverImage,
    int? likesCount,
    bool? isLiked,
  }) {
    return BookModel(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      genres: genres ?? this.genres,
      coverImage: coverImage ?? this.coverImage,
      likesCount: likesCount ?? this.likesCount,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}

class AuthorModel extends AuthorEntity {
  AuthorModel({
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