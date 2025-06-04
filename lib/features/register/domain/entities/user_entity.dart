class UserEntity {
  final String? id;
  final String username;
  final String email;
  final String password;

  const UserEntity({
    this.id,
    required this.username,
    required this.email,
    required this.password,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserEntity &&
        other.id == id &&
        other.username == username &&
        other.email == email &&
        other.password == password;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        username.hashCode ^
        email.hashCode ^
        password.hashCode;
  }

  @override
  String toString() {
    return 'UserEntity(id: $id, username: $username, email: $email)';
  }
}