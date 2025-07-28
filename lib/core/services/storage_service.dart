import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class StorageService {
  Future<void> saveUserId(String userId);
  Future<String?> getUserId();
  Future<void> saveUserData({
    required String userId,
    required String username,
    required String email,
    String? token,
    String? firebaseToken,
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

  // Configuración de flutter_secure_storage
  static const _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  @override
  Future<void> saveUserId(String userId) async {
    await _secureStorage.write(key: _userIdKey, value: userId);
  }

  @override
  Future<String?> getUserId() async {
    return await _secureStorage.read(key: _userIdKey);
  }

  @override
  Future<void> saveUserData({
    required String userId,
    required String username,
    required String email,
    String? token,
    String? firebaseToken, // NUEVO
  }) async {
    await _secureStorage.write(key: _userIdKey, value: userId);
    await _secureStorage.write(key: _usernameKey, value: username);
    await _secureStorage.write(key: _emailKey, value: email);
    if (token != null) {
      await _secureStorage.write(key: _tokenKey, value: token);
    }
    if (firebaseToken != null) {
      await _secureStorage.write(key: _firebaseTokenKey, value: firebaseToken);
    }
  }

  @override
  Future<Map<String, String?>> getUserData() async {
    return {
      'userId': await _secureStorage.read(key: _userIdKey),
      'username': await _secureStorage.read(key: _usernameKey),
      'email': await _secureStorage.read(key: _emailKey),
      'token': await _secureStorage.read(key: _tokenKey),
      'firebaseToken': await _secureStorage.read(key: _firebaseTokenKey), // NUEVO
    };
  }

  @override
  Future<void> clearUserData() async {
    await _secureStorage.delete(key: _userIdKey);
    await _secureStorage.delete(key: _usernameKey);
    await _secureStorage.delete(key: _emailKey);
    await _secureStorage.delete(key: _tokenKey);
    await _secureStorage.delete(key: _firebaseTokenKey); // NUEVO
  }

  @override
  Future<bool> isUserLoggedIn() async {
    final userId = await getUserId();
    return userId != null && userId.isNotEmpty;
  }

  // Métodos específicos para Firebase token
  @override
  Future<void> saveFirebaseToken(String firebaseToken) async {
    await _secureStorage.write(key: _firebaseTokenKey, value: firebaseToken);
  }

  @override
  Future<String?> getFirebaseToken() async {
    return await _secureStorage.read(key: _firebaseTokenKey);
  }

  @override
  Future<void> clearFirebaseToken() async {
    await _secureStorage.delete(key: _firebaseTokenKey);
  }
}
