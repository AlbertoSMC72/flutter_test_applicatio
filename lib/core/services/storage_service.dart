import 'package:shared_preferences/shared_preferences.dart';

abstract class StorageService {
  Future<void> saveUserId(String userId);
  Future<String?> getUserId();
  Future<void> saveUserData({
    required String userId,
    required String username,
    required String email,
    String? token,
  });
  Future<Map<String, String?>> getUserData();
  Future<void> clearUserData();
  Future<bool> isUserLoggedIn();
}

class StorageServiceImpl implements StorageService {
  static const String _userIdKey = 'user_id';
  static const String _usernameKey = 'username';
  static const String _emailKey = 'email';
  static const String _tokenKey = 'token';

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
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
    await prefs.setString(_usernameKey, username);
    await prefs.setString(_emailKey, email);
    if (token != null) {
      await prefs.setString(_tokenKey, token);
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
    };
  }

  @override
  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
    await prefs.remove(_usernameKey);
    await prefs.remove(_emailKey);
    await prefs.remove(_tokenKey);
  }

  @override
  Future<bool> isUserLoggedIn() async {
    final userId = await getUserId();
    return userId != null && userId.isNotEmpty;
  }
}