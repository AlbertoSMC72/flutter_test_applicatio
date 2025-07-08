import '../../domain/entities/login_entity.dart';

class LoginModel extends LoginEntity {
  const LoginModel({
    super.id,
    super.username,
    required super.email,
    super.token,
    super.firebaseTokenSaved,
    super.notificationMessage,
  });

  // Factory para crear desde JSON (respuesta del backend)
  factory LoginModel.fromJson(Map<String, dynamic> json) {
    final notificationsData = json['data']?['notifications'];
    
    return LoginModel(
      id: json['data']?['user']?['id']?.toString() ?? json['id']?.toString(),
      username: json['data']?['user']?['username'] ?? json['username'],
      email: json['data']?['user']?['email'] ?? json['email'] ?? '',
      token: json['data']?['token'] ?? json['token'],
      firebaseTokenSaved: notificationsData?['firebaseTokenSaved'],
      notificationMessage: notificationsData?['message'],
    );
  }

  // JSON para login request
  static Map<String, dynamic> loginRequest({
    required String email,
    required String password,
    String? firebaseToken,
  }) {
    final Map<String, dynamic> data = {
      'email': email,
      'password': password,
    };
    
    // Agregar Firebase token si está disponible
    if (firebaseToken != null && firebaseToken.isNotEmpty) {
      data['firebaseToken'] = firebaseToken;
    }
    
    return data;
  }

  // Factory para crear desde Entity
  factory LoginModel.fromEntity(LoginEntity entity) {
    return LoginModel(
      id: entity.id,
      username: entity.username,
      email: entity.email,
      token: entity.token,
      firebaseTokenSaved: entity.firebaseTokenSaved,
      notificationMessage: entity.notificationMessage,
    );
  }

  // Convertir a Entity
  LoginEntity toEntity() {
    return LoginEntity(
      id: id,
      username: username,
      email: email,
      token: token,
      firebaseTokenSaved: firebaseTokenSaved,
      notificationMessage: notificationMessage,
    );
  }

  @override
  String toString() {
    return 'LoginModel(id: $id, username: $username, email: $email, hasToken: ${token != null}, firebaseTokenSaved: $firebaseTokenSaved)';
  }
}