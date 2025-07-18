import 'dart:io';


import 'package:flutter_application_1/core/services/storage_service.dart';
import 'package:flutter_application_1/core/utils/image_utils.dart';
import 'package:flutter_application_1/features/book/domain/entities/book_detail_entity.dart';
import 'package:flutter_application_1/features/profile/data/datasourcers/profile_api_service.dart';

import 'package:flutter_application_1/features/profile/domain/usecases/profile_usecases.dart';
import 'package:flutter_application_1/features/writenBook/domain/usecases/books_usecases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final StorageService storageService;
  final GetProfileUseCase getProfileUseCase;
  final GetAllGenresUseCase getAllGenresUseCase;
  final ProfileApiService profileApiService;
  final UpdateProfilePictureUseCase updateProfilePictureUseCase;
  final UpdateBannerUseCase updateBannerUseCase;

  ProfileCubit({
    required this.storageService,
    required this.getProfileUseCase,
    required this.getAllGenresUseCase,
    required this.profileApiService,
    required this.updateProfilePictureUseCase,
    required this.updateBannerUseCase
  }) : super(ProfileInitial());

  Future<void> loadProfile(String? userId) async {
    try {
      emit(ProfileLoading());

      final userData = await storageService.getUserData();
      final currentUserId = userData['userId'].toString();
      print("userData: $currentUserId");
      
      final profileUserId = userId ?? currentUserId;
      print("perfil?: $profileUserId y $currentUserId");
      
      if (profileUserId == '' || profileUserId == currentUserId || profileUserId == 'null' || profileUserId == 'undefined') {
        print("[DEBUG_PROFILE] Cargando perfil del usuario logueado: $currentUserId");
        await _loadOwnProfile(currentUserId, profileUserId);
      } else {
        print("[DEBUG_PROFILE] Cargando perfil de otro usuario: $profileUserId");
        await _loadOtherProfile(currentUserId, profileUserId);
      }

    } catch (e) {
      debugPrint('[DEBUG_PROFILE] Error cargando perfil: $e');
      emit(ProfileError(message: 'Error al cargar el perfil: $e'));
    }
  }

  Future<void> _loadOwnProfile(String currentUserId, String profileUserId) async {
    final logUserProfile = await getProfileUseCase.call(currentUserId);
    debugPrint("Usuario loggeado: $currentUserId : 'No hay libros'}");
    
    emit(ProfileLoaded(
      currentUserId: currentUserId,
      profileUserId: profileUserId,
      username: logUserProfile.username,
      friendCode: logUserProfile.friendCode,
      bio: logUserProfile.biography ?? '',
      profileImageUrl: logUserProfile.profilePicture,
      bannerImageUrl: logUserProfile.banner,
      friendsCount: logUserProfile.stats.friendsCount,
      followersCount: logUserProfile.stats.followersCount,
      favoriteGenres: logUserProfile.favoriteGenres,
      ownBooks: logUserProfile.ownBooks,
      favoriteBooks: logUserProfile.likedBooks,
      isOwnProfile: true,
      isFollowed: false,
      showFollowOptions: false,
      allGenres: [],
    ));
  }

  Future<void> _loadOtherProfile(String currentUserId, String profileUserId) async {
    final profile = await profileApiService.getUserProfile(profileUserId);
    final isFollowed = await _checkIfFollowing(profileUserId);
    
    debugPrint("Usuario visitado: "
        "ID: ${profile.id}, "
        "Nombre: ${profile.username}, "
        "Biografía: ${profile.biography}, "
        "Imagen de perfil: ${profile.profilePicture}, "
        "Banner: ${profile.banner}, "
        "Géneros favoritos: ${profile.favoriteGenres.map((g) => g.name).join(', ')}");
    
    emit(ProfileLoaded(
      currentUserId: currentUserId,
      profileUserId: profileUserId,
      username: profile.username,
      friendCode: profile.friendCode,
      bio: profile.biography ?? '',
      profileImageUrl: profile.profilePicture,
      bannerImageUrl: profile.banner,
      friendsCount: profile.stats.friendsCount,
      followersCount: profile.stats.followersCount,
      favoriteGenres: profile.favoriteGenres,
      ownBooks: profile.publishedBooks,
      favoriteBooks: [],
      isOwnProfile: false,
      isFollowed: isFollowed,
      showFollowOptions: false,
      allGenres: [],
    ));
  }

  Future<bool> _checkIfFollowing(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return false; 
  }

  void toggleFollowOptions() {
    final currentState = state;
    if (currentState is ProfileLoaded) {
      emit(currentState.copyWith(
        showFollowOptions: !currentState.showFollowOptions,
      ));
    }
  }

  Future<void> toggleFollow(String option) async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return;

    try {
      if (currentState.isFollowed || option == 'unfollow') {
        await _unfollowUser(currentState.profileUserId);
        
        emit(currentState.copyWith(
          isFollowed: false,
          followersCount: currentState.followersCount > 0 ? currentState.followersCount - 1 : 0,
          showFollowOptions: false,
        ));
        
        emit(ProfileFollowSuccess(
          message: 'Has dejado de seguir a este usuario',
          isFollowed: false,
        ));
      } else {
        await _followUser(currentState.profileUserId, option);
        
        emit(currentState.copyWith(
          isFollowed: true,
          followersCount: currentState.followersCount + 1,
          showFollowOptions: false,
        ));

        String message = '';
        switch (option) {
          case 'Todas':
            message = 'Ahora recibirás todas las notificaciones';
            break;
          case 'Personalizadas':
            message = 'Configurando notificaciones personalizadas';
            break;
          case 'Ninguna':
            message = 'Siguiendo sin notificaciones';
            break;
        }

        emit(ProfileFollowSuccess(
          message: message,
          isFollowed: true,
        ));
      }
    } catch (e) {
      emit(ProfileError(message: 'Error: $e'));
    }
  }

  Future<void> _followUser(String userId, String notificationType) async {
    await Future.delayed(const Duration(milliseconds: 500));
    debugPrint('[DEBUG_PROFILE] Siguiendo usuario $userId con notificaciones: $notificationType');
  }

  Future<void> _unfollowUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    debugPrint('[DEBUG_PROFILE] Dejando de seguir usuario $userId');
  }

  Future<void> refreshProfile() async {
    final currentState = state;
    if (currentState is ProfileLoaded) {
      await loadProfile(currentState.profileUserId == currentState.currentUserId ? null : currentState.profileUserId);
    }
  }

  Future<void> loadAllGenres() async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return;

    try {
      if (currentState.allGenres.isEmpty) {
        final allGenres = await getAllGenresUseCase.call();
        emit(currentState.copyWith(allGenres: allGenres));
      }
    } catch (e) {
      emit(ProfileError(message: 'Error al cargar géneros: $e'));
    }
  }

  Future<void> updateBannerImage(String userId, String source) async {
    emit(ProfileLoading());
    try {
      File? imageFile;
      if (source == 'camera') {
        imageFile = await ImageUtils.pickImage(source: ImageSource.camera);
      } else {
        imageFile = await ImageUtils.pickImage(source: ImageSource.gallery);
      }
      if (imageFile == null) {
        emit(ProfileError(message: 'No se seleccionó imagen'));
        return;
      }
      String? base64Image = await ImageUtils.fileToBase64(imageFile);
      if (base64Image == null) {
        emit(ProfileError(message: 'Error al procesar la imagen'));
        return;
      }
      final updatedProfile = await updateBannerUseCase.call(userId, base64Image);
      emit(ProfileImageUpdated(updatedProfile.banner, isBanner: true));
    } catch (e) {
      emit(ProfileError(message: 'Error al actualizar imagen: $e'));
    }
  }

  Future<void> updateProfile({
    required String username,
    required String bio,
    required List<dynamic> favoriteGenres,
  }) async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return;

    try {
      emit(ProfileUpdateLoading());

      final genreIds = favoriteGenres.map((g) {
        dynamic id;
        if (g is GenreEntity) {
          id = g.id;
        } else if (g is Map && g['id'] != null) {
          id = g['id'];
        } else if (g is String) {
          id = int.tryParse(g);
        } else if (g is dynamic && g.id != null) {
          id = g.id;
        } else {
          id = g;
        }
        if (id is String) {
          return int.tryParse(id) ?? 0;
        }
        return id;
      }).toList();

      final updates = {
        'username': username,
        'biography': bio,
        'favoriteGenres': genreIds,
      };

      if (currentState.currentUserId == null) {
        emit(ProfileError(message: 'No se encontró el ID de usuario para actualizar.'));
        return;
      }

      await profileApiService.updateProfile(currentState.currentUserId, updates);
      await loadProfile(currentState.currentUserId);
      emit(ProfileUpdateSuccess(message: 'Perfil actualizado correctamente'));
    } catch (e) {
      emit(ProfileError(message: 'Error al actualizar el perfil: $e'));
    }
  }

  Future<void> updateProfileImage(String userId, String source) async {
    emit(ProfileLoading());
    try {
      File? imageFile;
      if (source == 'camera') {
        imageFile = await ImageUtils.pickImage(source: ImageSource.camera);
      } else {
        imageFile = await ImageUtils.pickImage(source: ImageSource.gallery);
      }
      if (imageFile == null) {
        emit(ProfileError(message: 'No se seleccionó imagen'));
        return;
      }
      String? base64Image = await ImageUtils.fileToBase64(imageFile);
      if (base64Image == null) {
        emit(ProfileError(message: 'Error al procesar la imagen'));
        return;
      }
      final updatedProfile = await updateProfilePictureUseCase.call(userId, base64Image);
      emit(ProfileImageUpdated(updatedProfile.profilePicture, isBanner: false));
    } catch (e) {
      emit(ProfileError(message: 'Error al actualizar imagen: $e'));
    }
  }
}