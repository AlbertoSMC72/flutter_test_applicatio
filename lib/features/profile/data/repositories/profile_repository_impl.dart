import '/../../features/profile/data/datasourcers/profile_api_service.dart';
import '/../../features/profile/data/models/follow_user_model.dart';
import '/../../features/profile/data/models/profile_model.dart';
import '/../../features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileApiService apiService;

  ProfileRepositoryImpl({required this.apiService});

  @override
  Future<Profile> getProfile(String userId) async {
    try {
      final result = await apiService.getProfile(userId);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Profile> getUserProfile(String userId, String requesterId) async {
    try {
      final result = await apiService.getUserProfile(userId, requesterId);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Profile> updateProfile(String userId, Map<String, dynamic> updates) async {
    try {
      final result = await apiService.updateProfile(userId, updates);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Profile> updateProfilePicture(String userId, String imagePath) async {
    try {
      final result = await apiService.updateProfilePicture(userId, imagePath);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Profile> updateBanner(String userId, String imagePath) async {
    try {
      final result = await apiService.updateBanner(userId, imagePath);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<FollowResponse> followUser(int userId, int targetUserId) async {
    try {
      final result = await apiService.followUser(userId, targetUserId);
      return result;
    } catch (e) {
      rethrow;
    }
  }
}