class FollowResponse {
  final bool success;
  final String message;
  final bool isFollowing;
  final int followersCount;
  final int followingCount;

  FollowResponse({
    required this.success,
    required this.message,
    required this.isFollowing,
    required this.followersCount,
    required this.followingCount,
  });

  factory FollowResponse.fromJson(Map<String, dynamic> json) {
    return FollowResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      isFollowing: json['isFollowing'] ?? false,
      followersCount: json['followersCount'] ?? 0,
      followingCount: json['followingCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'isFollowing': isFollowing,
      'followersCount': followersCount,
      'followingCount': followingCount,
    };
  }

  @override
  String toString() {
    return 'FollowResponse(success: $success, message: $message, isFollowing: $isFollowing, followersCount: $followersCount, followingCount: $followingCount)';
  }
}