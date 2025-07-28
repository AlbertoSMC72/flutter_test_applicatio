import 'dart:io';


import '/../../core/services/storage_service.dart';
import '/../../core/utils/image_utils.dart';
import '/../../features/book/domain/entities/book_detail_entity.dart';
import '/../../features/profile/data/datasourcers/profile_api_service.dart';
import '/../../features/profile/data/models/follow_user_model.dart';

import '/../../features/profile/domain/usecases/profile_usecases.dart';
import '/../../features/writenBook/domain/usecases/books_usecases.dart';
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
  final FollowUserUseCase followUserUseCase;

  ProfileCubit({
    required this.storageService,
    required this.getProfileUseCase,
    required this.getAllGenresUseCase,
    required this.profileApiService,
    required this.updateProfilePictureUseCase,
    required this.updateBannerUseCase,
    required this.followUserUseCase
  }) : super(ProfileInitial());

  Future<void> loadProfile(String? userId) async {
    print("[DEBUG_PROFILE] Cargando datos del usuario $userId");
    try {
      emit(ProfileLoading());

      final userData = await storageService.getUserData();
      final currentUserId = userData['userId'].toString();
      print("[DEBUG_PROFILE] userData: $currentUserId");
      
      final profileUserId = userId ?? currentUserId;
      print("[DEBUG_PROFILE] perfil?: $profileUserId y $currentUserId");
      
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
    debugPrint('[DEBUG_PROFILE] Cargando perfil externo');
    debugPrint('[DEBUG_PROFILE] Datos recibidos: currentUserId: $currentUserId, profileUserId: $profileUserId');
    final profile = await profileApiService.getUserProfile(currentUserId, profileUserId);
    debugPrint('[DEBUG_PROFILE] currentUserId: $currentUserId, profileUserId: $profileUserId');
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
      isFollowed: profile.isFollwing,
      showFollowOptions: profile.isFollwing,
      allGenres: [],
    ));
  }

  void toggleFollowOptions(isFollowing) {
      final currentState = state;
      if (currentState is ProfileLoaded) {
        emit(currentState.copyWith(
          showFollowOptions: !currentState.showFollowOptions,
        ));
      }
    }

    Future<void> toggleFollow(String action) async {
    debugPrint('[DEBUG_FOLLOW] Acción de seguir realizada con la accion: $action');
    final currentState = state;
    if (currentState is! ProfileLoaded) return;

    try {
      if (action == 'unfollow') {
        // Dejar de seguir
        final response = await _unfollowUser(
          currentState.currentUserId,                    
          currentState.profileUserId,       
        );
        
        emit(currentState.copyWith(
          isFollowed: false,
          followersCount: response.followersCount, 
          showFollowOptions: false,
        ));
        
        emit(ProfileFollowSuccess(
          message: response.message,
          isFollowed: false,
        ));
      } else {
        // Seguir
        final response = await _followUser(
          currentState.currentUserId,                  
          currentState.profileUserId,       
        );
        
        emit(currentState.copyWith(
          isFollowed: true,
          followersCount: response.followersCount, 
          showFollowOptions: false,
        ));

        emit(ProfileFollowSuccess(
          message: response.message,
          isFollowed: true,
        ));
      }
    } catch (e) {
      emit(ProfileError(message: 'Error: $e'));
    }
  }

  Future<FollowResponse> _followUser(String loggedUserId, String targetUserId) async {
    debugPrint('[DEBUG_FOLLOW] Usuario loggueado: $loggedUserId, usuario a seguir: $targetUserId');
    try {      
      final response = await followUserUseCase.call(
        int.parse(loggedUserId),    
        int.parse(targetUserId),   
      );
      
      if (!response.success) {
        throw Exception(response.message);
      }
      refreshProfile();
      debugPrint('[DEBUG_FOLLOW] Follow exitoso: ${response.message}');
      return response;
      
    } catch (e) {
      debugPrint('[DEBUG_FOLLOW] Error al seguir usuario: $e');
      rethrow;
    }
  }

  Future<FollowResponse> _unfollowUser(String loggedUserId, String targetUserId) async {
    try {
      debugPrint('[DEBUG_FOLLOW] Usuario $loggedUserId dejando de seguir a $targetUserId');
      
      final response = await followUserUseCase.call(
        int.parse(loggedUserId),    
        int.parse(targetUserId),  
      );
      
      if (!response.success) {
        throw Exception(response.message);
      }
      
      refreshProfile();
      debugPrint('[DEBUG_FOLLOW] Unfollow exitoso: ${response.message}');
      return response;
      
    } catch (e) {
      debugPrint('[DEBUG_FOLLOW] Error al dejar de seguir usuario: $e');
      rethrow;
    }
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
        // ignore: unnecessary_type_check
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

      // ignore: unnecessary_null_comparison
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