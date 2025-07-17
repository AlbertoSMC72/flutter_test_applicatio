import 'package:flutter_application_1/features/profile/data/models/profile_model.dart';

abstract class ProfileRepository {
  Future<Profile> getProfile(String userId);
  Future<Profile> getUserProfile(String userId);
  Future<Profile> updateProfile(String userId, Map<String, dynamic> updates);
  Future<Profile> updateProfilePicture(String userId, String profilePicture);
  Future<Profile> updateBanner(String userId, String banner);
}