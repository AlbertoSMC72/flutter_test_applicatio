import 'package:flutter_application_1/features/profile/data/models/profile_model.dart';
import 'package:flutter_application_1/features/profile/domain/repositories/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository repository;

  GetProfileUseCase({required this.repository});

  Future<Profile> call(String userId) async {
    try {
      return await repository.getProfile(userId);
    } catch (e) {
      rethrow;
    }
  }
}

class GetUserProfileUseCase {
  final ProfileRepository repository;

  GetUserProfileUseCase({required this.repository});

  Future<Profile> call(String userId) async {
    try {
      return await repository.getUserProfile(userId);
    } catch (e) {
      rethrow;
    }
  }
}

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase({required this.repository});

  Future<Profile> call(String userId, Map<String, dynamic> updates) async {
    try {
      _validateProfileUpdates(updates);
      
      return await repository.updateProfile(userId, updates);
    } catch (e) {
      rethrow;
    }
  }

  void _validateProfileUpdates(Map<String, dynamic> updates) {
    if (updates.containsKey('username')) {
      final username = updates['username'] as String?;
      if (username == null || username.trim().isEmpty) {
        throw Exception('El nombre de usuario es requerido');
      }
      if (username.trim().length < 3) {
        throw Exception('El nombre de usuario debe tener al menos 3 caracteres');
      }
      if (username.trim().length > 20) {
        throw Exception('El nombre de usuario no puede tener más de 20 caracteres');
      }
    }

    if (updates.containsKey('biography')) {
      final biography = updates['biography'] as String?;
      if (biography != null && biography.length > 500) {
        throw Exception('La biografía no puede tener más de 500 caracteres');
      }
    }

    if (updates.containsKey('favoriteGenres')) {
      final favoriteGenres = updates['favoriteGenres'] as List<dynamic>?;
      if (favoriteGenres == null || favoriteGenres.isEmpty) {
        throw Exception('Debe seleccionar al menos un género favorito');
      }
    }
  }
}

class UpdateProfilePictureUseCase {
  final ProfileRepository repository;

  UpdateProfilePictureUseCase({required this.repository});

  Future<Profile> call(String userId, String profilePictureBase64) async {
    try {
      _validateProfilePicture(profilePictureBase64);
      
      return await repository.updateProfilePicture(userId, profilePictureBase64);
    } catch (e) {
      rethrow;
    }
  }

  void _validateProfilePicture(String base64Image) {
    if (base64Image.trim().isEmpty) {
      throw Exception('La imagen de perfil es requerida');
    }

    if (!_isValidBase64Image(base64Image)) {
      throw Exception('Formato de imagen inválido');
    }

    final sizeInBytes = _getBase64SizeInBytes(base64Image);
    const maxSize = 5 * 1024 * 1024; 
    if (sizeInBytes > maxSize) {
      throw Exception('La imagen de perfil no puede ser mayor a 5MB');
    }
  }

  bool _isValidBase64Image(String base64String) {
    try {
      String cleanBase64 = base64String;
      if (base64String.contains(',')) {
        final parts = base64String.split(',');
        if (parts.length != 2) return false;
        
        final prefix = parts[0];
        if (!prefix.startsWith('data:image/')) return false;
        
        cleanBase64 = parts[1];
      }

      final RegExp base64RegExp = RegExp(r'^[A-Za-z0-9+/]*={0,2}$');
      if (!base64RegExp.hasMatch(cleanBase64)) {
        return false;
      }

      if (cleanBase64.length < 100) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  int _getBase64SizeInBytes(String base64String) {
    String cleanBase64 = base64String;
    if (base64String.contains(',')) {
      cleanBase64 = base64String.split(',').last;
    }
    
    final padding = cleanBase64.endsWith('==') ? 2 : cleanBase64.endsWith('=') ? 1 : 0;
    return ((cleanBase64.length * 3) ~/ 4) - padding;
  }
}

class UpdateBannerUseCase {
  final ProfileRepository repository;

  UpdateBannerUseCase({required this.repository});

  Future<Profile> call(String userId, String bannerBase64) async {
    try {
      _validateBanner(bannerBase64);
      
      return await repository.updateBanner(userId, bannerBase64);
    } catch (e) {
      rethrow;
    }
  }

  void _validateBanner(String base64Image) {
    if (base64Image.trim().isEmpty) {
      throw Exception('La imagen del banner es requerida');
    }

    if (!_isValidBase64Image(base64Image)) {
      throw Exception('Formato de imagen inválido');
    }

    final sizeInBytes = _getBase64SizeInBytes(base64Image);
    const maxSize = 10 * 1024 * 1024;
    if (sizeInBytes > maxSize) {
      throw Exception('La imagen del banner no puede ser mayor a 10MB');
    }

    _validateBannerFormat(base64Image);
  }

  bool _isValidBase64Image(String base64String) {
    try {
      String cleanBase64 = base64String;
      if (base64String.contains(',')) {
        final parts = base64String.split(',');
        if (parts.length != 2) return false;
        
        final prefix = parts[0];
        if (!prefix.startsWith('data:image/')) return false;
        
        cleanBase64 = parts[1];
      }

      final RegExp base64RegExp = RegExp(r'^[A-Za-z0-9+/]*={0,2}$');
      if (!base64RegExp.hasMatch(cleanBase64)) {
        return false;
      }

      if (cleanBase64.length < 100) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  void _validateBannerFormat(String base64String) {
    if (base64String.contains(',')) {
      final prefix = base64String.split(',')[0];
      
      const allowedFormats = ['data:image/jpeg', 'data:image/jpg', 'data:image/png', 'data:image/webp'];
      
      if (!allowedFormats.any((format) => prefix.startsWith(format))) {
        throw Exception('Formato de imagen no válido para banner. Use JPG, PNG o WebP');
      }
    }
  }

  int _getBase64SizeInBytes(String base64String) {
    String cleanBase64 = base64String;
    if (base64String.contains(',')) {
      cleanBase64 = base64String.split(',').last;
    }
    
    final padding = cleanBase64.endsWith('==') ? 2 : cleanBase64.endsWith('=') ? 1 : 0;
    return ((cleanBase64.length * 3) ~/ 4) - padding;
  }
}