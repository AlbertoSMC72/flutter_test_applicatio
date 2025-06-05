// features/writenBook/domain/entities/user_books_entity.dart
import 'book_entity.dart';

class UserBooksEntity {
  final UserEntity user;
  final List<BookEntity> books;

  const UserBooksEntity({
    required this.user,
    required this.books,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserBooksEntity &&
        other.user == user &&
        other.books == books;
  }

  @override
  int get hashCode {
    return user.hashCode ^ books.hashCode;
  }

  @override
  String toString() {
    return 'UserBooksEntity(user: $user, books: ${books.length} books)';
  }
}

class UserEntity {
  final int id;
  final String username;
  final String email;
  final String passwordHash;
  final String createdAt;
  final String firebaseToken;

  const UserEntity({
    required this.id,
    required this.username,
    required this.email,
    required this.passwordHash,
    required this.createdAt,
    required this.firebaseToken,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserEntity &&
        other.id == id &&
        other.username == username &&
        other.email == email;
  }

  @override
  int get hashCode {
    return id.hashCode ^ username.hashCode ^ email.hashCode;
  }

  @override
  String toString() {
    return 'UserEntity(id: $id, username: $username, email: $email)';
  }
}