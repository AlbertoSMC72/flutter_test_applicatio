import 'package:shared_preferences/shared_preferences.dart';

abstract class StorageService {
  Future<void> saveUserId(String userId);
  Future<String?> getUserId();
  Future<void> saveUserData({
    required String userId,
    required String username,
    required String email,
    String? token,
    String? firebaseToken, // NUEVO
  });
  Future<Map<String, String?>> getUserData();
  Future<void> clearUserData();
  Future<bool> isUserLoggedIn();
  
  // Métodos específicos para Firebase token
  Future<void> saveFirebaseToken(String firebaseToken);
  Future<String?> getFirebaseToken();
  Future<void> clearFirebaseToken();
}

class StorageServiceImpl implements StorageService {
  static const String _userIdKey = 'user_id';
  static const String _usernameKey = 'username';
  static const String _emailKey = 'email';
  static const String _tokenKey = 'token';
  static const String _firebaseTokenKey = 'firebase_token'; // NUEVO

  @override
  Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
  }

  @override
  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  @override
  Future<void> saveUserData({
    required String userId,
    required String username,
    required String email,
    String? token,
    String? firebaseToken, // NUEVO
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
    await prefs.setString(_usernameKey, username);
    await prefs.setString(_emailKey, email);
    if (token != null) {
      await prefs.setString(_tokenKey, token);
    }
    if (firebaseToken != null) {
      await prefs.setString(_firebaseTokenKey, firebaseToken);
    }
  }

  @override
  Future<Map<String, String?>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'userId': prefs.getString(_userIdKey),
      'username': prefs.getString(_usernameKey),
      'email': prefs.getString(_emailKey),
      'token': prefs.getString(_tokenKey),
      'firebaseToken': prefs.getString(_firebaseTokenKey), // NUEVO
    };
  }

  @override
  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
    await prefs.remove(_usernameKey);
    await prefs.remove(_emailKey);
    await prefs.remove(_tokenKey);
    await prefs.remove(_firebaseTokenKey); // NUEVO
  }

  @override
  Future<bool> isUserLoggedIn() async {
    final userId = await getUserId();
    return userId != null && userId.isNotEmpty;
  }

  // Métodos específicos para Firebase token
  @override
  Future<void> saveFirebaseToken(String firebaseToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_firebaseTokenKey, firebaseToken);
  }

  @override
  Future<String?> getFirebaseToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_firebaseTokenKey);
  }

  @override
  Future<void> clearFirebaseToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_firebaseTokenKey);
  }
}
