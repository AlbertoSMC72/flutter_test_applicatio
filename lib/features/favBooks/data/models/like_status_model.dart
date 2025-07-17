import '../../domain/entities/like_status_entity.dart';

class LikeStatusModel extends LikeStatusEntity {
  LikeStatusModel({
    required super.isLiked,
    required super.likesCount,
  });

  factory LikeStatusModel.fromJson(Map<String, dynamic> json) {
    return LikeStatusModel(
      isLiked: json['isLiked'] ?? false,
      likesCount: json['likesCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isLiked': isLiked,
      'likesCount': likesCount,
    };
  }
} 