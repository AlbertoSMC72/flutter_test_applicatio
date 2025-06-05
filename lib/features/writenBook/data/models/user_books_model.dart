import '../../domain/entities/user_books_entity.dart';
import 'book_model.dart';

class UserBooksModel extends UserBooksEntity {
  const UserBooksModel({
    required super.user,
    required super.books,
  });

  factory UserBooksModel.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] as Map<String, dynamic>;
    final booksJson = json['books'] as List<dynamic>;

    return UserBooksModel(
      user: UserModel.fromJson(userJson),
      books: booksJson.map((book) => BookModel.fromJson(book)).toList(),
    );
  }

  UserBooksEntity toEntity() {
    return UserBooksEntity(
      user: user,
      books: books,
    );
  }
}

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.username,
    required super.email,
    required super.passwordHash,
    required super.createdAt,
    required super.firebaseToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      passwordHash: json['password_hash'] ?? '',
      createdAt: json['created_at'] ?? '',
      firebaseToken: json['firebase_token'] ?? '',
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      username: username,
      email: email,
      passwordHash: passwordHash,
      createdAt: createdAt,
      firebaseToken: firebaseToken,
    );
  }
}