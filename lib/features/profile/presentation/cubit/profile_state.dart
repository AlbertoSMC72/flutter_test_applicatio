import 'package:equatable/equatable.dart';

import 'package:flutter_application_1/features/writenBook/domain/entities/genre_entity.dart' as writtenbook_entities;
import 'package:flutter_application_1/features/profile/data/models/profile_model.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
  
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String currentUserId;
  final String profileUserId;
  final String username;
  final String friendCode;
  final String bio;
  final String profileImageUrl;
  final String bannerImageUrl;
  final int friendsCount;
  final int followersCount;
  final List<dynamic> favoriteGenres;
  final List<OwnBook> ownBooks;
  final List<Book> favoriteBooks;
  final bool isOwnProfile;
  final bool isFollowed;
  final bool showFollowOptions;
  final List<writtenbook_entities.GenreEntity> allGenres;

  const ProfileLoaded({
    required this.currentUserId,
    required this.profileUserId,
    required this.username,
    required this.friendCode,
    required this.bio,
    required this.profileImageUrl,
    required this.bannerImageUrl,
    required this.friendsCount,
    required this.followersCount,
    required this.favoriteGenres,
    required this.ownBooks,
    required this.favoriteBooks,
    required this.isOwnProfile,
    required this.isFollowed,
    required this.showFollowOptions,
    this.allGenres = const [],
  });

  ProfileLoaded copyWith({
    String? currentUserId,
    String? profileUserId,
    String? username,
    String? friendCode,
    String? bio,
    String? profileImageUrl,
    String? bannerImageUrl,
    int? friendsCount,
    int? followersCount,
    List<dynamic>? favoriteGenres,
    List<OwnBook>? ownBooks,
    List<Book>? favoriteBooks,
    bool? isOwnProfile,
    bool? isFollowed,
    bool? showFollowOptions,
    List<writtenbook_entities.GenreEntity>? allGenres,
  }) {
    return ProfileLoaded(
      currentUserId: currentUserId ?? this.currentUserId,
      profileUserId: profileUserId ?? this.profileUserId,
      username: username ?? this.username,
      friendCode: friendCode ?? this.friendCode,
      bio: bio ?? this.bio,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bannerImageUrl: bannerImageUrl ?? this.bannerImageUrl,
      friendsCount: friendsCount ?? this.friendsCount,
      followersCount: followersCount ?? this.followersCount,
      favoriteGenres: favoriteGenres ?? this.favoriteGenres,
      ownBooks: ownBooks ?? this.ownBooks,
      favoriteBooks: favoriteBooks ?? this.favoriteBooks,
      isOwnProfile: isOwnProfile ?? this.isOwnProfile,
      isFollowed: isFollowed ?? this.isFollowed,
      showFollowOptions: showFollowOptions ?? this.showFollowOptions,
      allGenres: allGenres ?? this.allGenres,
    );
  }

  @override
  List<Object?> get props => [
    currentUserId,
    profileUserId,
    username,
    friendCode,
    bio,
    profileImageUrl,
    bannerImageUrl,
    friendsCount,
    followersCount,
    favoriteGenres,
    ownBooks,
    favoriteBooks,
    isOwnProfile,
    isFollowed,
    showFollowOptions,
    allGenres,
  ];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ProfileImageUpdated extends ProfileState {
  final String imageUrl;
  final bool isBanner;

  const ProfileImageUpdated(this.imageUrl, {this.isBanner = false});

  @override
  List<Object?> get props => [imageUrl, isBanner];
}

class ProfileFollowLoading extends ProfileState {}

class ProfileFollowSuccess extends ProfileState {
  final String message;
  final bool isFollowed;

  const ProfileFollowSuccess({
    required this.message,
    required this.isFollowed,
  });

  @override
  List<Object?> get props => [message, isFollowed];
}

class ProfileUpdateSuccess extends ProfileState {
  final String message;

  const ProfileUpdateSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class ProfileUpdateLoading extends ProfileState {}