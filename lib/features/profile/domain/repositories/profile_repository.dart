import '/../../features/profile/data/models/follow_user_model.dart';
import '/../../features/profile/data/models/profile_model.dart';

abstract class ProfileRepository {
  Future<Profile> getProfile(String userId);
  Future<Profile> getUserProfile(String userId, String requesterId);
  Future<Profile> updateProfile(String userId, Map<String, dynamic> updates);
  Future<Profile> updateProfilePicture(String userId, String profilePicture);
  Future<Profile> updateBanner(String userId, String banner);
  Future<FollowResponse> followUser(int userId, int targetUserId);
}