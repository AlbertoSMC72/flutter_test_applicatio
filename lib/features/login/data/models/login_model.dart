import '../../domain/entities/login_entity.dart';

class LoginModel extends LoginEntity {
  const LoginModel({
    super.id,
    super.username,
    required super.email,
    super.token,
  });

  // Factory para crear desde JSON (respuesta del backend)
  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      id: json['id']?.toString(),
      username: json['username'],
      email: json['email'] ?? '',
      token: json['token'],
    );
  }

  // Convertir a JSON para enviar al backend
  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }

  // JSON para login request
  static Map<String, dynamic> loginRequest({
    required String email,
    required String password,
  }) {
    return {
      'email': email,
      'password': password,
    };
  }

  // Factory para crear desde Entity
  factory LoginModel.fromEntity(LoginEntity entity) {
    return LoginModel(
      id: entity.id,
      username: entity.username,
      email: entity.email,
      token: entity.token,
    );
  }

  // Convertir a Entity
  LoginEntity toEntity() {
    return LoginEntity(
      id: id,
      username: username,
      email: email,
      token: token,
    );
  }

  @override
  String toString() {
    return 'LoginModel(id: $id, username: $username, email: $email, hasToken: ${token != null})';
  }
}