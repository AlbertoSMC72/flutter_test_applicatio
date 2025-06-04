class LoginEntity {
  final String? id;
  final String? username;
  final String email;
  final String? token;

  const LoginEntity({
    this.id,
    this.username,
    required this.email,
    this.token,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LoginEntity &&
        other.id == id &&
        other.username == username &&
        other.email == email &&
        other.token == token;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        username.hashCode ^
        email.hashCode ^
        token.hashCode;
  }

  @override
  String toString() {
    return 'LoginEntity(id: $id, username: $username, email: $email)';
  }
}